---
title: Pemodelan Arsitektur dan Tata Kelola Data Talent Management antara Departemen Delivery dan Departemen Presales
author: Tb M Reza Handzalah
---

Studi Kasus: PT Mitra Integrasi Informatika (MII), berbasis kerangka DAMA-DMBOK2.

**Disusun oleh Kelompok 6C**

Adryan Rizky Alviano (2606769261)

Fatimah Zahra (2606845642)

Sarah H M Siahaan (2606846241)

Tb M Reza Handzalah (2606769961)

**Magister Teknologi Informasi**

**Fakultas Ilmu Komputer, Universitas Indonesia**

**Semester Ganjil 2026/2027**

# 1. Executive Summary

PT Mitra Integrasi Informatika (MII), anak perusahaan PT Metrodata Electronics Tbk, menjalankan proyek TI untuk klien melalui Departemen Delivery, sementara Departemen Presales menyiapkan POC, dokumen tender, dan materi kick-off meeting (KOM) untuk proyek baru. Kedua departemen bertukar informasi talent dan dokumen proyek di setiap tahap, mulai dari peluang proyek sampai proyek dimulai. Laporan ini memakai sudut pandang talent management antar kedua departemen: data talent dikelola bersama sejak kebutuhan talent muncul di Presales, lalu talent diseleksi, ditugaskan, dan diperbarui profilnya di Delivery. Ringkasan 5W+1H pengelolaan data pada studi kasus ini sebagai berikut:

- What: informasi talent (CV, pengalaman proyek, daftar tenaga ahli usulan) dan dokumen proyek (hasil POC, timeline, materi KOM, MoM, NDA, permintaan akses VPN) [@dokumenkoma2025; @dokumenkomb2026].
- Who: Delivery sebagai produsen data, Presales sebagai pengguna data dan pemberi feedback, Project Manager sebagai perantara, serta klien sebagai penerima dokumen proyek.
- Where: PT MII; data tersimpan di penyimpanan pribadi, site SharePoint per proyek pada Microsoft 365, email, dan grup pesan singkat [@dokumenkoma2025; @dokumenkomb2026].
- When: setiap ada peluang proyek atau tender, setelah tender dimenangkan, dan saat proyek dimulai melalui KOM.
- Why: belum ada pemilik data, standar, repositori bersama, dan alur balik, sehingga penyiapan dokumen bergantung pada respons berantai dan data pribadi beredar tanpa klasifikasi.
- How: merancang tata kelola data talent management (kebijakan, standar, prosedur, 11 Knowledge Area DMBOK, peran dan RACI), arsitektur data, serta integrasi melalui repositori terpusat di Microsoft 365 [@dama2017].

Hasil checklist as-is terhadap 11 Knowledge Area DMBOK menunjukkan 4 area berjalan sebagian (Data Modeling and Design, Data Storage and Operations, Data Security, Document and Content Management) dan 7 area belum ada. Kondisi ini setara dengan tingkat kematangan tata kelola level 1 (Ad Hoc) menuju level 2 (Defined) [@dama2017]. Rancangan to-be menetapkan Division Manager Delivery sebagai Data Owner domain talent, Project Manager dan Koordinator Data Talent sebagai Business Data Steward, dan Admin Repositori SharePoint sebagai Technical Custodian, dengan Operations Committee sebagai forum tata kelola data. Arsitektur data dirancang dalam tiga area, yaitu Presales Data Domain, Shared Talent Master Data, dan Delivery Data Domain, yang dilengkapi EERD, matriks CRUD, dan kamus data. Integrasi to-be mengganti pertukaran berantai melalui email dan pesan singkat dengan pola hub-and-spoke berbasis repositori terpusat Microsoft 365 (Talent Hub), alur permintaan talent yang terotomasi, dan akses berbasis peran.

# 2. Profil Organisasi

## 2a. Information Value Chain

Value chain MII disusun dengan mengadaptasi model Porter [-@porter1985] untuk perusahaan jasa TI, lalu dibaca dengan sudut pandang Ward dan Peppard [-@ward2016] untuk melihat di aktivitas mana informasi dihasilkan dan digunakan.

![](figures/gambar1-dummy.png)

**Gambar 1. Information value chain PT MII dengan fokus talent management (diadaptasi dari Porter, 1985; Ward & Peppard, 2016)**

**Aktivitas utama:**

- Pemasaran dan penjualan (Presales dan Account Manager): menyiapkan POC, dokumen tender, dan materi KOM. Aktivitas ini membutuhkan informasi talent dan data teknis dari Delivery.
- Operasi (Delivery): menjalankan proyek TI melalui tim Technology Architecture, Development, Quality Excellence, dan Operation atau Support, serta menghasilkan pengalaman proyek, timeline, dan dokumen proyek [@dokumenkoma2025; @dokumenkomb2026].
- Layanan purna jual (Support): preventive maintenance, corrective maintenance, dan layanan sesuai SLA setelah proyek berjalan [@dokumenkoma2025].

**Aktivitas pendukung:**

- Talent management (fokus laporan): identifikasi kebutuhan, seleksi, penugasan tenaga ahli ke proyek, pemeliharaan CV, dan pemantauan ketersediaan talent.
- Pengembangan teknologi: Microsoft 365, termasuk site SharePoint per proyek.
- Infrastruktur perusahaan: manajemen proyek, Steering Committee, Operations Committee, serta dokumen legal seperti NDA [@dokumenkoma2025; @dokumenkomb2026].

Tabel 1. **Alur informasi Delivery dan Presales sepanjang siklus proyek**

| **Tahap** | **Aktivitas** | **Informasi** | **Arah aliran** | **Media as-is** | **Sumber** |
| --- | --- | --- | --- | --- | --- |
| 1. Peluang proyek atau tender | Penetapan Presales PIC dan Project Manager | Kebutuhan klien, KAK (Kerangka Acuan Kerja)/TOR | Presales ke Delivery | Email, rapat | Dokumen KOM Proyek A, 2025 |
| 2. Persiapan POC | Presales meminta data Delivery untuk POC | Kebutuhan teknis, hasil POC | Presales dan Delivery dua arah | Email, pesan singkat | Analisis kelompok |
| 3. Seleksi talent | PM menghubungi tenaga ahli Delivery, menganalisis, lalu menyetor nama | Daftar tenaga ahli usulan | PM ke Presales | Email, pesan singkat | Analisis kelompok |
| 4. Pengumpulan CV | PM mengumpulkan CV dari setiap tenaga ahli | CV dan pengalaman proyek | Tenaga ahli ke PM ke Presales | Email, pesan singkat, SharePoint proyek | Analisis kelompok |
| 5. Tender | Presales menyusun dan mengajukan dokumen tender | Dokumen tender | Presales ke klien | Email dan file dokumen tender | Analisis kelompok |
| 6. Tender dimenangkan | Presales meminta informasi lanjutan dari Delivery | Timeline, estimasi, struktur tim | Delivery ke Presales | Email, rapat | Analisis kelompok |
| 7. Proyek dimulai | KOM, penandatanganan NDA, permintaan akses VPN, notulensi rapat | Materi KOM, MoM Kick Off, NDA, permintaan akses | MII dan klien dua arah | File presentasi, email, pdf, grup pesan singkat | Dokumen KOM Proyek A, 2025; Dokumen KOM Proyek B, 2026 |
| 8. Alur balik | Feedback hasil tender dan kebutuhan talent berikutnya | Feedback | Presales ke Delivery | Belum ada alur formal | Analisis kelompok |

**Titik lemah dalam value chain:**

Informasi dihasilkan di aktivitas Operasi dan digunakan di aktivitas Pemasaran dan penjualan, tetapi perpindahannya bertumpu pada PM sebagai satu-satunya penghubung dan pada media yang tidak terkelola. Pola single point of contact juga tercantum pada rencana komunikasi proyek, yaitu seluruh komunikasi mengalir antar-PM tanpa komunikasi langsung antartim [@dokumenkomb2026]. Pola ini efektif untuk kendali proyek, tetapi menjadikan PM titik hambat ketika informasi talent dibutuhkan cepat. Selain itu, tidak adanya alur balik dari Presales membuat Delivery tidak mengetahui hasil tender dan kebutuhan talent berikutnya.

## 2b. Problem Statement Tata Kelola Data

Sumber: observasi anggota kelompok yang bekerja di Departemen Delivery, alur proses yang disusun kelompok, dan dokumen KOM [@dokumenkoma2025; @dokumenkomb2026].

**Pernyataan masalah:**

Dari perspektif talent management, informasi talent dan dokumen proyek yang dipertukarkan Departemen Delivery dan Departemen Presales belum dikelola sebagai aset data bersama, sehingga setiap peluang proyek dan setiap proyek baru bergantung pada pengumpulan manual berantai melalui Project Manager. Akibatnya, MII menghadapi risiko keterlambatan dan ketidaklengkapan dokumen POC dan tender di bawah tenggat yang tetap, yang dapat menurunkan peluang memenangkan proyek, serta risiko kepatuhan karena data pribadi tenaga ahli beredar melalui media yang tidak terkelola.

**Harapan:**

- Akses langsung: Presales dapat menemukan informasi talent terbaru dan hasil POC tanpa permintaan berantai.
- Pemilik data jelas: ada pihak yang ditetapkan untuk memelihara dan menyediakan informasi talent dan dokumen proyek.
- Prosedur pembaruan: CV diperbarui setiap proyek selesai dengan format CV standar perusahaan.
- Hak akses terkendali: akses diatur berdasarkan peran karena CV, KOM, NDA, dan permintaan akses VPN memuat data pribadi.
- Alur balik: Presales menyampaikan hasil tender dan kebutuhan talent berikutnya kepada Delivery.
- Kesiapan proyek: NDA dan permintaan akses VPN dapat disiapkan sejak tender dimenangkan.

**Realita:**

- Penyimpanan terpisah: informasi tersimpan di penyimpanan pribadi, site SharePoint per proyek dengan PIC dan hak akses berbeda, email, dan grup pesan singkat.
- Alur manual: PM menghubungi setiap tenaga ahli, menganalisis, menyetor nama, lalu mengumpulkan CV satu per satu untuk Presales.
- Versi tidak konsisten: CV satu karyawan dapat tersalin ke beberapa site proyek dengan versi berbeda.
- Data pribadi tersebar: materi KOM memuat nama, jabatan, nomor telepon, dan email personel, sementara rencana komunikasi proyek memakai email, telepon, dan grup pesan singkat [@dokumenkoma2025; @dokumenkomb2026].
- Istilah peran tidak seragam: struktur tim pada dua KOM memakai nama peran berbeda, misalnya Operation dan Support Manager pada Proyek A, serta Support, Co-PM, dan DevOps pada Proyek B [@dokumenkoma2025; @dokumenkomb2026].
- Tidak ada alur balik dari Presales ke Delivery.

Tabel 2. **Implikasi bisnis**

| **Implikasi bisnis** | **Penjelasan** | **Sumber** | **Bukti yang masih diperlukan** |
| --- | --- | --- | --- |
| Risiko kehilangan peluang proyek | Dokumen POC dan tender berisiko terlambat atau tidak lengkap karena pengumpulan berantai berlangsung di bawah tenggat yang tetap | Analisis kelompok | Jumlah tender yang terlambat atau gagal dalam 12 bulan terakhir |
| Kualitas penawaran menurun | CV yang belum mutakhir atau berbeda versi dapat masuk ke dokumen penawaran sehingga kualifikasi tim tidak tergambar akurat | Analisis kelompok | Contoh kasus CV usang pada dokumen penawaran |
| Produktivitas PM dan tenaga ahli tersita | PM menghubungi setiap orang, menganalisis, dan mengumpulkan CV di samping tugas proyek yang sedang berjalan | Analisis kelompok | Estimasi jam kerja per permintaan |
| Kesiapan awal proyek tertunda | Kesiapan server dan akses serta readiness environment menjadi butir logistik dan rencana lanjutan awal pada KOM; NDA dan akses VPN merupakan prasyarat kerja tenaga ahli | Dokumen KOM Proyek A, 2025 | Selisih hari antara KOM dan akses diberikan |
| Risiko kepatuhan dan reputasi | Data pribadi beredar melalui email dan pesan singkat tanpa klasifikasi; MII sebagai pemroses data pribadi perlu perjanjian dengan klien sebagai pemilik data | Dokumen KOM Proyek A, 2025; UU No. 27 Tahun 2022 | Daftar NDA dan perjanjian pemrosesan data yang aktif |
| Perencanaan talent tidak berbasis data | Tanpa feedback, Delivery tidak dapat merencanakan ketersediaan talent untuk peluang berikutnya | Analisis kelompok | Jumlah peluang proyek per kuartal |

**Permasalahan tata kelola data [@abraham2019]:**

- Struktural: belum ada data owner dan data steward untuk informasi talent dan dokumen proyek; hak akses ditentukan per site proyek, bukan berdasarkan kebutuhan lintas departemen.
- Prosedural: belum ada kebijakan, standar metadata, prosedur pembaruan, maupun repositori bersama yang dapat diakses Presales.
- Relasional: koordinasi bertumpu pada PM sebagai penghubung tunggal dan belum ada alur balik dari Presales [@dokumenkomb2026].

## 2c. Struktur Inti Organisasi dan Fungsi SI/TI

Sumber: struktur organisasi proyek pada dokumen KOM [@dokumenkoma2025; @dokumenkomb2026] dan observasi anggota kelompok. Nama personel dan klien disamarkan.

**Gambar 2. Struktur inti organisasi dan fungsi SI/TI terkait talent management (diolah dari Dokumen KOM Proyek A, 2025; Dokumen KOM Proyek B, 2026)**

**Struktur inti organisasi:**

- Induk perusahaan: PT Metrodata Electronics Tbk.
- Pimpinan PT MII: President Director dan Director, yang juga duduk di Steering Committee proyek [@dokumenkomb2026].
- Fungsi penjualan: Sales Division Manager dan Account Manager [@dokumenkoma2025; @dokumenkomb2026].
- Departemen Delivery: Division Manager dan Principal Manager, dengan Project Manager, Technical Manager, dan tenaga ahli dalam stream Technology Architecture, Development, Quality Excellence, dan Operation atau Support [@dokumenkoma2025; @dokumenkomb2026].
- Departemen Presales: mendukung fungsi penjualan dalam menyiapkan POC, dokumen tender, dan materi KOM; struktur internalnya tidak tercantum dalam dokumen KOM sehingga tidak dirinci.

**Struktur tata kelola proyek (berlaku per proyek):**

- Steering Committee: Director MII bersama pimpinan TI klien; menangani eskalasi isu dan persetujuan isu tingkat tinggi [@dokumenkoma2025; @dokumenkomb2026].
- Operations Committee: Division Manager, Account Manager, dan Principal Manager dari MII [@dokumenkoma2025; @dokumenkomb2026].
- Manajer proyek: Project Manager (dan Co-PM pada Proyek B) serta Technical Manager [@dokumenkoma2025; @dokumenkomb2026].
- Alur komunikasi: PM MII menjadi single point of contact dengan PM atau PIC klien [@dokumenkoma2025; @dokumenkomb2026].

**Fungsi SI/TI:**

Unit SI/TI internal yang mengelola Microsoft 365 dan SharePoint tidak teridentifikasi dalam dokumen yang tersedia, sehingga bagian ini dijelaskan melalui fungsi dan matriks tanggung jawab.

- Pengelolaan platform Microsoft 365 dan SharePoint: unit pengelolanya tidak teridentifikasi dalam dokumen yang tersedia, sehingga fungsi ini diusulkan sebagai Admin Repositori SharePoint (Technical Custodian).
- Pengaturan hak akses site SharePoint proyek: PIC site proyek.
- Akses ke sistem klien (VPN dan server): disediakan oleh klien atas permintaan tim proyek MII [@dokumenkoma2025].

# 3. Tata Kelola Data

## 3a. Kebijakan, Standar, dan Prosedur

Kebijakan internal MII yang khusus mengatur data talent dan dokumen proyek belum diketahui, sehingga analisis dilakukan dari perspektif organisasi secara umum, yaitu praktik yang terlihat pada dokumen proyek [@dokumenkoma2025; @dokumenkomb2026]. Pembedaan kebijakan sebagai arah, standar sebagai persyaratan, dan prosedur sebagai langkah kerja mengacu pada DAMA International [-@dama2017].

Tabel 3. **Analisis as-is dan to-be kebijakan, standar, dan prosedur**

| **Komponen** | **As-Is** | **To-Be** | **Landasan dan sumber** |
| --- | --- | --- | --- |
| Regulasi eksternal | UU PDP berlaku karena CV, KOM, NDA, dan permintaan akses VPN memuat data pribadi; belum ada pemetaan kewajiban | Pemetaan data pribadi per jenis dokumen, dasar pemrosesan, dan perjanjian pemrosesan dengan klien | UU No. 27 Tahun 2022 |
| Kebijakan internal | Kebijakan pengelolaan data talent dan dokumen proyek belum diketahui | Kebijakan Pengelolaan Informasi Talent dan Dokumen Proyek yang disetujui Director | DAMA International [-@dama2017] |
| Kontrak dan NDA | NDA dibuat per proyek; jadwal proyek mengikuti KAK dan dapat berubah sebelum kontrak ditandatangani | Register NDA terpusat dan klausul pemrosesan data pribadi pada perjanjian dengan klien | Dokumen KOM Proyek A, 2025 |
| Standar format dokumen | Format CV standar perusahaan dipakai [@cvkaryawan2026]; KOM memiliki struktur berulang: latar belakang dan lingkup, struktur organisasi, rencana komunikasi, jadwal | Format CV, template KOM, MoM, NDA, dan permintaan akses VPN ditetapkan sebagai standar wajib | Dokumen KOM Proyek A, 2025; Dokumen KOM Proyek B, 2026 |
| Standar klasifikasi dan akses | Belum ada klasifikasi; akses ditentukan per site proyek | Klasifikasi Publik, Internal, Rahasia, dan Data Pribadi; akses berbasis peran dan prinsip least privilege | DAMA International, 2017 |
| Standar metadata | Belum ada; nama peran berbeda antar proyek | Glosarium peran dan keahlian; metadata wajib: kode proyek, jenis dokumen, klasifikasi, pemilik, tanggal | Dokumen KOM Proyek A, 2025; Dokumen KOM Proyek B, 2026 |
| Prosedur komunikasi proyek | Ada: progress meeting dan progress report mingguan atau dua mingguan, rapat Steering Committee untuk eskalasi, komunikasi harian lewat email, telepon, dan grup pesan singkat | Dipertahankan; distribusi MoM dan dokumen dilakukan melalui repositori, bukan lampiran pesan singkat | Dokumen KOM Proyek A, 2025; Dokumen KOM Proyek B, 2026 |
| Prosedur permintaan informasi talent | Informal dan berantai melalui PM | SOP permintaan informasi talent dengan target waktu layanan yang disepakati PM dan Presales, misalnya 2 hari kerja (usulan kelompok) | Analisis kelompok |
| Prosedur pembaruan CV | Belum ada | CV diperbarui paling lambat 14 hari kerja (usulan kelompok) setelah proyek selesai dan diverifikasi PM | Analisis kelompok |
| Prosedur NDA dan akses VPN | Per proyek, belum terdokumentasi | SOP dan checklist kesiapan proyek yang dimulai sejak tender dimenangkan | Dokumen KOM Proyek A, 2025 |
| Prosedur eskalasi | Eskalasi isu proyek ke Steering Committee sudah ada; eskalasi isu data belum ada | Jalur eskalasi isu data: Steward, Owner, Operations Committee, lalu Steering Committee | Dokumen KOM Proyek A, 2025; Dokumen KOM Proyek B, 2026; DAMA International, 2017 |

## 3b. Fungsi dan Aktivitas: Checklist As-Is dan To-Be 11 Knowledge Area DMBOK

Setiap Knowledge Area dinilai berdasarkan evidensi dari dokumen proyek dan observasi. Area yang belum ada di perusahaan tetap dijelaskan evidensinya. Daftar dan fokus 11 Knowledge Area mengacu pada DAMA International [-@dama2017].

Tabel 4. **Checklist as-is dan to-be 11 Knowledge Area DMBOK**

|  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- |
| **No** | **Knowledge Area** | **Checklist As-Is** | **Evidensi As-Is** | **Rancangan To-Be** | **Sumber** |
| 1 | Data Governance | ☐ Belum ada | Tata kelola hanya ada di level proyek (Steering Committee, Operations Committee); belum ada owner, steward, atau kebijakan untuk informasi talent dan dokumen proyek | Operations Committee berfungsi sebagai forum tata kelola data; penetapan owner, steward, dan custodian; kebijakan dan RACI | Dokumen KOM Proyek A, 2025; Dokumen KOM Proyek B, 2026 |
| 2 | Data Architecture | ☐ Belum ada | Tidak ada dokumentasi arsitektur data; informasi tersebar di penyimpanan pribadi, site SharePoint per proyek, email, dan pesan singkat | Arsitektur target dengan repositori terpusat Microsoft 365 sebagai sumber acuan | Analisis kelompok |
| 3 | Data Modeling and Design | ◐ Sebagian | Format CV standar [@cvkaryawan2026] memberi struktur de facto, tetapi belum ada model konseptual, logis, maupun fisik | Subject area model, model logis, dan kamus data untuk talent, proyek, peluang, dan dokumen | Analisis kelompok |
| 4 | Data Storage and Operations | ◐ Sebagian | Microsoft 365 dan SharePoint tersedia dan dipakai per proyek; penyimpanan pribadi berada di luar pengelolaan perusahaan | Satu site atau library terpusat dengan retensi dan backup sesuai kebijakan platform | Analisis kelompok |
| 5 | Data Security | ◐ Sebagian | Akses site proyek sudah terbatas pada anggota proyek, tetapi data pribadi dikirim lewat email dan pesan singkat, dan KOM memuat nomor telepon serta email personel | Klasifikasi data, akses berbasis peran, berbagi melalui tautan terkendali, NDA dan perjanjian pemrosesan data sesuai UU PDP | Dokumen KOM Proyek A, 2025; UU No. 27 Tahun 2022 |
| 6 | Data Quality | ☐ Belum ada | Tidak ada aturan kelengkapan atau pemutakhiran; CV satu karyawan dapat berbeda versi antar site | Aturan kualitas: kelengkapan field wajib, ketepatan waktu pembaruan, satu versi aktif; dimonitor steward | DAMA International, 2017 |
| 7 | Metadata Management | ☐ Belum ada | Tidak ada glosarium; nama peran berbeda antar KOM (Operation dan Support Manager pada Proyek A, Support dan DevOps pada Proyek B) | Business glossary peran dan keahlian; metadata dokumen: kode proyek, jenis dokumen, klasifikasi, pemilik, tanggal | Dokumen KOM Proyek A, 2025; Dokumen KOM Proyek B, 2026 |
| 8 | Data Integration and Interoperability | ☐ Belum ada | Pertukaran manual berantai melalui PM lewat email dan pesan singkat (WhatsApp); tidak ada HRIS atau sistem lain yang terhubung ke SharePoint | Alur permintaan informasi terotomasi di Microsoft 365 dan penautan dokumen dari repositori terpusat ke site proyek | Analisis kelompok |
| 9 | Document and Content Management | ◐ Sebagian | KOM, MoM Kick Off, dokumen desain, laporan pengujian, dan BAST sudah menjadi keluaran baku proyek, tetapi disimpan per proyek tanpa versi dan retensi lintas proyek | Library dokumen per jenis (CV, hasil POC, KOM, MoM, NDA, permintaan akses VPN) dengan template, versi, dan retensi | Dokumen KOM Proyek A, 2025; Dokumen KOM Proyek B, 2026 |
| 10 | Reference and Master Data | ☐ Belum ada | Tidak ada daftar induk tenaga ahli; satu orang tercatat di banyak site proyek | Master data talent dengan satu catatan acuan per karyawan; data referensi: peran, keahlian, sertifikasi, kode klien, jenis dokumen | DAMA International, 2017 |
| 11 | Data Warehousing and Business Intelligence | ☐ Belum ada | Tidak ada laporan ketersediaan talent, kelengkapan CV, atau waktu pemenuhan permintaan | Dashboard: ketersediaan dan tingkat idle talent, kelengkapan CV, waktu pemenuhan permintaan, hasil tender | Analisis kelompok |

*Keterangan: ☑ Ada, ◐ Sebagian, ☐ Belum ada.*

**Checklist prioritas to-be:**

- ☐ Tahap 1: Data Governance, Data Security, Metadata Management, dan Document and Content Management, karena menjadi dasar kepemilikan, akses, dan standar dokumen.
- ☐ Tahap 2: Reference and Master Data, Data Quality, Data Architecture, Data Modeling and Design, dan Data Storage and Operations, untuk membentuk repositori terpusat dan master data talent.
- ☐ Tahap 3: Data Integration and Interoperability serta Data Warehousing and Business Intelligence, setelah data acuan tersedia.

*Pentahapan mengikuti prinsip bahwa arsitektur data adalah roadmap bertahap, bukan perubahan sekaligus* [@dama2017]*.*

## 3c. Role and Responsibility

Peran organisasi dipetakan ke peran DMBOK: Data Owner memutuskan apa dan mengapa, Data Steward menentukan bagaimana secara bisnis, dan Data Custodian menjalankan secara teknis [@dama2017]. Saat ini data owner dan data steward untuk data talent belum ditetapkan. Rancangan ini tidak membentuk komite baru, tetapi memakai Steering Committee dan Operations Committee yang sudah ada di setiap proyek [@dokumenkoma2025; @dokumenkomb2026].

Catatan: MII belum memiliki struktur tata kelola data formal, sehingga pemetaan peran pada bagian ini merupakan asumsi dan usulan kelompok. Pemegang peran dirujuk dari jabatan yang tercantum pada struktur organisasi proyek [@dokumenkoma2025; @dokumenkomb2026]. Untuk fungsi yang belum memiliki pemegang, kelompok mengusulkan penanggung jawab baru berikut.

**Usulan penambahan penanggung jawab:**

- Koordinator Data Talent (peran baru di Departemen Delivery): ditunjuk Division Manager, misalnya dari Principal Manager atau staf senior Delivery. Tugasnya memelihara repositori CV dan pengalaman proyek, memvalidasi pembaruan, dan menjawab permintaan Presales tanpa harus melalui setiap PM.
- Steward Dokumen Presales (peran baru di Departemen Presales): memelihara template dan versi dokumen tender, hasil POC, dan materi KOM, serta mencatat feedback hasil tender untuk Delivery.
- Admin Repositori SharePoint (Technical Custodian): karena unit SI/TI internal belum teridentifikasi, peran ini dapat dirangkap PIC site SharePoint atau anggota tim Operation/Support yang ditunjuk, untuk mengelola hak akses, retensi, dan backup.
- Forum tata kelola data: memanfaatkan Operations Committee yang sudah ada (Division Manager, Account Manager, Principal Manager) sebagai forum keputusan data lintas departemen, sehingga tidak perlu membentuk komite baru [@dokumenkoma2025; @dokumenkomb2026].

Tabel 5. **Pemetaan peran organisasi ke peran DMBOK**

| **Peran di organisasi** | **Peran DMBOK** | **Tanggung jawab to-be** | **Sumber** |
| --- | --- | --- | --- |
| Director MII | Executive Sponsor (Steering Committee) | Arahan strategis, persetujuan kebijakan, keputusan eskalasi akhir | Dokumen KOM Proyek A, 2025; Dokumen KOM Proyek B, 2026; DAMA International, 2017 |
| Operations Committee: Division Manager, Account Manager, Principal Manager | Data Governance Council | Forum lintas fungsi; menyetujui standar; menyelesaikan isu lintas Delivery dan Presales | Dokumen KOM Proyek A, 2025; Dokumen KOM Proyek B, 2026; DAMA International, 2017 |
| Division Manager Delivery | Data Owner domain talent dan data teknis proyek | Memutuskan definisi, akses, dan prioritas data talent | DAMA International, 2017 |
| Pimpinan Departemen Presales | Data Owner domain peluang dan dokumen tender | Memutuskan kebutuhan dan akses dokumen tender | DAMA International, 2017 |
| Project Manager | Business Data Steward | Memvalidasi CV dan data proyek, menjaga kualitas dan versi, menjadi penghubung kebutuhan | DAMA International, 2017 |
| Koordinator Data Talent (peran baru, Departemen Delivery) | Business Data Steward domain talent | Memelihara repositori CV dan pengalaman proyek, memvalidasi pembaruan, menjawab permintaan talent dari Presales | Analisis kelompok; DAMA International, 2017 |
| Presales PIC | Data Consumer dan steward dokumen tender | Menyampaikan kebutuhan, menyusun dokumen tender dan KOM, memberi feedback | Analisis kelompok |
| Steward Dokumen Presales (peran baru, Departemen Presales) | Business Data Steward domain peluang dan dokumen tender | Memelihara template dan versi dokumen tender, hasil POC, materi KOM, serta mencatat feedback hasil tender | Analisis kelompok; DAMA International, 2017 |
| Tenaga ahli Delivery, termasuk Technical Writer | Data Producer | Membuat dan memperbarui CV, hasil POC, MoM, NDA, dan permintaan akses VPN | Dokumen KOM Proyek A, 2025; Dokumen KOM Proyek B, 2026 |
| Admin Repositori SharePoint (diusulkan) dan PIC site proyek | Technical Data Custodian | Konfigurasi repositori, pemberian akses, backup, retensi | DAMA International, 2017 |
| Klien | Pihak pemilik data pribadi pada proyek; MII sebagai pemroses | Menyetujui perjanjian pemrosesan data dan NDA | UU No. 27 Tahun 2022 |

Matriks RACI berikut menerjemahkan peran menjadi akuntabilitas per aktivitas [@dama2017]. Singkatan kolom: DIR (Director), DMD (Division Manager Delivery, Data Owner), PM (Project Manager, Data Steward), PS (Presales), TA (tenaga ahli Delivery), CUS (Admin Repositori SharePoint, Technical Custodian), KDT (Koordinator Data Talent).

Tabel 6. **Matriks RACI pertukaran informasi talent dan dokumen proyek**

|  |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| **No** | **Aktivitas** | **DIR** | **DMD** | **PM** | **PS** | **TA** | **CUS** | **KDT** |
| 1 | Menetapkan kebijakan informasi talent dan dokumen proyek | A | R | C | C | I | C |  |
| 2 | Menetapkan standar format CV, template dokumen, dan metadata | I | A | R | C | I | C | C |
| 3 | Menetapkan PM untuk peluang proyek | I | A, R | I | C |  |  |  |
| 4 | Menyampaikan kebutuhan data untuk POC dan tender |  | I | C | A, R | I |  | I |
| 5 | Menganalisis dan mengusulkan tenaga ahli |  | A | C | C | C |  | R |
| 6 | Membuat dan memperbarui CV dan data POC |  | I | A | I | R |  | C |
| 7 | Memvalidasi kelengkapan dan versi CV |  | I | A, R | C | C |  | C |
| 8 | Menyusun dokumen tender, POC, dan materi KOM |  | C | C | A, R | C |  |  |
| 9 | Menyiapkan NDA dan permintaan akses VPN |  | I | A | I | R | C |  |
| 10 | Menyusun dan mendistribusikan MoM |  | I | A | I | R |  |  |
| 11 | Mengelola hak akses, backup, dan retensi repositori |  | A | C | I |  | R |  |
| 12 | Monitoring kualitas data talent |  | I | A | C | I | R | R |
| 13 | Menyampaikan feedback hasil tender ke Delivery |  | I | I | A, R | I |  | I |
| 14 | Eskalasi isu data lintas departemen | A | R | C | R |  | C | C |

*Keterangan: R = Responsible, A = Accountable, C = Consulted, I = Informed; sel kosong berarti tidak terlibat. Aktivitas 3, 4, 9, dan 13 serta kolom KDT merupakan usulan kelompok.*

**Checklist validasi RACI** [@dama2017]**:**

- ☑ Setiap aktivitas memiliki tepat satu A.
- ☑ Setiap aktivitas memiliki minimal satu R.
- ☑ Keputusan kebijakan dan standar menempatkan A pada sponsor atau Data Owner.
- ☑ Pekerjaan teknis (hak akses, backup, monitoring sistem) menempatkan R pada Custodian.
- ☑ RACI disusun per aktivitas, bukan per peran.
- ☑ Jumlah C dan I dibatasi pada pihak yang relevan.
- ☐ Pemegang peran dikonfirmasi ke PM dan Presales.
- ☐ Pemegang peran Admin Repositori SharePoint ditetapkan.
- ☐ RACI ditinjau berkala, misalnya setiap semester.

# 4. Arsitektur Data

## 4a. Subject Area Model

Struktur data berikut adalah rancangan to-be kelompok untuk talent management, dengan subject area utama Talent, yang disusun dari inventaris informasi Delivery dan Presales [@dokumenkoma2025; @dokumenkomb2026; @cvkaryawan2026]. Saat ini data tersebut belum tersimpan dalam basis data: CV dan dokumen proyek berupa file di SharePoint, sedangkan permintaan dan usulan talent dipertukarkan lewat email dan pesan singkat (WhatsApp) dengan PM. Entitas dikelompokkan menjadi tiga area: data Departemen Presales, data Departemen Delivery, dan Shared Talent Master Data sebagai titik sambung. Pengelompokan ini menunjukkan siapa yang membuat data; secara arsitektur, subject area disusun berdasarkan konsep bisnis, bukan unit organisasi [@dama2017].

Tabel 7. **Entitas per area data**

| **Area** | **Entitas** | **Atribut utama** | **Kondisi as-is** |
| --- | --- | --- | --- |
| Presales | PELUANG_TENDER | peluang_id (PK), presales_pic_id (FK ke KARYAWAN), kode_klien, nama_peluang, tenggat, status (open, menang, kalah) | Belum tercatat terstruktur; informasi ada di email dan pesan singkat |
| Presales | PERMINTAAN_TALENT | permintaan_id (PK), peluang_id (FK), peran_dibutuhkan, jumlah, tenggat_permintaan | Disampaikan lewat pesan singkat ke PM |
| Presales | POC | poc_id (PK), peluang_id (FK), ringkasan_hasil, lokasi_file | Belum tercatat terstruktur; file hasil POC tersebar per peluang |
| Presales | DOKUMEN_TENDER | dok_tender_id (PK), peluang_id (FK), jenis, versi, klasifikasi | File per peluang |
| Presales | FEEDBACK_TENDER | feedback_id (PK), peluang_id (FK), hasil, catatan, tanggal | Belum ada |
| Shared Talent Master Data | KARYAWAN (master) | karyawan_id (PK), nama, jabatan, departemen, peran (PM, Presales, tenaga ahli), status_ketersediaan | Belum ada daftar induk; tidak ada HRIS |
| Shared Talent Master Data | USULAN_TALENT | usulan_id (PK), permintaan_id (FK), karyawan_id (FK), cv_id (FK), status_usulan | Daftar nama dikirim PM lewat pesan singkat |
| Delivery | CV | cv_id (PK), karyawan_id (FK), versi, tanggal_update, lokasi_file, status_aktif | File di penyimpanan pribadi dan SharePoint proyek |
| Delivery | PROYEK | proyek_id (PK), peluang_id (FK, opsional), pm_id (FK ke KARYAWAN), kode_klien, tanggal_KOM, status | Site SharePoint per proyek |
| Delivery | PENUGASAN | penugasan_id (PK), karyawan_id (FK), proyek_id (FK), peran_di_proyek, periode | Tercantum di struktur organisasi KOM |
| Delivery | DOKUMEN_PROYEK | dokumen_id (PK), proyek_id (FK), jenis (KOM, MoM, NDA, permintaan VPN, BAST), klasifikasi, lokasi_file | File di site SharePoint proyek |

**Titik sambung antara data Presales dan data Delivery:**

- KARYAWAN menjadi inti Shared Talent Master Data: tenaga ahli, PM, dan PIC Presales dicatat sekali dan dirujuk kedua departemen.
- USULAN_TALENT menghubungkan PERMINTAAN_TALENT (Presales) dengan KARYAWAN dan CV (Delivery). Entitas ini menggantikan daftar nama yang saat ini dikirim PM lewat pesan singkat.
- PELUANG_TENDER terhubung ke PROYEK: setiap peluang yang dimenangkan menjadi satu proyek, sehingga timeline, KOM, NDA, dan permintaan VPN dapat ditelusuri ke peluang asalnya.
- FEEDBACK_TENDER menyediakan alur balik dari Presales ke Delivery.

Tabel 8. **Relasi dan kardinalitas**

| **Relasi** | **Kardinalitas (min..max)** | **Crow's foot** | **Aturan bisnis** | **Lintas departemen** |
| --- | --- | --- | --- | --- |
| KARYAWAN memiliki CV | 1 ke 0..* | \|\| ke o< | Satu karyawan dapat memiliki banyak versi CV, tepat satu berstatus aktif; setiap CV milik tepat satu karyawan | Tidak |
| KARYAWAN ditugaskan pada PROYEK melalui PENUGASAN | 1 ke 0..* (KARYAWAN ke PENUGASAN); 1 ke 0..* (PROYEK ke PENUGASAN) | \|\| ke o< dan \|\| ke o< | Relasi banyak ke banyak antara karyawan dan proyek dipecah melalui PENUGASAN | Tidak |
| PROYEK memiliki DOKUMEN_PROYEK | 1 ke 0..* | \|\| ke o< | Setiap dokumen (KOM, MoM, NDA, permintaan VPN) milik tepat satu proyek | Tidak |
| KARYAWAN (PM) memimpin PROYEK | 1 ke 0..* | \|\| ke o< | Setiap proyek memiliki tepat satu PM | Tidak |
| KARYAWAN (PIC Presales) menangani PELUANG_TENDER | 1 ke 0..* | \|\| ke o< | Setiap peluang memiliki tepat satu PIC Presales | Ya |
| PELUANG_TENDER memiliki PERMINTAAN_TALENT | 1 ke 1..* | \|\| ke \|< | Setiap peluang minimal memiliki satu permintaan talent | Tidak |
| PERMINTAAN_TALENT dipenuhi oleh USULAN_TALENT | 1 ke 0..* | \|\| ke o< | Satu permintaan dapat dipenuhi beberapa usulan; permintaan boleh belum terpenuhi | Ya |
| KARYAWAN diusulkan dalam USULAN_TALENT | 1 ke 0..* | \|\| ke o< | Satu karyawan dapat diusulkan untuk banyak permintaan | Ya |
| CV dilampirkan pada USULAN_TALENT | 1 ke 0..* | \|\| ke o< | Setiap usulan merujuk tepat satu versi CV aktif | Ya |
| PELUANG_TENDER menjadi PROYEK | 1 ke 0..1 | \|\| ke o\| | Peluang yang kalah tidak memiliki proyek; peluang yang menang menjadi tepat satu proyek | Ya |
| PELUANG_TENDER memerlukan POC | 1 ke 0..* | \|\| ke o< | POC bersifat opsional per peluang | Tidak |
| PELUANG_TENDER menghasilkan DOKUMEN_TENDER | 1 ke 0..* | \|\| ke o< | Setiap dokumen tender milik tepat satu peluang | Tidak |
| PELUANG_TENDER menghasilkan FEEDBACK_TENDER | 1 ke 0..* | \|\| ke o< | Feedback dikirim ke Delivery setelah hasil tender diketahui | Ya |

*Keterangan notasi: min..max pada ujung entitas kedua (1 = tepat satu, 0..1 = nol atau satu, 0..\* = nol atau banyak, 1..\* = satu atau banyak)* [@dama2017]*. Padanan crow's foot: || tepat satu, o| nol atau satu, o< nol atau banyak, |< satu atau banyak.*

Gambar 3. EERD **talent management antara Departemen Presales dan Departemen Delivery (notasi UML)**

*Keterangan: kotak entitas memuat atribut dengan {PK} kunci primer, {FK} kunci asing, dan \[1..\*] atau \[0..\*] atribut multivalued. Angka di ujung garis adalah multiplicity (1..1, 0..1, 0..\*, 1..\*). Garis oranye menandai relasi lintas departemen yang menjadi titik sambung Presales dan Delivery. Segitiga kosong menandai spesialisasi: KARYAWAN dispesialisasi menjadi PRESALES\_PIC, TENAGA\_AHLI, dan PROJECT\_MANAGER dengan constraint {Optional, And}, yaitu karyawan boleh tidak memegang peran tersebut dan boleh memegang lebih dari satu peran; DOKUMEN\_PROYEK dispesialisasi menjadi NDA, PERMINTAAN\_VPN, MOM, dan MATERI\_KOM dengan constraint {Mandatory, Or}, yaitu setiap dokumen proyek tepat satu jenis. Relasi pada tabel relasi dan kardinalitas yang merujuk KARYAWAN dirinci ke subclass yang sesuai. Sumber: rancangan kelompok berdasarkan Dokumen KOM Proyek A [-@dokumenkoma2025], Dokumen KOM Proyek B [-@dokumenkomb2026], dan CV karyawan MII [-@cvkaryawan2026].*

## 4b. CRUD Mapping antara Unit Organisasi dan Informasi

Matriks CRUD memetakan hak setiap peran terhadap entitas data: C (create), R (read), U (update), dan D (delete). Pemetaan diturunkan dari peran dan RACI pada bab Tata Kelola Data, sehingga setiap entitas memiliki satu peran pembuat utama dan hak hapus dibatasi pada pemilik proses atau custodian sesuai kebijakan retensi [@dama2017].

**Tabel 9. Matriks CRUD peran terhadap entitas data talent management**

| **Entitas** | **Tenaga Ahli Delivery** | **Project Manager (Steward)** | **Koordinator Data Talent** | **Presales PIC** | **Division Manager Delivery (Owner)** | **Admin Repositori SharePoint (Custodian)** |
| --- | --- | --- | --- | --- | --- | --- |
| PELUANG_TENDER |  | R | R | CRUD | R |  |
| PERMINTAAN_TALENT | R | R | RU | CRUD | R |  |
| POC | CRU | R |  | CRUD | R |  |
| DOKUMEN_TENDER |  | R |  | CRUD | R |  |
| FEEDBACK_TENDER | R | R | R | CRU | R |  |
| KARYAWAN dan subclass | R | R | CRU | R | R | R |
| USULAN_TALENT | R | CRU | CRU | RU | R |  |
| CV | CRU | RU | RUD | R | R |  |
| PROYEK | R | CRU | R | R | R |  |
| PENUGASAN | R | CRUD | R | R | R |  |
| DOKUMEN_PROYEK dan subclass (NDA, PERMINTAAN_VPN, MOM, MATERI_KOM) | CR | CRUD |  | CR | R | D (retensi) |

*Keterangan: sel kosong berarti peran tidak memiliki akses ke entitas tersebut. Hak D pada CV oleh Koordinator Data Talent terbatas pada pengarsipan versi lama, dan hak D pada dokumen proyek oleh Admin Repositori SharePoint terbatas pada penghapusan sesuai masa retensi. Sumber: rancangan kelompok berdasarkan Dokumen KOM Proyek A [-@dokumenkoma2025] dan Dokumen KOM Proyek B [-@dokumenkomb2026].*

## 4c. Kamus Data

Kamus data mendefinisikan elemen data utama setiap entitas beserta tipe data, constraint, aturan bisnis, dan klasifikasinya. Klasifikasi mengikuti empat tingkat pada standar klasifikasi yang diusulkan, yaitu Publik, Internal, Rahasia, dan Data Pribadi, dengan kategori Data Pribadi mengacu pada UU No. 27 Tahun 2022 [@republikindonesia2022].

**Tabel 10. Kamus data talent management**

| **Entitas** | **Elemen data** | **Tipe data** | **Constraint** | **Business rule** | **Klasifikasi** |
| --- | --- | --- | --- | --- | --- |
| KARYAWAN | karyawan_id | VARCHAR(12) | PK, NOT NULL | ID unik karyawan; dirujuk oleh semua entitas talent | Internal |
| KARYAWAN | nama | VARCHAR(100) | NOT NULL | Ditulis sesuai identitas resmi karyawan | Data Pribadi |
| KARYAWAN | jabatan | VARCHAR(60) | NOT NULL | Mengacu glosarium peran yang seragam lintas proyek | Internal |
| KARYAWAN | departemen | ENUM | NOT NULL; Delivery, Presales, Penjualan | Satu karyawan tercatat di satu departemen | Internal |
| KARYAWAN | status_ketersediaan | ENUM | NOT NULL; Tersedia, Ditugaskan, Cuti | Bernilai Ditugaskan bila ada PENUGASAN aktif | Internal |
| TENAGA_AHLI | keahlian | VARCHAR(60), multivalued | Minimal satu nilai | Mengacu glosarium keahlian | Internal |
| PROJECT_MANAGER | sertifikasi_pm | VARCHAR(60), multivalued | Boleh kosong | Sertifikasi yang masih berlaku | Internal |
| PRESALES_PIC | area_solusi | VARCHAR(60) | NOT NULL | Area solusi yang ditangani PIC | Internal |
| CV | cv_id | VARCHAR(15) | PK, NOT NULL | Satu baris per versi CV | Internal |
| CV | karyawan_id | VARCHAR(12) | FK ke KARYAWAN, NOT NULL | CV hanya dimiliki satu karyawan | Data Pribadi |
| CV | versi | INT | NOT NULL, lebih dari 0 | Naik satu angka setiap pembaruan | Internal |
| CV | tanggal_update | DATE | NOT NULL | Paling lambat 14 hari kerja setelah proyek selesai (usulan) | Internal |
| CV | lokasi_file | VARCHAR(255) | NOT NULL, URL | File disimpan di Talent Hub dengan format CV standar perusahaan | Data Pribadi |
| CV | status_aktif | BOOLEAN | NOT NULL | Hanya satu CV aktif per karyawan | Internal |
| PELUANG_TENDER | peluang_id | VARCHAR(15) | PK, NOT NULL | Satu baris per peluang atau tender | Internal |
| PELUANG_TENDER | kode_klien | VARCHAR(10) | NOT NULL | Kode samaran, bukan nama klien | Rahasia |
| PELUANG_TENDER | tenggat | DATE | NOT NULL | Batas pengajuan dokumen tender | Rahasia |
| PELUANG_TENDER | status | ENUM | NOT NULL; Open, Menang, Kalah | Status Menang memicu pembuatan PROYEK | Internal |
| PERMINTAAN_TALENT | peran_dibutuhkan | VARCHAR(60) | NOT NULL | Mengacu glosarium peran | Internal |
| PERMINTAAN_TALENT | jumlah | INT | NOT NULL, lebih dari 0 | Jumlah tenaga ahli per peran | Internal |
| PERMINTAAN_TALENT | tenggat_permintaan | DATE | NOT NULL | Tidak melewati tenggat peluang | Internal |
| USULAN_TALENT | usulan_id | VARCHAR(15) | PK; UNIQUE (permintaan_id, karyawan_id) | Satu karyawan diusulkan sekali per permintaan | Internal |
| USULAN_TALENT | cv_id | VARCHAR(15) | FK ke CV, NOT NULL | CV yang dirujuk harus berstatus aktif | Data Pribadi |
| USULAN_TALENT | status_usulan | ENUM | NOT NULL; Diusulkan, Diterima, Ditolak | Diperbarui Presales setelah seleksi | Internal |
| POC | ringkasan_hasil | TEXT | NOT NULL | Ringkasan teknis hasil POC | Rahasia |
| DOKUMEN_TENDER | klasifikasi | ENUM | NOT NULL; Publik, Internal, Rahasia, Data Pribadi | Menentukan hak akses dokumen | Internal |
| FEEDBACK_TENDER | hasil | ENUM | NOT NULL; Menang, Kalah, Batal | Diisi setelah hasil tender diumumkan | Internal |
| PROYEK | peluang_id | VARCHAR(15) | FK ke PELUANG_TENDER, UNIQUE, boleh kosong | Satu peluang menang menjadi satu proyek | Internal |
| PROYEK | pm_id | VARCHAR(12) | FK ke KARYAWAN, NOT NULL | Karyawan yang dirujuk berperan Project Manager | Internal |
| PENUGASAN | periode | DATE (tanggal_mulai, tanggal_selesai) | NOT NULL; tanggal_selesai tidak sebelum tanggal_mulai | Menjadi dasar status_ketersediaan | Internal |
| DOKUMEN_PROYEK | jenis | ENUM | NOT NULL; NDA, PERMINTAAN_VPN, MOM, MATERI_KOM | Setiap dokumen tepat satu jenis | Internal |
| NDA | masa_berlaku | DATE | NOT NULL, tidak sebelum tanggal_ttd | NDA wajib ada sebelum akses ke sistem klien | Rahasia |
| PERMINTAAN_VPN | status_akses | ENUM | NOT NULL; Diajukan, Disetujui, Ditolak, Dicabut | Dicabut saat penugasan berakhir | Rahasia |
| MOM | peserta | TEXT | NOT NULL | Memuat nama peserta rapat | Data Pribadi |

*Sumber: rancangan kelompok berdasarkan Dokumen KOM Proyek A [-@dokumenkoma2025], Dokumen KOM Proyek B [-@dokumenkomb2026], CV karyawan MII [-@cvkaryawan2026], dan UU No. 27 Tahun 2022.*

# 5. Integrasi Data

Integrasi data dianalisis pada pertukaran informasi talent dan dokumen proyek antar Departemen Presales dan Departemen Delivery, serta antara MII dan klien. Analisis mencakup entitas yang berinteraksi dengan data, environment yang dipakai, alur pertukaran, mekanisme teknis, dan tools, mengikuti Knowledge Area Data Integration and Interoperability [@dama2017].

## 5a. Integrasi Data As-Is

**Gambar 4. Arsitektur integrasi data as-is pertukaran informasi talent (diolah dari Dokumen KOM Proyek A, 2025; Dokumen KOM Proyek B, 2026)**

Gambar 4 menunjukkan bahwa saat ini tidak ada sistem yang saling terhubung. Informasi talent berpindah secara point-to-point dan manual, dengan Project Manager sebagai penghubung tunggal antara Presales dan tenaga ahli Delivery.

**Entitas:**

- Presales PIC sebagai pengguna informasi talent, Project Manager sebagai penghubung, tenaga ahli Delivery sebagai pemilik CV dan data teknis, serta klien sebagai penerima dokumen tender dan dokumen proyek.

**Environment:**

- Email (Outlook) dan WhatsApp sebagai media pertukaran; site SharePoint per proyek pada Microsoft 365 dengan akses terbatas pada anggota proyek; penyimpanan pribadi tenaga ahli untuk CV versi terbaru.

**Alur pertukaran:**

- Alur 1 sampai 4: Presales menyampaikan kebutuhan talent kepada PM, PM meminta CV kepada setiap tenaga ahli, tenaga ahli mengirim CV dari penyimpanan pribadi, lalu PM meneruskan shortlist dan CV kepada Presales.
- Alur 5 sampai 7: Presales mengirim dokumen tender, POC, dan materi KOM kepada klien; tenaga ahli dan PM mengirim NDA, permintaan akses VPN, dan MoM; komunikasi timeline proyek mengalir antar-PM sesuai rencana komunikasi proyek [@dokumenkomb2026].

**Teknis dan tools:**

- Integrasi berupa pertukaran file manual melalui lampiran email dan pesan singkat, tanpa API, sinkronisasi, maupun metadata bersama. Akibatnya terjadi duplikasi versi CV antar site proyek, data pribadi beredar tanpa klasifikasi, dan tidak ada jejak audit atas permintaan maupun pemenuhan talent.

## 5b. Integrasi Data To-Be

**Gambar 5. Arsitektur integrasi data to-be berbasis Talent Hub pada Microsoft 365 (rancangan kelompok)**

Rancangan to-be mengganti pola point-to-point dengan pola hub-and-spoke. Talent Hub, yaitu site SharePoint Online khusus pada lingkungan Microsoft 365 yang sudah dipakai MII, menjadi single source of truth untuk Shared Talent Master Data, sedangkan departemen dan site proyek menjadi spoke yang membaca atau menulis data melalui hub. Pola hub-and-spoke dipilih karena mengurangi jumlah koneksi antar pihak dan memusatkan kendali kualitas serta keamanan data [@dama2017]. Komponen teknis yang digunakan, yaitu SharePoint Online, Power Automate, dan label sensitivitas Microsoft Purview, mengacu pada dokumentasi resmi Microsoft [@microsoft2026a; @microsoft2026b; @microsoft2026c].

**Tabel 11. Alur integrasi data to-be**

| **No** | **Alur** | **Mekanisme teknis** | **Tools** |
| --- | --- | --- | --- |
| 1 | Presales mengajukan permintaan talent untuk peluang tender | Formulir menulis item baru ke list PERMINTAAN_TALENT dengan tenggat dan peran yang dibutuhkan | Power Apps atau Microsoft Forms, SharePoint list |
| 2 | Koordinator Data Talent mencari dan mengusulkan talent | Notifikasi otomatis saat permintaan masuk; pencarian KARYAWAN berdasarkan keahlian dan status ketersediaan; usulan ditulis ke list USULAN_TALENT dengan rujukan CV aktif | Power Automate, SharePoint list dan library |
| 3 | Tenaga ahli memperbarui CV | Unggah CV ke library CV dengan format standar; versioning otomatis; pengingat pembaruan setelah penugasan selesai | SharePoint library versioning, Power Automate |
| 4 | PM memvalidasi CV dan mencatat penugasan | Persetujuan validasi CV; pencatatan PENUGASAN yang memperbarui status ketersediaan karyawan | Power Automate approval, SharePoint list |
| 5 | Data dikonsumsi site proyek, dashboard, dan notifikasi | Site proyek menautkan dokumen dari Talent Hub, bukan menyalin; dashboard membaca list; notifikasi status dikirim otomatis | SharePoint, Power BI, Microsoft Teams dan Outlook |
| 6 | Presales menerima usulan dan mengirim feedback hasil tender | Status usulan diperbarui; hasil tender ditulis ke FEEDBACK_TENDER sebagai alur balik ke Delivery | SharePoint list, Power Automate |

**Keamanan dan kepatuhan:**

- Akses diatur melalui security group Microsoft Entra ID sesuai peran pada matriks CRUD, dengan prinsip least privilege.
- Dokumen diberi label sensitivitas (Publik, Internal, Rahasia, Data Pribadi) dan kebijakan retensi melalui Microsoft Purview; berbagi ke klien menggunakan tautan terkendali, bukan lampiran email.
- Pemrosesan data pribadi tenaga ahli dan data klien dilandasi NDA serta perjanjian pemrosesan data dengan klien sebagai pemilik data pribadi, sesuai UU No. 27 Tahun 2022 [@republikindonesia2022].

**Asumsi implementasi:**

- Rancangan memanfaatkan Microsoft 365 yang sudah dipakai MII. Ketersediaan Power Apps, Power Automate, Power BI, dan Microsoft Purview bergantung pada lisensi MII; bila belum tersedia, alur yang sama tetap dapat dijalankan secara manual melalui SharePoint list dan library di Talent Hub.

# 6. Referensi

::: {#refs}
:::

*Catatan: dokumen internal disamarkan sesuai kewajiban NDA. Nama klien diganti menjadi Klien A (BUMN sektor energi) dan Klien B (perbankan), sedangkan nama, nomor telepon, dan alamat email personel tidak dicantumkan.*
