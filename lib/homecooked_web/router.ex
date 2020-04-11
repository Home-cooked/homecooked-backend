defmodule HomecookedWeb.Router do
  use HomecookedWeb, :router
  require Ueberauth
  
  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug HomecookedWeb.Auth.Pipeline
  end
  
  scope "/api", HomecookedWeb do
    pipe_through :api
    get "/check-user-name/:user_name", UserController, :check
    # resources "/users", UserController
  end

  scope "/protected", HomecookedWeb do
    pipe_through :authenticated
    get "/hello", Mycontroller, :hello
  end
  
  scope "/auth", HomecookedWeb do
    pipe_through :api

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end
  
end
