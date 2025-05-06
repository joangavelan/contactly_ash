import { DeleteContactButton } from "@/components/DeleteContactButton"
import { useUser } from "@/hooks/useUser"
import { Layout } from "@/layouts/Layout"
import type { Contact } from "@/types/contact"
import { Link } from "@inertiajs/react"

interface Props {
  contacts: Contact[]
}

export default function Contacts({ contacts }: Props) {
  const { user } = useUser()

  return (
    <Layout title="Contacts">
      <div className="flex w-max flex-col gap-2.5">
        <h1>Contactly</h1>

        <div>
          <p>Welcome, {user?.first_name}!</p>
          <p>Email: {user?.email}</p>
        </div>

        <div className="flex flex-col gap-2.5">
          <Link href="/settings" as="button" className="btn">
            Settings
          </Link>

          <Link href="/logout" method="delete" className="btn btn-secondary">
            Logout
          </Link>
        </div>
      </div>

      <div className="divider"></div>

      <div className="flex w-[30rem] flex-col gap-8">
        <div className="flex items-center justify-between gap-2.5">
          <h2>Contacts</h2>

          <Link href="/contacts/new" as="button" className="btn btn-primary">
            New Contact
          </Link>
        </div>

        {contacts.length === 0 ? (
          <p>No contacts found.</p>
        ) : (
          <ul className="flex list-disc flex-col gap-4 pl-4">
            {contacts.map(({ id, name }) => (
              <li key={id} className="list-item">
                <div className="relative flex items-center justify-between gap-10">
                  <p className="truncate">{name}</p>

                  <div className="flex gap-2.5">
                    <Link href={`/contacts/${id}`} as="button" className="btn">
                      View
                    </Link>

                    <Link href={`/contacts/${id}/edit`} as="button" className="btn">
                      Edit
                    </Link>

                    <DeleteContactButton contactId={id} />
                  </div>
                </div>
              </li>
            ))}
          </ul>
        )}
      </div>
    </Layout>
  )
}
