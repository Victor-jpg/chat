defmodule ChatBackendWeb.UserTestA do
  use ChatBackendWeb.ConnCase
  use ExUnit.Case, async: true

  test "CRUD User" do
    params = %{
      "name" => "Victor Augusto",
      "email" => "victor@gmail.com",
      "password" => "123456"
    }

    user =
      build_conn()
      |> post("/user", %{"param" => params})
      |> json_response(200)
      |> Map.get("data")

    build_conn()
    |> get("/user/#{user["id"]}")
    |> json_response(200)

    build_conn()
    |> put("/user/#{user["id"]}", %{"param" => %{params | "name" => "Vitinho"}})
    |> json_response(200)
  end

  test "Login with guardian" do
    params = %{
      "name" => "Victor Augusto",
      "email" => "victor@gmail.com",
      "password" => "123456"
    }

    user =
      build_conn()
      |> post("/user", %{"param" => params})
      |> json_response(200)
      |> Map.get("data")

    login =
      build_conn()
      |> post("/user/login", %{"email" => params["email"], "password" => params["password"]})
      |> json_response(200)

    build_conn()
    |> put_req_header("authorization", "Bearer " <> login["token"])
    |> get("/user/#{user["id"]}")
    |> json_response(200)
  end

  test "Testing balance" do
    params = %{
      "name" => "Victor Augusto",
      "email" => "victor@gmail.com",
      "password" => "123456"
    }

    user =
      build_conn()
      |> post("/user", %{"param" => params})
      |> json_response(200)
      |> Map.get("data")

    login =
      build_conn()
      |> post("/user/login", %{"email" => params["email"], "password" => params["password"]})
      |> json_response(200)

    for _ <- 1..100 do
      build_conn()
      |> put_req_header("authorization", "Bearer " <> login["token"])
      |> put("/user/deposit/#{user["id"]}", %{"value" => 500})
      |> json_response(200)

      build_conn()
      |> put_req_header("authorization", "Bearer " <> login["token"])
      |> put("/user/withdraw/#{user["id"]}", %{"value" => 500})
      |> json_response(200)
      |> IO.inspect
    end
  end
end
