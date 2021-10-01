defmodule ChatBackendWeb.UserView do
  use ChatBackendWeb, :view

  def render("user.json", %{user: user}) do
    %{
      success: true,
      data: %{
        id: user.id,
        name: user.name,
        email: user.email,
        balance: user.balance
      }
    }
  end
end
