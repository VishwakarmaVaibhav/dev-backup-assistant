import Link from 'next/link';
import Image from 'next/image';

export default function Home() {
  return (
    <div className="min-h-screen bg-[#0a0a10] text-[#f0f0f5] font-sans">
      {/* Header */}
      <header className="container mx-auto px-6 py-6 flex justify-between items-center">
        <div className="text-2xl font-extrabold text-[#00c8b4] tracking-tighter">BACKUP PRO</div>
        <nav className="flex items-center space-x-6">
          <Link href="#features" className="hover:text-[#00c8b4] transition">Features</Link>
          <Link href="/pricing" className="hover:text-[#00c8b4] transition">Pricing</Link>
           <Link href="/api/auth/signin" className="text-gray-300 hover:text-white transition">
            Login
          </Link>
          <a href="/download/Backup-Pro-Setup-v120.exe" className="bg-[#00c8b4] hover:bg-[#00b0a0] text-[#0a0a10] px-4 py-2 rounded-lg font-bold transition shadow-lg shadow-[#00c8b4]/20">
            Download
          </a>
        </nav>
      </header>

      {/* Hero Section */}
      <section className="relative min-h-[80vh] flex items-center justify-center pt-20 overflow-hidden">
        {/* Glow Effect */}
        <div className="absolute top-0 left-1/2 -translate-x-1/2 w-[800px] h-[800px] bg-[radial-gradient(circle,rgba(0,200,180,0.15)_0%,transparent_70%)] pointer-events-none"></div>

        <div className="container mx-auto px-6 text-center z-10">
          <div className="text-6xl md:text-7xl font-extrabold mb-6 text-[#00c8b4] tracking-tight">
            BACKUP PRO
          </div>
          <h1 className="text-3xl md:text-4xl font-bold mb-6 text-white">
            Automatic Project Backups Made Easy
          </h1>
          <p className="text-xl text-[#8c8ca0] max-w-2xl mx-auto mb-10 leading-relaxed">
            Free, open-source backup tool for developers. Get daily popup reminders,
            smart file exclusions, and one-click sharing.
          </p>
          
          <div className="flex flex-wrap justify-center gap-4">
             <a href="/download/Backup-Pro-Setup-v120.exe" className="bg-[#00c8b4] hover:bg-[#00b0a0] text-[#0a0a10] px-8 py-4 rounded-xl text-lg font-bold transition transform hover:-translate-y-1 hover:shadow-xl hover:shadow-[#00c8b4]/30 flex items-center gap-2">
                <span>⬇</span> Download for Windows
             </a>
             <Link href="/pricing" className="bg-[#12121a] border border-[#00c8b4] text-white px-8 py-4 rounded-xl text-lg font-bold transition hover:bg-[#00c8b4]/10 flex items-center gap-2">
                <span>💎</span> Get License
             </Link>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section id="features" className="py-24 bg-[#0a0a10]">
        <div className="container mx-auto px-6">
          <h2 className="text-4xl font-bold text-center mb-16 text-white">Why Backup Pro?</h2>
          <div className="grid md:grid-cols-3 gap-8">
            <FeatureCard 
              icon="⏰" 
              title="Daily Reminders" 
              desc="Get popup notifications at your preferred time. Different schedules for different days." 
            />
            <FeatureCard 
              icon="🚀" 
              title="Smart Exclusions" 
              desc="Automatically skips node_modules, .git, dist, build folders. Clean backups every time." 
            />
            <FeatureCard 
              icon="🧹" 
              title="Auto Cleanup" 
              desc="Configure how many backups to keep. Older ones are automatically deleted." 
            />
            <FeatureCard 
              icon="📤" 
              title="Easy Sharing" 
              desc="One-click to open folder, send via email, or copy path for quick sharing." 
            />
             <FeatureCard 
              icon="🎨" 
              title="Beautiful UI" 
              desc="Modern dark theme interface. Welcome wizard for first-time setup." 
            />
             <FeatureCard 
              icon="💯" 
              title="100% Free Trial" 
              desc="Try it out with our generous free trial. Upgrade only when you need pro features." 
            />
          </div>
        </div>
      </section>

      {/* How It Works */}
      <section className="py-24 bg-[#12121a]">
        <div className="container mx-auto px-6 text-center">
            <h2 className="text-4xl font-bold mb-16 text-white">How It Works</h2>
            <div className="flex flex-wrap justify-center gap-12">
                <Step number="1" title="Download & Install" desc="Download the installer and run setup." />
                <Step number="2" title="Configure" desc="Set your project folder and schedule." />
                <Step number="3" title="Relax" desc="Daily popups remind you to backup. One click done!" />
            </div>
        </div>
      </section>

      {/* Download CTA */}
      <section className="py-24 text-center">
          <div className="container mx-auto px-6">
              <div className="bg-gradient-to-br from-[#00c8b4]/10 to-[#00c8b4]/5 border border-[#00c8b4] rounded-3xl p-16 max-w-3xl mx-auto">
                  <h2 className="text-3xl font-bold mb-4 text-white">Ready to secure your code?</h2>
                  <p className="text-[#8c8ca0] mb-8 text-lg">Download Backup Pro and never lose your work again.</p>
                  <a href="/download/Backup-Pro-Setup-v120.exe" className="inline-block bg-[#00c8b4] hover:bg-[#00b0a0] text-[#0a0a10] px-10 py-5 rounded-xl text-xl font-bold transition shadow-lg shadow-[#00c8b4]/30">
                      Download Now - Free Trial
                  </a>
                  <div className="mt-8 text-sm text-[#8c8ca0] border-t border-white/10 pt-6">
                      <strong>Requirements:</strong> Windows 10/11 • Node.js • WinRAR
                  </div>
              </div>
          </div>
      </section>

      {/* Footer */}
      <footer className="py-10 text-center border-t border-white/5 bg-[#0a0a10]">
        <p className="text-[#8c8ca0]">
            Made with ❤️ by <a href="https://github.com/VishwakarmaVaibhav" className="text-[#00c8b4] hover:underline">Vaibhav</a> • 
            <a href="https://github.com/VishwakarmaVaibhav/dev-backup-assistant" className="text-[#00c8b4] hover:underline ml-2">GitHub</a>
        </p>
      </footer>
    </div>
  );
}

function FeatureCard({ icon, title, desc }: { icon: string, title: string, desc: string }) {
  return (
    <div className="bg-[#12121a] p-8 rounded-2xl border border-white/5 hover:border-[#00c8b4] hover:-translate-y-1 transition duration-300 group">
      <div className="text-4xl mb-6 group-hover:scale-110 transition-transform">{icon}</div>
      <h3 className="text-xl font-bold mb-3 text-white">{title}</h3>
      <p className="text-[#8c8ca0] leading-relaxed">{desc}</p>
    </div>
  );
}

function Step({ number, title, desc }: { number: string, title: string, desc: string }) {
    return (
        <div className="max-w-[250px] text-center">
            <div className="w-16 h-16 rounded-full bg-[#00c8b4] text-[#0a0a10] text-2xl font-bold flex items-center justify-center mx-auto mb-6 shadow-lg shadow-[#00c8b4]/40">
                {number}
            </div>
            <h3 className="text-xl font-bold mb-2 text-white">{title}</h3>
            <p className="text-[#8c8ca0]">{desc}</p>
        </div>
    );
}
