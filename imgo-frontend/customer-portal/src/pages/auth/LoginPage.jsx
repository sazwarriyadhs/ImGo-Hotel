import { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import Navbar from '../../components/Navbar';
import Footer from '../../components/Footer';

export default function LoginPage() {
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');
    
    // Demo login
    if (email === 'sarah.wilson@example.com' && password === 'customer123') {
      localStorage.setItem('isLoggedIn', 'true');
      localStorage.setItem('user', JSON.stringify({ name: 'Sarah Wilson', email: email }));
      navigate('/');
    } else if (email === 'john.doe@example.com' && password === 'customer123') {
      localStorage.setItem('isLoggedIn', 'true');
      localStorage.setItem('user', JSON.stringify({ name: 'John Doe', email: email }));
      navigate('/');
    } else {
      setError('Invalid email or password');
    }
    setLoading(false);
  };

  return (
    <div className="bg-black text-white min-h-screen">
      <Navbar />
      <div className="relative h-[40vh] bg-gradient-to-r from-primary-800 to-primary-900">
        <div className="absolute inset-0 bg-black/50"></div>
        <div className="relative z-10 flex flex-col items-center justify-center h-full text-center px-4">
          <h1 className="text-5xl md:text-6xl font-bold mb-4">Welcome Back</h1>
          <p className="text-xl text-gray-300">Sign in to continue your luxury experience</p>
        </div>
      </div>
      <section className="py-16 px-4">
        <div className="container mx-auto max-w-md">
          <div className="bg-gray-800 rounded-2xl p-8 shadow-xl border border-gray-700">
            <div className="text-center mb-8">
              <div className="w-20 h-20 bg-gold-500 rounded-full flex items-center justify-center mx-auto mb-4">
                <span className="text-3xl">👤</span>
              </div>
              <h2 className="text-2xl font-bold">Sign In</h2>
            </div>
            {error && <div className="mb-4 p-3 bg-red-500/20 border border-red-500 rounded-lg text-red-500 text-sm">{error}</div>}
            <form onSubmit={handleSubmit} className="space-y-5">
              <div>
                <label className="block text-sm font-medium mb-2">Email Address</label>
                <input type="email" value={email} onChange={(e) => setEmail(e.target.value)} required className="w-full px-4 py-3 bg-gray-700 border border-gray-600 rounded-lg focus:outline-none focus:border-gold-500 text-white" placeholder="Enter your email" />
              </div>
              <div>
                <label className="block text-sm font-medium mb-2">Password</label>
                <input type="password" value={password} onChange={(e) => setPassword(e.target.value)} required className="w-full px-4 py-3 bg-gray-700 border border-gray-600 rounded-lg focus:outline-none focus:border-gold-500 text-white" placeholder="Enter your password" />
              </div>
              <button type="submit" disabled={loading} className="w-full bg-gold-500 text-primary-800 font-semibold py-3 rounded-lg hover:bg-gold-600 transition disabled:opacity-50">
                {loading ? 'Signing in...' : 'Sign In'}
              </button>
            </form>
            <div className="mt-6 text-center">
              <p className="text-gray-400">Don't have an account? <Link to="/register" className="text-gold-500 hover:underline">Sign Up</Link></p>
            </div>
            <div className="mt-6 p-4 bg-gray-700/30 rounded-lg">
              <p className="text-sm text-center text-gray-400 mb-2">Demo Credentials</p>
              <p className="text-xs text-center text-gray-500">Email: sarah.wilson@example.com</p>
              <p className="text-xs text-center text-gray-500">Password: customer123</p>
            </div>
          </div>
        </div>
      </section>
      <Footer />
    </div>
  );
}
