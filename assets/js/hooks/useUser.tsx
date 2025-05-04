import type { User } from "@/types/user"
import type { PageProps } from "@inertiajs/core"
import { usePage } from "@inertiajs/react"

export function useUser(): User | null {
  const { current_user } = usePage<PageProps & { current_user: User | null }>().props
  return current_user
}
