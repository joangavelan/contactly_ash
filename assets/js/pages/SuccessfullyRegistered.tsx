import { Layout } from "@/layouts/Layout"
import { Link } from "@inertiajs/react"

export default function SuccessfullyRegistered() {
  return (
    <Layout title="Success!">
      <div>
        <h1>Successfully Registered!</h1>
        <p>We've sent you an email with instructions to confirm your account.</p>
      </div>

      <div className="flex flex-col gap-1.5">
        <Link href="/confirm-user" className="link">
          ¿Didn't receive the email?
        </Link>

        <Link href="/login" className="link">
          Login
        </Link>
      </div>
    </Layout>
  )
}
