export default function RoomCard({ title, description, price, buttonText, bgColor, icon }) {
  return (
    <div className={`bg-gradient-to-br ${bgColor} rounded-xl overflow-hidden border border-gray-700 hover:scale-105 transition-all duration-300`}>
      <div className="h-48 bg-gradient-to-br from-gray-800 to-gray-900 flex items-center justify-center">
        <span className="text-6xl">{icon || '🏨'}</span>
      </div>
      <div className="p-6">
        <h3 className="text-xl font-bold mb-2">{title}</h3>
        <p className="text-gray-300 text-sm mb-4">{description}</p>
        <p className="text-gold-500 font-semibold mb-4">{price}</p>
        <a href="#" className="block w-full text-center border border-gold-500 text-gold-500 hover:bg-gold-500 hover:text-black font-semibold py-2 px-4 rounded-lg transition">
          {buttonText}
        </a>
      </div>
    </div>
  );
}
