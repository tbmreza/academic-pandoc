# **SYSTEM REQUEST**

|  |  |
| --- | --- |
| **Project Sponsor** | Ekonaldi Hutabarat — Technical Lead proyek Platform Integrasi dan API Management, PT Mitra Integrasi Informatika (PT MII) |
| **Target Organization** | Klien PT Mitra Integrasi Informatika yaitu organisasi enterprise berskala besar pengguna Platform Integrasi dan API Management. Identitas, sektor industri, serta seluruh atribut yang dapat mengidentifikasi organisasi tersebut disamarkan sesuai ketentuan Perjanjian Kerahasiaan (NDA) dan selanjutnya disebut "Klien". |
| **Prepared by** | Sarah H M Siahaan (NPM 2606846241) |
| **Document Classification** | Internal — PT Mitra Integrasi Informatika (identitas Klien disamarkan sesuai NDA) |

# **1. Project Sponsor**

*Figure 1 Identitas Project Sponsor*

Proyek ini disponsori oleh Ekonaldi Hutabarat, Technical Lead pada proyek Platform Integrasi dan API Management yang dikerjakan PT Mitra Integrasi Informatika (MII) untuk Klien. Sebagaimana disampaikan pada wawancara (Appendix B — Transkrip Wawancara), beliau memimpin sisi teknis proyek yang mencakup arsitektur sistem, pembagian kerja tim developer, dan keputusan atas teknologi yang digunakan. Setiap usulan perubahan maupun penambahan tooling pada lingkungan pengembangan harus melalui persetujuan beliau sebelum diteruskan ke manajemen MII dan ke Klien, sehingga beliau memiliki otoritas yang relevan untuk menyetujui adopsi teknologi baru guna mengatasi bottleneck pada fase pengujian (testing) dan peluncuran (deployment).

# **2. Business Needs**

Inisiasi proyek ini didorong oleh kebutuhan mendesak untuk mengatasi bottleneck kritis dalam siklus pengembangan perangkat lunak (Software Development Life Cycle/SDLC) di lingkungan Klien. Saat ini terdapat ketidaksesuaian arsitektur antara Lower Environment (Development/Testing) dan Production Environment, di mana infrastruktur Dev/Test tidak memiliki rasio spesifikasi dan beban kerja 1:1 terhadap Production.

Hasil wawancara dengan sponsor mengungkap tiga faktor operasional yang memperburuk kondisi tersebut.

- **Environment testing belum siap:** tanggung jawab penyiapan terbagi dua — konfigurasi (setup) environment dilakukan oleh MII sebagai vendor, sedangkan penyediaan infrastruktur servernya berada pada Klien. Ketika server belum tersedia, tim vendor tidak dapat melakukan apa pun selain menunggu dan mengingatkan Klien, sementara jadwal proyek tidak ikut bergeser. Akibatnya pengujian tetap dijalankan pada environment Development meskipun kode masih berubah-ubah dan belum menggambarkan perilaku sistem yang sesungguhnya diterima pengguna.
- **Keterbatasan sumber daya manusia:** tim proyek terdiri atas tiga developer dengan hanya satu personel Quality Assurance, sementara fase development terus berjalan bersamaan dengan pengujian.
- **Keterbatasan ketersediaan pengguna Klien:** pengguna dari sisi Klien tidak selalu dapat hadir mengikuti sesi pengujian, sehingga verifikasi tertunda.

Sponsor menegaskan bahwa idealnya pengujian memiliki environment tersendiri agar basis kode yang diuji stabil dan skenario pengujian dapat dirinci, berbeda dengan kondisi saat ini ketika pengembangan dan pengujian berbagi satu environment.

Secara teknis, kondisi environment dan anomali yang terjadi dapat diuraikan sebagai berikut.

- **Arsitektur Production:** environment Production Klien terdiri atas beberapa node yang berada di belakang sebuah Load Balancer dengan pembagian transaksi 50:50.
- **Gejala anomali:** secara fungsional layanan telah dinyatakan normal pada pengujian di environment Development, namun pada Production — ketika volume transaksi meningkat di atas kondisi biasanya — CPU pada salah satu node mengalami spike sehingga transaksi yang diarahkan ke node tersebut tidak diproses dan berakhir timeout, sementara node lain tetap melayani secara normal.
- **Kebutuhan pengujian:** tipe request yang masuk ke kedua node pada dasarnya sama, sehingga tim perlu menguji ketahanan node dan perilaku pembagian trafik oleh Load Balancer untuk mengetahui penyebabnya.
- **Kendala di Production:** pengujian semacam itu tidak dapat dilakukan secara masif di Production.
- **Kendala di lower environment:** meskipun kode di Development identik dengan Production, Development hanya memiliki satu node dengan kapasitas lebih kecil sehingga skenario spike maupun distribusi trafik antar-node tidak mungkin dibentuk.

Dengan demikian, isu bersifat fungsional dan logika program masih dapat ditemukan pada environment Development, tetapi isu yang bergantung pada kapasitas dan jumlah node tidak.

Akibatnya, masalah krusial seperti anomali performa (CPU spike) dan request timeout tidak dapat direplikasi pada fase Testing. Timeline proyek kerap mundur karena tim Quality Assurance (QA) harus melakukan re-test, sementara tim Developer terpaksa menghentikan pengembangan fitur baru untuk memperbaiki bug yang baru teridentifikasi setelah rilis ke Production.

Sponsor menyatakan bahwa isu terakhir memang sudah tidak berulang, namun penanganannya masih berupa solusi jangka pendek dan tim tetap membutuhkan solusi jangka panjang; karena layanan terus diperbarui, masalah serupa yang belum pernah ditemui tetap berpeluang muncul di Production.

Ditinjau dari sisi analisis penulis, solusi tradisional atas persoalan ini — pengadaan dan peningkatan kapasitas server agar environment Dev/Test setara dengan Production — memiliki tiga keterbatasan:

- **Ketergantungan pada Klien:** pelaksanaannya bergantung pada penyediaan infrastruktur oleh Klien.
- **Beban belanja modal:** menuntut belanja modal (Capital Expenditure) untuk perangkat dan lisensi yang hanya dipakai bagi keperluan pengujian.
- **Waktu pengadaan:** membutuhkan waktu pengadaan yang tidak sejalan dengan timeline proyek yang terus berjalan.

# **3. Business Requirements**

Sistem yang diusulkan adalah AI-Powered Digital Twin for Environment Simulation. Sistem ini tidak menggantikan aplikasi manajemen API yang telah berjalan, melainkan berfungsi sebagai layer simulasi cerdas pada lingkungan pengujian (testing environment).

## **3.1 Fungsionalitas Utama**

- **Data Ingestion & Baseline Profiling:** sistem mampu menarik dan memproses metrik operasional, log, serta distributed traces secara real-time dari observability stack yang digunakan pada Production environment.
- **Traffic & Behavior Replication:** sistem mampu mereplikasi pola interaksi microservice, memodelkan latensi jaringan, dan menyimulasikan beban kerja (workload) secara dinamis dari Production ke environment pengujian.
- **Automated Environment Throttling:** pada saat pengujian beban (load/stress testing) dijalankan oleh tim Quality Assurance (QA) di environment Dev/Test, sistem secara cerdas membatasi (throttle) respons CPU atau memicu timeout sehingga menyerupai titik jenuh di Production.

## **3.2 Implementasi Emerging Technology (Artificial Intelligence)**

Sistem menyematkan teknologi Predictive Machine Learning (Time-Series Analysis) untuk mendeteksi pola anomali performa dari data historis log produksi. Model AI dilatih untuk memprediksi probabilitas terjadinya CPU spike berdasarkan struktur payload dan request rate dari API Gateway, kemudian memproyeksikan anomali tersebut ke dalam bentuk simulasi di lingkungan Testing.

# **4. Business Value**

Penerapan AI-Powered Digital Twin memberikan nilai tambah strategis yang signifikan bagi Klien dan MII, melampaui kemampuan solusi pengadaan infrastruktur tradisional.

## **4.1 Manfaat Terukur (Tangible)**

- **Cost Avoidance (Penekanan Biaya):** menghilangkan keharusan belanja modal (Capital Expenditure) untuk pengadaan dan pemeliharaan server fisik baru yang bertujuan menyetarakan spesifikasi environment Dev/Testing dengan Production pada rasio 1:1. Sebagai acuan proyeksi, studi Pandey dan Sharma mencatat peningkatan optimalisasi utilisasi sumber daya dari 70% menjadi 90% setelah penerapan Digital Twin pada infrastruktur TI perusahaan.
- **Efisiensi Resolusi Masalah (MTTR):** melalui simulasi anomali yang presisi sejak fase testing, waktu resolusi insiden dapat dipangkas secara signifikan. Pandey dan Sharma \[1] melaporkan penurunan issue resolution time dari rata-rata 4 jam menjadi 1 jam pasca-adopsi Digital Twin, sementara Wang et al. \[2] mencatat penurunan Mean Time To Resolution (MTTR) sebesar 84,2% dari 87,3 menit menjadi 13,8 menit melalui analitik observability berbasis Large Language Model pada arsitektur cloud-native. Kedua temuan tersebut menjadi dasar proyeksi manfaat efisiensi pada proyek ini, dan angka aktual akan divalidasi melalui pengukuran baseline pada lingkungan Klien.

## **4.2 Manfaat Tidak Terukur (Intangible)**

- **Mitigasi Risiko Kegagalan Produksi:** menghindari downtime layanan API di Production karena bottleneck performa telah terdeteksi dan diselesaikan pada fase pengujian (shift-left testing).
- **Peningkatan Produktivitas Tim:** menghilangkan context-switching bagi Developer yang sebelumnya sering terhenti proses pengembangannya karena harus melakukan perbaikan (fixing issue) atas temuan anomali yang lolos ke Production.
- **Peningkatan Kepercayaan Klien:** memperbaiki persepsi Klien atas kualitas rilis, karena setiap gangguan di Production selama ini terlihat sebagai masalah layanan Klien dan bukan sebagai konsekuensi keterbatasan environment pengujian, sekaligus mengurangi perbaikan pasca-rilis yang selalu dikerjakan di bawah tekanan waktu.

# **5. Special Issues**

## **5.1 Isu Keamanan Data dan Privasi**

Karena model Digital Twin “mempelajari” log dari Production, terdapat tiga hal yang wajib diperhatikan.

- **Risiko eksposur data:** potensi tereksposnya data sensitif pelanggan (Personally Identifiable Information/PII) maupun transaksi finansial.
- **Kewajiban mitigasi:** mekanisme Data Masking dan Encryption wajib diterapkan pada pipeline data sebelum memasuki engine machine learning guna memastikan kepatuhan terhadap Undang-Undang Pelindungan Data Pribadi (UU PDP).
- **Batasan kontraktual:** Perjanjian kerahasiaan (Non-Disclosure Agreement) antara MII dan Klien mensyaratkan tidak adanya data nyata yang keluar dari perimeter server internal.

## **5.2 Risiko dan Batasan (Constraints)**

Terdapat dua hal utama yang perlu diantisipasi.

- **Model Drift:** kondisi ketika arsitektur Production mengalami pembaruan (update) namun model AI belum dilatih ulang dengan data log terbaru sehingga hasil simulasi menjadi tidak akurat. Risiko ini sejalan dengan temuan tinjauan literatur sistematis Asim dan Ali \[3], yang mencatat bahwa celah utama pada penelitian simulasi arsitektur microservice justru terletak pada validasi terhadap kondisi dunia nyata serta kebutuhan kalibrasi runtime yang berkelanjutan.
- **Overhead komputasi:** keterbatasan kapasitas komputasi pada server pengujian untuk menjalankan engine Digital Twin secara bersamaan dengan aplikasi utama.

## **5.3 Faktor Penentu Keberhasilan (Critical Success Factors)**

Keberhasilan implementasi bergantung pada tiga faktor berikut.

- **Ketersediaan data:** data historis log yang bersih dan berkesinambungan dari observability datastore Klien.
- **Akurasi pemodelan:** pemetaan topologi microservices dan perilaku Load Balancer yang presisi.
- **Kolaborasi lintas tim:** kerja sama yang kuat antara tim QA, Developer, dan DevOps/SRE dalam mengalibrasi parameter simulasi agar tetap relevan dengan kondisi operasional dunia nyata.

# **6. Metode Pengumpulan Data dan Sumber Informasi**

Materi penyusunan System Request ini berasal dari dua sumber yang dipisahkan secara eksplisit:

- **Sumber primer**: wawancara langsung dengan project sponsor atas kondisi lapangan, dilaksanakan pada 8 September 2026 secara daring melalui Zoom dengan durasi 34 menit 35 detik. Daftar pertanyaan, transkrip lengkap, dan berkas rekaman disertakan sebagai lampiran.
- **Sumber sekunder**: kajian literatur akademis atas kelayakan teknologi dan tolok ukur manfaat.

Perlu dicatat bahwa wawancara hanya menggali akar masalah dan tidak membahas usulan solusi; usulan AI-Powered Digital Twin merupakan hasil kajian literatur dan desk research setelah wawancara.

## **6.1 Sumber Primer: Hasil Wawancara Project Sponsor**

- **Bottleneck fase pengujian:** fase paling memakan waktu adalah awal fase pengujian, ketika environment Testing belum selesai disiapkan sementara timeline proyek dan fase development terus berjalan.
- **Keterbatasan sumber daya:** tim terdiri atas tiga developer dan hanya satu personel Quality Assurance, serta pengguna dari sisi Klien tidak selalu dapat hadir mengikuti sesi pengujian.
- **Risiko pengujian pada environment Development:** kode masih berubah-ubah karena developer tetap melakukan update saat pengujian berlangsung, dan sebagian data masih berupa hasil mocking atau hardcode sehingga tidak menggambarkan data riil yang seharusnya diuji; idealnya pengujian memiliki environment tersendiri.
- **Pain point utama:** timeline mundur karena QA harus melakukan re-test dan Developer harus berhenti mengembangkan fitur untuk menangani perbaikan issue.
- **Anomali yang tidak dapat direplikasi:** Production terdiri atas beberapa node di belakang Load Balancer dengan pembagian transaksi 50:50; salah satu node mengalami CPU spike sehingga transaksi ke node tersebut timeout sementara node lain normal. Pengujian masif tidak dapat dilakukan di Production, dan di Development hanya tersedia satu node sehingga skenario spike maupun distribusi trafik tidak dapat dibentuk.
- **Status penyelesaian:** isu terakhir sudah tidak berulang, namun penanganannya masih berupa solusi jangka pendek; sponsor menyatakan tim tetap membutuhkan solusi jangka panjang karena layanan terus diperbarui sehingga masalah baru masih mungkin muncul di Production.
- **Kepemilikan environment:** setup environment dikerjakan MII sebagai vendor, sedangkan penyediaan infrastruktur server berada pada Klien; bila server belum tersedia, tim vendor hanya dapat menunggu sementara jadwal proyek tetap berjalan.
- **Cara insiden terdeteksi:** anomali baru diketahui setelah layanan berjalan di Production dan ditelusuri melalui tracing serta pengujian sederhana pada Production, bukan dari hasil pengujian sebelum rilis.
- **Cakupan isu yang lolos:** seluruh isu yang bergantung pada kapasitas dan jumlah node (CPU jenuh, timeout, perilaku pada trafik tinggi) tidak dapat diuji secara meyakinkan di lower environment, sedangkan bug logika program masih dapat ditemukan di environment Development.
- **Dampak pada Klien:** gangguan di Production terlihat oleh Klien sebagai persoalan kualitas layanan dan rilis, sehingga memengaruhi kepercayaan, dan setiap perbaikan pasca-rilis dikerjakan di bawah tekanan waktu.
- **Batasan data operasional:** data Production merupakan data riil milik Klien dan tidak dapat dibagikan karena keterikatan NDA; yang dimungkinkan adalah gambaran umum serta data pada environment Development yang bersifat dummy atau hasil mocking.
- **Indikator keberhasilan (rumusan penulis atas kondisi yang disampaikan sponsor):** isu performa seperti CPU spike dan timeout teridentifikasi sebelum rilis, jumlah temuan yang lolos ke Production menurun, waktu penyelesaian insiden lebih singkat, dan tersedianya solusi jangka panjang yang menggantikan penanganan jangka pendek saat ini.

## **6.2 Sumber Sekunder: Hasil Kajian Literatur**

Kajian literatur dilakukan atas tiga poin pencarian: (i) bukti akademis bahwa Digital Twin dapat menggantikan penyetaraan server fisik dan digunakan untuk simulasi infrastruktur maupun pengujian perangkat lunak; (ii) bukti bahwa Machine Learning atau AIOps mampu menganalisis data log untuk mendeteksi serta menelusuri anomali performa; serta (iii) sintesis akademis atas penggunaan simulasi untuk mendukung analisis performa dan pengambilan keputusan arsitektural pada sistem microservice.

- **Poin 1 — Digital Twin untuk infrastruktur TI dan pengujian (Pandey dan Sharma** \[1]**):** penerapan Digital Twin pada infrastruktur TI perusahaan menurunkan downtime bulanan dari 15 jam menjadi 3 jam, memangkas issue resolution time dari 4 jam menjadi 1 jam, serta meningkatkan optimalisasi utilisasi sumber daya dari 70% menjadi 90%. Temuan ini menjadi dasar argumen Business Value pada Bagian 4.
- **Poin 2a — Observability berbasis LLM untuk root cause analysis (Wang et al. \[2]):** kerangka kerja yang memadukan telemetri OpenTelemetry (metrik, log, dan trace) dengan LLM yang di-fine-tune menurunkan MTTR sebesar 84,2% dibandingkan metode berbasis aturan, mencapai F1-score 0,95 dalam deteksi anomali, dan menyelesaikan 91% insiden tanpa intervensi manusia. Temuan ini mendukung rancangan fungsi Data Ingestion dan Baseline Profiling pada Bagian 3.1.
- **Poin 2b — Root cause analysis spekulatif pada microservice (Zhang et al. \[4]):** kerangka SpecRCA dengan paradigma hypothesize-then-verify mempercepat dan meningkatkan akurasi penelusuran akar masalah pada sistem microservice, diuji pada dataset AIOps 2022. Temuan ini mendukung pemetaan topologi microservices sebagai faktor penentu keberhasilan pada Bagian 5.3.
- **Poin 3 — Simulasi sebagai pendukung arsitektur microservice (Asim dan Ali \[3]):** tinjauan literatur sistematis (Systematic Literature Review) atas 68 studi primer dari empat basis data ilmiah menunjukkan bahwa simulasi telah mapan digunakan untuk analisis performa, pengambilan keputusan arsitektural, dan analisis perilaku sistem pada arsitektur microservice termasuk sebagai alternatif yang lebih murah daripada menggelar dan memantau aplikasi secara nyata. Tinjauan tersebut juga mengidentifikasi celah pada validasi dunia nyata serta kebutuhan kerangka simulasi yang adaptif dengan kalibrasi runtime. Temuan ini memperkuat kelayakan pendekatan simulasi pada Bagian 3 sekaligus menjadi dasar akademis atas risiko Model Drift pada Bagian 5.2.

# **7. Daftar Referensi**

\[1] D. Pandey and D. Sharma, “Solving IT challenges with digital twins: A simplified approach for enhanced efficiency,” in Proc. 4th Int. Conf. Sentiment Analysis and Deep Learning (ICSADL), 2025, pp. 398–404, doi: 10.1109/ICSADL65848.2025.10933077.

\[2] C. Wang, T. Yuan, C. Hua, L. Chang, X. Yang, and Z. Qiu, “Integrating large language models with cloud-native observability for automated root cause analysis and remediation,” in Proc. 3rd Int. Conf. Artificial Intelligence, Systems and Network Security (AISNS), Xiangtan, China, 2025, pp. 327–333, doi: 10.1145/3797161.3797213.

\[3] A. Asim and N. Ali, “Simulation approaches for supporting microservice architectures: A systematic review,” ACM Trans. Softw. Eng. Methodol., 2026, doi: 10.1145/3816152.

\[4] L. Zhang, T. Jia, Y. Zhai, L. Pan, C. Duan, M. He, P. Xiao, and Y. Li, “Hypothesize-then-verify: Speculative root cause analysis for microservices with pathwise parallelism,” in Proc. 48th IEEE/ACM Int. Conf. Software Engineering – New Ideas and Emerging Results (ICSE-NIER), Rio de Janeiro, Brazil, 2026, doi: 10.1145/3786582.3786803.

# **Lampiran (Appendices)**

Bagian ini memuat bukti pendukung penyusunan System Request sesuai ketentuan tugas: daftar pertanyaan wawancara (Appendix A), transkrip lengkap hasil wawancara (Appendix B), dan tautan berkas rekaman (Appendix C). Identitas organisasi Klien disamarkan sesuai ketentuan Perjanjian Kerahasiaan (NDA).

## **Appendix A:  Daftar Pertanyaan Wawancara**

Daftar pertanyaan berikut disusun sebelum sesi perekaman dan dikirimkan kepada narasumber. Fokus wawancara dibatasi pada penggalian akar masalah; usulan solusi tidak dibahas dalam sesi ini.

1. Boleh dijelaskan peran dan kewenangan Bapak di proyek Platform Integrasi dan API Management, serta gambaran high level proyek tersebut?
2. Sepanjang siklus proyek berjalan, fase mana yang paling memakan waktu dan paling banyak ditemukan bottleneck?
3. Environment testing tersebut disiapkan oleh pihak vendor atau pihak Klien, dan berapa lama prosesnya?
4. Selain environment yang belum siap, faktor apa lagi yang memperparah kondisi pada fase tersebut?
5. Pada akhirnya pengujian dijalankan di environment mana?
6. Apa risiko teknis dan operasional apabila pengujian dilakukan pada environment Development?
7. Boleh diceritakan detail insiden di Production — apa yang terjadi, bagaimana ditelusuri, dan mengapa tidak tertangkap pada fase pengujian?
8. Apakah isu tersebut sudah diselesaikan secara permanen, atau tim masih bekerja dengan risiko yang sama?
9. Bagaimana status dan batasan data operasional Production (log, metrik, trace) — apakah dapat dilampirkan sebagai bukti tugas?
10. Apakah kondisi di Production saat ini sudah berjalan sebagaimana mestinya?

Catatan protokol: pada awal sesi narasumber dimintai persetujuan atas perekaman percakapan, batasan kerahasiaan informasi Klien, serta pencantuman identitas dan perannya sebagai project sponsor dalam dokumen tugas ini. Seluruh persetujuan tersebut terekam pada transkrip di Appendix B.

## **Appendix B :  Transkrip Wawancara**

**Nama Pewawancara: Sarah H M Siahaan**

**Narasumber / Project Sponsor: Ekonaldi Hutabarat (Technical Lead, PT Mitra Integrasi Informatika)**

**Tanggal: 08 September 2026**

**Durasi: 34 menit 35 detik**

**Metode:** Wawancara Online via Zoom

**\[MULAI TRANSKRIP]**

Sarah: Halo-halo, Pak Eko. Apakah suara saya sudah terdengar?

Ekonaldi: Halo. Iya, cukup jelas. Ya, kedengaran.

Sarah: Pertama-tama selamat malam ya, Pak. Mohon maaf mengganggu waktunya dan terima kasih juga sudah meluangkan waktunya untuk saya wawancarai pada sesi ini. Seperti yang sudah pernah saya sampaikan sebelumnya di kantor, bahwa saya sedang melanjutkan pendidikan magister Teknologi Informasi di UI dan saat ini saya sedang ada tugas dalam mata kuliah AKPSI. Di sini saya sedang mencari dan menggali problem atau isu yang pernah ditemukan oleh Pak Ekonaldi, khususnya di project Klien yang kemarin saya sempat join sebagai Quality Assurance. Namun saat ini saya sudah di-assign di project lain. Terima kasih ya, Pak, untuk ketersediaannya.

Ekonaldi: Oke. Ini berarti untuk tugas kuliah magister ya?

Sarah: Iya, betul, Pak. Untuk informasi juga, saat ini saya sedang melakukan fase gathering requirement, jadi keluaran pada wawancara kali ini kita hanya mendefinisikan problem-nya. Ini untuk memberi bayangan ke Pak Eko bahwa belum ada solusi, kita masih benar-benar requirement gathering. Namun pada tugas ini, saya sedang membuat dokumen System Request. Boleh kita mulai aja ya, Pak?

Ekonaldi: Ya, boleh, boleh. Silakan, silakan.

Ekonaldi: Eh, mungkin sebelum saya mau nanya, sebelum ini. Berarti nanti topiknya akan mengenai project yang pernah kita kerjakan di Klien gitu ya?

Sarah: Iya, betul, Pak. Apakah ada concern semisal, Pak, terkait kerahasiaan informasi dan lain-lain seperti itu yang perlu saya jaga kerahasiaannya selama saya sedang melakukan riset ini, Pak?

Ekonaldi: Eh, kemungkinan nanti kalau misalnya di tugasmu ini membutuhkan data-data tertentu dari Klien, kemungkinan datanya akan susah. Tapi jika hanya untuk, eh, misal untuk studi case aja, mungkin bisa kita bawa yang ada di Klien. Tapi mungkin untuk data-data tertentu nantinya kita nggak bisa share untuk tugas seperti ini. Tapi nggak apa-apa dilanjut dulu aja, nanti mana yang nggak harusnya nanti bisa kita filter.

Sarah: Oke, terima kasih, Pak, untuk kesediaannya. Eh, mungkin saya juga izin untuk percakapan ini saya record ya, Pak. Karena dalam tugas ini kita ada kewajiban untuk men-deliver evidence seperti bentuk recording seperti ini, Pak, sebagai bukti bahwa masalah ini benar adanya dan saya benar-benar melakukan penggalian root cause-nya seperti apa dari problem yang kita akan temukan ini. Seperti itu, Pak.

Ekonaldi: Oke, oke. Silakan, silakan.

Sarah: Mungkin pertama-tama, saya boleh mohon dijelaskan Pak Ekonaldi peran dan kewenangannya di project Klien ini dan mungkin boleh disebutkan juga ini project seperti apa kemarin? Dijelaskan secara high level saja, secara singkat saja sebagai pengantar.

Ekonaldi: Oh ya. Eh, ya di project ini, di Klien, posisi saya kebetulan sebagai Technical Lead eh, di pengembangan platform integrasi dan API management. Jadi di tim ini saya yang nge-lead beberapa ada beberapa tim. Ada tiga developer dan kemarin sama Sarah juga ya yang sebagai tim tester-nya. Jadi saya bertanggung jawab untuk ngambil keputusan di project, misalnya di bagian pengembangan arsitektur, pengembangan kerja tim, sama termasuk juga untuk eh, keputusan-keputusan yang eh, teknologi apa yang akan kita gunakan gitu. Jadi biasanya diskusi seperti ini nanti itu melalui saya dulu, baru nanti kita diskusikan bersama klien.

Sarah: Oke, baik. Terima kasih, Pak Ekonaldi. Nah, dari kacamata Pak Eko nih sebagai Technical Lead di project kita kemarin, di sepanjang siklus project kita berjalan, eh di fase mana yang kira-kira paling memakan waktu atau paling banyak ditemukan bottleneck seperti itu, Pak?

Ekonaldi: Paling banyak memakan waktu ya, itu yang pasti sebenarnya, ya. Eh, selain di... itu sudah hampir pasti yang paling banyak memakan waktu itu di fase-fase awal, eh terdiri dari fase pengujian. Ini biasanya, eh, bisa memakan waktu lebih banyak dari yang kita set dari awal. Jadi, eh kalau contoh yang terakhir ya di Klien itu, itu di awal kita sudah nge-set timeline, eh tetapi timeline-nya bergeser karena ada beberapa hal, ee... masalah seperti eh, environment testing yang belum belum tersedia. Ee... tetapi kan timeline-nya berjalan terus. Eh, tetapi untuk testing-nya kita nggak bisa eh, mulai gitu. Jadi fase testing-nya menjadi salah satu yang paling banyak makan waktu, sih, sebenarnya.

Sarah: Kemarin pun saya ada pengalaman sih ya, Pak, waktu proses testing. Saya sudah ready untuk melakukan testing, tapi proses testing-nya belum juga dimulai. Belum juga dimulai mungkin alasannya ternyata karena environment yang belum tersedia ya, Pak.

Ekonaldi: Ya, salah satunya environment ya, eh, terlepas di faktor lain, ya. Tapi ya faktor utamanya environment, eh yang perlu disediakan. Karena kita perlu environment itu untuk testing gitu.

Sarah: Eh, maaf Pak, sebelumnya environment testing ini yang mempersiapkan atau yang menyediakan itu dari sisi kita sebagai vendor atau dari sisi Klien ya, Pak?

Ekonaldi: Eh, sebenarnya environment ini secara teknikal itu ada di kita sebagai vendor ya yang nge-setup environment-nya, itu kita. Tetapi, tetapi tetap saja untuk penyediaan infrastrukturnya itu tetap dari klien. Jadi kalau infrastrukturnya belum ada, eh kita nggak ada nih yang mau disetup, misalnya kita butuh server dua atau tiga ya. Jadi kalau server-nya nggak ada, kita dari tim kita juga nggak bisa ngelakuin apa-apa selain meminta dari, menunggu dari klien gitu. Sebenarnya eh tanggung jawabnya jadi dua, sih, ya. Cuma ada dari sisi vendor buat setup, juga ada dari kliennya juga karena mereka harus menyediakan server juga gitu.

Sarah: Eh, kira-kira Pak, selain dari environment ini yang belum siap, apakah ada lagi hal-hal yang memperparah kondisi di fase tersebut seperti itu, Pak?

Ekonaldi: Eh, selain ini gambaran ya, kejadian di project Klien ya. Ini sebenarnya jarang-jarang kejadian di tempat lain. Cuma kemarin itu, sebenarnya selain ketersediaan environment juga, eh, ada, eh... beberapa faktor. Jadi setelah environment-nya ini jadi, kita juga masih dapat masalah. Misalnya, eh sumber daya manusianya juga terbatas. Saat itu kan QA-nya cuma satu ya, hanya Sarah aja. Sedangkan, eh, development kita ini kan masih sambil berjalan. Kemudian sambil testing jadi, karena keterbatasan eh sumber daya manusia, nah itu juga pengaruh, eh, terhadap waktu gitu. Kemudian dari sisi dari sisi eh klien ya, karena kan namanya testing kita harus melibatkan eh, user. Nah, user itu kan nggak eh... nggak selalu hadir lah istilahnya, ya. Enggak selalu hadir untuk mengikuti fase testing. Ini juga berpengaruh kepada timeline kita sendiri gitu.

Sarah: Oke. Eh, saya penasaran nih, Pak. Kemarin kan testing tetap berjalan ya, biarpun setelah menunggu beberapa lama, itu kemarin testing dilakukan di mana ya, Pak? Konteksnya environment-nya. Apakah disiapkan environment untuk testing kemarin?

Ekonaldi: Ya, benar. Kemarin kan eh, kita jadi bisa melakukan testing ah... sedikit lebih cepat lah ya dari ee keterlambatan yang sudah kejadian. Jadi sebenarnya buat ngejaga kemarin sambil menunggu environment testing-nya jadi, kita itu kan nge-testing di dev, development. Jadi kita di environment yang sama, kita melakukan developer juga di situ melakukan pengembangan, tester juga melakukan testing gitu.

Sarah: Berarti Pak, yang saya tangkap testing yang dilakukan kemarin tidak dilakukan di environment yang seharusnya, seperti itu ya Pak. Nah, eh, saya ingin bertanya nih Pak, eh, apa sih risikonya atau hal apa yang tidak baik yang seharusnya tidak terjadi jika testing dilakukan di environment development seperti itu, Pak?

Ekonaldi: Eh, risiko ya. Hmmm... sebenarnya tergantung eh, tergantung service-nya apa ya. Ada beberapa yang memang eh, tidak masalah di-lakukan testing di development. Tapi di case-case tertentu kita butuh, oh.. case-case tertentu risiko ini bisa jadi fatal eh, ketika environment development ini nggak sebanding eh, sebagaimana harusnya sistem berjalan. Misalnya, eh, untuk fase testing ya. Untuk fase testing itu eh sebaiknya kita kan punya environment sendiri buat testing. Supaya code-code nya itu lebih bersih, skenarionya bisa didetailin. Berbeda dengan kita ngetes terakhir ya, kita ngetesting di development, nge-testing juga di- nge-dev juga di development, jadi code-nya itu masih berubah-ubah. Kemungkinan tim tester bakal, eh... punya lebih banyak masalah ketika melakukan testing karena mungkin ketika development teman-teman masih ada update. Padahal lagi posisi dalam testing, jadi kemungkinan terganggu testing sangat memungkinkan. Kemudian dari sisi dari sisi eh code ya, dari sisi service-nya sendiri, eh development itu eh risikonya mungkin ada hal-hal yang eh, nggak ke-handle eh testing. Misalnya di development, bisa jadi datanya masih hasil mocking atau hasil hardcode ya, jadi nggak menggambarkan data riil yang seharusnya didapatkan tim tester gitu. Nah itu sih salah satu risikonya ya, data testing-nya jadi nggak se-riil itu dan potensinya bisa mengganggu teman-teman tester yang sedang testing.

Sarah: Oke. Berarti eh, yang saya tangkap ini seharusnya ada environment khusus di mana dilakukannya development dan ada environment khusus juga di mana testing akan dilakukan dengan ekspektasi eh testing yang dilakukan benar-benar menggambarkan yang seharusnya berjalan seperti di production, seperti itu ya, Pak. Harusnya memang eh secara, dan yang umumnya memang eh, sebaiknya kita itu punya minimal eh tiga environment, satu development, yang kedua testing, yang ketiga production. Tapi ini balik lagi ke kliennya. Ada beberapa klien memang punya keterbatasan untuk penyediaan server. Nah, biasanya eh, seperti kasus kemarin itu kan di project kita sebelumnya, karena mereka mungkin ya, keterbatasan server, ya jadinya ada dua, development dan production. Nah, tapi untuk ee... sebaiknya itu eh, harusnya punya satu environment lagi nih untuk testing. Supaya eh nanti code-code yang udah naik ke testing itu bisa lebih bersih, lebih nyata sebelum naik ke production. Ini juga nanti bisa membantu eh, menghindari eh, masalah-masalah yang akan terjadi di production gitu. Jadi sebaiknya ya, sebaiknya ada environment testing atau setidak-tidaknya eh core-core intinya yang di production itu ada satu banding satu dengan development gitu. Minimal kalau kalau dari saya itu menurut minimal itu ada tiga lah ya, tiga environment: Development, Testing, dan Production.

Sarah: Gini Pak, kemarin kan saya sebenarnya masih join ya di grup internal project itu. Kemarin kan sempat ada insiden ya, dan insiden ini juga cukup krusial karena terjadi di production. Boleh diceritain nggak, Pak, maksudnya gimana detail dari insiden atau isu kemarin, apa sih yang terjadi? Terus kemarin gimana cara men-define ternyata ada issue-nya seperti itu, Pak. Boleh diceritakan?

Ekonaldi: Oh ya, kemarin ada ini ya, yang sempat isu ya. Sebenarnya dibilang incident ya, bisa mengarah ke insiden sih, ya. Cuman kejadiannya itu kemarin, eh kita kan ngetesnya udah di dev, development, secara fungsi service ini berjalan dengan normal. Nah, tapi kan balik lagi, environment development ini dan production pasti jauh berbeda, secara infrastruktur juga berbeda, secara kapasitas server juga berbeda. Nah, kejadian kemarin, itu di production, eh ketika transaksi lagi berjalan, eh, kemungkinan mungkin ya ada di fase tertentu transaksi ini eh lebih banyak dari yang biasanya. Nah, salah satu, jadi di production itu ada beberapa node lah ya, mungkin node 1, node 2, node 3 mungkin. Jadi salah satu node ini, eh CPU-nya spike, jadi dia meningkat. Nah, ketika salah satu CPU-nya ini spike, jadi transaksi yang masuk ke eh, ke node yang CPU-nya sedang bermasalah itu jadi nggak diproses, jadi time out. Nah, di sisi lain, node yang lainnya itu normal, jadi transaksi yang masuk ke node eh yang satu lagi itu tetap berjalan normal. Artinya kan eh, kalau kita dari sisi itu kita ngecek nih tipe request yang masuk ke node yang bermasalah dan yang normal itu sama aja. Tapi kan kita perlu mengidentifikasi apa yang menyebabkan eh node, yang satu node ini eh, bisa jadi CPU-nya jadi spike gitu, jadi meningkat tiba-tiba. Nah, di production kan sebenarnya sebelum kedua node ini kan ada di depannya itu kan ada LB (Load Balancer) ya. Di depannya ada LB. LB ini nanti yang bertugas buat eh, ngebagi transaksi. Nah, posisi transaksinya ini adalah 50:50. Jadi misalnya ada transaksi yang masuk dua, satu di node 1, satu di node 2. Artinya kan secara pembagian ini normal ya. Nah, pertanyaannya kenapa di node 1 ini eh atau di node tertentu terjadi masalah gitu. Nah, itu kemarin kita coba tracing-tracing, terus kita mau coba uji. Tapi kan namanya production kita nggak bisa melakukan pengujian secara masif di production, hanya mungkin kita mencoba pengujian-pengujian sederhana. Jadi kita sebenarnya mau menguji ketahanan eh node-nya. Tapi kan kita nggak bisa melakukan misalnya stress testing di production. Jadi kita mau melihat nih gimana sebenarnya LB-nya mengalirkan datanya. Nah, ketika ini mau kita uji, kita nggak punya environment buat pengujian ini. Ketika kita mau kita turunkan ke lower env, development ya, low env maksudnya di lower env, eh kita nggak bisa replicate masalahnya. Karena di dev itu secara code udah 100% sama, tapi kan yang mau kita coba itu pengujian spike-nya sama pembagian transaksinya. Karena di development dia hanya satu node, kita nggak bisa tuh ngebagi bikin skenario eh spike eh CPU-nya gitu.

Sarah: Berarti yang saya tangkap, Pak, risiko isu yang kemarin sudah diselesaikan ya. Tapi saat ini eh tim tetap bekerja dengan risiko yang sama dong ya, maksudnya. Kemarin itu kan dilakukan cara cepat gimana supaya isu itu selesai, tapi bukan solusi yang untuk mencegahnya terjadi kembali, atau gimana, Pak?

Ekonaldi: Iya sorry gimana? Boleh diulangi pertanyaannya?

Sarah: Berarti saya tangkapnya itu kemarin isunya sudah diselesaikan tapi diselesaikan dengan cara cepat dan kemungkinan risiko seperti itu masih mungkin terjadi ya di kemudian hari, dikarenakan belum ada solusi jangka panjang yang dilakukan?

Ekonaldi: Iya, jadi untuk eh hal-hal seperti itu ya eh isu-isu di production memang sebisanya itu kita kasih respons mungkin ya atau penyelesaian secepat mungkin, baik itu solusi jangka panjang atau jangka pendek. Jadi yang sekarang itu di production ya itu masih solusi-solusi yang eh biasa kita lakukan. Ya sekarang itu memang solusi yang kita lakukan itu masih cukup nge-handle di eh isu yang terakhir kejadian, ya. Tapi enggak menutup kemungkinan kalau ada masalah-masalah yang baru eh yang belum pernah kita temui akan kejadian di sana gitu. Karena balik lagi fasenya itu kan masih tetap berjalan ya. Service-nya masih terus update. Jadi ya solusi-solusi yang udah kita berikan belum tentu bisa nge-handle case-case yang akan ada.

Sarah: Terkait batasan saya mengekspos masalah ini, Mas. Terkait data dari operasional production kemarin seperti log atau metrik atau trace dari isunya, apakah hal ini bisa saya lampirin datanya atau tidak boleh ya, Mas?

Ekonaldi: Mmm, kalau ini terms, ini sebenarnya data data klien ya, kalau untuk log kemungkinan nggak sih ya, karena data di production itu udah data riil gitu. Tapi mungkin kalau untuk yang eh data development mungkin masih bisa karena itu data dummy. Tapi kalau yang production eh sepertinya nggak bisa karena kita juga kan ada terikat NDA ya. Data-data production itu kita nggak bisa kasih. Tapi mungkin misalnya eh terkait gambaran, mungkin bisa. Tapi bukan data riilnya ya. Dan itu bisa kita mocking di development.

Sarah: Pertanyaan saya ada terakhir nih, Pak. Terkait berarti eh masalah yang kemarin sudah selesai, Pak?

Ekonaldi: Sudah selesai dalam konteks apa dulu? Di isu yang terakhir, ya?

Sarah: Iya. Production sudah berjalan sebagaimana mestinya.

Ekonaldi: Sebenarnya secara secara isu, ya, isunya enggak kejadian lagi yang untuk isu tertentu gitu. Udah enggak kejadian. Tapi eh, kita tetap butuh eh solusi-solusi yang untuk jangka panjang gitu.

Sarah: Oke, baik, Pak Eko Naldi. Saya rasa ini sudah cukup untuk saya rumuskan sebagai business needs yang akan saya taruh di system request saya di tugas kuliah ini. Sesuai tahapannya, saya belum mengusulkan solusi apa pun. Saya akan lakukan kajian literatur dulu, desk research dulu, lalu usulan teknologinya saya bisa bawa ke Pak Ekonaldi di tahap berikutnya. Namun belum tentu juga dikarenakan setiap system request ini akan dinilai kelayakannya di perkuliahan saya. Jadi ekspektasinya saya gali masalahnya dulu, namun untuk solusinya saya belum bisa memastikan ya, Pak, itu akan saya selesaikan apa tidak. Tergantung dari apakah ini system request saya terpilih untuk diteliti lebih lanjut atau enggak. Nah, kira-kira seperti itu tanggapan dari Pak Ekonaldi gimana ya?

Ekonaldi: Oh ya. Ini nanti berarti kalau... Ini kan lagi nyariin masalah, ya. Berdasarkan case yang di Klien. Nanti kira-kira output yang kita dapat kira-kira seperti apa?

Sarah: Nah, kita akan kasih solusi, Pak, yang kita selesaikan secara teknis, dalam artian eh, berupa inovasi teknologi. Namun belum bisa saya sampaikan sekarang karena kan eh belum saya lakukan literature review atau belum saya lakukan penelitian yang lebih lanjut untuk menemukan best practice atau solusi seperti apa yang bisa saya jawab, yang bisa saya tawarkan untuk menyelesaikan isu ini. Seperti itu, Pak.

Ekonaldi: Oh ya. Jadi saya izin untuk naruh problem ini di system request saya, Pak. Boleh ya, Pak?

Ekonaldi: Iya, boleh silakan. Silakan, silakan. Kalau ada nanti ide-ide dari ee, dari sini juga kalau misalnya idenya bisa dieksekusi lebih bagus, sih, ya. Saya berharap memang idenya bisa kita, inovasinya bisa kita implementasi di sana gitu.

Sarah: Oke. Terima kasih banyak ya, Pak Eko Naldi. Saya juga izin mencantumkan identitas Bapak sebagai project sponsor atau tempat saya menggali informasi terkait problem ini di dokumen tugas saya. Boleh ya, Pak?

Ekonaldi: Oke, oke, boleh. Silakan.

Sarah: Oke. Terima kasih, Pak, sudah cukup, eh terima kasih sudah meluangkan waktunya, nanti saya akan infokan lagi bagaimana kelanjutan dari eh system request yang udah saya lakukan ini, apakah layak untuk diteliti lebih lanjut oleh saya dan tim, atau tidak di perkuliahan ini. Terima kasih ya, Pak.

Ekonaldi: Oke, sama-sama.

Sarah: Oke, kalau gitu saya izin untuk end meeting-nya ya, Pak.

Ekonaldi: Eh, saya mau nanya dong.

Sarah: Iya, apa... oke, ada apa itu, Pak?

Ekonaldi: Ini kuliah magister di UI itu online ya? Atau... ini kuliah online, ya?

Sarah: Iya. Sebenarnya tidak online, Pak. Jadi kita itu on-site, cuma ada beberapa porsi, berapa persen gitu di mana perkuliahan bisa dilakukan secara online. Tapi mostly dilakukan on-site, Pak. Cuma kelas malam, jadi nggak bakal mengganggu proses, maksudnya nggak akan mengganggu waktu saya bekerja seperti itu, Pak.

Ekonaldi: Oh, oke oke. Keren-keren. Oke oke. Makasih Pak.

**\[AKHIR TRANSKRIP]**

## **Appendix C :  Berkas Rekaman Wawancara**

Rekaman audio wawancara dapat diakses melalui tautan berikut: [Rekaman Wawancara.m4a](https://univindonesia-my.sharepoint.com/:u:/g/personal/sarah_h_office_ui_ac_id/IQDRvCu6GUGwRbY5rgfPL-GdAYryGiy17lIcbKpO9v0I3mQ?nav=eyJyZWZlcnJhbEluZm8iOnsicmVmZXJyYWxBcHAiOiJPbmVEcml2ZUZvckJ1c2luZXNzIiwicmVmZXJyYWxBcHBQbGF0Zm9ybSI6IldlYiIsInJlZmVycmFsTW9kZSI6InZpZXciLCJyZWZlcnJhbFZpZXciOiJNeUZpbGVzTGlua0NvcHkifX0&e=XkSZFA). Akses tautan telah disetel ke “Anyone with the link can view”. Rekaman dilaksanakan pada 8 September 2026 melalui Zoom dengan durasi 34 menit 35 detik dan telah memperoleh persetujuan narasumber sebagaimana terekam pada Appendix B.

