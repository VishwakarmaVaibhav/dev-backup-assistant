import { NextResponse } from 'next/server';
import crypto from 'crypto';

export async function POST(request: Request) {
    try {
        const body = await request.json();
        const { txnid, amount, productinfo, firstname, email } = body;

        const salt = process.env.PAYU_SALT || "YOUR_TEST_SALT";
        const key = process.env.PAYU_KEY || "GTKFFx"; // Default Test Key

        // Hash Sequence: key|txnid|amount|productinfo|firstname|email|udf1|udf2|...|udf10||||||salt
        // We use empty UDFs for now
        const hashString = `${key}|${txnid}|${amount}|${productinfo}|${firstname}|${email}|||||||||||${salt}`;
        
        const hash = crypto.createHash('sha512').update(hashString).digest('hex');

        return NextResponse.json({ hash, key });
    } catch (e) {
        return NextResponse.json({ error: 'Hash generation failed' }, { status: 500 });
    }
}
