defmodule HomecookedWeb.UserController do
  use HomecookedWeb, :controller

  alias Homecooked.Accounts
  alias Homecooked.Accounts.User

  action_fallback HomecookedWeb.FallbackController

  # Add load User for handlers
  def action(conn, _params) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, Guardian.Plug.current_resource(conn)])
  end

  def index(conn, _params, _user) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  # Creating Users handled in auth controller
  def show(conn, %{"id" => id} = params, _user) do
    options = %{
      "pending_friend_requests" => :pending_friend_requests,
      "incoming_friend_requests" => :incoming_friend_requests,
      "pending_host_approval" => :pending_host_approval,
      "attending" => :attending,
    }

    friends_option = Map.get(params, "friends", false)
    preload_options = MapSet.intersection(MapSet.new(Map.keys(options)), MapSet.new(Map.keys(params)))
    |> Enum.map(&(options[&1]))
    
    user = Accounts.get_user!(id, preload_options)
    friends = Accounts.get_friends!(id)
    render(conn, "rich_user.json", user: user, preload: preload_options, extra: %{friends: friends})
  end

  def self(conn, _params, user) do
    options = [:pending_friend_requests, :incoming_friend_requests,:pending_host_approval,:attending]
    filled = Accounts.fill_user!(user)
    friends = Accounts.get_friends!(user.id)
    render(conn, "rich_user.json", %{user: filled, preload: options ,extra: %{ friends: friends }})
  end


  def update(conn, %{"id" => id, "user" => user_params}, _user) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}, _user) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def check(conn, %{"user_name" => user_name}, _user) do
    taken = Accounts.check_user_name(user_name)
    json(conn, %{taken: taken})
  end

  def request_friend(conn, %{"id" => to}, user) do
    if !!user.friends and to in user.friends do
      json(conn, nil)
    else
      Accounts.request_friend!(user, to)
      fresh_user = Accounts.get_user!(user.id, [:pending_friend_requests])
      render(conn, "rich_user.json", user: fresh_user, preload: [:pending_friend_requests], extra: %{})
    end
  end

  def respond_to_friend_request(conn, %{"id" => from, "val" => val}, user) do
    Accounts.respond_to_friend(from, user, val)
    fresh_user = Accounts.get_user!(user.id, [:incoming_friend_requests])
    friends = Accounts.get_friends!(user.id)
    render(conn, "rich_user.json", user: fresh_user, preload: [:incoming_friend_requests], extra: %{friends: friends})
  end

  def unfriend(conn, %{"id" => to}, user) do
    with {:ok, %User{} = new_user} <- Accounts.unfriend!(user, to) do
      render(conn, "show.json", user: new_user)
    end
  end
    

end

