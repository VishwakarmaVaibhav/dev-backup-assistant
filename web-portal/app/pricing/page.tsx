import Link from 'next/link';

export default function PricingPage() {
  return (
    <div className="min-h-screen bg-gray-900 text-white font-sans py-20 px-6">
      <div className="max-w-4xl mx-auto text-center">
        <h1 className="text-4xl font-bold mb-4">Simple, Transparent Pricing</h1>
        <p className="text-gray-400 mb-12 text-xl">Choose the plan that fits your needs.</p>

        <div className="grid md:grid-cols-2 gap-8 items-center">
          
          {/* Free Trial Card */}
          <div className="bg-gray-800 p-8 rounded-2xl border border-gray-700 hover:border-teal-500 transition">
            <h2 className="text-2xl font-bold mb-4">Free Trial</h2>
            <p className="text-4xl font-extrabold mb-6">₹0</p>
            <ul className="text-left space-y-3 mb-8 text-gray-300">
              <li>✅ 3 Free Backups</li>
              <li>✅ Full Feature Access</li>
              <li>✅ No Credit Card Required</li>
              <li>❌ No Technical Support</li>
            </ul>
            <a href="#" className="block w-full py-3 px-6 bg-gray-700 hover:bg-gray-600 rounded-lg font-bold transition">
              Download Trial
            </a>
          </div>

          {/* Pro License Card */}
          <div className="bg-gray-800 p-8 rounded-2xl border-2 border-teal-500 relative transform md:scale-105 shadow-2xl shadow-teal-500/20">
            <div className="absolute top-0 right-0 bg-teal-500 text-xs font-bold px-3 py-1 rounded-bl-lg rounded-tr-lg">
              BEST VALUE
            </div>
            <h2 className="text-2xl font-bold mb-4 text-teal-400">Lifetime License</h2>
            <p className="text-4xl font-extrabold mb-6">₹200 <span className="text-lg font-normal text-gray-500">/ one-time</span></p>
            <ul className="text-left space-y-3 mb-8 text-gray-300">
              <li>✅ Unlimited Backups</li>
              <li>✅ Lifetime Updates</li>
              <li>✅ Priority Support</li>
              <li>✅ Commercial Use</li>
            </ul>
            <Link href="/checkout" className="block w-full py-3 px-6 bg-teal-500 hover:bg-teal-600 rounded-lg font-bold text-white transition">
              Buy Now
            </Link>
          </div>

        </div>
      <div className="mt-12">
        <Link href="/" className="text-gray-400 hover:text-white underline">
          &larr; Back to Home
        </Link>
      </div>
      </div>
    </div>
  );
}
