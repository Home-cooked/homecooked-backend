defmodule HomecookedWeb.AuthController do
  use HomecookedWeb, :controller

  plug(Ueberauth)

  alias Homecooked.Accounts

  def callback(%{assigns: %{ueberauth_failure: errors}} = conn, _params) do
    IO.inspect(errors)
    json(conn, %{error: "Failed to authenticate"})
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    %{info: info} = auth

    user =
      info
      |> Map.take([:first_name, :last_name, :email])
      |> Accounts.get_or_create_user()

    {:ok, token, _ } = Homecooked.Guardian.encode_and_sign(user)
    conn = Homecooked.Guardian.Plug.sign_in(conn, user)
    redirect(conn, external: "https://homecookn.co.uk/#/parse_credentials/#{token}")
  end

  def callback(conn, _params) do
    json(conn, %{error: "Auth controller callback error"})
  end
end
