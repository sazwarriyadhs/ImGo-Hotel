import { Menu, X, Bell, User } from 'lucide-react';
import { useState, useEffect } from 'react';
import { Link, useNavigate } from 'react-router-dom';

export default function Navbar() {
  const [isOpen, setIsOpen] = useState(false);
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [userName, setUserName] = useState('');
  const navigate = useNavigate();

  useEffect(() => {
    const checkLoginStatus = () => {
      const loggedIn = localStorage.getItem('isLoggedIn') === 'true';
      const user = localStorage.getItem('user');
      setIsLoggedIn(loggedIn);
      if (user) {
        try {
          const userData = JSON.parse(user);
          setUserName(userData.name || userData.email?.split('@')[0] || 'User');
        } catch (e) {
          setUserName('User');
        }
      }
    };
    checkLoginStatus();
    window.addEventListener('storage', checkLoginStatus);
    return () => window.removeEventListener('storage', checkLoginStatus);
  }, []);

  const handleLogout = () => {
    localStorage.removeItem('user');
    localStorage.removeItem('isLoggedIn');
    setIsLoggedIn(false);
    navigate('/');
  };

  return (
    <header className="absolute top-0 left-0 right-0 z-50 flex justify-between items-center p-6 md:p-8 bg-gradient-to-b from-black/50 to-transparent">
      <Link to="/" className="flex items-center space-x-4">
        {/* Logo 150x150 tanpa border, tanpa background */}
        <div className="w-[150px] h-[150px] flex items-center justify-center">
          <img 
            src="/images/logo.png" 
            alt="IMGO Hotel Logo" 
            className="w-full h-full object-contain"
            style={{ background: 'transparent' }}
            onError={(e) => {
              e.target.style.display = 'none';
              const parent = e.target.parentElement;
              if (parent) {
                parent.innerHTML = '<span class="text-gold-500 font-bold text-4xl">IMG</span>';
              }
            }}
          />
        </div>
        <div>
          <span className="text-2xl font-bold tracking-wide">IMGO HOTEL</span>
          <p className="text-xs text-gray-300 -mt-1">Luxury Stay</p>
        </div>
      </Link>
      
      <nav className="hidden md:flex items-center space-x-8 text-lg">
        <Link to="/" className="nav-link font-medium hover:text-gold-500 transition">Home</Link>
        <Link to="/hotels" className="nav-link font-medium hover:text-gold-500 transition">Hotels</Link>
        <Link to="/restaurant" className="nav-link font-medium hover:text-gold-500 transition">Restaurant</Link>
        <Link to="/spa" className="nav-link font-medium hover:text-gold-500 transition">Spa</Link>
        <Link to="/pilates" className="nav-link font-medium hover:text-gold-500 transition">Pilates</Link>
        <Link to="/offers" className="nav-link font-medium hover:text-gold-500 transition">Offers</Link>
        {isLoggedIn ? (
          <div className="relative group">
            <button className="flex items-center gap-2 nav-link font-medium">
              <User className="h-5 w-5" />
              <span>{userName}</span>
            </button>
            <div className="absolute right-0 mt-2 w-48 bg-gray-800 rounded-lg shadow-lg overflow-hidden hidden group-hover:block">
              <Link to="/profile" className="block px-4 py-2 text-sm hover:bg-gray-700 transition">My Profile</Link>
              <Link to="/bookings" className="block px-4 py-2 text-sm hover:bg-gray-700 transition">My Bookings</Link>
              <button onClick={handleLogout} className="block w-full text-left px-4 py-2 text-sm hover:bg-gray-700 transition text-red-400">
                Logout
              </button>
            </div>
          </div>
        ) : (
          <Link to="/login" className="bg-gold-500 text-primary-800 px-4 py-2 rounded-lg font-semibold hover:bg-gold-600 transition">
            Sign In
          </Link>
        )}
      </nav>

      <div className="flex items-center space-x-4">
        <Bell className="h-6 w-6 hover:text-gold-500 cursor-pointer transition" />
        <button className="md:hidden text-white" onClick={() => setIsOpen(!isOpen)}>
          {isOpen ? <X className="h-6 w-6" /> : <Menu className="h-6 w-6" />}
        </button>
      </div>

      {isOpen && (
        <div className="absolute top-24 left-0 right-0 bg-black/95 backdrop-blur-lg p-6 flex flex-col space-y-4 md:hidden border-b border-gray-800">
          <Link to="/" className="nav-link text-lg py-2 hover:text-gold-500" onClick={() => setIsOpen(false)}>Home</Link>
          <Link to="/hotels" className="nav-link text-lg py-2 hover:text-gold-500" onClick={() => setIsOpen(false)}>Hotels</Link>
          <Link to="/restaurant" className="nav-link text-lg py-2 hover:text-gold-500" onClick={() => setIsOpen(false)}>Restaurant</Link>
          <Link to="/spa" className="nav-link text-lg py-2 hover:text-gold-500" onClick={() => setIsOpen(false)}>Spa</Link>
          <Link to="/pilates" className="nav-link text-lg py-2 hover:text-gold-500" onClick={() => setIsOpen(false)}>Pilates</Link>
          <Link to="/offers" className="nav-link text-lg py-2 hover:text-gold-500" onClick={() => setIsOpen(false)}>Offers</Link>
          {isLoggedIn ? (
            <>
              <Link to="/profile" className="nav-link text-lg py-2 hover:text-gold-500" onClick={() => setIsOpen(false)}>My Profile</Link>
              <Link to="/bookings" className="nav-link text-lg py-2 hover:text-gold-500" onClick={() => setIsOpen(false)}>My Bookings</Link>
              <button onClick={handleLogout} className="text-left text-red-400 text-lg py-2 hover:text-red-300">Logout</button>
            </>
          ) : (
            <Link to="/login" className="bg-gold-500 text-primary-800 text-center px-4 py-2 rounded-lg font-semibold" onClick={() => setIsOpen(false)}>
              Sign In
            </Link>
          )}
        </div>
      )}
    </header>
  );
}
