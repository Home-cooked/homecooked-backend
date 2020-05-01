defmodule Homecooked.UserContent do

  import Ecto.Query, warn: false
  alias Homecooked.Repo

  alias Homecooked.Accounts.User
  alias Homecooked.UserContent.HostPost
  alias Homecooked.UserContent.SubmitGroup
  alias Homecooked.UserContent.HostPostComment

  def list_host_posts(user_id) do
    if user_id do
      Repo.all(from p in HostPost,
        left_join: g in SubmitGroup,
        on: p.id == g.host_post_id,
        where: p.user_id == ^user_id)
    else
      Repo.all(from p in HostPost,
        left_join: g in SubmitGroup,
        on: p.id == g.host_post_id)
    end
  end
  
  def search_host_posts(lat, lng, radius) do
    query =
      from p in HostPost,
      where: ^(lat-radius) <= p.lat and p.lat <= ^(lat+radius),
      where: ^(lng-radius) <= p.lng and p.lng <= ^(lng+radius)
    Repo.all(query)
  end

  def get_host_post!(id), do: Repo.get!(HostPost, id)

  def create_host_post(attrs) do
    %HostPost{}
    |> HostPost.changeset(attrs)
    |> Repo.insert()
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
