# Project Sponsor

## Context

PT Paragon Technology & Innovation is a beauty and personal-care company founded in 1985 that develops, manufactures, markets, and distributes cosmetics, skincare, haircare, and related products. The company employs more than 14,000 people and operates an extensive distribution network across Indonesia and Malaysia. Its brand portfolio includes Wardah, Make Over, Emina, Kahf, Putri, Crystallure, Instaperfect, Labore, Biodef, Tavi, Wonderly, OMG, Beyondly, Earth Love Life, and DSE Dermascalp Expert. Paragon expanded its presence through local distributors and major retail networks such as Watsons and Guardian.

Paragon is strengthening its competitive advantage by moving beyond the simple purchase of emerging AI technologies and investing in the development of its own Computer Vision Engine.
By building this capability in-house, the company can tailor AIs to its specific business needs, retain greater control over proprietary data and intellectual property.
Computer Vision (CV), a branch of AI that enables systems to interpret images
and video,
powers Paragon's experience applications such as
Virtual Try-On experience^[https://vto.wardahbeauty.com/].
Strategically, fast-moving consumer goods companies invest in such consumer experiences for practical marketing purposes.

## Assignment Topic Fitness

This proposal satisfies the brief's requirement to incorporate emerging digital technologies because
implementing instrumentation layer to an in-house CV is 
a genuinely current problem rather than a generic IT solution exercise. CV services have workload characteristics that
traditional web services don't naturally demand, so extending it with an observability capability demonstrates technical currency while seizing cost-saving opportunity.

## Support Manifestation

I identified 2 primary stakeholders for sponsorship of this system request document: Technology Product Owner and Engineering Manager.
As project initiator, I have secured verbal agreement for the following support points, evidence available in the appendices.

+ Access to the CV Engine API (free of charge)
+ Consultation with internal experts (monthly until end of year, 30–60 minutes each session)

# Business Needs

## Problems
I interviewed our proposed system's projected primary user. 
The following table summarizes the profile of relevant Engineering Manager.

| ![](images/figma.png){width=100%}  |
|-----------------------------------|
| Contact: adinda.gdshinta@paracorpgroup.com |
: User Persona {#tbl-persona}

The interview captured a rather abstract problem:

> _Kita tau tim bisnis akan nanya "bisa dibuat lebih akurat, cepat, atau lebih murah lagi kah, mbak," cepat atau lambat. Tim engineering sih akan berusaha sebaik mungkin aja untuk menuhinnya nanti. Dan bukan tugas tim engineering untuk bikin business-case sebelum ngoding apa yang engineer pengen bikin, way of working-nya tidak seperti itu_

## Opportunities

1. Given compatible project roadmap and boundaries in CV Engine project at Paragon (see interview appendix),
I propose an instrumentation layer for its observability as a plausible orthogonal effort to the mainline & internal
engine development.

2. OpenTelemetry is the default instrumentation pipeline standard that has created an opportunity to unify observability across services, reduce vendor lock‑in, and lower total cost of ownership^[https://www.cncf.io/announcements/2026/05/21/cloud-native-computing-foundation-announces-opentelemetrys-graduation-solidifying-status-as-the-de-facto-observability-standard/].
Observability itself, however, is mature as a domain problem: adopting OpenTelemetry is more of an inspiration than a hard requirement.

# Business Requirements

## User Story

**_As_** an IT operations engineer responsible for the department's computer vision services,

**_I want_** end-to-end tracing and standardized metrics across the inference pipeline,

**_so that_** when a request runs slow or returns an unexpected result, I can see exactly which stage introduced the delay or failure, instead of guessing from application logs alone. Today, when an external vendor or integrator reports that inference results look off for a batch of images, there is no way to correlate a single request across the pipeline layers.

## Deliverable

The deliverable is an observability dashboard that gives IT operations engineers a visibility into the CV Engine inference pipeline. The mockup below illustrates the intended result.

![Mockup Illustration](images/visual.png){fig-align="center" width="100%" fig-cap="Mockup Illustration"}
: Figure: Automatically Generated Mockup Illustration

# Business Value

I approximate the expected monetary valuation of the proposed system as follows: first the value of having observability (as opposed to having none),
and second, the value of avoiding external service expenses (as opposed to spending on a benchmark external service).

The following table lists assumed values for the valuation.

| No. | Parameter                                              | Estimated value | Basis / rationale |
|---|----|---:|----|
| 1 | Application integrations per year                      | 7 | Initial adoption scenario |
| 2 | Significant integration incidents per integration/year | 4 | 1 incident every 3 months |
| 3 | Investigation time without instrumentation             | 6 hours/incident | Logs + reproduction + cross-team investigation |
| 4 | Investigation time with instrumentation                | 2 hours/incident | Correlated telemetry narrows the investigation |
| 5 | Engineering cost                                       | Rp250.000/hour | Blended engineering cost |
| 6 | Performance/evaluation effort without instrumentation  | 40 hours/integration | Manual resource/performance investigation |
| 7 | Performance/evaluation effort with instrumentation     | 20 hours/integration | Automated metrics and standardized reporting |
| 8 | Incidents causing prolonged service disruption         | 2/year | Conservative initial assumption |
| 9 | Downtime avoided per incident                          | 2 hours | Better detection/diagnosis |
| 10 | Operational cost of downtime                           | Rp1.500.000/hour | Conservative business-impact estimate |

## 1. Annual Opportunity Cost of Having Observability

This analysis values observability by comparing the effort required to operate the CV Engine with and without instrumentation.
The value of having observability is parametrized by all of the above value assumptions.

| Saving source | Annual saving |
|---|---:|
| Incident investigation | 7 integrations × 4 incidents × (6 − 2) hours × Rp250.000 = Rp28.000.000 |
| Performance/evaluation | 7 integrations × (40 − 20) hours × Rp250.000 = Rp35.000.000 |
| Downtime avoidance | 2 incidents × 2 hours × Rp1.500.000 = Rp6.000.000 |
| **Total** | **Rp69.000.000** |

## 2. Annual Opportunity Cost of Subscribing to Observability as a Service
A more fair comparison requires a complete list of features that CV Engine will exactly want from an observability platform.
Such list is not available at this stage of the roadmap, so for the purpose of concretizing the monetary cost of subscribing to a service of its kind,
I pick Datadog as a representative popular benchmark.

### 2026 Benchmark External Service Pricelist
I looked at Datadog's pricing page^[https://www.datadoghq.com/pricing/?site=ap2].

| Parameter | Value | Remarks |
|---|---:|---|
| Server Site | AP2 (Australia) | AP2 is closer geographically to Jakarta than AP1 (Japan) |
| Pricing Plan | Enterprise | Datadog provides 4-level non-free plans, Enterprise is level 2 |
| Price | USD 27.60 per month | USD 27.60 * 12 months = USD 331.2 annually |

## Annual Valuation Summary

This table takes the total values from above analyses.

| Valuation analysis | Annual value | In Rupiah (17.630,80 USD-Rupiah Rate) |
|---|---:|---|
| Opportunity cost of having observability | Rp69.000.000 | 69.000.000 |
| Avoided external service subscription (Datadog benchmark) | USD 331.20 | 5.839.321 |

Finally, the following table hopes to present all possible decisions on this matter, letting engineering effort for the last option be unlisted as this is for instructive group class assignment.

| Option                               | Internal engineering effort | External service cost | Annual investment | Annual value gained |  Net annual value |
| --- | ---: | ---: | ---: | ---: | ---: |
| **Do nothing**                    |                         Rp0 |                   Rp0 |           **Rp0** |                 Rp0 |           **Rp0** |
| **Subscribe** |         100 hrs × Rp250.000 |           Rp5.839.321 |  **Rp30.839.321** |        Rp69.000.000 |  **Rp38.160.679** |
| **Build**         |                        (not accounted) |                   Rp0 |          **≈Rp0** |        Rp69.000.000 | **≈Rp69.000.000** |


# Special Issues
Finally, this system request proposal acknowledges the following issues that are worth anticipating.

### Implications

#### Application performance overhead:

Studies of instrumentation overhead are often conducted within a specific language ecosystem and its corresponding observability frameworks. For example, @Reichelt2026BenchmarkingTO evaluates seven distributed-tracing frameworks in the Java ecosystem (including OpenTelemetry) and reports significant differences in their performance overhead. However, regardless of the relative efficiency of individual frameworks, the study establishes the more fundamental point relevant to this work: instrumentation is not overhead-free.

### Critical Success Factors

+ **Discipline from application developers and integrators:**
Maintaining application logging requires ongoing discipline, as modifications to log statements can affect downstream log analysis. A systematic mapping study of logging practices from @gu2022logging identified _maintenance barriers_ as a major issue, reported across over 17% of its primary studies. Such modifications can also introduce errors into the main system, increasing the overall cost over time.

+ **Business-level demand for system optimizations:**
Without sustained stakeholder demand to do concrete system optimizations, the overhead outweighs its practical utility.

# References

::: {#refs}
:::

{{< pagebreak >}}

\appendix

# Appendix A. Interview Questions and Transcripts

## Question Set 1: Project Scope and Sponsorship
The first question set confirms whether our proposal is feasible in terms of scope and timeline.

1. What is the scope and expected impact of the upcoming Computer Vision Engine project?
2. What projects/events/brands will see it in action for the first time?
3. Is sharing actual observability data out of Paragon permitted?
4. What forms of sponsorship can you give to this project initiative?
5. How does the project timeline look like for Computer Vision Engine project?

### Semi-Automated Transcription

| Speaker | Role |
|:-------------|:-----|
| **[I]**      | Interviewer |
| **[TPO]**     | Technology Product Owner |

| | |
|:---|:---|
| **[I]** Iya Mas, mungkin pertama aku konfirmasi dulu Mas Gia ini adalah Technology Produk Officer ya di IT Paragon | |
| | **[TPO]** Iya betul, Technology Product Owner di Paragon |
| **[I]** Oh mohon maaf, Owner ya, oke aku mau mulai dengan pertanyaan pertama, Mas. **_Bagaimana sebenarnya visi dari Computer Vision Engine ini, mungkin dari segi impact dan scopenya_** | |
| | **[TPO]** Iya CV Engine itu nanti akan dibangun sebagai salah satu building block Untuk kita bisa menghasilkan suatu rekomendasi produk yang lebih akurat ya. Jadinya, misal customer melakukan scanning wajah gitu ya. Itu harapannya nanti Vision Engine itu akan meng-capture dan menganalisa dengan lebih akurat secara terus menerus, artinya terus menerus kita akan improvement dengan retraining model. Kemudian kita pertajam dari sisi analisa. Tidak hanya dari sisi bentuk wajah, tapi juga dari warna kulit, external factor Contohnya misal UV Index, humidity, dan lain-lain. Nah ini harapannya sebenarnya Vision Engine itu akan membantu kita bisa men-shaping ke customer yang lebih segmented dan targeted. Dan akhirnya nanti produk recommendation yang kita berikan itu memang yang men-solve dan meng-capture isu dari customer itu sendiri. Nah dan harapannya lagi sebenarnya kalau bicara bisnis impactnya ya, kita bisa membuat sesuatu seperti system as a service juga yang nanti bisa kita jual di luar Paragon, yang harapannya nanti akan membawa revenue baru di luar Paragon itu sendiri. Paling mungkin dari aku secara vision-nya itu seperti itu ya |
| **[I]** Baik, untuk awal, **_project, event, atau brand apa aja mas sudah terlihat akan menggunakan engine-nya_** | |
| | **[TPO]** Ya kalau untuk project, event, dan brand itu mungkin hampir semua yang akan menggunakan CV Engine ini ya. Mungkin kita akan coba piloting dari beberapa event terlebih dahulu gitu ya. Nah misalnya contohnya event di Wardah ada A.M. Club, nah dia bisa jadi salah satu piloting untuk kita melakukan proses Vision Engine ini. Harapannya sih nanti kita gradually ya, improve dan expand gitu Misalnya dari sisi piloting itu sudah oke Kita coba mulai approach ke existing-existing platform kita ya Yang sudah di brand-brand atau di event-event Mungkin harapannya kita bisa nge-replace yang vendor pernah kerjakan. Jadi semua proses dan data owningnya itu di kita Harapannya sih seperti itu, Mas Reza |
| **[I]** Baik Mas. Kemudian Sebenarnya wawancara ini itu dalam rangka saya itu akan mem-propose sebuah sistem observability seperti itu Mas Untuk diterapkan di engine-nya yang baru nanti. Nah Yang saya mau bertanya, **_Apakah membagikan video usage dari sistem saya itu yang artinya mungkin menunjukkan data aktual gitu ya dari pengguna-pengguna enginee yang baru itu keluar lingkungan perusahaan apakah dibolehkan, Mas?_** | |
| | **[TPO]** Ya kalau untuk simulasi ya Simulasi dan juga video Dari sisi performance kita itu dibolehkan Mas, Selama itu bukan data customer ya Dan juga data produk-produk sensitif kita Itu dibolehkan Mas |
| **[I]** Baik, terima kasih Mas. Kemudian pertanyaan terakhir, setelah ini saya akan melakukan juga wawancara dengan stakeholder Yaitu mungkin dari sisi engineeringnya Yang akan menjadi pengguna langsung dari sistem yang akan saya buat begitu. Nah apabila proposal saya nanti dinilai feasible, **_sponsorship atau dukungan apa saja yang mungkin Mas berikan ya Untuk pengembangan sistem saya? Kalau mungkin secara secara poin-poin itu saya membutuhkan pertama Boleh mengakses API engine yang baru Mungkin diperbolehkan untuk tidak dibilling atau tanpa berbayar begitu Lalu mungkin kedua Kami akan butuh bertanya-tanya yang dalam hal ini konsultasi begitu Yang profesional dengan internal experts._** Mungkin kalau di estimasi sampai dengan akhir proyek atau akhir tahun ini Kira-kira setengah sampai satu jam seperti itu Mas. Nah untuk dua hal tersebut Apakah mungkin untuk diberikan? | |
| | **[TPO]** Ya Kalau untuk yang poin satu Nanti kita bisa coba Berikan aksesnya ya. Mungkin nanti bisa Ada beberapa Ini juga ya beberapa kriteria juga ya Yang penting sebenarnya kan Kita tidak mengakses data customer aja. Yang kedua untuk subject matter expert pun sebenarnya Dari sisi kita juga Ada yang mungkin lebih ahli ya dari penggunaan computer vision Misalnya contohnya kayak Kayak Risman gitu ya Atau Mungkin Mas Redha gitu ya Di level Yang lebih atas Nah itu Mungkin mereka bisa lebih expert ya Untuk dijadikan sebagai Konsultasi gitu |
| **[I]** Baik Terima kasih Kalau begitu, boleh saya Konfirmasi Akan didukung lah ya Untuk setidaknya dua Tadi itu Dan mungkin akan diarahkan ke Expert Yang Lebih expert tadi ya Dengan Pak Risman dan Mas Redha | |
| | **[TPO]** Ya betul |
| **[I]** Oke Selanjutnya Boleh dikonfirmasi Mas Ini nanti itu Akan estimasinya **_Secara roadmap Di Q4 Tahun ini kah Atau seperti apa Mas?_** | |
| | **[TPO]** Ya Nanti kita Akan mulai start dari Q3 sekarang. Dan harapannya di Q4 itu kita udah bisa cover hampir semua brand ya Menggunakan existing platform kita gitu. Mungkin secara milestone Seperti itu ya Mas Reza |

## Question Set 2: Challenges when Optimizing AI Application
This set confirms the usability of the proposed system deliverable.

1. Which metrics can we potentially track from the upcoming Computer Vision Engine?
2. How can an instrumentation layer help identify the cause of a degradation (internal engine implementation, input data quality, etc)?
3. Can we generate real-world trace data so we can validate optimization gains in a reproducible environment?
4. How can an instrumentation alert us to information such as a decrease in model accuracy, increased memory footprint, etc?

### Semi-Automated Transcription

| Speaker | Role |
|:-------------|:-----|
| **[I]**      | Interviewer |
| **[EM]**    | Engineering Manager |


| | |
|:---|:---|
| **[I]** Mbak boleh konfirmasi dulu posisinya sebagai Engineering Manager Yang kemungkinan akan handle tim Computer Vision engine ini? | |
| | **[EM]** Iya betul Saya Engineering Manager yang pegang tim yang akan develop dan maintain CV Engine ini |
| **[I]** Kalau sekarang **_Apa saja metrik yang kemungkinan bisa di track dari engine nya nanti?_** | |
| | **[EM]** Jadi kalau dari sisi kita Ada beberapa layer sih. Di level input resolusi gambar Format Sama latency dari preprocessing step. Kalau di level inference, mungkin ada latency per-request, sama utilization GPU atau CPU tergantung deploymentnya. Nah yang paling krusial paling di level output, bisa track accuracy Confidence score distribution-nya. |
| **[I]** Berarti udah langsung bisa terbayang ya Dari sekarang. Pertanyaan selanjutnya. **_Bagaimana instrumentation layer ini membantu kita mengisolasi apakah penurunan performa itu disebabkan oleh kodingan engine sendiri, atau karena variasi eksternal seperti resolusi gambar input?_** | |
| | **[EM]** Jadi instrumentation layer itu bisa didesain supaya dia nge-capture context Di setiap request, bukan cuma resultnya. Misal, kalau ada spike di latency, kita bisa langsung lihat, oh ternyata request ini payload nya resolusi gambar yang jauh di atas rata-rata, atau formatnya beda. Jadi kita bisa korelasiin antara input characteristics dengan output metrics. Kalau memang variance-nya konsisten across resolusi yang beda-beda, berarti kemungkinan besar itu emang dari kode kita. Tapi kalau ternyata drop-nya cuma terjadi pas ada outlier di input, ya berarti itu bukan bug, itu variance eksternal Yang emang di luar kontrol kita. |
| **[I]** Kemudian **_Apakah kita bisa generate real-world trace data supaya kita bisa validasi effort optimisasi di environment staging misal?_** | |
| | **[EM]** Bisa, arahnya memang biasanya ke situ. Misal mau bikin semacam Trace capture dari traffic production, di-anonymize dan di Sample secukupnya, terus kita replay di staging environment. Jadi kalau ada optimization baru, kita nggak cuma test pakai synthetic data doang yang belum tentu representatif, tapi kita bisa validasi pakai pattern yang beneran mirip real-world usage Za. Reproducibility-nya paling dijagainnya pakai versioning Jadi tiap kali ada perubahan di engine, kita bisa re-run trace yang sama dan compare hasilnya secara fair |
| **[I]** Terakhir nih. **_Bagaimana instrumentation kita bisa jadi alarm untuk semisal ada penurunan akurasi model Peningkatan cost infra gitu-gitu?_** | |
| | **[EM]** Kalau udah di define threshold-threshold nya sih enak ya. Misal accuracy turun di bawah threshold itu, atau memory footprint naik, itu bakal trigger alert otomatis. Tapi bukan cuma alert doang sih Biasanya bentuknya dashboard yang lebih visual, jadi tim bisa lihat trend-nya dari waktu ke waktu, bukan cuma snapshot pas ada masalah aja. Karena kita tau tim bisnis akan nanya "bisa dibuat lebih akurat, cepat, atau lebih murah lagi kah Mbak," cepat atau lambat. Tim engineering sih akan berusaha sebaik mungkin aja untuk menuhinnya nanti. Dan bukan tugas tim engineering untuk bikin Business-case sebelum ngoding apa yang engineer pengen bikin, way of working-nya tidak seperti itu sih. Jadi instrumentation ini lebih ke Supaya kita punya visibility duluan sebelum jadi masalah besar gitu paling Za |






<!-- | | | -->
<!-- |:---|:---| -->
<!-- | **[I]** Mbak, boleh konfirmasi dulu posisinya sebagai Engineering Manager yang kemungkinan akan handle tim Computer Vision Engine ini? | | -->
<!-- | | **[EM]** Iya betul, saya Engineering Manager yang pegang tim yang akan develop dan maintain CV Engine ini, jadi dari sisi teknikal implementation-nya itu tanggung jawab saya | -->
<!-- | **[I]** Oke, aku mau mulai dari sisi karakteristik beban kerja dulu ya Mbak. Kalau kita lihat use case seperti Virtual Try On misalnya, itu di tahap mana biasanya yang paling terasa lambat? Mulai dari device user sampai ke server IT Paragon | | -->
<!-- | | **[EM]** Jadi kalau kita breakdown end-to-end flow-nya ya, mulai dari user buka kamera di device, itu ada beberapa fase. Pertama capture image atau video frame di client side, itu biasanya cepat karena cuma proses lokal. Terus upload ke server, nah ini tergantung network condition user, apalagi kalau resolusi image-nya besar. Setelah sampai di server, ada preprocessing dulu — resize, normalization, face detection kalau perlu crop area wajah. Nah dari pengalaman kita develop prototype awal, yang paling terasa berat itu justru di bagian inference-nya sendiri, terutama kalau modelnya cukup kompleks kayak untuk deteksi skin tone atau segmentation wajah yang detail. Apalagi kalau GPU lagi busy handle banyak request bersamaan, itu queueing time-nya yang bisa jadi bottleneck, bukan compute time-nya doang. Jadi dugaan saya sih nanti yang perlu di-instrument dengan detail itu ya di sekitar inference call itu, termasuk berapa lama antri sebelum dieksekusi, sama utilization GPU-nya gimana. I/O layer juga penting tapi saya rasa itu lebih predictable, yang inference itu yang paling banyak variabelnya | -->
<!-- | **[I]** Menarik Mbak, berarti nanti kita perlu lihat dari sisi custom span di inference call ya, sama GPU metrics-nya. Lanjut ke pertanyaan berikutnya soal arsitektur deployment. Aplikasinya nanti direncanakan monolith atau microservices, Mbak? Terus model CV-nya rencananya di-serve pakai apa? | | -->
<!-- | | **[EM]** Untuk arsitektur, kita condong ke microservices ya, karena kita mau CV Engine ini bisa scale independent dari servis lain, dan juga supaya tim bisa deploy dan iterate model tanpa ganggu servis lain yang udah jalan. Jadi nanti kemungkinan flow-nya itu ada gateway di depan, terus masuk ke preprocessing service, baru habis itu ke inference service yang khusus handle model CV-nya. Untuk serving model sendiri, kita masih eksplorasi, tapi condongnya pakai Python dulu karena tim data science kita juga develop model-nya di Python, jadi memudahkan dari sisi maintenance dan velocity. Kemungkinan kita mulai dari custom FastAPI service untuk yang lebih fleksibel, tapi kita juga masih buka opsi ke TorchServe atau Triton kalau ternyata butuh throughput yang lebih tinggi dan udah ada built-in optimization dari sananya. Untuk bahasa utama across service, kemungkinan besar Python juga untuk konsistensi, tapi kita juga masih eksplorasi opsi lain kalau ada bagian yang butuh performance lebih tinggi. Yang jelas iya, request-nya bakal melintasi beberapa service, jadi tracing itu bakal penting banget buat kita bisa lihat di mana exactly bottleneck-nya terjadi | -->
<!-- | **[I]** Oke, berarti nanti kita perlu SDK OTel yang Python-based dulu ya sebagai prioritas, dengan opsi auto-instrumentation untuk FastAPI, dan karena request-nya lintas service, distributed tracing jadi krusial, bukan cuma single-service tracing. Lanjut ke observability yang sudah ada, Mbak. Apakah service CV Engine ini nanti akan didaftarkan di Datadog milik tim infra? | | -->
<!-- | | **[EM]** Iya, jadi sejauh ini semua service production kita itu emang wajib onboarding ke Datadog, itu udah jadi standar dari tim infra. Cuma yang jadi concern saya adalah, Datadog itu kan lebih ke observability platform yang general purpose ya, dia bagus untuk metrics dan logs standar, APM juga ada. Tapi untuk kebutuhan CV Engine yang butuh instrumentasi lebih spesifik, misalnya GPU metrics yang detail atau custom span untuk track queueing time di inference, saya belum yakin itu udah ke-cover dengan baik dari Datadog agent yang sekarang. Jadi kemungkinan kita butuh setup OpenTelemetry Collector sendiri sebagai layer tambahan, yang nanti bisa kita pakai untuk collect metrics dan traces yang lebih custom, baru kita export ke Datadog via OTLP supaya tetap terpusat di satu observability backend yang sama dengan servis lain. Untuk prioritas gap-nya sendiri, saya rasa Traces itu yang paling urgent karena kita butuh visibility di flow lintas service tadi, disusul Metrics terutama yang terkait resource utilization, baru Logs karena itu saya rasa udah cukup ter-cover dari standar logging yang ada | -->
<!-- | **[I]** Baik Mbak, jadi nanti kita bisa design OTel Collector sebagai agregasi layer baru yang expor ke Datadog, dengan prioritas Traces dan Metrics dulu. Pertanyaan terakhir dari saya soal target SLA, Mbak. Optimisasi yang lebih prioritas itu biasanya untuk mencapai target apa — throughput, cost efficiency, atau reliability? | | -->
<!-- | | **[EM]** Ini pertanyaan yang bagus, karena sebenarnya ketiganya itu saling tarik-menarik ya. Tapi kalau saya harus urutkan prioritas di fase awal ini, saya rasa reliability dulu yang paling penting, karena ini masih early stage dan kita gak mau customer experience-nya terganggu gara-gara error rate yang tinggi atau service yang down. Jadi target awal kita itu pastiin error rate serendah mungkin dan availability yang tinggi dulu. Habis itu baru throughput, karena kita tau nanti volume request bakal naik seiring adoption fitur ini, jadi kita perlu tau berapa FPS atau requests per second yang bisa kita handle dengan setup sekarang, supaya kita bisa planning capacity dengan lebih baik. Cost efficiency itu prioritas ketiga buat saya, bukan berarti gak penting, tapi saya rasa itu sesuatu yang bisa kita optimize belakangan begitu kita udah punya baseline yang solid dari reliability dan throughput. Kalau dari sisi metric yang perlu di-instrument, kayaknya histogram untuk latency itu wajib banget supaya kita bisa lihat distribusinya, gak cuma rata-rata doang. Counter untuk request dan error juga penting buat hitung error rate. Terus gauge untuk resource utilization kayak GPU memory sama utilization-nya, itu juga krusial buat kita bisa alert kalau resource-nya udah mepet | -->

# Appendix B. Interview Audio Recording

Minimally edited audio recording files are inserted to this DOCX document.
