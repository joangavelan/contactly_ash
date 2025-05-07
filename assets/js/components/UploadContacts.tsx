import { useForm } from "@inertiajs/react"
import type { FormEvent } from "react"
import * as React from "react"

export function UploadContacts() {
  const { data, setData, post, processing, reset } = useForm<{ file?: File }>({
    file: undefined
  })
  const inputRef = React.useRef<HTMLInputElement>(null)

  const handleSubmit = (e: FormEvent) => {
    e.preventDefault()
    post("/contacts/import", {
      onSuccess: () => {
        clearForm()
      }
    })
  }

  const removeFile = () => {
    if (inputRef?.current) {
      inputRef.current.value = ""
    }
  }

  const clearForm = () => {
    reset()
    removeFile()
  }

  return (
    <div className="flex flex-col gap-2.5">
      <div>
        <h2>Import contacts from CSV</h2>
        <p>The CSV file should include headers for name, email, and phone.</p>
      </div>

      <form onSubmit={handleSubmit} encType="multipart/form-data" className="flex gap-2.5">
        <input
          ref={inputRef}
          type="file"
          className="file-input"
          onChange={(e) => {
            setData("file", e.target.files?.[0])
          }}
        />
        {data.file && (
          <button onClick={clearForm} type="button" className="btn btn-error">
            X
          </button>
        )}
        <button className="btn" type="submit" disabled={!data.file || processing}>
          Upload
        </button>
      </form>
    </div>
  )
}
