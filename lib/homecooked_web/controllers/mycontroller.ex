defmodule HomecookedWeb.Mycontroller do
  use HomecookedWeb, :controller

  def hello(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    json(conn, %{sup: "#{user.id}"})
  end
end
