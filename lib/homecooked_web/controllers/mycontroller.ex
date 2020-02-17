defmodule HomecookedWeb.Mycontroller do
  use HomecookedWeb, :controller

  def hello(conn, _) do
    json(conn, %{sup: "boi"})
  end
end
