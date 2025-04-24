defmodule ContactlyWeb.PageController do
  use ContactlyWeb, :controller

  def home(conn, _params) do
    conn
    |> assign_prop(:text, "Hello World")
    |> render_inertia("Home")
  end
end
