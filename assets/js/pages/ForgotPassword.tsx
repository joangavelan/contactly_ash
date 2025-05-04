import { Layout } from "@/layouts/Layout"
import { useForm } from "@inertiajs/react"
import { FormEvent } from "react"

export default function ForgotPassword() {
  const { data, setData, post, processing } = useForm({ email: "" })

  const handleSubmit = (e: FormEvent) => {
    e.preventDefault()
    post("/password-reset")
  }

  return (
    <Layout title="Forgot password">
      <div>
        <h1>Forgot your password?</h1>
        <p>Enter your email and we will send you instructions to reset your password.</p>
      </div>

      <form onSubmit={handleSubmit} className="form">
        <fieldset className="form-group">
          <label htmlFor="email" className="label">
            Email
          </label>
          <input
            id="email"
            type="email"
            name="email"
            className="input"
            value={data.email}
            onChange={(e) => setData("email", e.target.value)}
          />
        </fieldset>

        <button className="btn btn-primary" type="submit" disabled={processing}>
          Send instructions
        </button>
      </form>
    </Layout>
  )
}
