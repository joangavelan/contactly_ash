import { ContactForm } from "@/components/ContactForm"
import { Layout } from "@/layouts/Layout"

export default function NewContact() {
  return (
    <Layout title="New Contact">
      <h1>New Contact</h1>

      <ContactForm />
    </Layout>
  )
}
