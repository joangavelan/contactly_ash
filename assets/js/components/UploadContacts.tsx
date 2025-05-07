import { useForm } from "@inertiajs/react"
import type { FormEvent } from "react"

export function UploadContacts() {
  const { setData, post, processing, isDirty } = useForm({
    file: undefined as File | undefined
  })

  function submit(e: FormEvent) {
    e.preventDefault()
    post("/contacts/import")
  }

  return (
    <div className="flex flex-col gap-2.5">
      <div>
        <h2>Import contacts from CSV</h2>
        <p>The CSV file should include headers for name, email, and phone.</p>
      </div>

      <form onSubmit={submit} encType="multipart/form-data" className="flex gap-2.5">
        <input
          type="file"
          className="file-input"
          onChange={(e) => {
            setData("file", e.target.files?.[0])
          }}
        />
        <button className="btn" type="submit" disabled={processing || !isDirty}>
          Upload
        </button>
      </form>
    </div>
  )
}
