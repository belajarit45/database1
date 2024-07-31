#!/bin/bash

# URL untuk memeriksa keberadaan file
file_url="https://raw.githubusercontent.com/belajarit45/database1/main/earnapplinkupdate.txt"

# Fungsi untuk memeriksa apakah file ada
cek_file_ada() {
  if curl --output /dev/null --silent --head --fail "$1"; then
    echo "File ditemukan: $1"
    return 0
  else
    echo "File tidak ditemukan: $1"
    return 1
  fi
}

# Fungsi untuk mengambil URL dari file
ambil_urls() {
  curl -s "$1" | grep -o 'https://earnapp.com/r/[^\"]*' | uniq
}

# Memeriksa apakah file ada
if cek_file_ada "$file_url"; then
  echo "Mengambil URLs dari $file_url ..."
  urls=($(ambil_urls "$file_url"))

  if [ ${#urls[@]} -eq 0 ]; then
    echo "Tidak ada URL yang ditemukan di $file_url. Keluar."
    exit 1
  fi

  echo "Ditemukan ${#urls[@]} URL."
else
  echo "File $file_url tidak ditemukan. Keluar."
  exit 1
fi

# Fungsi untuk membuka URL di peramban
buka_url() {
  termux-open-url "$1"
}

# Melakukan loop untuk setiap URL
for (( i=0; i<${#urls[@]}; i++ )); do
  # Menampilkan nomor link saat ini
  echo "Membuka link $((i+1)) dari ${#urls[@]}"
  
  # Membuka URL
  buka_url "${urls[$i]}"
  
  # Memeriksa apakah perlu tidur
  if (( ($i + 1) % 5 == 0 && ($i + 1) < ${#urls[@]} )); then
    echo "Menunggu selama 5 menit..."
    sleep 300  # Tidur selama 5 menit
  elif (( ($i + 1) < ${#urls[@]} )); then
    echo "Menunggu selama 10 detik..."
    sleep 10   # Tidur selama 10 detik
  fi
done

echo "Selesai!"
