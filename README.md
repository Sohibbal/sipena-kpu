<div align="center">
  <img src="backend/public/logo.jpeg" alt="Logo KPU" width="100"/>
  <h1 style="color: #f3f1f1ff;">Si-Pena KPU</h1>
  <p><b>Sistem Pecatatan data Pemilih KPU Berbasis Mobile (Local-First)</b></p>

  ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
  ![Next.js](https://img.shields.io/badge/Next.js-000000?style=for-the-badge&logo=next.js&logoColor=white)
  ![SQLite](https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white)
  ![Status](https://img.shields.io/badge/Status-Production_Ready-B71C1C?style=for-the-badge)
</div>

<br/>

## 🔴 Tentang Proyek
**Si-Pena KPU** adalah aplikasi pendataan calon pemilih yang dirancang khusus untuk Petugas Pemutakhiran Data Pemilih (Pantarlih). Dibangun dengan arsitektur **Local-First**, aplikasi ini memungkinkan petugas untuk melakukan entri data secara *offline* 100% di area pedesaan/pelosok tanpa sinyal, dan menyinkronkan datanya secara massal ke server pusat saat koneksi internet telah tersedia.

## ✨ Fitur Utama
- 📋 **Entri Data Terstruktur & Validasi**: Input form cerdas dengan validasi NIK (16 digit angka wajib) dan nama alfabetis untuk mencegah *human-error*.
- 📍 **Location Based Service (LBS)**: Merekam titik koordinat (Latitude/Longitude) secara presisi tinggi via GPS hardware, dilengkapi *Reverse Geocoding* untuk translasi alamat jalan otomatis.
- 📸 **Mobile Sensor Camera**: Pengambilan foto KTP/wajah pemilih secara langsung terintegrasi dengan sensor kamera bawaan (*native*).
- 💾 **Local-First Database**: Seluruh data tersimpan aman di internal memori perangkat (SQLite) sebagai antisipasi area *blank-spot* seluler.
- 🔄 **Batch Synchronization**: Sistem integrasi REST API yang mengirimkan *payload* data lokal ke server secara serentak, menghemat *bandwidth* kuota.
- ✏️ **Edit Data Offline**: Mengoreksi atau memperbarui data secara langsung di HP sebelum status disinkronisasikan.

## 🛠️ Stack Teknologi
| Platform | Teknologi | Deskripsi |
| :--- | :--- | :--- |
| **Mobile App** | Flutter (Dart) | *Framework UI Cross-platform*. |
| **Mobile DB** | SQLite | RDBMS untuk *offline persistence*. |
| **Backend API** | Next.js (TypeScript) | *Framework* Node.js untuk RESTful API. |
| **Backend ORM**| Prisma | Manajemen skema database server. |

---

## 🚀 Panduan Instalasi (Development)

### 1. Menjalankan Backend (Server API)
Pastikan Anda telah menginstal **Node.js** (v18+) di komputer Anda.
```bash
cd backend
npm install

# Konfigurasi file .env
npx prisma db push
npm run dev
```
*Server akan berjalan di `http://localhost:3000`*

### 2. Menjalankan Mobile App (Flutter)
Pastikan Anda telah menginstal **Flutter SDK** dan memiliki perangkat Android (fisik atau *emulator*).
```bash
# Di direktori utama proyek (root)
flutter pub get

# [PENTING] Jika menggunakan HP Fisik:
# Buka lib/data/api/api_service.dart 
# Sesuaikan `baseUrl` dengan IP Wi-Fi lokal komputer pribadi.

flutter run
```

## 🔒 Aspek Keamanan
Aplikasi ini dirancang dengan mematuhi prinsip **Mobile Security**:
- **Pencegahan SQL Injection**: Menerapkan *Parameterized Query* (`whereArgs`) pada layer abstraksi database lokal.
- **Sesi Aman**: Autentikasi sesi kredensial ditangani menggunakan enkapsulasi `SharedPreferences`.
- **Mitigasi Wireless Attack**: Desain sinkronisasi *on-demand* (bukan *open channel real-time*) meminimalisir risiko penyadapan *Man-in-the-Middle* saat survei di ruang terbuka. Akses *hardware* juga diproteksi dengan *Runtime User Permission*.

<br/>
<div align="center">
  <sub>Dibangun untuk kelancaran demokrasi Indonesia. © 2026 KPU RI</sub>
</div>
