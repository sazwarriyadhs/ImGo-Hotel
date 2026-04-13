import { useState, useEffect } from 'react';
import Navbar from '../components/Navbar';
import Footer from '../components/Footer';

// Data promo dari database
const promotions = [
  { 
    id: 1, 
    title: 'Weekend Special', 
    description: 'Diskon khusus untuk booking akhir pekan', 
    type: 'promo', 
    discount_type: 'percentage', 
    discount_value: 20, 
    start_date: '2026-04-12', 
    end_date: '2026-05-12', 
    status: 'active' 
  },
  { 
    id: 2, 
    title: 'Early Bird Discount', 
    description: 'Booking 30 hari sebelumnya dapat diskon', 
    type: 'promo', 
    discount_type: 'percentage', 
    discount_value: 15, 
    start_date: '2026-04-12', 
    end_date: '2026-06-11', 
    status: 'active' 
  },
  { 
    id: 3, 
    title: 'Member Exclusive', 
    description: 'Diskon khusus member loyalty', 
    type: 'promo', 
    discount_type: 'percentage', 
    discount_value: 10, 
    start_date: '2026-04-12', 
    end_date: '2026-05-27', 
    status: 'active' 
  },
  { 
    id: 4, 
    title: 'Long Stay Promo', 
    description: 'Minimal 3 malam dapat diskon', 
    type: 'promo', 
    discount_type: 'fixed', 
    discount_value: 500000, 
    start_date: '2026-04-12', 
    end_date: '2026-05-12', 
    status: 'active' 
  },
  { 
    id: 5, 
    title: 'IMGO Anniversary Sale', 
    description: 'Promo ulang tahun IMGO untuk semua hotel', 
    type: 'promo', 
    discount_type: 'percentage', 
    discount_value: 25, 
    start_date: '2026-04-12', 
    end_date: '2026-04-26', 
    status: 'active' 
  },
  { 
    id: 6, 
    title: 'Referral Bonus', 
    description: 'Dapatkan bonus dengan mengajak teman', 
    type: 'reward', 
    discount_type: 'fixed', 
    discount_value: 100000, 
    start_date: '2026-04-12', 
    end_date: '2026-07-11', 
    status: 'active' 
  }
];

export default function OffersPage() {
  const [selectedType, setSelectedType] = useState('all');
  const [loading, setLoading] = useState(false);

  const filteredPromotions = selectedType === 'all' 
    ? promotions 
    : promotions.filter(promo => promo.type === selectedType);

  const formatDiscount = (promo) => {
    if (promo.discount_type === 'percentage') {
      return `${promo.discount_value}% OFF`;
    } else {
      return `Rp ${promo.discount_value.toLocaleString()} OFF`;
    }
  };

  const getDiscountIcon = (promo) => {
    return promo.discount_type === 'percentage' ? '🎯' : '💰';
  };

  const getDaysLeft = (endDate) => {
    const today = new Date();
    const end = new Date(endDate);
    const diffTime = end - today;
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    if (diffDays < 0) return 'Expired';
    if (diffDays === 0) return 'Last day!';
    return `${diffDays} days left`;
  };

  return (
    <div className="bg-black text-white min-h-screen">
      <Navbar />
      
      {/* Hero Section */}
      <div className="relative h-[40vh] bg-gradient-to-r from-gold-600 to-gold-800">
        <div className="absolute inset-0 bg-black/40"></div>
        <div className="relative z-10 flex flex-col items-center justify-center h-full text-center px-4">
          <h1 className="text-5xl md:text-6xl font-bold mb-4">Special Offers</h1>
          <p className="text-xl text-gray-200 max-w-2xl">
            Get exclusive discounts and promotions for your next stay
          </p>
        </div>
      </div>

      {/* Filter Section */}
      <section className="py-8 px-4 bg-gray-900/50 sticky top-0 z-20 backdrop-blur-sm">
        <div className="container mx-auto">
          <div className="flex flex-wrap justify-center gap-4">
            <button
              onClick={() => setSelectedType('all')}
              className={`px-6 py-2 rounded-full transition-all duration-300 ${
                selectedType === 'all' 
                  ? 'bg-gold-500 text-primary-800' 
                  : 'bg-gray-800 text-gray-400 hover:bg-gray-700'
              }`}
            >
              All Offers
            </button>
            <button
              onClick={() => setSelectedType('promo')}
              className={`px-6 py-2 rounded-full transition-all duration-300 ${
                selectedType === 'promo' 
                  ? 'bg-gold-500 text-primary-800' 
                  : 'bg-gray-800 text-gray-400 hover:bg-gray-700'
              }`}
            >
              🎉 Promotions
            </button>
            <button
              onClick={() => setSelectedType('reward')}
              className={`px-6 py-2 rounded-full transition-all duration-300 ${
                selectedType === 'reward' 
                  ? 'bg-gold-500 text-primary-800' 
                  : 'bg-gray-800 text-gray-400 hover:bg-gray-700'
              }`}
            >
              🎁 Rewards
            </button>
          </div>
        </div>
      </section>

      {/* Promotions Grid */}
      <section className="py-16 px-4">
        <div className="container mx-auto">
          {loading ? (
            <div className="text-center py-12">
              <div className="inline-block w-8 h-8 border-4 border-gold-500 border-t-transparent rounded-full animate-spin"></div>
              <p className="mt-4 text-gray-400">Loading offers...</p>
            </div>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
              {filteredPromotions.map((promo) => (
                <div key={promo.id} className="group relative bg-gradient-to-br from-gray-800 to-gray-900 rounded-2xl overflow-hidden border border-gray-700 hover:border-gold-500 transition-all duration-300 hover:transform hover:scale-105">
                  {/* Discount Badge */}
                  <div className="absolute top-4 right-4 z-10">
                    <div className="bg-gold-500 text-primary-800 px-3 py-1 rounded-full text-sm font-bold flex items-center gap-1">
                      <span>{getDiscountIcon(promo)}</span>
                      <span>{formatDiscount(promo)}</span>
                    </div>
                  </div>
                  
                  {/* Card Content */}
                  <div className="p-6 pt-12">
                    <h3 className="text-xl font-bold mb-2 group-hover:text-gold-500 transition">
                      {promo.title}
                    </h3>
                    <p className="text-gray-400 text-sm mb-4">
                      {promo.description}
                    </p>
                    
                    {/* Date Info */}
                    <div className="flex items-center gap-4 mb-4 text-sm">
                      <div className="flex items-center gap-1 text-gray-500">
                        <span>📅</span>
                        <span>{new Date(promo.start_date).toLocaleDateString('id-ID')}</span>
                      </div>
                      <div className="flex items-center gap-1 text-gray-500">
                        <span>➡️</span>
                        <span>{new Date(promo.end_date).toLocaleDateString('id-ID')}</span>
                      </div>
                    </div>
                    
                    {/* Days Left */}
                    <div className="mb-4">
                      <span className={`text-sm font-semibold ${
                        getDaysLeft(promo.end_date).includes('day') 
                          ? 'text-green-500' 
                          : getDaysLeft(promo.end_date) === 'Last day!' 
                            ? 'text-orange-500' 
                            : 'text-red-500'
                      }`}>
                        ⏰ {getDaysLeft(promo.end_date)}
                      </span>
                    </div>
                    
                    {/* Book Now Button */}
                    <a 
                      href="/hotels" 
                      className="block w-full text-center bg-gold-500 text-primary-800 font-semibold py-2 rounded-lg hover:bg-gold-600 transition mt-4"
                    >
                      Claim Offer →
                    </a>
                  </div>
                  
                  {/* Decorative Element */}
                  <div className="absolute bottom-0 left-0 right-0 h-1 bg-gradient-to-r from-gold-500 to-transparent transform scale-x-0 group-hover:scale-x-100 transition-transform duration-500"></div>
                </div>
              ))}
            </div>
          )}
          
          {filteredPromotions.length === 0 && (
            <div className="text-center py-12">
              <p className="text-gray-400 text-lg">No offers found.</p>
            </div>
          )}
        </div>
      </section>

      {/* How It Works Section */}
      <section className="py-16 px-4 bg-gray-900">
        <div className="container mx-auto">
          <h2 className="text-3xl md:text-4xl font-bold text-center mb-12">How to Redeem</h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div className="text-center p-6">
              <div className="w-16 h-16 bg-gold-500/20 rounded-full flex items-center justify-center mx-auto mb-4">
                <span className="text-3xl">1️⃣</span>
              </div>
              <h3 className="text-xl font-bold mb-2">Choose Your Offer</h3>
              <p className="text-gray-400">Browse through our exclusive promotions and rewards</p>
            </div>
            <div className="text-center p-6">
              <div className="w-16 h-16 bg-gold-500/20 rounded-full flex items-center justify-center mx-auto mb-4">
                <span className="text-3xl">2️⃣</span>
              </div>
              <h3 className="text-xl font-bold mb-2">Book Your Stay</h3>
              <p className="text-gray-400">Select your hotel and dates, apply the promo code</p>
            </div>
            <div className="text-center p-6">
              <div className="w-16 h-16 bg-gold-500/20 rounded-full flex items-center justify-center mx-auto mb-4">
                <span className="text-3xl">3️⃣</span>
              </div>
              <h3 className="text-xl font-bold mb-2">Enjoy Your Discount</h3>
              <p className="text-gray-400">Get instant discount on your booking total</p>
            </div>
          </div>
        </div>
      </section>

      <Footer />
    </div>
  );
}
