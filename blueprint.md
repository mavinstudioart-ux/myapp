# CEO Journey: Simulator Manajemen Kehidupan

## Ringkasan

CEO Journey adalah game simulasi kehidupan yang berfokus pada manajemen strategis sumber daya, keuangan, dan gaya hidup. Dengan antarmuka yang modern, pemain ditantang untuk membuat keputusan cerdas setiap minggu untuk membangun kesuksesan dari nol.

---

## **Visi & Rencana Pengembangan**

Berikut adalah peta jalan pengembangan yang menguraikan fitur-fitur yang akan diimplementasikan.

### **Fase 1: Pondasi & Pengalaman Inti (Selesai)**
1.  **Mekanisme Dasar:** Implementasi pergerakan waktu per minggu, status karakter (kesehatan, mood, lapar), dan sistem keuangan awal.
2.  **Aktivitas Dasar:** Pembelian makanan, pelamaran pekerjaan, pembelian properti, dan investasi sederhana.
3.  **UI Dashboard Modern:** Desain ulang UI dari `BottomNavigationBar` menjadi dashboard sentris dengan kartu navigasi berbasis ikon.

### **Fase 2: Peningkatan UI & Alur Game (Sedang Dikerjakan)**
1.  **Menu Utama:** Membuat layar menu utama dengan opsi "Permainan Baru", "Lanjutkan", dan "Pengaturan" untuk alur masuk yang profesional.
2.  **Kustomisasi Pemain:** Memungkinkan pemain memasukkan nama karakter mereka saat memulai permainan baru.
3.  **Informasi Status yang Jelas:** Menampilkan persentase numerik (`85%`) pada bar status (Kesehatan, Mood, Kenyang) untuk memberikan informasi yang lebih presisi.
4.  **Kondisi Game Over:** Mengimplementasikan layar "Game Over" saat kesehatan pemain mencapai 0, dengan opsi untuk memulai kembali.

### **Fase 3: Sistem Karir & Pendidikan (Selanjutnya)**
1.  **Model Data Baru:** Membuat kelas untuk `Education` (dengan properti seperti `name`, `durationInWeeks`, `cost`, `skillPointsAwarded`) dan `Skill`.
2.  **Sistem Pendidikan:**
    *   Membuat halaman "Pusat Pendidikan" di mana pemain dapat mendaftar untuk jenjang:
        *   SMA (prasyarat awal)
        *   Diploma (D3)
        *   Sarjana (S1)
        *   Magister (S2)
        *   Doktor (S3)
    *   Setiap jenjang akan memiliki durasi (dalam minggu) dan biaya yang realistis dalam konteks game.
3.  **Sistem Pekerjaan Ditingkatkan:**
    *   Setiap pekerjaan di `_jobBoard` akan memiliki prasyarat `requiredSkills`.
    *   Pemain hanya bisa melamar jika `character.skills` memenuhi syarat.

### **Fase 4: Sistem Keuangan & Bisnis Lanjutan (Masa Depan)**
1.  **Fitur Perbankan:**
    *   Membuat halaman "Bank" di dashboard.
    *   **Simpanan/Deposito:** Pemain dapat menyimpan uang dan menerima bunga mingguan.
    *   **Pinjaman:** Pemain dapat mengajukan pinjaman dengan sistem skor kredit yang memengaruhi plafon dan bunga.
2.  **Fitur Bisnis:**
    *   Membuat halaman "Bisnis" di dashboard.
    *   Pemain dapat mendirikan bisnis dari berbagai sektor (misal: Kafe, Startup Teknologi, dll.).
    *   **Mekanisme:** Membutuhkan modal awal, memiliki biaya operasional mingguan, dan menghasilkan pendapatan. Akan ada elemen risiko dan peluang.

