defmodule XpendrWeb.SessionManager.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :xpendr,
    error_handler: XpendrWeb.SessionManager.ErrorHandler,
    module: XpendrWeb.SessionManager.Guardian

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
end
