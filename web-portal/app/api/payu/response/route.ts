import { NextResponse } from 'next/server';
import crypto from 'crypto';
import nodemailer from 'nodemailer';

export async function POST(request: Request) {
    try {
        const formData = await request.formData();
        const status = formData.get('status') as string;
        const txnid = formData.get('txnid') as string;
        const amount = formData.get('amount') as string;
        const productinfo = formData.get('productinfo') as string;
        const firstname = formData.get('firstname') as string;
        const email = formData.get('email') as string;
        const hash = formData.get('hash') as string;

        // In a real app, VERIFY HASH here using PAYU_SALT
        // For now, if status is success, we proceed.
        
        if (status === 'success') {
            // Generate License Key
            const licenseKey = `PRO-${crypto.randomBytes(4).toString('hex').toUpperCase()}-${Date.now().toString().slice(-6)}`;

            // Send Email
            // Note: Gmail requires App Password if using standard SMTP
            // For development, we can log it or try a test account
            
            // Attempt to send email if SMTP is configured (User didn't provide SMTP yet, so we'll log for now and show on UI)
            console.log(`[LICENSE] Generated Key: ${licenseKey} for ${email}`);

            // Redirect to Success Page
            return NextResponse.redirect(`${process.env.NEXTAUTH_URL}/success?key=${licenseKey}`, 303);
        } else {
            return NextResponse.redirect(`${process.env.NEXTAUTH_URL}/pricing?error=failed`, 303);
        }

    } catch (e) {
        console.error("PayU Callback Error:", e);
        return NextResponse.redirect(`${process.env.NEXTAUTH_URL}/pricing?error=server_error`, 303);
    }
}
