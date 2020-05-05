defmodule Homecooked.UserContent do

  import Ecto.Query, warn: false
  alias Homecooked.Repo

  alias Homecooked.Accounts.User
  alias Homecooked.UserContent.HostPost
  alias Homecooked.UserContent.SubmitGroup
  alias Homecooked.UserContent.SubmitGroupUser
  alias Homecooked.UserContent.Attending
  alias Homecooked.UserContent.HostPostComment

  def list_host_posts(user_id) do
    if user_id do
      Repo.all(from p in HostPost,
        left_join: g in SubmitGroup,
        on: p.id == g.host_post_id,
        where: p.user_id == ^user_id,
        preload: [submit_groups: :users]
      )
    else
      Repo.all(from p in HostPost,
        left_join: g in SubmitGroup,
        on: p.id == g.host_post_id,
        preload: [submit_groups: :users])
    end
  end
  
  def search_host_posts(lat, lng, radius) do
    query =
      from p in HostPost,
      where: ^(lat-radius) <= p.lat and p.lat <= ^(lat+radius),
      where: ^(lng-radius) <= p.lng and p.lng <= ^(lng+radius),
      preload: [{:submit_groups, [:users]}, :user]
    Repo.all(query)
  end

  def get_host_post!(id, opts) do
    Repo.get!(HostPost, id)
    |> Repo.preload(opts)
  end

  def create_host_post(attrs) do
    %HostPost{}
    |> HostPost.changeset(attrs)
    |> Repo.insert()
  end

  def respond_to_group!(attrs) do
    group = Repo.get!(SubmitGroup, attrs["submit_group_id"])
    |> Repo.preload([:users])

    if attrs["val"] do
      Enum.map(group.users, fn u ->
        %Attending{}
        |> Attending.changeset(%{user_id: u.id, host_post_id: group.host_post_id})
        |> Repo.insert!()
      end)      
    end

    Repo.delete!(group)
    get_host_post!(attrs["host_post_id"],[:submit_groups])
  end
  
  def submit_group!(attrs) do
    {users, attrs} = Map.pop(attrs, "users", [])
    submit_group = %SubmitGroup{}
    |> SubmitGroup.changeset(attrs)
    |> Repo.insert!()
    res =
      users
      |> Enum.map(fn id ->
      %SubmitGroupUser{}
      |> SubmitGroupUser.changeset(%{user_id: id, submit_group_id: submit_group.id})
      |> Repo.insert!()
    end)

    Repo.get!(HostPost, attrs["host_post_id"])
    |> Repo.preload(:submit_groups)
  end
  
  def create_comment(attrs) do
    %HostPostComment{}
    |> HostPostComment.changeset(attrs)
    |> Repo.insert()
  end

  def get_post_comments!(host_post_id) do
    Repo.all(from c in HostPostComment,
      where: c.host_post_id == ^host_post_id,
      preload: [:user])
    end

  def delete_comment(%HostPostComment{} = comment) do
    Repo.delete(comment)
  end
  
end
