import { ErrorField } from "@/components/ErrorField"
import type { Contact } from "@/types/contact"
import { useForm } from "@inertiajs/react"
import type { FormEvent } from "react"

interface Props {
  contact?: Contact
}

export function ContactForm({ contact }: Props) {
  const { data, setData, post, put, transform, processing, errors } = useForm({
    name: contact?.name || "",
    email: contact?.email || "",
    phone: contact?.phone || ""
  })

  const handleSubmit = (e: FormEvent) => {
    e.preventDefault()

    if (contact) {
      transform((data) => ({
        id: contact.id,
        contact: { ...data }
      }))

      put(`/contacts/${contact.id}`)
    } else {
      post("/contacts")
    }
  }

  return (
    <form onSubmit={handleSubmit} className="form">
      <fieldset className="form-field">
        <label htmlFor="name" className="label">
          Name
        </label>
        <input
          id="name"
          name="name"
          type="text"
          className="input"
          value={data.name}
          onChange={(e) => setData("name", e.target.value)}
        />
        <ErrorField error={errors.name} />
      </fieldset>

      <fieldset className="form-field">
        <label htmlFor="email" className="label">
          Email
        </label>
        <input
          id="email"
          name="email"
          type="email"
          className="input"
          value={data.email}
          onChange={(e) => setData("email", e.target.value)}
        />
        <ErrorField error={errors.email} />
      </fieldset>

      <fieldset className="form-field">
        <label htmlFor="phone" className="label">
          Phone
        </label>
        <input
          id="phone"
          name="phone"
          type="tel"
          className="input"
          value={data.phone}
          onChange={(e) => setData("phone", e.target.value)}
        />
        <ErrorField error={errors.phone} />
      </fieldset>

      <button className="btn btn-primary" type="submit" disabled={processing}>
        {contact ? "Update Contact" : "Create Contact"}
      </button>
    </form>
  )
}
