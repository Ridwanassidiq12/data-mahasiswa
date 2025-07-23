#BUAT SCHEMA DB
CREATE SCHEMA portofolio; 

#PANGGIL DB YANG TADI DI BUAT
USE portofolio;
SHOW TABLES;

# 1. BUAT TABLE 
CREATE TABLE mahasiswa (
    nim INT PRIMARY KEY,
    nama VARCHAR(250),
    jenis_kelamin VARCHAR(20),
    angkatan INT,
    kota_asal VARCHAR(50)
    
);


CREATE TABLE nilai (
	nim INT,
	kode_matakuliah VARCHAR(50),
	nilai_tugas INT,
	nilai_mid INT,
	nilai_uas INT
);

SELECT * FROM mahasiswa;
SELECT * FROM nilai;

# 2.Buat Query Data semua mahasiswa
SELECT * FROM mahasiswa;

# 3.Buat Query Data semua mahasiswa angkatan tertentu
SELECT * FROM mahasiswa
WHERE angkatan = 2001;

# 4. Buat Query Data semua nilai matakuliah tertentu (mata kuliah PBD)
SELECT * FROM nilai
WHERE kode_matakuliah = 'PBD';

# 5. Buat Query Data, Jika nilai akhir adalah hasil perhitungan dari 40% nilai tugas, 30% nilai mid dan 30% nilai uas
SELECT nilai_tugas, nilai_mid, nilai_uas, ROUND((0.4 * nilai_tugas) + (0.3 * nilai_mid) + (0.3 * nilai_uas), 2) as nilai_akhir
FROM nilai;

# 6. Dengan data no. 5 buat query satu row data yang menunjukkan nilai rata-rata
SELECT ROUND(AVG((0.4 * nilai_tugas) + (0.3 * nilai_mid) + (0.3 * nilai_uas)), 2) as rata_nilai_akhir
FROM nilai;

# 7.Gabungkan kedua query no.5 dan no.6 
SELECT nilai_tugas, nilai_mid, nilai_uas, ROUND((0.4 * nilai_tugas) + (0.3 * nilai_mid) + (0.3 * nilai_uas), 2) as nilai_akhir,
(SELECT ROUND(AVG((0.4 * nilai_tugas) + (0.3 * nilai_mid) + (0.3 * nilai_uas)), 2) FROM nilai) as rata_nilai_akhir
FROM nilai;

# 8. Buat Query jika anda menampilkan data semua nilai matakuliah AI dan yang belum ada nilai gunakan “UNION” sehingga data bisa tampil semua
SELECT m.nim, m.nama, n.kode_matakuliah, n.nilai_tugas, n.nilai_mid , n.nilai_uas 
FROM mahasiswa m
JOIN nilai n ON n.nim = m.nim
WHERE n.kode_matakuliah = 'AI '

UNION

SELECT m.nim, m.nama,
    'AI ' AS kode_matakuliah,
    NULL AS nilai_tugas,
    NULL AS nilai_mid,
    NULL AS nilai_uas
FROM mahasiswa m
WHERE m.nim NOT IN (
    SELECT nim FROM nilai WHERE kode_matakuliah = 'AI '
);

# 9. Buat query untuk menampilkan table berikut :
SELECT m.nim, m.nama, n.nilai_tugas, n.nilai_mid, n.nilai_uas, ROUND((0.4 * n.nilai_tugas) + (0.3 * n.nilai_mid) + (0.3 * n.nilai_uas), 2) as nilai_akhir
FROM nilai n
JOIN mahasiswa m ON m.nim = n.nim

UNION

SELECT 
    NULL AS nim,
    'RATA-RATA' AS nama,
    ROUND(AVG(nilai_tugas), 2) AS nilai_tugas,
    ROUND(AVG(nilai_mid), 2) nilai_mid,
    ROUND(AVG(nilai_uas), 2) nilai_uas,
    ROUND(AVG((0.4 * nilai_tugas) + (0.3 * nilai_mid) + (0.3 * nilai_uas)), 2) AS nilai_akhir
FROM nilai;

#Buat query, Jika anda diminta untuk mengkonversi nilai akhir dengan aturan sebagai berikut:
#nilai akhir >80 maka “A”
#nilai akhir >60 maka “B”
#nilai akhir >40 maka “C”
#nilai akhir >20 maka “D”
#nilai akhir <=20 maka “E”

SELECT nilai_tugas, nilai_mid, nilai_uas, ROUND((0.4 * nilai_tugas) + (0.3 * nilai_mid) + (0.3 * nilai_uas), 2) as nilai_akhir,
	CASE
        WHEN ((0.4 * nilai_tugas) + (0.3 * nilai_mid) + (0.3 * nilai_uas)) > 80 THEN 'A'
        WHEN ((0.4 * nilai_tugas) + (0.3 * nilai_mid) + (0.3 * nilai_uas)) > 60 THEN 'B'
        WHEN ((0.4 * nilai_tugas) + (0.3 * nilai_mid) + (0.3 * nilai_uas)) > 40 THEN 'C'
        WHEN ((0.4 * nilai_tugas) + (0.3 * nilai_mid) + (0.3 * nilai_uas)) > 20 THEN 'D'
        ELSE 'E'
    END AS predikat
FROM nilai;


# 11
SELECT m.nim,m.nama,n.nilai_tugas, n.nilai_mid,n.nilai_uas,ROUND((0.4 * n.nilai_tugas) + (0.3 * n.nilai_mid) + (0.3 * n.nilai_uas), 2) AS nilai_akhir,
    CASE
        WHEN ((0.4 * n.nilai_tugas) + (0.3 * n.nilai_mid) + (0.3 * n.nilai_uas)) > 80 THEN 'A'
        WHEN ((0.4 * n.nilai_tugas) + (0.3 * n.nilai_mid) + (0.3 * n.nilai_uas)) > 60 THEN 'B'
        WHEN ((0.4 * n.nilai_tugas) + (0.3 * n.nilai_mid) + (0.3 * n.nilai_uas)) > 40 THEN 'C'
        WHEN ((0.4 * n.nilai_tugas) + (0.3 * n.nilai_mid) + (0.3 * n.nilai_uas)) > 20 THEN 'D'
        ELSE 'E'
    END AS predikat

FROM nilai n
JOIN mahasiswa m ON m.nim = n.nim;
