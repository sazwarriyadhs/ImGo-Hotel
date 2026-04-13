import axios from 'axios';

const HOTEL_SERVICE = 'http://localhost:8094';

export const api = {
  getHotels: async () => {
    try {
      const response = await axios.get(`${HOTEL_SERVICE}/api/hotels`);
      return response.data;
    } catch (error) {
      console.error('Error fetching hotels:', error);
      return [];
    }
  },
  
  getHotelDetail: async (id) => {
    try {
      const response = await axios.get(`${HOTEL_SERVICE}/api/hotels/${id}`);
      return response.data;
    } catch (error) {
      console.error('Error fetching hotel detail:', error);
      return null;
    }
  },
  
  getRestaurantMenus: async () => {
    return [];
  },
  
  getSpaServices: async () => {
    return [];
  },
  
  getPilatesClasses: async () => {
    return [];
  },
  
  getPromotions: async () => {
    return [];
  },
  
  login: async (email, password) => {
    if (email === 'sarah.wilson@example.com' && password === 'customer123') {
      return { success: true, user: { name: 'Sarah Wilson', email: email } };
    }
    return { success: false };
  }
};

export default api;
