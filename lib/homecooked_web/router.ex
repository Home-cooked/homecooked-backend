defmodule HomecookedWeb.Router do
  use HomecookedWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", HomecookedWeb do
    pipe_through :api

    get "/hello", Mycontroller, :hello
  end
end
