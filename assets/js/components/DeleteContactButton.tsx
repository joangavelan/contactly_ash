import { useForm } from "@inertiajs/react"
import type { FormEvent } from "react"
import * as React from "react"

interface Props {
  contactId: string
}

export function DeleteContactButton({ contactId }: Props) {
  const { delete: destroy, processing } = useForm()
  const ref = React.useRef<HTMLDialogElement>(null)

  const handleSubmit = (e: FormEvent) => {
    e.preventDefault()

    destroy(`/contacts/${contactId}`, {
      onSuccess: () => ref.current?.close()
    })
  }

  const openModal = () => {
    ref.current?.showModal()
  }

  return (
    <>
      <button className="btn" onClick={openModal}>
        Delete
      </button>

      <dialog ref={ref} className="modal">
        <div className="modal-box">
          <h3 className="text-lg font-bold">Are you sure?</h3>
          <p className="py-4">You will lose all data associated with this contact.</p>
          <div className="modal-action">
            <form method="dialog">
              <button className="btn">Cancel</button>
            </form>

            <form onSubmit={handleSubmit}>
              <button className="btn btn-primary" type="submit" disabled={processing}>
                Delete
              </button>
            </form>
          </div>
        </div>
      </dialog>
    </>
  )
}
