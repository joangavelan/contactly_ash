import { Layout } from "@/layouts/Layout"
import { Link } from "@inertiajs/react"

export default function Home() {
  return (
    <Layout title="Home">
      <h1>Contactly</h1>

      <Link href="/contacts" className="btn">
        Go to main application
      </Link>
    </Layout>
  )
}
