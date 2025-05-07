defmodule ContactlyWeb.ContactsController do
  use ContactlyWeb, :controller

  import ContactlyWeb.Serializers

  alias Contactly.Contacts

  def index(conn, _params) do
    current_user = conn.assigns.current_user

    contacts = Contacts.list_contacts!(actor: current_user)

    conn
    |> assign_prop(:contacts, serialize_contacts(contacts))
    |> render_inertia("Contacts/Index")
  end

  def new(conn, _params) do
    render_inertia(conn, "Contacts/New")
  end

  def create(conn, params) do
    current_user = conn.assigns.current_user

    case Contacts.create_contact(params, actor: current_user) do
      {:ok, _contact} ->
        conn
        |> put_flash(:success, "Contact created successfully.")
        |> redirect(to: ~p"/contacts")

      {:error, %Ash.Error.Invalid{} = error} ->
        conn
        |> assign_errors(error)
        |> redirect(to: ~p"/contacts/new")
    end
  end

  def show(conn, %{"id" => id}) do
    current_user = conn.assigns.current_user

    contact = Contacts.get_contact!(id, actor: current_user)

    conn
    |> assign_prop(:contact, serialize_contact(contact))
    |> render_inertia("Contacts/Show")
  end

  def edit(conn, %{"id" => id}) do
    current_user = conn.assigns.current_user

    contact = Contacts.get_contact!(id, actor: current_user)

    conn
    |> assign_prop(:contact, serialize_contact(contact))
    |> render_inertia("Contacts/Edit")
  end

  def update(conn, %{"id" => id, "contact" => contact_params}) do
    current_user = conn.assigns.current_user

    case Contacts.update_contact(id, contact_params, actor: current_user) do
      {:ok, _contact} ->
        conn
        |> put_flash(:success, "Contact updated successfully.")
        |> redirect(to: ~p"/contacts/#{id}")

      {:error, %Ash.Error.Invalid{} = error} ->
        conn
        |> assign_errors(error)
        |> redirect(to: ~p"/contacts/#{id}/edit")
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = conn.assigns.current_user

    case Contacts.delete_contact(id, actor: current_user) do
      :ok ->
        conn
        |> put_flash(:success, "Contact deleted successfully.")
        |> redirect(to: ~p"/contacts")

      {:error, _error} ->
        conn
        |> put_flash(:error, "An error occurred while deleting the contact.")
        |> redirect(to: ~p"/contacts")
    end
  end

  def import_csv(conn, %{"file" => %Plug.Upload{path: path, content_type: "text/csv"}}) do
    current_user = conn.assigns.current_user

    case Contacts.upload_csv_contacts(%{file_path: path}, actor: current_user) do
      {:ok, _result} ->
        conn
        |> put_flash(:success, "Contacts imported successfully!")
        |> redirect(to: ~p"/contacts")

      {:error, _error} ->
        conn
        |> put_flash(:error, "An error occurred while trying to upload the contacts.")
        |> redirect(to: ~p"/contacts")
    end
  end

  def export_csv(conn, _params) do
    current_user = conn.assigns.current_user

    with {:ok, csv} <- Contacts.generate_csv_contacts(actor: current_user) do
      conn
      |> put_resp_content_type("text/csv")
      |> put_resp_header("content-disposition", "attachment; filename=contacts.csv")
      |> send_resp(200, csv)
    else
      _ ->
        conn
        |> put_flash(:error, "An error occurred while trying to export contacts.")
        |> redirect(to: ~p"/contacts")
    end
  end
end
