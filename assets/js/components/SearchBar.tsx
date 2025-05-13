import { router } from "@inertiajs/react"
import { useDebounce, useIsFirstRender } from "@uidotdev/usehooks"
import * as React from "react"

interface Props {
  initialSearch?: string
}

const routerOptions = {
  preserveState: true,
  preserveScroll: true,
  replace: true
}

export function SearchBar({ initialSearch = "" }: Props) {
  const [search, setSearch] = React.useState(initialSearch)
  const debouncedSearch = useDebounce(search, 300)
  const isFirstRender = useIsFirstRender()

  React.useEffect(() => {
    if (!isFirstRender && debouncedSearch.trim()) {
      router.visit(`/contacts?search=${search}`, routerOptions)
    }

    if (!isFirstRender && debouncedSearch.trim() === "") {
      router.visit(`/contacts`, routerOptions)
    }
  }, [debouncedSearch])

  return (
    <input
      id="search"
      name="search"
      type="text"
      className="input"
      placeholder="Search contacts..."
      value={search}
      onChange={(e) => setSearch(e.target.value)}
    />
  )
}
