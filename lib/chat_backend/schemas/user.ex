defmodule ChatBackend.UserSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user" do
    field :name, :string
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :balance, :integer, default: 0

    timestamps()
  end

  def changeset(changeset, params \\ %{}) do
    changeset
    |> cast(params, [:name, :email, :password_hash, :password, :balance])
    |> validate_required([:name, :email])
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Bcrypt.add_hash(password))
  end

  defp put_pass_hash(changeset), do: changeset
end
