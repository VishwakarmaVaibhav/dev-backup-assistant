'use client';

import { useState } from 'react';
import { useSession, signIn } from 'next-auth/react';

export default function CheckoutPage() {
  const { data: session } = useSession();
  const [loading, setLoading] = useState(false);

  // Default Test Data
  const amount = "200.00";
  const productinfo = "Backup Pro License";
  
  // Handled by API
  const [payuData, setPayuData] = useState<any>(null);

  const initiatePayment = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!session) {
        signIn('google');
        return;
    }

    setLoading(true);
    const txnid = "TXN" + Date.now();
    const firstname = session.user?.name?.split(' ')[0] || "User";
    const email = session.user?.email || "user@example.com";

    // Get Hash from Server
    const res = await fetch('/api/payu/hash', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ txnid, amount, productinfo, firstname, email })
    });

    const data = await res.json();
    if (data.hash) {
        setPayuData({
            key: data.key,
            txnid,
            amount,
            productinfo,
            firstname,
            email,
            phone: "9999999999", // Dummy for test
            surl: `${window.location.origin}/api/payu/response`, 
            furl: `${window.location.origin}/api/payu/response`,
            hash: data.hash
        });
        
        // Auto-submit form after state update (using effect) or manual
        setTimeout(() => {
            (document.getElementById('payuForm') as HTMLFormElement)?.submit();
        }, 500);
    } else {
        alert("Payment Intiation Failed");
        setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-[#0a0a10] text-[#f0f0f5] font-sans py-20 px-6 flex items-center justify-center">
      <div className="w-full max-w-md bg-[#12121a] p-8 rounded-2xl shadow-xl border border-white/5">
        <h1 className="text-2xl font-bold mb-6 text-center text-white">Complete Your Purchase</h1>
        
        <div className="mb-6 p-4 bg-white/5 rounded-lg flex justify-between items-center border border-white/10">
          <div>
            <h3 className="font-bold text-white">Backup Pro Lifetime</h3>
            <p className="text-sm text-[#8c8ca0]">One-time payment</p>
          </div>
          <div className="text-xl font-bold text-[#00c8b4]">₹200</div>
        </div>

        {/* User Info / Login Prompt */}
        {!session ? (
            <button onClick={() => signIn('google')} className="w-full py-3 px-6 bg-[#4285F4] hover:bg-[#357ae8] text-white rounded-lg font-bold mb-6 flex justify-center items-center gap-2">
                <svg className="w-4 h-4" viewBox="0 0 24 24"><path fill="currentColor" d="M12.48 10.92v3.28h7.84c-.24 1.84-.853 3.187-1.787 4.133-1.147 1.147-2.933 2.4-6.053 2.4-4.827 0-8.6-3.893-8.6-8.72s3.773-8.72 8.6-8.72c2.6 0 4.507 1.027 5.907 2.347l2.307-2.307C18.747 1.44 16.133 0 12.48 0 5.867 0 0 5.867 0 12.48c0 6.613 5.867 12.48 12.48 12.48 3.6 0 6.333-1.187 8.547-3.483 2.253-2.253 2.947-5.36 2.947-7.92 0-.787-.067-1.453-.173-2.147H12.48z"/></svg>
                Sign in with Google
            </button>
        ) : (
             <div className="mb-6 text-sm text-[#8c8ca0] text-center">
                Logged in as <span className="text-[#00c8b4]">{session.user?.email}</span>
            </div>
        )}

        {/* PayU Form (Hidden or Visual) */}
        {!payuData ? (
            <button 
              onClick={initiatePayment}
              disabled={loading || !session}
              className={`w-full py-3 px-6 rounded-lg font-bold text-[#0a0a10] transition flex justify-center items-center ${
                loading || !session ? 'bg-gray-600 cursor-not-allowed text-gray-400' : 'bg-[#00c8b4] hover:bg-[#00b0a0]'
              }`}
            >
              {loading ? 'Processing...' : 'Pay ₹200 via PayU'}
            </button>
        ) : (
            <form action="https://test.payu.in/_payment" method="post" id="payuForm" className="text-center">
                <input type="hidden" name="key" value={payuData.key} />
                <input type="hidden" name="txnid" value={payuData.txnid} />
                <input type="hidden" name="productinfo" value={payuData.productinfo} />
                <input type="hidden" name="amount" value={payuData.amount} />
                <input type="hidden" name="email" value={payuData.email} />
                <input type="hidden" name="firstname" value={payuData.firstname} />
                <input type="hidden" name="phone" value={payuData.phone} />
                <input type="hidden" name="surl" value={payuData.surl} />
                <input type="hidden" name="furl" value={payuData.furl} />
                <input type="hidden" name="hash" value={payuData.hash} />
                
                <p className="text-white mb-2">Redirecting to Payment Gateway...</p>
                <button type="submit" className="bg-[#00c8b4] text-[#0a0a10] px-4 py-2 rounded font-bold">
                    Click if not redirected
                </button>
            </form>
        )}
          
        <p className="text-xs text-center text-gray-500 mt-4">
          Secured by PayU. License key sent to your email.
        </p>
      </div>
    </div>
  );
}
