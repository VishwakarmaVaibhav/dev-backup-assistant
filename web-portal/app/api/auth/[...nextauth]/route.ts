import NextAuth from "next-auth";
import GoogleProvider from "next-auth/providers/google";

export const authOptions = {
  providers: [
    GoogleProvider({
      clientId: process.env.GOOGLE_CLIENT_ID || "",
      clientSecret: process.env.GOOGLE_CLIENT_SECRET || "",
    }),
  ],
  pages: {
    signIn: '/api/auth/signin',
    // error: '/auth/error', 
  },
  callbacks: {
    async session({ session, token }: any) {
      return session;
    },
    async signIn({ user, account, profile }: any) {
      // Allow sign in
      return true;
    }
  },
};

const handler = NextAuth(authOptions);

export { handler as GET, handler as POST };
