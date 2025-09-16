defmodule DemoElixirAshBackpexWeb.PageController do
  use DemoElixirAshBackpexWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
