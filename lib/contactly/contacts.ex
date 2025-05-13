defmodule Contactly.Contacts do
  use Ash.Domain,
    otp_app: :contactly

  resources do
    resource Contactly.Contacts.Contact do
      define :list_contacts
      define :create_contact
      define :get_contact, args: [:id]
      define :update_contact, action: :update
      define :delete_contact, action: :destroy
      define :upload_csv_contacts
      define :generate_csv_contacts
    end
  end
end
