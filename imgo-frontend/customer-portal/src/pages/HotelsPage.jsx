// C:\imgo-enterprise\imgo-frontend\customer-portal\src\pages\HotelsPage.jsx
import { useState, useEffect, useRef } from 'react';
import Navbar from '../components/Navbar';
import Footer from '../components/Footer';

// Koordinat untuk setiap kota (fallback)
const cityCoordinates = {
  'Jakarta': [-6.2088, 106.8456],
  'Surabaya': [-7.2575, 112.7521],
  'Bandung': [-6.9175, 107.6191],
  'Yogyakarta': [-7.7956, 110.3695],
  'Bali': [-8.3405, 115.0920],
  'Denpasar': [-8.6705, 115.2126],
  'Medan': [3.5952, 98.6722],
  'Semarang': [-6.9667, 110.4167],
  'Makassar': [-5.1477, 119.4327],
  'Palembang': [-2.9761, 104.7754],
  'Malang': [-7.9797, 112.6304],
  'Banda Aceh': [5.5483, 95.3238],
  'Padang': [-0.9471, 100.4172],
  'Pekanbaru': [0.5071, 101.4478],
  'Batam': [1.0456, 104.0305],
  'Bandar Lampung': [-5.3971, 105.2686],
  'Jambi': [-1.6101, 103.6161],
  'Bengkulu': [-3.7928, 102.2655],
  'Tangerang': [-6.1783, 106.63],
  'Bekasi': [-6.2383, 106.9936],
  'Depok': [-6.4025, 106.8186],
  'Bogor': [-6.5971, 106.8067],
  'Cirebon': [-6.7322, 108.5571],
  'Surakarta': [-7.5755, 110.8266],
  'Kediri': [-7.8169, 112.0179],
  'Probolinggo': [-7.7549, 113.2159],
  'Palu': [-0.8917, 119.87],
  'Kendari': [-3.9985, 122.5036],
  'Gorontalo': [0.5435, 123.07],
  'Tasikmalaya': [-7.3274, 108.2206],
  'Pangkal Pinang': [-2.1291, 106.1122],
  'Tanjung Pinang': [0.9174, 104.4433],
  'Purwokerto': [-7.4262, 109.2389],
  'Kuta': [-8.7238, 115.169],
  'Ubud': [-8.5069, 115.2625],
  'Mataram': [-8.5833, 116.1167],
  'Kupang': [-10.1772, 123.6069],
  'Pontianak': [-0.0263, 109.3425],
  'Balikpapan': [-1.2379, 116.8634],
  'Banjarmasin': [-3.3199, 114.5928],
  'Palangkaraya': [-2.2152, 113.9172],
  'Samarinda': [-0.5022, 117.1565],
  'Tarakan': [3.3167, 117.63],
  'Manado': [1.4748, 124.8421],
  'Luwuk': [-0.9516, 122.79],
  'Ambon': [-3.6556, 128.1922],
  'Ternate': [0.7894, 127.4],
  'Jayapura': [-2.5337, 140.7181],
  'Manokwari': [-0.8665, 134.08],
  'Sorong': [-0.8818, 131.25],
  'Merauke': [-8.4933, 140.4]
};

const HotelsPage = () => {
  const [hotels, setHotels] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedHotel, setSelectedHotel] = useState(null);
  const [currentPage, setCurrentPage] = useState(1);
  const [map, setMap] = useState(null);
  const [markers, setMarkers] = useState([]);
  const [mapType, setMapType] = useState('street'); // 'street' or 'satellite'
  const mapContainerRef = useRef(null);
  const hotelsPerPage = 6;

  const fetchHotels = async () => {
    try {
      setLoading(true);
      const response = await fetch('http://127.0.0.1:8094/api/hotels');
      if (!response.ok) throw new Error('Failed to fetch hotels');
      const data = await response.json();
      setHotels(data);
      setError(null);
    } catch (err) {
      console.error(err);
      setError(err.message || 'Failed to load hotels');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchHotels();
  }, []);

  const filteredHotels = hotels.filter((hotel) => {
    const keyword = searchTerm.toLowerCase();
    return (
      searchTerm === '' ||
      hotel.name?.toLowerCase().includes(keyword) ||
      hotel.city?.toLowerCase().includes(keyword) ||
      hotel.address?.toLowerCase().includes(keyword)
    );
  });

  const getHotelCoordinates = (hotel) => {
    if (hotel.latitude && hotel.longitude && hotel.latitude !== 0 && hotel.longitude !== 0) {
      return [hotel.latitude, hotel.longitude];
    }
    return cityCoordinates[hotel.city] || [-6.2088, 106.8456];
  };

  // Get tile layer URL based on map type
  const getTileLayer = () => {
    if (mapType === 'satellite') {
      // Satellite imagery from Esri
      return 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';
    } else {
      // Street map with dark theme
      return 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png';
    }
  };

  const getTileAttribution = () => {
    if (mapType === 'satellite') {
      return '&copy; <a href="https://www.esri.com">Esri</a> | Source: Esri, DigitalGlobe, GeoEye, Earthstar Geographics';
    } else {
      return '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors | CartoDB';
    }
  };

  // Load Leaflet map
  useEffect(() => {
    if (typeof window !== 'undefined' && !map && mapContainerRef.current && hotels.length > 0) {
      import('leaflet').then((L) => {
        import('leaflet/dist/leaflet.css');
        
        // Fix marker icon
        delete L.Icon.Default.prototype._getIconUrl;
        L.Icon.Default.mergeOptions({
          iconRetinaUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.7.1/images/marker-icon-2x.png',
          iconUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.7.1/images/marker-icon.png',
          shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.7.1/images/marker-shadow.png',
        });

        // Initialize map centered on Indonesia
        const mapInstance = L.map(mapContainerRef.current).setView([-2.5489, 118.0149], 5);
        
        L.tileLayer(getTileLayer(), {
          attribution: getTileAttribution(),
          maxZoom: 19,
          minZoom: 3
        }).addTo(mapInstance);

        setMap(mapInstance);
      });
    }
  }, [hotels, map]);

  // Update tile layer when map type changes
  useEffect(() => {
    if (map) {
      import('leaflet').then((L) => {
        // Clear existing tile layers
        map.eachLayer((layer) => {
          if (layer instanceof L.TileLayer) {
            map.removeLayer(layer);
          }
        });
        
        // Add new tile layer based on selected map type
        L.tileLayer(getTileLayer(), {
          attribution: getTileAttribution(),
          maxZoom: 19,
          minZoom: 3
        }).addTo(map);
      });
    }
  }, [mapType, map]);

  // Update markers with custom icon
  useEffect(() => {
    if (!map || hotels.length === 0) return;

    import('leaflet').then((L) => {
      // Clear existing markers
      markers.forEach(marker => marker.remove());
      
      const newMarkers = [];
      
      // Create custom marker icons
      const defaultMarkerIcon = new L.Icon({
        iconUrl: '/images/marker.png',
        iconSize: [32, 32],
        iconAnchor: [16, 32],
        popupAnchor: [0, -32],
        className: 'custom-marker'
      });

      const selectedMarkerIcon = new L.Icon({
        iconUrl: '/images/marker.png',
        iconSize: [42, 42],
        iconAnchor: [21, 42],
        popupAnchor: [0, -42],
        className: 'custom-marker-selected'
      });

      // Add markers for filtered hotels
      filteredHotels.forEach(hotel => {
        const coords = getHotelCoordinates(hotel);
        const isSelected = selectedHotel?.id === hotel.id;
        
        const marker = L.marker(coords, {
          icon: isSelected ? selectedMarkerIcon : defaultMarkerIcon,
          riseOnHover: true
        }).addTo(map);
        
        // Create detailed popup content
        const popupContent = `
          <div style="min-width: 280px; max-width: 320px; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;">
            <img 
              src="${hotel.photo}" 
              alt="${hotel.name}" 
              style="width: 100%; height: 140px; object-fit: cover; border-radius: 12px 12px 0 0; margin-bottom: 12px;" 
              onerror="this.src='https://images.unsplash.com/photo-1566073771259-6a8506099945?w=300'"
            />
            <div style="padding: 0 12px 12px 12px;">
              <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                <h3 style="font-weight: bold; font-size: 16px; margin: 0; color: #1a1a1a;">${hotel.name}</h3>
                <span style="background: #D4AF37; color: #000; padding: 4px 8px; border-radius: 20px; font-size: 12px; font-weight: bold;">
                  ★ ${hotel.rating}
                </span>
              </div>
              
              <div style="margin-bottom: 10px;">
                <div style="display: flex; align-items: center; gap: 6px; margin-bottom: 6px;">
                  <span style="font-size: 14px;">📍</span>
                  <span style="color: #666; font-size: 13px;">${hotel.city}</span>
                </div>
                <div style="display: flex; align-items: flex-start; gap: 6px; margin-bottom: 6px;">
                  <span style="font-size: 14px;">🏢</span>
                  <span style="color: #666; font-size: 12px; line-height: 1.4;">${hotel.address || 'Alamat tidak tersedia'}</span>
                </div>
                <div style="display: flex; align-items: center; gap: 6px; margin-bottom: 6px;">
                  <span style="font-size: 14px;">📞</span>
                  <span style="color: #666; font-size: 12px;">${hotel.phone || 'Tidak tersedia'}</span>
                </div>
                <div style="display: flex; align-items: center; gap: 6px;">
                  <span style="font-size: 14px;">🛏️</span>
                  <span style="color: #666; font-size: 12px;">${hotel.total_rooms || 0} Kamar tersedia</span>
                </div>
              </div>
              
              ${hotel.description ? `
                <div style="margin-bottom: 12px; padding-top: 8px; border-top: 1px solid #eee;">
                  <p style="color: #888; font-size: 11px; line-height: 1.4; margin: 0;">
                    ${hotel.description.substring(0, 100)}${hotel.description.length > 100 ? '...' : ''}
                  </p>
                </div>
              ` : ''}
              
              <button 
                onclick="window.dispatchEvent(new CustomEvent('selectHotel', { detail: { hotelId: '${hotel.id}' } }))" 
                style="width: 100%; background: #D4AF37; color: #000; border: none; padding: 10px; border-radius: 8px; cursor: pointer; font-size: 13px; font-weight: 600; margin-top: 8px; transition: all 0.2s;"
                onmouseover="this.style.background='#b8922e'"
                onmouseout="this.style.background='#D4AF37'"
              >
                View Details & Book Now →
              </button>
            </div>
          </div>
        `;
        
        marker.bindPopup(popupContent, {
          maxWidth: 320,
          minWidth: 280,
          className: 'custom-popup'
        });
        
        newMarkers.push(marker);
        
        marker.on('click', () => {
          setSelectedHotel(hotel);
          map.setView(coords, 14);
        });
      });
      
      setMarkers(newMarkers);
      
      if (selectedHotel) {
        const coords = getHotelCoordinates(selectedHotel);
        map.setView(coords, 13);
      } else if (filteredHotels.length > 0 && filteredHotels.length !== hotels.length) {
        const bounds = L.latLngBounds(newMarkers.map(m => m.getLatLng()));
        map.fitBounds(bounds);
      }
    });
  }, [map, filteredHotels, selectedHotel, hotels]);

  useEffect(() => {
    const handleSelectHotel = (event) => {
      const hotel = hotels.find(h => h.id === event.detail.hotelId);
      if (hotel) {
        setSelectedHotel(hotel);
      }
    };
    
    window.addEventListener('selectHotel', handleSelectHotel);
    return () => window.removeEventListener('selectHotel', handleSelectHotel);
  }, [hotels]);

  // Pagination
  const indexOfLastHotel = currentPage * hotelsPerPage;
  const indexOfFirstHotel = indexOfLastHotel - hotelsPerPage;
  const currentHotels = filteredHotels.slice(indexOfFirstHotel, indexOfLastHotel);
  const totalPages = Math.ceil(filteredHotels.length / hotelsPerPage);

  const paginate = (pageNumber) => setCurrentPage(pageNumber);

  useEffect(() => {
    setCurrentPage(1);
  }, [searchTerm]);

  if (loading) {
    return (
      <>
        <Navbar />
        <div className="min-h-screen bg-black flex items-center justify-center">
          <div className="text-center">
            <div className="w-12 h-12 border-4 border-gold-500 border-t-transparent rounded-full animate-spin mx-auto" />
            <p className="mt-4 text-gray-400">Loading luxury hotels...</p>
          </div>
        </div>
        <Footer />
      </>
    );
  }

  if (error) {
    return (
      <>
        <Navbar />
        <div className="min-h-screen bg-black flex items-center justify-center">
          <div className="bg-gray-900 rounded-2xl p-8 text-center shadow-xl max-w-md">
            <p className="text-4xl mb-4">⚠️</p>
            <p className="text-gray-300">{error}</p>
            <button
              onClick={fetchHotels}
              className="mt-6 px-6 py-2 bg-gold-500 text-black rounded-lg hover:bg-gold-600 transition"
            >
              Try Again
            </button>
          </div>
        </div>
        <Footer />
      </>
    );
  }

  return (
    <>
      <Navbar />
      <div className="min-h-screen bg-black text-white pt-16">
        {/* Hero Section */}
        <section className="pt-12 pb-6 text-center px-4 animate-fadeIn">
          <div className="container mx-auto">
            <p className="text-gold-500 uppercase tracking-[0.3em] text-sm mb-3">Luxury Stay</p>
            <h1 className="text-4xl md:text-5xl font-bold mb-4">Our Hotels</h1>
            <p className="text-gray-400 max-w-2xl mx-auto">
              Discover {hotels.length} elegant stays across Indonesia
            </p>
          </div>
        </section>

        {/* Search Bar */}
        <section className="px-4 py-4">
          <div className="max-w-2xl mx-auto">
            <div className="relative">
              <input
                type="text"
                placeholder="Search by hotel name, city, or address..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full bg-gray-900 text-white border border-gray-700 rounded-full px-5 py-3 focus:outline-none focus:border-gold-500 pl-12"
              />
              <svg className="absolute left-4 top-3.5 w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
              </svg>
            </div>
          </div>
        </section>

        {/* Map Type Selector - Street & Satellite */}
        <section className="px-4 py-2">
          <div className="max-w-6xl mx-auto flex justify-end">
            <div className="flex gap-2 bg-gray-900 rounded-lg p-1 border border-gray-700">
              <button
                onClick={() => setMapType('street')}
                className={`px-5 py-1.5 rounded-md text-sm font-medium transition-all duration-200 flex items-center gap-2 ${
                  mapType === 'street'
                    ? 'bg-gold-500 text-black shadow-lg'
                    : 'text-gray-400 hover:text-white hover:bg-gray-800'
                }`}
              >
                <span>🗺️</span> Street View
              </button>
              <button
                onClick={() => setMapType('satellite')}
                className={`px-5 py-1.5 rounded-md text-sm font-medium transition-all duration-200 flex items-center gap-2 ${
                  mapType === 'satellite'
                    ? 'bg-gold-500 text-black shadow-lg'
                    : 'text-gray-400 hover:text-white hover:bg-gray-800'
                }`}
              >
                <span>🛰️</span> Satellite
              </button>
            </div>
          </div>
        </section>

        {/* Interactive Map */}
        <section className="px-4 py-4">
          <div className="max-w-6xl mx-auto">
            <div className="bg-gray-900 rounded-xl overflow-hidden border border-gray-700 shadow-xl">
              <div className="px-4 py-3 border-b border-gray-700 flex justify-between items-center">
                <div className="flex items-center gap-3">
                  <h3 className="text-gold-500 font-semibold text-sm flex items-center gap-1">
                    {mapType === 'satellite' ? '🛰️' : '🗺️'} 
                    {mapType === 'satellite' ? ' Satellite View' : ' Street View'}
                  </h3>
                  <span className="text-xs text-gray-500">|</span>
                  <p className="text-gray-400 text-xs">
                    {filteredHotels.length} hotels displayed
                  </p>
                </div>
                {searchTerm && (
                  <p className="text-gray-400 text-xs">
                    Showing {filteredHotels.length} results for "{searchTerm}"
                  </p>
                )}
              </div>
              <div 
                ref={mapContainerRef} 
                className="w-full h-[500px] bg-gray-800 z-0"
              />
              <div className="px-4 py-2 border-t border-gray-700 flex flex-wrap gap-4 justify-center text-xs text-gray-400">
                <span className="flex items-center gap-1">
                  <img src="/images/marker.png" alt="marker" className="w-4 h-4" />
                  <span>Hotel Location</span>
                </span>
                <span className="text-gray-600">•</span>
                <span>Click on marker or card to see details</span>
                <span className="text-gray-600">•</span>
                <span>🖱️ Click marker for hotel info</span>
                <span className="text-gray-600">•</span>
                <span>🔍 Zoom in/out for details</span>
              </div>
            </div>
          </div>
        </section>

        {/* Hotels Grid */}
        <section className="px-4 py-8 pb-20">
          <div className="max-w-6xl mx-auto">
            <div className="flex justify-between items-center mb-5">
              <h2 className="text-xl font-semibold text-gold-500">
                Featured Hotels
                {searchTerm && <span className="text-sm text-gray-400 ml-2">- Search results</span>}
              </h2>
              <p className="text-gray-400 text-sm">
                Showing {indexOfFirstHotel + 1}-{Math.min(indexOfLastHotel, filteredHotels.length)} of {filteredHotels.length} hotels
              </p>
            </div>

            {currentHotels.length === 0 ? (
              <div className="text-center py-12 bg-gray-900 rounded-xl">
                <p className="text-gray-400">No hotels found matching your search.</p>
                <button
                  onClick={() => setSearchTerm('')}
                  className="mt-4 text-gold-500 hover:underline"
                >
                  Clear search
                </button>
              </div>
            ) : (
              <>
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                  {currentHotels.map((hotel, index) => (
                    <div 
                      key={hotel.id} 
                      className={`bg-gray-900 rounded-xl overflow-hidden hover:scale-[1.02] transition duration-300 animate-fadeIn cursor-pointer ${
                        selectedHotel?.id === hotel.id ? 'ring-2 ring-gold-500' : ''
                      }`}
                      style={{ animationDelay: `${index * 0.1}s` }}
                      onClick={() => setSelectedHotel(hotel)}
                    >
                      <div className="relative h-48 overflow-hidden">
                        <img
                          src={hotel.photo}
                          alt={hotel.name}
                          className="w-full h-full object-cover hover:scale-105 transition duration-500"
                          onError={(e) => {
                            e.target.src = 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400';
                          }}
                        />
                        <div className="absolute top-3 right-3 bg-gold-500 text-black px-2 py-1 rounded-lg text-sm font-bold">
                          ★ {hotel.rating}
                        </div>
                        <div className="absolute bottom-3 left-3 bg-black/60 backdrop-blur-sm px-2 py-1 rounded-lg text-xs">
                          📍 {hotel.city}
                        </div>
                      </div>

                      <div className="p-5">
                        <h3 className="text-lg font-bold mb-1">{hotel.name}</h3>
                        <p className="text-gray-400 text-xs mb-3 line-clamp-2">{hotel.address}</p>
                        
                        <div className="flex justify-between items-center text-xs text-gray-500 mb-4">
                          <span>📞 {hotel.phone}</span>
                          <span>🛏️ {hotel.total_rooms} rooms</span>
                        </div>

                        {hotel.description && (
                          <p className="text-gray-500 text-xs mb-4 line-clamp-2">
                            {hotel.description.substring(0, 100)}...
                          </p>
                        )}

                        <button className="w-full bg-gold-500 text-black py-2 rounded-lg text-sm font-medium hover:bg-gold-600 transition">
                          View Details
                        </button>
                      </div>
                    </div>
                  ))}
                </div>

                {/* Pagination */}
                {totalPages > 1 && (
                  <div className="flex justify-center gap-2 mt-10">
                    <button
                      onClick={() => paginate(currentPage - 1)}
                      disabled={currentPage === 1}
                      className={`px-4 py-2 rounded-lg transition ${
                        currentPage === 1
                          ? 'bg-gray-800 text-gray-500 cursor-not-allowed'
                          : 'bg-gray-800 text-white hover:bg-gold-500 hover:text-black'
                      }`}
                    >
                      Previous
                    </button>
                    
                    {[...Array(Math.min(totalPages, 7))].map((_, i) => {
                      let pageNum;
                      if (totalPages <= 7) {
                        pageNum = i + 1;
                      } else if (currentPage <= 4) {
                        pageNum = i + 1;
                        if (i === 6) pageNum = totalPages;
                      } else if (currentPage >= totalPages - 3) {
                        pageNum = totalPages - 6 + i;
                      } else {
                        pageNum = currentPage - 3 + i;
                      }
                      
                      if (pageNum > totalPages) return null;
                      
                      return (
                        <button
                          key={pageNum}
                          onClick={() => paginate(pageNum)}
                          className={`px-4 py-2 rounded-lg transition ${
                            currentPage === pageNum
                              ? 'bg-gold-500 text-black font-bold'
                              : 'bg-gray-800 text-white hover:bg-gray-700'
                          }`}
                        >
                          {pageNum}
                        </button>
                      );
                    })}
                    
                    <button
                      onClick={() => paginate(currentPage + 1)}
                      disabled={currentPage === totalPages}
                      className={`px-4 py-2 rounded-lg transition ${
                        currentPage === totalPages
                          ? 'bg-gray-800 text-gray-500 cursor-not-allowed'
                          : 'bg-gray-800 text-white hover:bg-gold-500 hover:text-black'
                      }`}
                    >
                      Next
                    </button>
                  </div>
                )}
              </>
            )}
          </div>
        </section>
      </div>
      <Footer />
    </>
  );
};

export default HotelsPage;