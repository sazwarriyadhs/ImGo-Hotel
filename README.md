<div align="center">
  <img src="./imgo-frontend/customer-portal/public/images/logo.png" alt="ImGo-Hotel Logo" width="200"/>
  <h1>ImGo-Hotel</h1>
  <p>Solusi manajemen perhotelan modern yang dibangun dengan arsitektur microservices menggunakan Go dan Next.js.</p>
  <p>
    <a href="#-teknologi-yang-digunakan">Teknologi</a> •
    <a href="#-arsitektur">Arsitektur</a> •
    <a href="#-memulai">Memulai</a> •
    <a href="#-struktur-proyek">Struktur Proyek</a> •
    <a href="#-kontribusi">Kontribusi</a>
  </p>
</div>

---

## 📝 Tentang Proyek

**ImGo-Hotel** adalah sebuah platform perangkat lunak sebagai layanan (SaaS) yang dirancang untuk menyederhanakan dan mengotomatiskan operasi hotel. Dari manajemen reservasi hingga layanan tamu, proyek ini menyediakan serangkaian *microservices* yang kuat di backend dan dasbor admin yang intuitif di frontend.

## ✨ Teknologi yang Digunakan

Proyek ini dibangun menggunakan teknologi modern untuk memastikan skalabilitas, kinerja, dan kemudahan pengembangan.

| Komponen | Teknologi |
| :--- | :--- |
| **Backend** | Go (Golang) |
| **Frontend** | Next.js, React, TypeScript |
| **Database** | PostgreSQL (Dapat disesuaikan) |
| **Orkestrasi** | Docker, Docker Compose |
| **API Gateway** | Kustom menggunakan Go |
| **Linting & Formatting** | ESLint, Prettier |

## 🏛️ Arsitektur

Aplikasi ini menggunakan arsitektur *microservices* di mana setiap fungsi bisnis utama dipisahkan menjadi layanan independen. Pendekatan ini memungkinkan pengembangan dan penskalaan yang fleksibel.

<div align="center">
  <img src="https://i.imgur.com/your-architecture-diagram.png" alt="Diagram Arsitektur" width="600"/>
  <p><i><small>Diagram Arsitektur Sistem ImGo-Hotel (Ganti dengan diagram Anda)</small></i></p>
</div>

-   **API Gateway**: Bertindak sebagai satu-satunya titik masuk untuk semua permintaan klien, mengarahkannya ke layanan internal yang sesuai.
-   **Layanan Independen**: Setiap layanan (seperti `auth-service`, `hotel-service`, dll.) memiliki tanggung jawab tunggal dan basis datanya sendiri, berkomunikasi satu sama lain melalui API.

## 🚀 Memulai

Untuk menjalankan proyek ini di lingkungan pengembangan lokal Anda, ikuti langkah-langkah di bawah ini.

### Prasyarat

-   [Docker](https://www.docker.com/get-started) & [Docker Compose](https://docs.docker.com/compose/install/)
-   [Git](https://git-scm.com/)

### Instalasi

1.  **Clone repository:**
    ```bash
    git clone https://github.com/sazwarriyadhs/ImGo-Hotel.git
    cd ImGo-Hotel
    ```

2.  **Konfigurasi Lingkungan:**
    Setiap layanan mungkin memerlukan file `.env`. Salin file `.env.example` (jika ada) menjadi `.env` di setiap direktori layanan dan sesuaikan konfigurasinya.

3.  **Jalankan dengan Docker Compose:**
    Perintah ini akan membangun dan menjalankan semua layanan yang didefinisikan dalam `docker-compose.yml`.
    ```bash
    docker-compose up --build -d
    ```
    Flag `-d` akan menjalankannya di *detached mode*.

4.  **Akses Aplikasi:**
    -   **Frontend (Admin Dashboard):** [http://localhost:3000](http://localhost:3000)
    -   **Backend (API Gateway):** [http://localhost:8080](http://localhost:8080)

    *Catatan: Port dapat bervariasi tergantung pada konfigurasi `docker-compose.yml` Anda.*

## 📁 Struktur Proyek

Proyek ini diorganisir sebagai monorepo untuk memudahkan pengelolaan kode backend dan frontend secara bersamaan.
