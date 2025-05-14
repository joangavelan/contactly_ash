import { Back } from "@/components/Back"
import { DeleteContactButton } from "@/components/DeleteContactButton"
import { Layout } from "@/layouts/Layout"
import type { Contact } from "@/types/contact"
import { Link } from "@inertiajs/react"

interface Props {
  contact: Contact
}

export default function Show({ contact }: Props) {
  const { id, name, email, phone } = contact

  return (
    <Layout title="Contact">
      <Back />

      <h1>Contact details</h1>

      <div>
        <p>Name: {name}</p>
        <p>Email: {email}</p>
        <p>Phone: {phone}</p>
      </div>

      <div className="flex gap-2.5">
        <Link href={`/contacts/${id}/edit`} as="button" className="btn">
          Edit
        </Link>

        <DeleteContactButton contactId={id} />
      </div>
    </Layout>
  )
}
