import { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import Navbar from '../../components/Navbar';
import Footer from '../../components/Footer';

export default function RegisterPage() {
  const navigate = useNavigate();
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');
    
    if (password !== confirmPassword) {
      setError('Passwords do not match');
      setLoading(false);
      return;
    }
    
    // Simulasi registrasi berhasil
    setTimeout(() => {
      localStorage.setItem('isLoggedIn', 'true');
      localStorage.setItem('user', JSON.stringify({ name: name, email: email }));
      navigate('/');
      setLoading(false);
    }, 1000);
  };

  return (
    <div className="bg-black text-white min-h-screen">
      <Navbar />
      <div className="relative h-[40vh] bg-gradient-to-r from-primary-800 to-primary-900">
        <div className="absolute inset-0 bg-black/50"></div>
        <div className="relative z-10 flex flex-col items-center justify-center h-full text-center px-4">
          <h1 className="text-5xl md:text-6xl font-bold mb-4">Join IMGO Hotel</h1>
          <p className="text-xl text-gray-300">Create an account and start earning loyalty points</p>
        </div>
      </div>
      <section className="py-16 px-4">
        <div className="container mx-auto max-w-md">
          <div className="bg-gray-800 rounded-2xl p-8 shadow-xl border border-gray-700">
            <div className="text-center mb-8">
              <div className="w-20 h-20 bg-gold-500 rounded-full flex items-center justify-center mx-auto mb-4">
                <span className="text-3xl">✨</span>
              </div>
              <h2 className="text-2xl font-bold">Create Account</h2>
            </div>
            {error && <div className="mb-4 p-3 bg-red-500/20 border border-red-500 rounded-lg text-red-500 text-sm">{error}</div>}
            <form onSubmit={handleSubmit} className="space-y-4">
              <div><label className="block text-sm font-medium mb-2">Full Name</label><input type="text" value={name} onChange={(e) => setName(e.target.value)} required className="w-full px-4 py-3 bg-gray-700 border border-gray-600 rounded-lg focus:outline-none focus:border-gold-500 text-white" placeholder="Enter your full name" /></div>
              <div><label className="block text-sm font-medium mb-2">Email Address</label><input type="email" value={email} onChange={(e) => setEmail(e.target.value)} required className="w-full px-4 py-3 bg-gray-700 border border-gray-600 rounded-lg focus:outline-none focus:border-gold-500 text-white" placeholder="Enter your email" /></div>
              <div><label className="block text-sm font-medium mb-2">Password</label><input type="password" value={password} onChange={(e) => setPassword(e.target.value)} required className="w-full px-4 py-3 bg-gray-700 border border-gray-600 rounded-lg focus:outline-none focus:border-gold-500 text-white" placeholder="Create a password" /></div>
              <div><label className="block text-sm font-medium mb-2">Confirm Password</label><input type="password" value={confirmPassword} onChange={(e) => setConfirmPassword(e.target.value)} required className="w-full px-4 py-3 bg-gray-700 border border-gray-600 rounded-lg focus:outline-none focus:border-gold-500 text-white" placeholder="Confirm your password" /></div>
              <button type="submit" disabled={loading} className="w-full bg-gold-500 text-primary-800 font-semibold py-3 rounded-lg hover:bg-gold-600 transition disabled:opacity-50">{loading ? 'Creating Account...' : 'Sign Up'}</button>
            </form>
            <div className="mt-6 text-center"><p className="text-gray-400">Already have an account? <Link to="/login" className="text-gold-500 hover:underline">Sign In</Link></p></div>
          </div>
        </div>
      </section>
      <Footer />
    </div>
  );
}
