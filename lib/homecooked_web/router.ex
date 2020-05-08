defmodule HomecookedWeb.Router do
  use HomecookedWeb, :router
  require Ueberauth

  use Plug.ErrorHandler
  use Sentry.Plug
  
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

    post "/users/self/request-friend", UserController, :request_friend
    post "/users/self/friend-response", UserController, :respond_to_friend_request
    delete "/users/self/unfriend", UserController, :unfriend
    get "/users/self", UserController, :self

    resources "/users", UserController

    get "/host-post/map/:lat/:lng", HostPostController, :map
    resources "/host-post", HostPostController

    resources "/comments/host-post", HostPostCommentController

    post "/host-post/:host_post_id/submit-group", HostPostController, :submit_group
    post "/host-post/:host_post_id/respond-to-group", HostPostController, :respond_to_group

  end

  scope "/ping", HomecookedWeb do
    pipe_through [:api]
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
