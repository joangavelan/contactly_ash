import { ErrorField } from "@/components/ErrorField"
import { Layout } from "@/layouts/Layout"
import { useForm } from "@inertiajs/react"
import type { FormEvent } from "react"

interface Props {
  reset_token: string
}

export default function ResetPassword({ reset_token }: Props) {
  const { data, setData, put, processing, errors } = useForm({
    password: "",
    password_confirmation: ""
  })

  const handleSubmit = (e: FormEvent) => {
    e.preventDefault()
    put(`/password-reset/${reset_token}`)
  }

  return (
    <Layout title="Reset Password">
      <h1>Reset Password</h1>

      <form onSubmit={handleSubmit} className="form">
        <fieldset className="form-field">
          <label htmlFor="password" className="label">
            New Password
          </label>
          <input
            id="password"
            type="password"
            name="password"
            className="input"
            value={data.password}
            onChange={(e) => setData("password", e.target.value)}
          />
          <ErrorField error={errors.password} />
        </fieldset>

        <fieldset className="form-field">
          <label htmlFor="password_confirmation" className="label">
            Confirm New Password
          </label>
          <input
            id="password_confirmation"
            type="password"
            name="password_confirmation"
            className="input"
            value={data.password_confirmation}
            onChange={(e) => setData("password_confirmation", e.target.value)}
          />
          <ErrorField error={errors.password_confirmation} />
        </fieldset>

        <button className="btn btn-primary" type="submit" disabled={processing}>
          Reset password
        </button>
      </form>
    </Layout>
  )
}
