import { ErrorField } from "@/components/ErrorField"
import { Layout } from "@/layouts/Layout"
import { useForm } from "@inertiajs/react"
import type { FormEvent } from "react"

export default function UserSettings() {
  const { data, setData, put, processing, errors } = useForm({
    current_password: "",
    password: "",
    password_confirmation: ""
  })

  const handleSubmit = (e: FormEvent) => {
    e.preventDefault()
    put("/settings")
  }

  return (
    <Layout title="Settings">
      <h1>User Settings</h1>

      <div className="divider"></div>

      <div className="flex flex-col gap-2.5">
        <h2>Update password</h2>

        <form onSubmit={handleSubmit} className="form">
          <fieldset className="form-group">
            <label htmlFor="current_password" className="label">
              Current Password
            </label>
            <input
              type="password"
              id="current_password"
              name="current_password"
              className="input"
              value={data.current_password}
              onChange={(e) => setData("current_password", e.target.value)}
            />
            <ErrorField error={errors.current_password} />
          </fieldset>

          <fieldset className="form-group">
            <label htmlFor="password" className="label">
              New Password
            </label>
            <input
              type="password"
              id="password"
              name="password"
              className="input"
              value={data.password}
              onChange={(e) => setData("password", e.target.value)}
            />
            <ErrorField error={errors.password} />
          </fieldset>

          <fieldset className="form-group">
            <label htmlFor="password_confirmation" className="label">
              Confirm New Password
            </label>
            <input
              type="password"
              id="password_confirmation"
              name="password_confirmation"
              className="input"
              value={data.password_confirmation}
              onChange={(e) => setData("password_confirmation", e.target.value)}
            />
            <ErrorField error={errors.password_confirmation} />
          </fieldset>

          <button className="btn btn-primary" type="submit" disabled={processing}>
            Update password
          </button>
        </form>
      </div>
    </Layout>
  )
}
