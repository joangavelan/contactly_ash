defmodule ContactlyWeb.ContactsController do
  use ContactlyWeb, :controller

  def index(conn, _params) do
    render_inertia(conn, "Contacts")
  end
end
