defmodule Contactly.Contacts do
  use Ash.Domain,
    otp_app: :contactly

  resources do
    resource Contactly.Contacts.Contact do
      define :list_contacts, action: :read
      define :create_contact
      define :get_contact, args: [:id]
      define :update_contact, action: :update
      define :delete_contact, action: :destroy
    end
  end

  def upload_csv_contacts(file_path, current_user) do
    file_path
    |> File.stream!()
    |> CSV.decode!(headers: true)
    |> Ash.bulk_create(Contactly.Contacts.Contact, :create_contact, actor: current_user)
  end

  def generate_csv_contacts(contacts) do
    headers = ["name", "email", "phone"]
    rows = Enum.map(contacts, &[&1.name, &1.email, &1.phone])

    csv =
      [headers | rows]
      |> CSV.encode()
      |> Enum.join()

    {:ok, csv}
  end
end
