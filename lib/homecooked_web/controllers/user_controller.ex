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
  def show(conn, %{"id" => id, "friends" => friends}, _user) do
    user = Accounts.get_user!(id)
    friends = Accounts.get_friends!(id)
    render(conn, "rich_user.json", user: user, rich_info: %{ friends: friends})
  end

  def show(conn, %{"id" => id}, _user) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
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

  def self(conn, _params, user) do
    friends = Accounts.get_friends!(user.id)
    incoming_friends = Accounts.get_incoming_friends!(user.id)
    IO.inspect incoming_friends
    pending_friends = Accounts.get_pending_friends!(user.id) |> Enum.map(&(&1.id))
    render(conn, "rich_user.json", %{user: user, rich_info: %{
                                        incoming_friends: incoming_friends,
                                        friends: friends,
                                        pending_friends: pending_friends
                                     }})
  end

  def request_friend(conn, %{"id" => to}, user) do
    if !!user.friends and to in user.friends do
      json(conn, nil)
    else
      Accounts.request_friend!(user, to)
      friends = Accounts.get_pending_friends!(user.id) |> Enum.map(&(&1.id))
      render(conn, "rich_user.json", user: user, rich_info: %{ pending_friends: friends})
    end
  end

  def respond_to_friend_request(conn, %{"id" => from, "val" => val}, user) do
    new_user = Accounts.respond_to_friend(from, user, val)
    render(conn, "show.json", user: new_user)
  end

  def unfriend(conn, %{"id" => to}, user) do
    with {:ok, %User{} = new_user} <- Accounts.unfriend!(user, to) do
      render(conn, "show.json", user: new_user)
    end
  end
    

end

