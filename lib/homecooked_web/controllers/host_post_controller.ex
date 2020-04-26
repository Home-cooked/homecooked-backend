defmodule HomecookedWeb.HostPostController do
  use HomecookedWeb, :controller
  
  alias Homecooked.Accounts.User
  alias Homecooked.UserContent
  alias Homecooked.UserContent.HostPost

  action_fallback HomecookedWeb.FallbackController

  # Add load User for handlers
  def action(conn, _params) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, Guardian.Plug.current_resource(conn)])
  end

  def index(conn, _params, _user) do
    host_posts = UserContent.list_host_posts()
    render(conn, "index.json", host_posts: host_posts)
  end

  def create(conn, params, user) do
    {:ok, new_ts } = DateTime.from_unix(params["event_time"], :millisecond)
    IO.inspect new_ts
    {:ok, host_post} =
      params
      |> Map.put("user_id", user.id)
      |> Map.put("event_time", new_ts)
      |> UserContent.create_host_post()
    render(conn, "show.json", host_post: host_post)
  end


end
