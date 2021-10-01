defmodule ChatBackend.Repo.Migrations.User do
  use Ecto.Migration

  def change do
    create table(:user) do
      add :name, :string
      add :email, :string
      add :password_hash, :string
      add :balance, :integer

      timestamps()
    end
  end
end
