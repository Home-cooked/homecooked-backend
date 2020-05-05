defmodule HomecookedWeb.Mycontroller do
  use HomecookedWeb, :controller

  def hello(conn, _) do
    json(conn, %{sup: "my old amigo"})
  end
end
