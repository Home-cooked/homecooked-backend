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

  def show(conn, %{"id" => id}, _user) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
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
    render(conn, "show.json", user: user)
  end

end
