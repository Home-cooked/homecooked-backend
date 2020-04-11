defmodule HomecookedWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :homecooked,
    error_handler: HomecookedWeb.Auth.ErrorHandler,
    module: Homecooked.Guardian

  # Get error throw below handled by errorHandler
  plug(Guardian.Plug.VerifyHeader, realm: "Bearer")
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
