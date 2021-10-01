defmodule ChatBackendWeb.PageController do
  use ChatBackendWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
