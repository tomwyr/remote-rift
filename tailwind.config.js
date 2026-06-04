/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./{lib,web}/**/*.dart"],
  theme: {
    extend: {
      colors: {
        brand: {
          50: "#f9f5e8",
          100: "#f3e8c7",
          200: "#ead189",
          300: "#e0bb5e",
          400: "#d7ae4d",
          500: "#d0ad4f",
          600: "#b69141",
          700: "#967436",
          800: "#7a5c2c",
          900: "#644b24"
        },
        'brand-charcoal': {
          100: "#c2dcea",
          200: "#85b8d5",
          300: "#4995c1",
          400: "#2f6889",
          500: "#1a3a4c",
          600: "#152e3d",
          700: "#10232e",
          800: "#0a171e",
          900: "#050c0f"
        }
      }
    }
  },
  plugins: [],
}