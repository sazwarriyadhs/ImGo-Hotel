/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          500: '#0B1E3C',
          600: '#091830',
          700: '#071224',
          800: '#040c18',
        },
        gold: {
          500: '#D4AF37',
          600: '#aa8c2c',
        },
      },
    },
  },
  plugins: [],
}
