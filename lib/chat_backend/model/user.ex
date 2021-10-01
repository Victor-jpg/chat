defmodule ChatBackend.UserModel do
  alias ChatBackend.Repo
  alias ChatBackend.UserSchema

  def create(params) do
    %UserSchema{}
    |> UserSchema.changeset(params)
    |> Repo.insert()
  end

  def show(id) do
    case Repo.get(UserSchema, id) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  def update(changeset, params) do
    changeset
    |> UserSchema.changeset(params)
    |> Repo.update()
  end

  def get_by_email(email) do
    case Repo.get_by(UserSchema, email: email) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  def withdraw(user, value) do
    params = %{
      "balance" => user.balance - value
    }

    user
    |> UserSchema.changeset(params)
    |> Repo.update()
  end

  def deposit(user, value) do
    params = %{
      "balance" => user.balance + value
    }

    user
    |> UserSchema.changeset(params)
    |> Repo.update()
  end
end
