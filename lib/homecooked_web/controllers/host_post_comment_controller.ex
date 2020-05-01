defmodule HomecookedWeb.HostPostCommentController do
  # TODO refactor into assoc using :through
  use HomecookedWeb, :controller
  alias Homecooked.UserContent


  action_fallback HomecookedWeb.FallbackController

  # Add load User for handlers
  def action(conn, _params) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, Guardian.Plug.current_resource(conn)])
  end

  def index(conn, %{"host_post_id" => host_post_id }, user) do
    comments = UserContent.get_post_comments!(host_post_id)
    IO.inspect comments
    render(conn, "index.json", comments: comments)
  end
  
  def create(conn, params, user) do
    {:ok, comment} = UserContent.create_comment(params |> Map.put("user_id", user.id))
    render(conn, "show.json", comment: %{comment | user: user})
  end

end
