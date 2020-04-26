defmodule Homecooked.UserContent do

  import Ecto.Query, warn: false
  alias Homecooked.Repo

  alias Homecooked.Accounts.User
  alias Homecooked.UserContent.HostPost
  alias Homecooked.UserContent.SubmitGroup

  def list_host_posts() do
    Repo.all(from p in HostPost, join: g in SubmitGroup, on: p.id == g.host_post_id)
  end

  def create_host_post(attrs) do
    %HostPost{}
    |> HostPost.changeset(attrs)
    |> Repo.insert()
  end
  
end
