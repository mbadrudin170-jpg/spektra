saya ingin agar yang menambahkan atau memperbarui isi file `task.md` di root harus menaati semua aturan gaya penulisan format ini.
jadi agar setiap orang dan AI yang mengedit file task.md ini isi nya akan selalu konsisten.
saya ingin setiap task itu dikelompokkan berdasarkan file file yang terdampak, misalnya `task A` mengedit file `A,B,dan C` lalu `task B` hanya mengerjakan file `A` saja, maka dikelompokkan dalam satu kelompok.
lihat contoh di bawah untuk format nya.

Contoh:

# Kelompok 1

## file terdampak

- (file A)[../FileA.md]

## Tinggi

#### Task 1

- Status : isi misalnya [selesai, belum, setengah, kerjakan]
- Masalah : isi dengan masalah apa yang di ketahui nya.
- Solusi : isi dengan solusi apa yang di rekomendasikan dan berikan contoh nya.
- aturan dilanggar : sisipkan nama semua aturan yang dilanggarnya misalnya : (aturan_boilprate)[aturan_boilprate:32]
- file bermasalah : sisipkan semua file yang harus di perbaiki tersebut misalnya (aturan_boilprate)[aturan_boilprate:32].
- prompt : hanya diisi oleh saya

#### Task 2

- Status : isi misalnya [selesai, belum, setengah, kerjakan]
- Masalah : isi dengan masalah apa yang di ketahui nya.
- Solusi : isi dengan solusi apa yang di rekomendasikan dan berikan contoh nya.
- aturan dilanggar : sisipkan nama semua aturan yang dilanggarnya misalnya : (aturan_boilprate)[aturan_boilprate:32]
- file bermasalah : sisipkan semua file yang harus di perbaiki tersebut misalnya (aturan_boilprate)[aturan_boilprate:32]
- prompt : hanya diisi oleh saya

## Rendah

#### Task 1

- Status : isi misalnya [selesai, belum, setengah, kerjakan]
- Masalah : isi dengan masalah apa yang diketahui nya.
