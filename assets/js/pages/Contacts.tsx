import { useUser } from "@/hooks/useUser"
import { Layout } from "@/layouts/Layout"
import { Link } from "@inertiajs/react"

export default function Contacts() {
  const user = useUser()

  return (
    <Layout title="Contacts">
      <h1>Contacts</h1>

      <div>
        <p>Welcome, {user?.first_name}!</p>
        <p>Email: {user?.email}</p>
      </div>

      <div className="flex flex-col gap-2.5">
        <Link href="/settings" className="btn btn-primary">
          Settings
        </Link>

        <Link href="/logout" method="delete" className="btn btn-secondary">
          Logout
        </Link>
      </div>
    </Layout>
  )
}
