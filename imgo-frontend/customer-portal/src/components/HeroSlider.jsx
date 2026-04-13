import { Swiper, SwiperSlide } from 'swiper/react';
import { Autoplay, Pagination, Navigation, EffectFade } from 'swiper/modules';
import 'swiper/css';
import 'swiper/css/navigation';
import 'swiper/css/pagination';
import 'swiper/css/effect-fade';

const slides = [
  { id: 1, image: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=1920&h=1080&fit=crop', title: 'Luxury Stay Across Indonesia', subtitle: 'Discover Premium Rooms, Dining, and Exclusive Deals', btn1: 'Book Now', btn2: 'Explore Hotels' },
  { id: 2, image: 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=1920&h=1080&fit=crop', title: 'Experience Fine Dining', subtitle: 'Award-winning restaurants with exquisite cuisine', btn1: 'Book Now', btn2: 'Explore Menu' },
  { id: 3, image: 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=1920&h=1080&fit=crop', title: 'Luxurious Suites', subtitle: 'Elegant rooms with modern amenities and city views', btn1: 'Book Now', btn2: 'View Rooms' },
  { id: 4, image: 'https://images.unsplash.com/photo-1584132967334-10e028bd69f7?w=1920&h=1080&fit=crop', title: 'Romantic Dinner Packages', subtitle: 'Luxurious villas with private pool & ocean view', btn1: 'Reserve Now', btn2: 'Learn More' }
];

export default function HeroSlider() {
  return (
    <div className="relative h-screen w-full overflow-hidden">
      <Swiper modules={[Autoplay, Pagination, Navigation, EffectFade]} effect="fade" spaceBetween={0} slidesPerView={1} autoplay={{ delay: 5000, disableOnInteraction: false }} pagination={{ clickable: true, dynamicBullets: true }} navigation={true} loop={true} className="h-full w-full">
        {slides.map((slide) => (
          <SwiperSlide key={slide.id}>
            <div className="relative h-full w-full">
              <div className="absolute inset-0 bg-gradient-to-r from-black/70 to-black/50 z-10"></div>
              <div className="absolute inset-0 bg-cover bg-center" style={{ backgroundImage: `url(${slide.image})` }}></div>
              <div className="relative z-20 flex flex-col items-center justify-center h-full text-center px-4">
                <div className="mb-6">
                  {/* Logo 150x150 tanpa border, tanpa background */}
                  <img 
                    src="/images/logo.png" 
                    alt="IMGO Hotel" 
                    className="w-[150px] h-[150px] object-contain mx-auto mb-6"
                    style={{ background: 'transparent' }}
                    onError={(e) => e.target.style.display = 'none'}
                  />
                </div>
                <h1 className="text-5xl md:text-7xl font-extrabold mb-4 animate-fadeIn">{slide.title}</h1>
                <p className="text-xl md:text-2xl mb-8 animate-fadeIn animation-delay-200">{slide.subtitle}</p>
                <div className="flex space-x-4 animate-fadeIn animation-delay-400">
                  <a href="/hotels" className="btn-primary">{slide.btn1}</a>
                  <a href="/hotels" className="btn-outline">{slide.btn2}</a>
                </div>
              </div>
            </div>
          </SwiperSlide>
        ))}
      </Swiper>
    </div>
  );
}
