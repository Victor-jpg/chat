defmodule ChatBackend.Guardian do
  use Guardian, otp_app: :chat_backend

  alias ChatBackend.UserModel

  def subject_for_token(resource, _claims) do
    sub = to_string(resource.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = UserModel.show(id)
  end
end
