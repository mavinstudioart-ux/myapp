# CEO Journey: Simulator Manajemen Kehidupan

## Ringkasan

CEO Journey adalah game simulasi kehidupan yang berfokus pada manajemen strategis sumber daya, keuangan, dan gaya hidup. Dengan antarmuka minimalis, pemain ditantang untuk membuat keputusan cerdas setiap minggu untuk membangun kesuksesan sambil menghindari kebangkrutan atau kematian.

## 1. Perbaikan Bug Kritis & Prioritas Utama

- **Akurasi Pelacakan Keuangan:** Prioritas utama adalah memperbaiki sistem log transaksi untuk memastikan **semua pengeluaran (termasuk pembelian makanan) tercatat secara real-time** pada total pengeluaran mingguan. Bug ini akan diatasi terlebih dahulu.
- **Kalkulasi Unit Investasi yang Tepat:** Merombak total fungsi pembelian aset untuk **menghilangkan bug kelebihan unit**. Jumlah unit yang diterima harus sama persis dengan yang dibeli.

## 2. Sistem Status & Sumber Daya Utama
- **Trio Sumber Daya:** Status utama karakter terdiri dari:
    - **Kesehatan:** Menentukan kemampuan bekerja dan risiko kematian.
    - **Kenyang:** Menjaga agar kesehatan dan mood tidak menurun.
    - **Mood:** Status baru yang menunjukkan tingkat kebahagiaan. Dipengaruhi oleh gaya hidup (tempat tinggal, kendaraan), pekerjaan, dan event. Mood rendah menurunkan performa.

## 3. Sistem Keuangan & Gameplay Lanjutan
- **Sistem Kelas Pinjaman Bank (Credit Score):
    -** Pemain akan memiliki **peringkat kredit berbentuk bintang (1-5)**.
    - Peringkat ini menentukan **plafon maksimal pinjaman** yang bisa diajukan.
    - Peringkat akan naik seiring dengan meningkatnya kekayaan, histori pembayaran yang baik, dan stabilitas keuangan.
- **Berita Naratif & Dampak Pasar:**
    - Fitur berita akan aktif. Setiap event pasar (misal: "Emas Naik") akan disertai dengan **kalimat naratif yang menjelaskan konteks** (misal: "Investor global beralih ke aset aman di tengah ketidakpastian ekonomi.").
    - Narasi ini memberikan petunjuk strategis kepada pemain.

## 4. Konten & Realisme
- **Harga Makanan Mingguan:** Harga semua item makanan di marketplace akan disesuaikan untuk merefleksikan **biaya belanja kebutuhan selama satu minggu**.

## 5. UI/UX & Optimisasi
- **Reset Log Aktivitas:** Untuk menjaga keringanan UI, daftar log aktivitas akan **dikosongkan secara otomatis setiap kali karakter berulang tahun** (setiap 52 minggu).

## Rencana Pengembangan

### **Fase 1: Perbaikan Bug & Implementasi Sistem Mood (Saat ini)**
1.  **Perbaiki Bug Finansial & Investasi:** Mengerjakan dua bug kritis yang telah diidentifikasi sebagai prioritas absolut.
2.  **Implementasikan Status Mood:** Menambahkan "Mood" ke dalam model data karakter dan menampilkannya di UI profil.
3.  **Hubungkan Mood dengan Gaya Hidup:** Membuat logika awal di mana kualitas tempat tinggal dan kendaraan memberikan bonus pasif pada Mood setiap minggu.

### **Fase 2: Implementasi Fitur Keuangan Lanjutan & Narasi**
1.  **Bangun Sistem Peringkat Kredit:** Mengembangkan logika untuk sistem bintang pada fitur pinjaman bank.
2.  **Implementasi Berita Naratif:** Membuat data set untuk event dan narasi yang menyertainya, lalu mengintegrasikannya ke dalam UI.
3.  **Kaji Ulang Harga Makanan:** Menyesuaikan semua harga item makanan di marketplace.

### **Fase 3: Optimisasi & Penambahan Konten**
1.  **Implementasi Reset Log Aktivitas:** Menambahkan fungsi untuk membersihkan log saat ulang tahun karakter.
2.  Memperluas daftar event, pekerjaan, aset, dan pilihan gaya hidup.
