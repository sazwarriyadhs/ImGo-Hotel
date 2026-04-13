import { Link } from 'react-router-dom';
import { Twitter, Facebook, Instagram } from 'lucide-react';

export default function Footer() {
  return (
    <footer className="bg-gray-900 text-gray-400 py-12 px-4 mt-12">
      <div className="container mx-auto flex flex-wrap justify-between items-start">
        <div className="w-full md:w-1/4 mb-8 md:mb-0">
          <div className="flex items-center space-x-4 mb-4">
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
                    parent.innerHTML = '<span class="text-gold-500 font-bold text-3xl">IMG</span>';
                  }
                }}
              />
            </div>
            <div>
              <span className="text-xl font-bold text-white">IMGO HOTEL</span>
              <p className="text-xs text-gray-400">Premium hospitality</p>
            </div>
          </div>
          <p className="text-sm">Premium hospitality across Indonesia.</p>
        </div>
        <div className="w-full md:w-auto mb-8 md:mb-0">
          <h3 className="font-bold text-white mb-4">Quick Links</h3>
          <ul className="space-y-2 text-sm">
            <li><Link to="/" className="hover:text-gold-500 transition">Home</Link></li>
            <li><Link to="/about" className="hover:text-gold-500 transition">About Us</Link></li>
            <li><Link to="/concierge" className="hover:text-gold-500 transition">Concierge</Link></li>
          </ul>
        </div>
        <div className="w-full md:w-auto mb-8 md:mb-0">
          <h3 className="font-bold text-white mb-4">Contact</h3>
          <p className="text-sm">Jl. Sudirman No. 11, Jakarta</p>
          <p className="text-sm">Indonesia</p>
          <p className="text-sm mt-2">contact@imgohotel.com</p>
        </div>
        <div className="w-full md:w-auto">
          <div className="flex space-x-4 mb-4">
            <a href="#" className="hover:text-gold-500 transition"><Twitter className="h-5 w-5" /></a>
            <a href="#" className="hover:text-gold-500 transition"><Facebook className="h-5 w-5" /></a>
            <a href="#" className="hover:text-gold-500 transition"><Instagram className="h-5 w-5" /></a>
          </div>
          <p className="text-sm">+62 21 555-1234</p>
          <div className="flex space-x-4 mt-2 text-xs">
            <a href="#" className="hover:text-gold-500 transition">Privacy Policy</a>
            <span>|</span>
            <a href="#" className="hover:text-gold-500 transition">Terms of Service</a>
          </div>
        </div>
      </div>
      <div className="text-center text-xs text-gray-500 mt-8 pt-8 border-t border-gray-800">
        © 2026 IMGO HOTEL. All rights reserved.
      </div>
    </footer>
  );
}
