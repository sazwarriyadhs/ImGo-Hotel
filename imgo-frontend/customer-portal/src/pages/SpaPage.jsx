import { useState } from 'react';
import Navbar from '../components/Navbar';
import Footer from '../components/Footer';

const services = [
  { id: 1, name: 'Traditional Massage', price: 250000, duration: 60, description: 'Relaxing traditional Indonesian massage', photo: 'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=400&h=300&fit=crop' },
  { id: 2, name: 'Aromatherapy Massage', price: 350000, duration: 90, description: 'Massage with essential oils', photo: 'https://images.unsplash.com/photo-1600334129128-685c5582fd35?w=400&h=300&fit=crop' },
  { id: 3, name: 'Hot Stone Massage', price: 400000, duration: 75, description: 'Therapeutic massage with heated stones', photo: 'https://images.unsplash.com/photo-1600334089645-1c1a30e6c5c4?w=400&h=300&fit=crop' },
];

export default function SpaPage() {
  return (
    <div className="bg-black text-white min-h-screen">
      <Navbar />
      <div className="pt-32 px-4">
        <div className="container mx-auto">
          <h1 className="text-4xl font-bold text-center mb-8">Spa & Wellness</h1>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {services.map(service => (
              <div key={service.id} className="bg-gray-800 rounded-xl overflow-hidden">
                <img src={service.photo} alt={service.name} className="w-full h-48 object-cover" />
                <div className="p-4">
                  <h3 className="text-xl font-bold">{service.name}</h3>
                  <p className="text-gray-400 text-sm">{service.description}</p>
                  <div className="flex justify-between items-center mt-4">
                    <div>
                      <span className="text-gold-500 font-bold">Rp {service.price.toLocaleString()}</span>
                      <span className="text-gray-500 text-sm ml-1">/{service.duration} min</span>
                    </div>
                    <button className="bg-gold-500 text-black px-4 py-2 rounded-lg">Book Now</button>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
      <Footer />
    </div>
  );
}
