import { Link } from "@inertiajs/react"

interface Props {
  items: Array<number | string>
  params: Record<string, string>
}

export function Pagination({ items, params }: Props) {
  const currentPage = Number(params?.page || "1")

  return (
    <div className="join">
      {items.map((item) => {
        if (typeof item === "string") {
          return <button className="join-item btn btn-disabled">...</button>
        }

        return (
          <Link
            href="/contacts"
            data={{ ...params, page: item > 1 ? item : undefined }}
            as="button"
            className={`join-item btn ${currentPage === item ? "btn-active" : ""}`}
            preserveScroll
          >
            {item}
          </Link>
        )
      })}
    </div>
  )
}
