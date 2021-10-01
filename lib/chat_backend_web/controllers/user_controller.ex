defmodule ChatBackendWeb.UserController do
  use ChatBackendWeb, :controller
  alias ChatBackend.UserModel

  alias ChatBackend.Guardian

  def create(conn, %{"param" => params}) do
    case UserModel.create(params) do
      {:ok, user} ->
        conn
        |> put_status(200)
        |> put_resp_content_type("application/json")
        |> render("user.json", %{user: user})

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, Jason.encode!(%{success: false, data: "Falha ao criar usuario"}))
        |> halt()
    end
  end

  def show(conn, %{"id" => id}) do
    case UserModel.show(id) do
      {:ok, user} ->
        conn
        |> put_status(200)
        |> put_resp_content_type("application/json")
        |> render("user.json", %{user: user})

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(
          400,
          Jason.encode!(%{success: false, data: "Não foi possivel achar esse usuario"})
        )
        |> halt()
    end
  end

  def update(conn, %{"id" => id, "param" => params}) do
    with {:ok, user} <- UserModel.show(id),
         {:ok, user_updated} <- UserModel.update(user, params) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("user.json", %{user: user_updated})
    else
      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(
          400,
          Jason.encode!(%{success: false, data: "Não conseguimos atualizar o usuario"})
        )
        |> halt()
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    with {:ok, user} <- UserModel.get_by_email(email),
         true <- Bcrypt.verify_pass(password, user.password_hash),
         {:ok, jwt, _claims} = Guardian.encode_and_sign(user, %{}) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{token: jwt}))
    else
      false ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(
          400,
          Jason.encode!(%{success: false, data: "Usuario não autenticado"})
        )
        |> halt()

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(
          400,
          Jason.encode!(%{success: false, data: "Esse email não está cadastrado"})
        )
        |> halt()
    end
  end

  def withdraw(conn, %{"id" => id, "value" => value}) do
    with {:ok, user} <- UserModel.show(id),
         true <- user.balance - value >= 0,
         {:ok, result} <- UserModel.withdraw(user, value) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("user.json", %{user: result})
    else
      false ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(
          400,
          Jason.encode!(%{success: false, data: "Voce não tem esse valor para fazer a retirada."})
        )
        |> halt()
    end
  end

  def deposit(conn, %{"id" => id, "value" => value}) do
    with {:ok, user} <- UserModel.show(id),
         {:ok, result} <- UserModel.deposit(user, value) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("user.json", %{user: result})
    end
  end
end
