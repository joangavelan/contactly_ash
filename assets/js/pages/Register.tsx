import { ErrorField } from "@/components/ErrorField"
import { Layout } from "@/layouts/Layout"
import { Link, useForm } from "@inertiajs/react"
import type { FormEvent } from "react"

export default function Register() {
  const { data, setData, errors, post, processing } = useForm({
    first_name: "",
    last_name: "",
    email: "",
    password: "",
    password_confirmation: ""
  })

  const handleSubmit = (e: FormEvent) => {
    e.preventDefault()
    post("/register")
  }

  return (
    <Layout title="Register">
      <h1 className="mb-1.5">Register</h1>

      <form onSubmit={handleSubmit} id="register-form" className="form">
        <fieldset className="form-group">
          <label htmlFor="first_name" className="label">
            First Name
          </label>
          <input
            id="first_name"
            name="first_name"
            type="text"
            className="input"
            value={data.first_name}
            onChange={(e) => setData("first_name", e.target.value)}
          />
          <ErrorField error={errors.first_name} />
        </fieldset>

        <fieldset className="form-group">
          <label htmlFor="last_name" className="label">
            Last Name
          </label>
          <input
            id="last_name"
            name="last_name"
            type="text"
            className="input"
            value={data.last_name}
            onChange={(e) => setData("last_name", e.target.value)}
          />
          <ErrorField error={errors.last_name} />
        </fieldset>

        <fieldset className="form-group">
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

        <fieldset className="form-group">
          <label htmlFor="password" className="label">
            Password
          </label>
          <input
            id="password"
            name="password"
            type="password"
            className="input"
            value={data.password}
            onChange={(e) => setData("password", e.target.value)}
          />
          <ErrorField error={errors.password} />
        </fieldset>

        <fieldset className="form-group">
          <label htmlFor="password_confirmation" className="label">
            Confirm password
          </label>
          <input
            id="password_confirmation"
            name="password_confirmation"
            type="password"
            className="input"
            value={data.password_confirmation}
            onChange={(e) => setData("password_confirmation", e.target.value)}
          />
          <ErrorField error={errors.password_confirmation} />
        </fieldset>

        <button className="btn btn-primary" type="submit" disabled={processing}>
          Register
        </button>
      </form>

      <Link href="/login" className="link">
        Login
      </Link>
    </Layout>
  )
}
