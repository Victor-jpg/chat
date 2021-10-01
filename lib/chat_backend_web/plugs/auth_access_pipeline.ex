defmodule ChatBackendWeb.AuthAccessPipeline do
  use Guardian.Plug.Pipeline, otp_app: :chat_backend

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: true
end
