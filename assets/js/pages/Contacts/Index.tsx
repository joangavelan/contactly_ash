import { DeleteContactButton } from "@/components/DeleteContactButton"
import { DownloadContacts } from "@/components/DownloadContacts"
import { Pagination } from "@/components/Pagination"
import { SearchBar } from "@/components/SearchBar"
import { UploadContacts } from "@/components/UploadContacts"
import { useUser } from "@/hooks/useUser"
import { Layout } from "@/layouts/Layout"
import type { Contact } from "@/types/contact"
import { Link } from "@inertiajs/react"

interface Props {
  contacts: {
    data: Contact[]
    pagination: Array<number | string>
  }
  params: Record<string, string>
}

export default function Contacts({ contacts, params }: Props) {
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
        <UploadContacts />

        <DownloadContacts />

        <div className="divider"></div>

        <div className="flex items-center justify-between gap-2.5">
          <h2>Contacts</h2>

          <Link href="/contacts/new" as="button" className="btn btn-primary">
            New Contact
          </Link>
        </div>

        <SearchBar initialSearch={params?.search} />

        {contacts.data.length === 0 ? (
          <p>No contacts found.</p>
        ) : (
          <div className="flex flex-col gap-4 divide-y">
            <div className="flex items-center gap-2.5 pb-2.5">
              <h3 className="font-semibold">Name</h3>
              <div className="flex gap-1.5">
                <Link
                  href="/contacts"
                  as="button"
                  data={{ ...params, sort: params?.sort === "+name" ? undefined : "+name" }}
                  className={`btn btn-sm ${params?.sort === "+name" ? "btn-active" : ""}`}
                  preserveScroll
                >
                  Asc
                </Link>
                <Link
                  href="/contacts"
                  as="button"
                  data={{ ...params, sort: params?.sort === "-name" ? undefined : "-name" }}
                  className={`btn btn-sm ${params?.sort === "-name" ? "btn-active" : ""}`}
                  preserveScroll
                >
                  Desc
                </Link>
              </div>
            </div>

            <ul className="flex list-disc flex-col gap-4 pb-2.5 pl-4">
              {contacts.data.map(({ id, name }) => (
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

            <Pagination items={contacts.pagination} params={params} />
          </div>
        )}
      </div>
    </Layout>
  )
}
