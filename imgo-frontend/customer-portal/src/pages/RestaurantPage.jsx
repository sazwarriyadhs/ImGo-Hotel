// C:\imgo-enterprise\imgo-frontend\customer-portal\src\pages\RestaurantPage.jsx
import { useState, useEffect } from 'react';
import Navbar from '../components/Navbar';
import Footer from '../components/Footer';

const RestaurantPage = () => {
  const [menus, setMenus] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [selectedCategory, setSelectedCategory] = useState('all');
  const [searchTerm, setSearchTerm] = useState('');

  // Fetch menus from API
  const fetchMenus = async () => {
    try {
      setLoading(true);
      const response = await fetch('http://127.0.0.1:8094/api/menus');
      if (!response.ok) throw new Error('Failed to fetch menus');
      const data = await response.json();
      setMenus(data);
      setError(null);
    } catch (err) {
      console.error('Error fetching menus:', err);
      setError(err.message || 'Failed to load menus');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchMenus();
  }, []);

  // Get unique categories from database
  const categories = ['all', ...new Set(menus.map(m => m.category))];

  // Filter menus based on category and search
  const filteredMenus = menus.filter(menu => {
    const matchCategory = selectedCategory === 'all' || menu.category === selectedCategory;
    const matchSearch = searchTerm === '' || 
      menu.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      (menu.description && menu.description.toLowerCase().includes(searchTerm.toLowerCase()));
    return matchCategory && matchSearch;
  });

  // Format price to Rupiah
  const formatPrice = (price) => {
    return new Intl.NumberFormat('id-ID', {
      style: 'currency',
      currency: 'IDR',
      minimumFractionDigits: 0
    }).format(price);
  };

  if (loading) {
    return (
      <div className="bg-black text-white min-h-screen">
        <Navbar />
        <div className="flex items-center justify-center h-screen pt-16">
          <div className="text-center">
            <div className="w-12 h-12 border-4 border-gold-500 border-t-transparent rounded-full animate-spin mx-auto" />
            <p className="mt-4 text-gray-400">Loading menu...</p>
          </div>
        </div>
        <Footer />
      </div>
    );
  }

  if (error) {
    return (
      <div className="bg-black text-white min-h-screen">
        <Navbar />
        <div className="flex items-center justify-center h-screen pt-16">
          <div className="bg-gray-900 rounded-2xl p-8 text-center max-w-md">
            <p className="text-4xl mb-4">⚠️</p>
            <p className="text-gray-300">{error}</p>
            <button 
              onClick={fetchMenus}
              className="mt-6 px-6 py-2 bg-gold-500 text-black rounded-lg hover:bg-gold-600 transition"
            >
              Try Again
            </button>
          </div>
        </div>
        <Footer />
      </div>
    );
  }

  return (
    <div className="bg-black text-white min-h-screen">
      <Navbar />
      <div className="pt-32 px-4">
        <div className="container mx-auto">
          {/* Hero Section */}
          <div className="text-center mb-8">
            <p className="text-gold-500 uppercase tracking-[0.3em] text-sm mb-3">Exquisite Dining</p>
            <h1 className="text-4xl md:text-5xl font-bold mb-4">Our Restaurant</h1>
            <p className="text-gray-400 max-w-2xl mx-auto">
              Experience culinary excellence with our authentic Indonesian and international cuisine
            </p>
          </div>

          {/* Search Bar */}
          <div className="max-w-md mx-auto mb-6">
            <div className="relative">
              <input
                type="text"
                placeholder="Search menu..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full bg-gray-900 text-white border border-gray-700 rounded-full px-5 py-2.5 focus:outline-none focus:border-gold-500 pl-10"
              />
              <svg className="absolute left-3 top-3 w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
              </svg>
            </div>
          </div>

          {/* Category Filter */}
          <div className="flex flex-wrap gap-2 justify-center mb-8">
            {categories.map(cat => (
              <button 
                key={cat} 
                onClick={() => setSelectedCategory(cat)} 
                className={`px-5 py-1.5 rounded-full text-sm transition capitalize ${
                  selectedCategory === cat 
                    ? 'bg-gold-500 text-black font-medium' 
                    : 'bg-gray-800 text-gray-300 hover:bg-gray-700'
                }`}
              >
                {cat === 'all' ? 'All' : cat}
              </button>
            ))}
          </div>

          {/* Results Count */}
          <div className="flex justify-between items-center mb-6">
            <h2 className="text-xl font-semibold text-gold-500">
              {selectedCategory === 'all' ? 'All Menu' : selectedCategory}
              {searchTerm && <span className="text-sm text-gray-400 ml-2">- Search results</span>}
            </h2>
            <p className="text-gray-400 text-sm">{filteredMenus.length} items</p>
          </div>

          {/* Menu Grid */}
          {filteredMenus.length === 0 ? (
            <div className="text-center py-12 bg-gray-900 rounded-xl">
              <p className="text-gray-400">No menu items found.</p>
              <button
                onClick={() => {
                  setSearchTerm('');
                  setSelectedCategory('all');
                }}
                className="mt-4 text-gold-500 hover:underline"
              >
                Clear filters
              </button>
            </div>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {filteredMenus.map(menu => (
                <div key={menu.id} className="bg-gray-800 rounded-xl overflow-hidden hover:scale-[1.02] transition duration-300 group">
                  <div className="relative h-48 overflow-hidden">
                    <img 
                      src={menu.photo} 
                      alt={menu.name} 
                      className="w-full h-full object-cover group-hover:scale-105 transition duration-500"
                      onError={(e) => {
                        e.target.src = 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400';
                      }}
                    />
                    <div className="absolute top-3 right-3 bg-gold-500 text-black px-2 py-1 rounded-lg text-xs font-bold capitalize">
                      {menu.category}
                    </div>
                  </div>
                  <div className="p-5">
                    <h3 className="text-xl font-bold mb-2">{menu.name}</h3>
                    <p className="text-gray-400 text-sm mb-4">{menu.description || 'Delicious dish from our kitchen'}</p>
                    <div className="flex justify-between items-center">
                      <span className="text-gold-500 font-bold text-lg">{formatPrice(menu.price)}</span>
                      <button className="bg-gold-500 text-black px-5 py-2 rounded-lg font-medium hover:bg-gold-600 transition">
                        Order Now
                      </button>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
      <Footer />
    </div>
  );
};

export default RestaurantPage;