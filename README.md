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

## 🚀 Fitur Utama

🏠 1. Home Page
```
- Search bar 
- Pemilihan lokasi (Bali, Jakarta, Bandung, Yogyakarta, Surabaya, dll)
- Kategori tempat wisata
- Daftar rekomendasi wisata
- Data diambil real-time menggunakan Geoapify Places API
```
![Success](https://github.com/user-attachments/assets/c47f2e47-beb3-4013-a6c5-5fb7ea0a4b70)

🔍 2. Search Page
```
- Pencarian nama tempat wisata atau kota
- Menggunakan Geoapify Autocomplete API
- Hasil suggestion langsung tampil
```
![Search 1](https://github.com/user-attachments/assets/853a2f48-50d8-4369-b8a5-141ad3544062)
![Search 2](https://github.com/user-attachments/assets/e6a368bf-5a70-4c96-84ee-ba9c1a9573ee)

📌 3. Detail Page
```
- Menampilkan detail wisata (nama, alamat, rating, kategori, coordinate)
- Menggunakan Geoapify Place Details API
```
![Detail](https://github.com/user-attachments/assets/922df1ab-4055-4fb4-862a-466f02ed1c43)

⭐ 4. Favorite Page
```
- Menyimpan tempat wisata favorit secara offline
- Menggunakan SharedPreferences / Hive
```
![Favorite](https://github.com/user-attachments/assets/29bd64fe-c118-4c3b-82f2-d2c3d162cfea)

👤 5. Profile Page
```
- Informasi tentang aplikasi
- API yang digunakan
- Versi aplikasi
```
![Profile Aplikasi](https://github.com/user-attachments/assets/97308ab1-5b6b-4ef6-aa06-d999e913a619)

## 🌐 API yang Digunakan (Geoapify)
Berikut endpoint wajib yang digunakan aplikasi:

1. Places API (List Tempat Wisata)

Digunakan untuk halaman Home dan Kategori.

```https://api.geoapify.com/v2/places?categories={categories}&filter={filter}&limit={limit}&apiKey=API_KEY```


Parameter:
- categories → tourism.attraction, natural, entertainment, dll
- filter → circle:lon,lat,radius
- limit → jumlah data
- apiKey → API key dari Geoapify

2. Autocomplete API (Search)

Digunakan untuk input pencarian.

```https://api.geoapify.com/v1/geocode/autocomplete?text={keyword}&apiKey=API_KEY```

3. Place Details API (Detail Wisata)
```https://api.geoapify.com/v2/place-details?id={place_id}&apiKey=API_KEY```

## 📁 Struktur Folder Project
```
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
```
## 🏛 Arsitektur Aplikasi

Pattern yang digunakan:
- Service Layer = untuk fetch data dari API
- Model Layer = untuk parsing JSON
- Provider / State Management = loading, error, success
- UI Layer = halaman Home, Search, Detail, Favorite, Profile
UI Layer
halaman Home, Search, Detail, Favorite, Profile

## 🧪 Pengujian API (Success & Error)

Aplikasi menangani tiga state:
- Loading → CircularProgressIndicator
  ![Loading](https://github.com/user-attachments/assets/a6f4ff3c-a7c8-44c2-9060-70678cca2cce)

- Success → data tampil
  ![Success](https://github.com/user-attachments/assets/75b5ec4c-26e6-49d4-ab4f-81b534ffea0a)

## Link Video YouTube
https://youtu.be/_Gt1-X0PObg

- Error → pesan error / retry button
  ![Error Handling](https://github.com/user-attachments/assets/4c97e394-f1f3-4bfc-a7ba-131ba98b68fa)

- Empty → jika API tidak mengembalikan data
  ![Empty](https://github.com/user-attachments/assets/ed1db458-3475-4f21-836f-ab1546320b66)

