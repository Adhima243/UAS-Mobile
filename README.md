

# 📱 Aplikasi Wisata Indonesia 

Aplikasi mobile Flutter untuk menampilkan daftar tempat wisata di Indonesia secara real-time menggunakan Geoapify Places API.
Aplikasi ini dibuat sebagai pemenuhan Ujian Akhir Semester (UAS) Mobile Programming.

Aplikasi memuat:

Daftar tempat wisata berdasarkan lokasi
- Fitur pencarian wisata (autocomplete)
- Detail tempat wisata
- Kategori wisata
- Favorit (offline menggunakan SharedPreferences)
- Profil aplikasi
- Tanpa login

🚀 Fitur Utama
🏠 1. Home Page

```- Search bar 
- Pemilihan lokasi (Bali, Jakarta, Bandung, Yogyakarta, Surabaya, dll)
- Kategori tempat wisata
- Daftar rekomendasi wisata
- Data diambil real-time menggunakan Geoapify Places API```

🔍 2. Search Page

```- Pencarian nama tempat wisata atau kota

- Menggunakan Geoapify Autocomplete API

- Hasil suggestion langsung tampil```

📌 3. Detail Page

Menampilkan detail wisata (nama, alamat, rating, kategori, coordinate)

Menggunakan Geoapify Place Details API

⭐ 4. Favorite Page

Menyimpan tempat wisata favorit secara offline

Menggunakan SharedPreferences / Hive

👤 5. Profile Page

Informasi tentang aplikasi

API yang digunakan

Versi aplikasi

🌐 API yang Digunakan (Geoapify)

Berikut endpoint wajib yang digunakan aplikasi:

✅ 1. Places API (List Tempat Wisata)

Digunakan untuk halaman Home dan Kategori.

https://api.geoapify.com/v2/places?categories={categories}&filter={filter}&limit={limit}&apiKey=API_KEY


Parameter:

categories → tourism.attraction, natural, entertainment, dll

filter → circle:lon,lat,radius

limit → jumlah data

apiKey → API key dari Geoapify

✅ 2. Autocomplete API (Search)

Digunakan untuk input pencarian.

https://api.geoapify.com/v1/geocode/autocomplete?text={keyword}&apiKey=API_KEY

✅ 3. Place Details API (Detail Wisata)
https://api.geoapify.com/v2/place-details?id={place_id}&apiKey=API_KEY

🟡 Optional – Reverse Geocoding API

Digunakan jika mengambil nama lokasi dari GPS coordinates.

https://api.geoapify.com/v1/geocode/reverse?lat={lat}&lon={lon}&apiKey=API_KEY

📁 Struktur Folder Project
lib/
│
├── main.dart
│
├── config/
│   ├── app_config.dart
│   └── theme.dart
│
├── utils/
│   ├── api_endpoint.dart
│   ├── location_helper.dart
│   └── formatter.dart
│
├── models/
│   ├── place.dart
│   ├── place_detail.dart
│   └── category_model.dart
│
├── services/
│   └── geoapify_service.dart
│
├── controllers/
│   ├── place_provider.dart
│   ├── search_provider.dart
│   ├── detail_provider.dart
│   └── favorite_provider.dart
│
├── db/
│   └── favorite_db.dart
│
├── pages/
│   ├── home/
│   ├── search/
│   ├── detail/
│   ├── favorite/
│   └── profile/
│
└── widgets/

🏛 Arsitektur Aplikasi

Pattern yang digunakan:

Service Layer
untuk fetch data dari API

Model Layer
untuk parsing JSON

Provider / State Management
loading, error, success

UI Layer
halaman Home, Search, Detail, Favorite, Profile
