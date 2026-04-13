# ImGo-Hotel

Selamat datang di ImGo-Hotel, solusi manajemen perhotelan modern yang komprehensif. Proyek ini dibangun dengan arsitektur microservices di backend menggunakan Go, dan antarmuka frontend yang responsif dengan Next.js.

## 📝 Deskripsi Proyek

ImGo-Hotel adalah platform terintegrasi yang dirancang untuk mengelola berbagai aspek operasional hotel, mulai dari layanan kamar, otentikasi pengguna, hingga manajemen karyawan dan promosi. Dengan backend yang tangguh dan frontend yang intuitif, ImGo-Hotel bertujuan untuk memberikan pengalaman terbaik bagi staf dan tamu hotel.

## 🏛️ Arsitektur

Proyek ini mengadopsi pendekatan monorepo yang terdiri dari dua bagian utama:

*   **`backend/`**: Kumpulan microservices yang ditulis dalam bahasa Go. Setiap layanan bertanggung jawab atas domain bisnis tertentu dan dapat dikembangkan, di-deploy, dan di-skala secara independen.
*   **`imgo-frontend/`**: Aplikasi frontend yang dibangun menggunakan Next.js, menyediakan antarmuka pengguna untuk administrasi dan manajemen.

### Layanan Backend

Berikut adalah daftar microservices yang ada di backend:

*   **API Gateway**: Pintu masuk tunggal untuk semua permintaan dari frontend, yang kemudian diteruskan ke layanan yang sesuai.
*   **Auth Service**: Mengelola otentikasi dan otorisasi pengguna.
*   **Hotel Service**: Mengelola data inti hotel seperti kamar, reservasi, dll.
*   **Employee Service**: Mengelola data karyawan.
*   **Promo Service**: Mengelola promosi dan diskon.
*   **Restaurant Service**: Mengelola layanan restoran.
*   **SPA Service**: Mengelola layanan spa.
*   **Pilates Service**: Mengelola layanan pilates.
*   **AI Service**: Menyediakan fitur-fitur cerdas (misalnya, rekomendasi).

## 🚀 Cara Menjalankan Proyek

Proyek ini dirancang untuk dijalankan menggunakan Docker dan Docker Compose untuk menyederhanakan proses setup dan deployment.

### Prasyarat

Pastikan Anda telah menginstal perangkat lunak berikut di mesin Anda:

*   [Docker](https://www.docker.com/get-started)
*   [Docker Compose](https://docs.docker.com/compose/install/)

### Langkah-langkah Instalasi

1.  **Clone repository ini:**
    ```bash
    git clone https://github.com/sazwarriyadhs/ImGo-Hotel.git
    cd ImGo-Hotel
    ```

2.  **Konfigurasi Environment Variables:**
    Salin file `.env.example` (jika ada) menjadi `.env` di setiap layanan yang membutuhkannya dan sesuaikan nilainya.

3.  **Jalankan semua layanan menggunakan Docker Compose:**
    Dari direktori root proyek, jalankan perintah berikut:
    ```bash
    docker-compose up --build
    ```
    Perintah ini akan membangun image untuk setiap layanan dan menjalankannya dalam container.

4.  **Akses Aplikasi:**
    *   **Backend API Gateway** kemungkinan akan berjalan di port seperti `http://localhost:8080`.
    *   **Frontend Admin Dashboard** kemungkinan akan dapat diakses melalui `http://localhost:3000`.

    (Silakan sesuaikan port di atas sesuai dengan konfigurasi di `docker-compose.yml` Anda)

## 🤝 Kontribusi

Saat ini kami belum membuka kontribusi dari pihak eksternal. Namun, Anda dapat melakukan forking pada repositori ini untuk pengembangan pribadi.

---

Dibuat dengan ❤️ untuk manajemen perhotelan yang lebih baik.
