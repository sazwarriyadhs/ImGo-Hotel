import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Navbar from './components/Navbar';
import HeroSlider from './components/HeroSlider';
import RoomCard from './components/RoomCard';
import Footer from './components/Footer';
import RestaurantPage from './pages/RestaurantPage';
import SpaPage from './pages/SpaPage';
import PilatesPage from './pages/PilatesPage';
import HotelsPage from './pages/HotelsPage';
import OffersPage from './pages/OffersPage';
import LoginPage from './pages/auth/LoginPage';
import RegisterPage from './pages/auth/RegisterPage';
import { useState, useEffect } from 'react';
import api from './services/api';

function HomePage() {
  const [hotels, setHotels] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => { fetchData(); }, []);

  const fetchData = async () => {
    setLoading(true);
    try {
      const hotelsData = await api.getHotels();
      setHotels(hotelsData);
    } catch (error) { console.error('Error fetching data:', error);
    } finally { setLoading(false); }
  };

  const roomCards = [
    { id: 1, title: "Deluxe Room", description: "Elegant rooms with modern amenities", price: "Rp 1.200.000 / night", buttonText: "Discover More", bgColor: "from-blue-900/50 to-blue-800/50", icon: "🏨" },
    { id: 2, title: "Executive Suite", description: "Spacious suites with living area and city views", price: "From 2.500.000 / night", buttonText: "Discover More", bgColor: "from-purple-900/50 to-purple-800/50", icon: "🏨" },
    { id: 3, title: "Romantic Dinner Package", description: "Luxurious villa with private pool & ocean view", price: "From 900.000 / night", buttonText: "Reserve Table", bgColor: "from-pink-900/50 to-pink-800/50", icon: "🍽️" },
    { id: 4, title: "Priority Reservations", description: "Elegant environs with resort package", price: "From 1.100.000 / night", buttonText: "Reserve Table", bgColor: "from-green-900/50 to-green-800/50", icon: "🏨" }
  ];

  return (
    <>
      <Navbar />
      <HeroSlider />
      <section className="py-20 px-4 text-center"><div className="max-w-4xl mx-auto"><div className="w-20 h-1 bg-gold-500 mx-auto mb-6 rounded-full"></div><h2 className="text-4xl md:text-5xl font-bold mb-4">Explore Our Restaurant</h2><p className="text-lg md:text-xl text-gray-300">Experience exquisite dining at our award-winning restaurants.</p><div className="mt-8"><a href="/restaurant" className="btn-primary inline-block mx-2">Book Now</a><a href="/restaurant" className="btn-outline inline-block mx-2">Explore Menu</a></div></div></section>
      <section className="py-20 px-4 bg-gray-900/30"><div className="container mx-auto"><h2 className="text-3xl md:text-4xl font-bold text-center mb-12">Featured Hotels</h2>
        {loading ? (<div className="text-center py-12"><div className="inline-block w-8 h-8 border-4 border-gold-500 border-t-transparent rounded-full animate-spin"></div><p className="mt-4 text-gray-400">Loading hotels...</p></div>) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
            {hotels.slice(0, 4).map((hotel) => (<div key={hotel.id} className="bg-gradient-to-br from-gray-800 to-gray-900 rounded-xl overflow-hidden border border-gray-700 hover:scale-105 transition-all duration-300"><div className="h-48 bg-gradient-to-br from-gray-700 to-gray-800 flex items-center justify-center"><span className="text-6xl">🏨</span></div><div className="p-6"><h3 className="text-xl font-bold mb-2">{hotel.name}</h3><p className="text-gray-300 text-sm mb-2">{hotel.city}</p><p className="text-gold-500 font-semibold mb-4">Rp {hotel.price?.toLocaleString() || '850,000'} / night</p><a href={`/hotels/${hotel.id}`} className="block w-full text-center border border-gold-500 text-gold-500 hover:bg-gold-500 hover:text-black font-semibold py-2 px-4 rounded-lg transition">Book Now</a></div></div>))}
          </div>
        )}
      </div></section>
      <section className="py-20 px-4"><div className="container mx-auto"><h2 className="text-3xl md:text-4xl font-bold text-center mb-12">Rooms & Suites</h2><div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">{roomCards.map((room) => (<RoomCard key={room.id} {...room} />))}</div></div></section>
      <section className="py-16 px-4"><div className="container mx-auto"><div className="bg-gradient-to-r from-gold-500 to-gold-600 rounded-2xl p-12 text-center text-primary-800"><h3 className="text-3xl md:text-4xl font-bold mb-4">Special Offer!</h3><p className="text-lg md:text-xl mb-6">Get 20% off on all spa packages this weekend</p><a href="/spa" className="inline-block bg-primary-800 text-white px-8 py-3 rounded-lg font-semibold hover:bg-primary-700 transition transform hover:scale-105">Book Now →</a></div></div></section>
      <Footer />
    </>
  );
}

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<HomePage />} />
        <Route path="/hotels" element={<HotelsPage />} />
        <Route path="/restaurant" element={<RestaurantPage />} />
        <Route path="/spa" element={<SpaPage />} />
        <Route path="/pilates" element={<PilatesPage />} />
        <Route path="/offers" element={<OffersPage />} />
        <Route path="/login" element={<LoginPage />} />
        <Route path="/register" element={<RegisterPage />} />
      </Routes>
    </Router>
  );
}

export default App;
