defmodule HomecookedWeb.Router do
  use HomecookedWeb, :router
  require Ueberauth

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :multipart do
    plug :accepts, ["multipart"]
  end
  
  pipeline :authenticated do
    plug HomecookedWeb.Auth.Pipeline
  end

  scope "/mp", HomecookedWeb do
    pipe_through [:multipart, :authenticated]
    post "/image-upload", ImageController, :create
  end
  
  scope "/api", HomecookedWeb do
    pipe_through [:api, :authenticated]
    get "/check-user-name/:user_name", UserController, :check
    get "/users/self", UserController, :self
    resources "/users", UserController
    resources "/host-post", HostPostController
  end

  scope "/protected", HomecookedWeb do
    pipe_through [:api, :authenticated]
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
