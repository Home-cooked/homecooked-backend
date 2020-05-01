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
    ts_file = "#{DateTime.utc_now() |> DateTime.to_unix()}-#{filename}"
    namespaced_file = "#{user.id}/#{ts_file}"
    path
    |> S3.Upload.stream_file
    |> S3.upload("homecooked-images", namespaced_file)
    |> ExAws.request!
    json(conn, %{image_url: "#{ts_file}"})
  end
  
end
