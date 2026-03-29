# 🚀 Newsly: Masa Depan Membaca Berita

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Gemini AI](https://img.shields.io/badge/Gemini%20AI-8E75B2?style=for-the-badge&logo=google-gemini&logoColor=white)](https://deepmind.google/technologies/gemini/)

**Newsly** adalah aplikasi baca berita modern yang dirancang untuk memberikan pengalaman membaca yang imersif, cerdas, dan futuristik. Bukan sekadar agregator berita biasa, Newsly menggabungkan kekuatan **AI Generatif** dengan desain **Glassmorphism** yang premium.

---

## ✨ Fitur Unggulan

### 🤖 Kecerdasan Buatan (AI-Powered)
*   **Ringkasan Otomatis**: Dapatkan poin-poin penting dari berita panjang dalam sekejap menggunakan Google Gemini AI.
*   **Jelaskan Sederhana**: Fitur "Explain Simply" membantu Anda memahami topik kompleks dengan bahasa yang lebih mudah dimengerti.
*   **Analisis Sentimen**: Ketahui suasana berita sebelum Anda membacanya.

### 🎧 Pengalaman Multimedia
*   **Audio Reading (TTS)**: Sedang sibuk? Biarkan Newsly membacakan berita untuk Anda dengan teknologi *Text-to-Speech* yang jernih.
*   **In-App WebView**: Baca artikel lengkap tanpa meninggalkan aplikasi dengan navigasi yang mulus.

### 🎨 Desain Futuristik
*   **Antarmuka Glassmorphism**: Visual modern dengan efek kaca yang elegan dan transparan.
*   **Animasi Fluida**: Transisi halaman dan interaksi yang halus menggunakan *Flutter Animate*.
*   **Dark Mode First**: Dirancang untuk kenyamanan mata dengan estetika gelap yang premium.

### 📚 Fitur Lainnya
*   **Markah Buku (Bookmarks)**: Simpan berita favorit Anda secara lokal menggunakan Hive.
*   **Berbagi Berita**: Bagikan informasi penting ke teman-teman Anda dengan satu ketukan.
*   **Shimmer Loading**: Pengalaman memuat data yang estetik dan tidak membosankan.

---

## 🛠️ Teknologi yang Digunakan

| Kategori | Teknologi |
| :--- | :--- |
| **Framework** | Flutter (Dart) |
| **AI Integration** | Google Generative AI (Gemini) |
| **State Management** | Provider |
| **Database Lokal** | Hive |
| **UI/UX** | Glassmorphism, Google Fonts, Flutter Animate, Shimmer |
| **Networking** | HTTP, Flutter Dotenv |

---

## 🚀 Cara Menjalankan Proyek

### Prasyarat
*   Flutter SDK (^3.8.1)
*   Dart SDK
*   Editor: VS Code atau Android Studio
*   API Key dari [NewsAPI](https://newsapi.org/) dan [Google AI Studio](https://aistudio.google.com/)

### Langkah-langkah Instalasi

1.  **Clone Repositori**
    ```bash
    git clone https://github.com/jodijonatan/newsly.git
    cd newsly
    ```

2.  **Instal Dependensi**
    ```bash
    flutter pub get
    ```

3.  **Konfigurasi Environment**
    Buat file `.env` di direktori *root* dan masukkan API Key Anda:
    ```env
    NEWS_API_KEY=isi_dengan_newsapi_key_anda
    GEMINI_API_KEY=isi_dengan_gemini_api_key_anda
    ```

4.  **Jalankan Aplikasi**
    ```bash
    flutter run
    ```

---

## 📸 Tampilan Aplikasi
*(Tambahkan screenshot atau GIF di sini)*

---

## 🤝 Kontribusi

Kontribusi selalu terbuka! Jika Anda memiliki ide untuk meningkatkan Newsly, silakan:
1. Fork proyek ini.
2. Buat branch fitur baru (`git checkout -b feature/FiturKeren`).
3. Commit perubahan Anda (`git commit -m 'Menambahkan Fitur Keren'`).
4. Push ke branch tersebut (`git push origin feature/FiturKeren`).
5. Buat Pull Request.

---

## 📄 Lisensi

Proyek ini dilisensikan di bawah **MIT License**. Lihat info selengkapnya di file [LICENSE](LICENSE).

---

## 🌟 Ucapan Terima Kasih

*   [NewsAPI](https://newsapi.org/) untuk penyediaan data berita.
*   Tim [Flutter](https://flutter.dev) untuk framework yang luar biasa.
*   [Google DeepMind](https://deepmind.google/) untuk teknologi Gemini AI.

---
*Dibuat dengan ❤️ oleh [Jodi Jonatan](https://github.com/jodijonatan)*
