defmodule ContactlyWeb.PageController do
  use ContactlyWeb, :controller

  def home(conn, _params) do
    render_inertia(conn, "Home")
  end
end
