defmodule Homecooked.UserContent do

  import Ecto.Query, warn: false
  alias Homecooked.Repo

  alias Homecooked.Accounts.User
  alias Homecooked.UserContent.HostPost
  alias Homecooked.UserContent.SubmitGroup
  alias Homecooked.UserContent.SubmitGroupUser
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
      preload: [submit_groups: :users]
    Repo.all(query)
  end

  def get_host_post!(id) do
    Repo.get!(HostPost, id)
    |> Repo.preload([{:submit_groups, [:users]} ])
  end

  def create_host_post(attrs) do
    %HostPost{}
    |> HostPost.changeset(attrs)
    |> Repo.insert()
  end

  def submit_group!(attrs) do
    # Repo.get!(HostPost, attrs["host_post_id"])
    # |> Repo.preload(:submit_groups)
    # |> Ecto.cast_assoc(:submit_groups)
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
    Repo.insert_all(SubmitGroupUser, res)
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
