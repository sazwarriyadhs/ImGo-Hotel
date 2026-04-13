import { useState } from 'react';
import Navbar from '../components/Navbar';
import Footer from '../components/Footer';

const classes = [
  { id: 1, name: 'Mat Pilates Beginner', instructor: 'Maria Kristina', price: 150000, schedule: 'Monday 09:00', available: 5, photo: 'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=400&h=300&fit=crop' },
  { id: 2, name: 'Reformer Pilates', instructor: 'Maria Kristina', price: 200000, schedule: 'Monday 11:00', available: 3, photo: 'https://images.unsplash.com/photo-1545389336-cf090694435e?w=400&h=300&fit=crop' },
  { id: 3, name: 'Pilates Flow', instructor: 'Anita Permatasari', price: 120000, schedule: 'Tuesday 10:00', available: 7, photo: 'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=400&h=300&fit=crop' },
];

export default function PilatesPage() {
  return (
    <div className="bg-black text-white min-h-screen">
      <Navbar />
      <div className="pt-32 px-4">
        <div className="container mx-auto">
          <h1 className="text-4xl font-bold text-center mb-8">Pilates Classes</h1>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {classes.map(cls => (
              <div key={cls.id} className="bg-gray-800 rounded-xl overflow-hidden">
                <img src={cls.photo} alt={cls.name} className="w-full h-48 object-cover" />
                <div className="p-4">
                  <h3 className="text-xl font-bold">{cls.name}</h3>
                  <p className="text-gray-400 text-sm">Instructor: {cls.instructor}</p>
                  <p className="text-gray-400 text-sm">Schedule: {cls.schedule}</p>
                  <div className="flex justify-between items-center mt-4">
                    <span className="text-gold-500 font-bold">Rp {cls.price.toLocaleString()}</span>
                    <span className={`text-sm ${cls.available > 0 ? 'text-green-500' : 'text-red-500'}`}>{cls.available} spots left</span>
                  </div>
                  <button className="w-full mt-3 bg-gold-500 text-black py-2 rounded-lg">Book Class</button>
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
