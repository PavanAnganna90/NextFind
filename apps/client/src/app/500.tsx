import Image from 'next/image'
import Link from 'next/link'

export default function Custom500() {
  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50">
      <div className="max-w-md w-full text-center">
        <div className="mb-8">
          <h1 className="text-6xl font-bold text-gray-900 mb-4">500</h1>
          <h2 className="text-2xl font-semibold text-gray-700 mb-4">
            Server Error
          </h2>
        </div>
        
        <p className="text-gray-600 mb-8">
          We're sorry, but something went wrong on our end. 
          Our team has been notified and is working to fix the issue.
        </p>
        
        <div className="space-y-4">
          <Link
            href="/"
            className="inline-block bg-black text-white px-6 py-3 rounded-md hover:bg-gray-800 transition-colors"
          >
            Go Home
          </Link>
          
          <div className="text-sm text-gray-500">
            <Link href="/products" className="hover:text-gray-700 underline">
              Browse Products
            </Link>
            {' • '}
            <Link href="/contact" className="hover:text-gray-700 underline">
              Contact Support
            </Link>
          </div>
        </div>
      </div>
    </div>
  )
}

