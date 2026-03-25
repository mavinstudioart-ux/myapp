# Blueprint: CEO Journey

## Ringkasan Proyek

CEO Journey adalah game simulasi kehidupan berbasis Flutter yang memungkinkan pemain untuk menavigasi perjalanan karakter dari awal yang sederhana hingga menjadi seorang CEO yang sukses. Game ini menyeimbangkan elemen strategi keuangan, pengembangan diri, dan manajemen waktu dalam antarmuka yang modern dan menarik.

## Fitur & Desain Utama

### 1. Antarmuka & Pengalaman Pengguna (UI/UX)
- **Desain Modern:** Menggunakan estetika profesional dengan latar belakang gradasi biru tua, kartu putih solid, dan ikonografi yang jelas.
- **Dashboard Terpusat:** `game_screen.dart` menampilkan kartu status utama yang terinspirasi dari desain GoPay, merangkum semua informasi vital pemain (Nama, Saldo, Usia, Minggu, dan status Kesehatan/Mood/Kenyang dalam bentuk *chip*).
- **Navigasi Intuitif:** Menggunakan `GridView` untuk akses cepat ke fitur-fitur utama (Pekerjaan, Bisnis, Belanja, dll.) dan `BottomAppBar` dengan `FloatingActionButton` untuk aksi utama (minggu berikutnya) dan navigasi sekunder.
- **Umpan Balik Responsif:** Memberikan notifikasi `SnackBar` untuk aksi yang gagal (misalnya, dana tidak cukup) dan dialog "Game Over" yang jelas saat kondisi kekalahan terpenuhi.

### 2. Sistem Game Inti
- **Manajemen Status:** Pemain harus menyeimbangkan tiga atribut utama: **Kesehatan**, **Mood**, dan **Kenyang**. Status ini menurun setiap minggu dan dapat dipulihkan dengan membeli makanan atau item lainnya.
- **Sistem Waktu:** Permainan berjalan dalam siklus mingguan. Setiap minggu, status diperbarui, pendapatan diterima, dan event acak dapat terjadi.
- **Keuangan:** Pemain mengelola uang tunai, rekening bank (tabungan dan pinjaman), dan berinvestasi di berbagai aset.
- **Kondisi Kalah:** Permainan berakhir (Game Over) jika kesehatan pemain mencapai nol.

### 3. Fitur Gameplay
- **Sistem Karier (Update Terbaru):**
  - **Dua Jenis Pekerjaan:**
    - **Pekerjaan Tetap (`permanent`):** Memberikan gaji mingguan yang stabil. Pemain hanya bisa memiliki satu pekerjaan tetap pada satu waktu dan tidak bisa bekerja sambil menempuh pendidikan.
    - **Pekerjaan Lepas (`freelance`):** Berbasis proyek dengan durasi tertentu (minggu). Bayaran diberikan penuh setelah proyek selesai. Pemain dapat mengambil beberapa pekerjaan lepas secara bersamaan.
  - **Papan Pekerjaan:** Daftar pekerjaan diperbarui secara berkala, menawarkan berbagai peluang di berbagai sektor dengan persyaratan keterampilan yang berbeda.
- **Pendidikan:** Pemain dapat mendaftar di program pendidikan untuk memperoleh keterampilan baru, yang membuka akses ke pekerjaan dengan gaji lebih tinggi.
- **Bisnis:** Memungkinkan pemain untuk membeli dan mengelola bisnis yang menghasilkan pendapatan pasif mingguan.
- **Investasi:** Pemain dapat membeli dan menjual aset seperti saham dan properti.
- **Belanja:** Tempat untuk membeli item-item yang dapat memulihkan status (misalnya, makanan).
- **Bank:** Mengelola tabungan untuk mendapatkan bunga atau mengambil pinjaman.

### 4. Rencana Fitur (Coming Soon)
- **Sosial:** Fitur untuk berinteraksi dengan NPC, membangun hubungan, dan membuka event atau peluang baru.
- **Inventori:** Sistem untuk mengelola item-item yang dimiliki pemain selain aset keuangan.

## Struktur Kode Utama
- `main.dart`: Titik masuk aplikasi, menginisialisasi `GameState`.
- `game_state.dart`: Otak dari permainan, mengelola semua logika status, progres, dan aksi pemain.
- `models/models.dart`: Mendefinisikan semua struktur data inti seperti `Character`, `Job`, `Education`, dll.
- `screens/`: Berisi semua file UI untuk setiap fitur utama (cth., `game_screen.dart`, `job_screen.dart`).
