import { ContactForm } from "@/components/ContactForm"
import { Layout } from "@/layouts/Layout"
import type { Contact } from "@/types/contact"

interface Props {
  contact: Contact
}

export default function Edit({ contact }: Props) {
  return (
    <Layout title="Edit Contact">
      <h1>Edit Contact</h1>

      <ContactForm contact={contact} />
    </Layout>
  )
}
