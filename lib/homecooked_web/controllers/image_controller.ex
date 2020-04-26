defmodule HomecookedWeb.ImageController do
  use HomecookedWeb, :controller
  alias ExAws.S3
  # Add load User for handlers
  def action(conn, _params) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, Guardian.Plug.current_resource(conn)])
  end

  def create(conn, %{"photo" => photo}, user) do
    # Why can't i do this in fn signature?
    %{:filename => filename, :path => path} = photo
    IO.puts path
    path
    |> S3.Upload.stream_file
    |> S3.upload("homecooked-images", filename)
    |> ExAws.request!
    json(conn, %{sup: "#{user.first_name}"})
  end

  def show(conn, _, _user) do
    user = Guardian.Plug.current_resource(conn)
    json(conn, %{sup: "#{user.id}"})
  end
  
end
