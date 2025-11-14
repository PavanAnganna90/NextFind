'use client'

import { AuthProvider } from '@/contexts/AuthContext'
import { SessionProvider } from 'next-auth/react'

export function Providers({ children }: { children: React.ReactNode }) {
  return (
    <SessionProvider>
      <AuthProvider>
        {children}
      </AuthProvider>
    </SessionProvider>
  )
}
