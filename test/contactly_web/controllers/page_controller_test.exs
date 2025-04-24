defmodule ContactlyWeb.PageControllerTest do
  use ContactlyWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert inertia_component(conn) == "Home"
  end
end
