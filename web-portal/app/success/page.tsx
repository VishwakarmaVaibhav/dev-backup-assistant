'use client';

import { useSearchParams } from 'next/navigation';
import Link from 'next/link';
import { useEffect, useState, Suspense } from 'react';

function SuccessContent() {
  const searchParams = useSearchParams();
  const key = searchParams.get('key');
  const [copied, setCopied] = useState(false);

  useEffect(() => {
    if (key) {
      // Attempt Auto-Activation via Deep Link
      window.location.href = `backuppro://activate?key=${key}`;
    }
  }, [key]);

  const copyToClipboard = () => {
    if (key) {
      navigator.clipboard.writeText(key);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    }
  };

  return (
    <div className="w-full max-w-lg bg-gray-800 p-8 rounded-2xl shadow-xl border border-teal-500/30 text-center">
        <div className="mb-6 flex justify-center">
          <div className="h-20 w-20 bg-teal-500/20 rounded-full flex items-center justify-center">
            <svg className="h-10 w-10 text-teal-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M5 13l4 4L19 7" />
            </svg>
          </div>
        </div>
        
        <h1 className="text-3xl font-bold mb-4 text-white">Payment Successful!</h1>
        <p className="text-gray-400 mb-8">Thank you for your purchase. Your copy of Backup Pro is ready to activate.</p>

        <div className="bg-gray-900 p-4 rounded-lg border border-gray-700 mb-8 relative">
          <p className="text-xs text-gray-500 uppercase tracking-wide mb-1">Your License Key</p>
          <div className="font-mono text-xl text-teal-400 select-all">{key || 'Loading...'}</div>
          
          <button 
            onClick={copyToClipboard}
            className="absolute top-1/2 right-4 transform -translate-y-1/2 text-gray-500 hover:text-white"
            title="Copy to clipboard"
          >
            {copied ? (
               <svg className="h-5 w-5 text-green-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                 <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M5 13l4 4L19 7" />
               </svg>
            ) : (
              <svg className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
              </svg>
            )}
          </button>
        </div>

        <div className="space-y-4">
          <Link 
            href={`backuppro://activate?key=${key}`}
            className="block w-full py-4 px-6 bg-teal-500 hover:bg-teal-600 rounded-lg font-bold text-white transition shadow-lg shadow-teal-500/25"
          >
            Activate App Now
          </Link>
          
          <Link href="/" className="block text-gray-500 hover:text-gray-300 text-sm">
            Return to Home
          </Link>
        </div>
      </div>
  );
}

export default function SuccessPage() {
  return (
    <div className="min-h-screen bg-gray-900 text-white font-sans py-20 px-6 flex items-center justify-center">
      <Suspense fallback={<div>Loading...</div>}>
        <SuccessContent />
      </Suspense>
    </div>
  );
}
