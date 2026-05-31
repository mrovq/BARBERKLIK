DOKUMEN BLUEPRINT FINAL PROYEK
APLIKASI: BARBERKLIK SUPER-APP
Matakuliah: Mobile Programming (Semester 4)
Program Studi: Teknik Informatika
1. IDENTITAS PROYEK (REVISED)
● Nama Aplikasi: BARBERKLIK (Edisi Super-App)
● Platform: Lintas Platform / Cross-Platform (Android & iOS)
● Bahasa Pemrograman: Dart
● Framework Utama: Flutter SDK
● Arsitektur Sistem: Multi-Role Workspace (Satu Codebase untuk Pelanggan & Mitra)
● Skema Warna & Tema Visual: Premium Modern Minimalis / Luxurious Dark Mode
○ Primary Background: Obsidian Black (#0A0A0A / #0D0D0D)
○ Surface/Card: Charcoal Grey (#121212 / #1E1E1E)
○ Accent/Highlights: Metallic Gold (#D4AF37)
○ Secondary Accent: Emerald Green (#10B981) (Khusus Status Online & Finansial)
2. LATAR BELAKANG & REVISI DESAIN
Berdasarkan hasil evaluasi dan revisi oleh Dosen Pengampu, aplikasi BARBERKLIK yang
semula dirancang sebagai sistem reservasi satu arah berbasis integrasi manual WhatsApp
(informational-transaksional sederhana) kini ditransformasikan secara menyeluruh.
Aplikasi baru ini mengadopsi konsep Super-App yang terinspirasi dari arsitektur layanan Grab.
Transformasi ini meningkatkan kompleksitas akademis proyek melalui penerapan:
1. Multi-User Role Synchronization: Interaksi real-time antara aplikasi Pelanggan
(Customer) dan aplikasi Kapster (Partner).
2. Sistem Antrean Digital (KlikQueue): Pengganti antrean fisik di outlet melalui estimasi
waktu tunggu otomatis.
3. E-Commerce Produk Grooming (KlikMart): Penjualan produk rambut secara instan dari
aplikasi.
4. Sistem Pembayaran Cashless (KlikPay): Manajemen dompet digital (e-wallet)
terintegrasi lengkap dengan poin loyalitas (loyalty points).
3. ARSITEKTUR MULTI-USER ROLES (2-IN-1
APPLICATION WORKSPACE)
Untuk mempermudah pengujian serta demonstrasi di hadapan penguji/dosen, aplikasi
dirancang menggunakan pendekatan Single-Codebase Multi-Role Simulator. Pengguna
dapat beralih peran (role) secara instan melalui Header Switcher Widget tanpa perlu melakukan
kompilasi ulang atau instalasi dua aplikasi terpisah.
┌────────────────────────────────────────────────────────┐
│ BARBERKLIK DART ENGINE │
└──────────────────────────┬─────────────────────────────┘
│
┌────────────────────────┴────────────────────────┐
▼ ▼
┌─────────────────────────────────┐
┌─────────────────────────────────┐
│ ROLE 1: PELANGGAN (USER) │ │ ROLE 2: MITRA
(KAPSTER) │
├─────────────────────────────────┤
├─────────────────────────────────┤
│ • KlikPay (Manajemen Saldo) │ │ • Status Toggle
(Online/Offline)│
│ • KlikCut (Home Service Booking)│ │ • Real-time Order Bid
Panel │
│ • KlikQueue (Antrean Outlet) │ │ • Penghitungan Pendapatan
Trip │
│ • KlikMart (Belanja Produk) │ │ • Ringkasan Profil &
Rating │
└─────────────────────────────────┘
└─────────────────────────────────┘
4. SPESIFIKASI FITUR UTAMA & SPESIFIKASI TEKNIS
A. KlikPay (Sistem Pembayaran & Finansial)
● Fungsi: Dompet digital internal untuk seluruh transaksi di ekosistem BARBERKLIK.
● Komponen UI: Kartu Glassmorphism dengan informasi saldo (Rupiah), poin loyalitas
(XP), dan tombol aksi cepat untuk penambahan saldo (Top Up) fiktif.
● Logika Bisnis: Setiap transaksi sukses memotong saldo KlikPay dan memberikan
akumulasi poin loyalitas kepada Pelanggan.
B. KlikCut (Layanan Panggil Kapster ke Rumah)
● Fungsi: Memesan kapster untuk datang dan melakukan pemotongan rambut di lokasi
pelanggan (layaknya GrabRide/GrabCar).
● Alur Kerja State Engine (Sangat Penting untuk Sidang):
[none] ➔ [searching] ➔ [accepted] ➔ [otw] ➔ [arrived] ➔
[completed]
○ none: Pengguna memilih jenis layanan (Gentleman Cut, Hair Spa, dll.) dan melihat
rincian lokasi penjemputan.
○ searching: Sistem menampilkan indikator pemuatan radial (radar waves) untuk
mensimulasikan pencarian kapster terdekat.
○ accepted: Mitra Kapster menerima notifikasi bidding order dan menyetujui
pekerjaan tersebut.
○ otw (On The Way): Sistem menampilkan visualisasi peta (Map Canvas Grid)
interaktif. Posisi motor Kapster bergerak secara dinamis mendekati penanda rumah
Pelanggan (menggunakan interpolasi koordinat GPS virtual).
○ arrived: Kapster tiba di lokasi. Tombol konfirmasi penyelesaian layanan aktif pada
layar Pelanggan.
○ completed: Layanan selesai, saldo KlikPay dipotong secara otomatis, dan status
pemesanan disetel kembali ke awal.
C. KlikQueue (Sistem Antrean Digital Outlet)
● Fungsi: Memungkinkan pelanggan melakukan pemesanan kursi di outlet fisik sebelum
tiba di lokasi untuk meminimalkan waktu tunggu.
● Komponen UI: * Outlet Info Card: Informasi jarak, sisa antrean saat ini, dan estimasi
waktu tunggu (misal: 30 menit).
○ Barber Selector Widget: Daftar kapster yang bertugas beserta rating performanya.
○ Service Checklist: Daftar jasa yang akan dikerjakan di outlet.
● Aturan Transaksi: Dikenakan biaya pencetakan antrean digital (Booking Fee) sebesar
Rp 10.000 yang langsung dipotong dari KlikPay saat tiket diterbitkan.
D. KlikMart (Katalog Grooming Store)
● Fungsi: Layanan E-Commerce dalam aplikasi untuk membeli produk penataan rambut
premium (seperti Pomade, Hair Powder, Beard Oil).
● Komponen UI: Grid dua kolom dengan kartu produk, indikator jumlah item dalam
keranjang belanja (Shopping Cart Badge), dan tombol pembayaran instan (Instant
Checkout).
5. STRUKTUR DATA (DART MODEL CLASS
REPRESENTATION)
Berikut adalah struktur representasi data objek yang digunakan di dalam aplikasi untuk
memelihara keadaan (state) data secara dinamis:
A. Model Data Layanan (Service)
class BarberService {
final String id;
final String name;
final int price;
final String desc;
BarberService({
required this.id,
required this.name,
required this.price,
required this.desc,
});
}
B. Model Data Pemesanan (Booking)
class BookingOrder {
final String bookingId;
final String clientId;
final String? partnerId;
final List<BarberService> services;
final int totalPrice;
final String status; // 'searching', 'accepted', 'otw', 'arrived',
'completed'
final double currentGpsProgress;
BookingOrder({
required this.bookingId,
required this.clientId,
this.partnerId,
required this.services,
required this.totalPrice,
required this.status,
required this.currentGpsProgress,
});
}
6. STRATEGI IMPLEMENTASI KODE SUMBER
(FLUTTER)
Aplikasi dirancang menggunakan prinsip Stateful Widget Architecture dengan optimalisasi
lifecycle widget sebagai berikut:
1. Timer Periodic: Digunakan di dalam metode initState() untuk mensimulasikan
pergerakan koordinat GPS tanpa memblokir benang proses utama (main thread) UI.
2. State Re-rendering (setState): Untuk menjaga sinkronisasi data keuangan, keranjang
belanja, dan status antrean di seluruh komponen halaman secara efisien.
3. Responsive Layouting: Menggunakan kombinasi LayoutBuilder, MediaQuery, dan
fleksibilitas widget (Expanded, Flexible, Grid) agar aplikasi tetap presisi dan proporsional
saat dijalankan pada berbagai ukuran layar ponsel pintar (Android & iOS).
7. RENCANA PENGUJIAN SIDANG / DEMO DOSEN
Dokumen ini merekomendasikan skenario demonstrasi interaktif berikut untuk menunjukkan
kompleksitas sistem di hadapan dosen penguji:
Langkah Skenario Tindakan Penguji /
Mahasiswa
Hasil / Reaksi Aplikasi Aspek Teknis yang
Dinilai
Langkah 1 Masuk ke menu
KlikCut di Aplikasi
Pelanggan, pilih
layanan Gentleman
Cut, lalu tekan Pesan
Sekarang.
Layar berubah menjadi
mode pencarian
(Searching Mode)
dengan animasi
pemuatan radial.
State Management,
Conditional UI
Rendering
Langkah 2 Ubah peran menjadi
Aplikasi Kapster
melalui tombol toggle di
bagian atas aplikasi.
Muncul panel notifikasi
orderan masuk
(Incoming Order Bid)
berwarna emas secara
real-time lengkap
dengan detail harga
dan jarak.
Multi-role Interaction,
Event Handling
Langkah 3 Tekan tombol Terima
Order pada layar
Kapster.
Sistem memulai
simulasi GPS. Jika
beralih kembali ke layar
pelanggan, motor
kapster terlihat
bergerak di peta secara
dinamis mendekati
lokasi rumah.
Asynchronous
Simulation, Timer, Math
Interpolation
Langkah 4 Setelah motor tiba
(GPS Progress =
100%), tekan tombol
Selesaikan Layanan.
Saldo KlikPay
pelanggan otomatis
terpotong Rp 85.000,
poin loyalitas
bertambah, dan
pendapatan kapster
hari ini terbarui.
Transaction Logic,
Math Operations, State
Syncing