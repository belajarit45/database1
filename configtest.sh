#!/bin/bash

# Install paket-paket yang diperlukan
apk add nano git docker-compose netdata

# Start Netdata service
rc-service netdata start

# Netdata akan dimulai secara otomatis saat sistem boot
rc-update add netdata default

# Install Netdata menggunakan perintah curl
curl https://get.netdata.cloud/kickstart.sh > /tmp/netdata-kickstart.sh && sh /tmp/netdata-kickstart.sh --nightly-channel --claim-token VO61cF_igS-y1DRluKjYwPOfvW9yL8-wmLQUjaNi_J7tW7MVwyfCN02-VIh7mZ3nn5szxhUbhvy5_SKBAQPGegVHyufAqwNcoODrVgHuw4SXn1AoHzlyS7sQG1SvrURIzSM3RVE --claim-rooms ecf705d6-c0bc-4044-ac48-b241c9ac1db3 --claim-url https://app.netdata.cloud

# Nama file yang akan dicek di GitHub
FILE_NAME="uuidnew.txt"
# URL repositori GitHub
GITHUB_REPO="https://raw.githubusercontent.com/belajarit45/database1/main"

# 1. Periksa apakah file uuidnew.txt ada di dalam repositori GitHub
check_file_exists() {
    local url="$1/$2"
    local response_code=$(curl -sL -w "%{http_code}" -o /dev/null "$url")
    if [ $response_code -eq 200 ]; then
        echo "File $2 ditemukan di repositori GitHub."
    else
        echo "File $2 tidak ditemukan di repositori GitHub."
        exit 1
    fi
}

# Panggil fungsi untuk memeriksa keberadaan file
check_file_exists "$GITHUB_REPO" "$FILE_NAME"

# 2. Ambil daftar UUID dari file uuidnew.txt
UUID_LIST=$(curl -sL "$GITHUB_REPO/$FILE_NAME")

# 3. Buat docker-compose.yaml
{
echo "services:"
echo ""
} > docker-compose.yaml

# Inisialisasi counter untuk nama layanan
service_counter=1

# Loop untuk setiap UUID yang ditemukan
while IFS= read -r uuid; do
    {
    echo "  earnapp_$service_counter:"
    echo "    container_name: earnapp-container_$service_counter"
    echo "    image: fazalfarhan01/earnapp:lite"
    echo "    restart: always"
    echo "    volumes:"
    echo "      - earnapp-data:/etc/earnapp"
    echo "    environment:"
    echo "      EARNAPP_UUID: $uuid"
    echo ""
    } >> docker-compose.yaml

    # Increment counter
    ((service_counter++))
done <<< "$UUID_LIST"

# Tambahkan definisi volume earnapp-data di docker-compose.yaml
{
echo "volumes:"
echo "  earnapp-data:"
} >> docker-compose.yaml

# Mendapatkan tanggal dan waktu saat ini dalam format yang diinginkan (Rabu 31/07/2024 14:28:28)
current_datetime=$(TZ=Asia/Jakarta date +'%A %d/%m/%Y %H:%M:%S' | sed 's/Monday/Senin/; s/Tuesday/Selasa/; s/Wednesday/Rabu/; s/Thursday/Kamis/; s/Friday/Jumat/; s/Saturday/Sabtu/; s/Sunday/Minggu/')

# 4. Buat URL dan simpan ke earnapplinkupdate.txt
{
echo "Dibuat pada: $current_datetime"
echo "URL earnapp:"
} > earnapplinkupdate.txt

# Loop untuk setiap UUID dan tambahkan URL ke earnapplinkupdate.txt
while IFS= read -r uuid; do
    echo "https://earnapp.com/r/$uuid" >> earnapplinkupdate.txt
done <<< "$UUID_LIST"

# Jalankan container menggunakan docker-compose up -d
service_count=$(echo "$UUID_LIST" | wc -l)
containers_per_run=5
runs=$(( (service_count + containers_per_run - 1) / containers_per_run )) # Pembagian membulatkan ke atas

for (( run=0; run<$runs; run++ )); do
    start=$((run * containers_per_run + 1))
    end=$((start + containers_per_run - 1))

    if [ $end -gt $service_count ]; then
        end=$service_count
    fi

    # Menyusun daftar nama layanan yang akan dijalankan
    services_to_run=$(printf "earnapp_%d " $(seq $start $end))

    # Jalankan container dengan docker-compose up -d
    docker-compose up -d $services_to_run
done

# Push ke GitHub dengan Personal Access Token (PAT)
GITHUB_TOKEN="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"

# Konfigurasi git
git config --global user.email "you@example.com"
git config --global user.name "Your Name"

# Klona repositori sementara
git clone https://github.com/belajarit45/database1.git temp_repo
cd temp_repo
git checkout main

# Pindahkan earnapplinkupdate.txt ke direktori temp_repo
mv "../earnapplinkupdate.txt" . 2>/dev/null || touch earnapplinkupdate.txt

# Tambahkan perubahan ke repositori
git add earnapplinkupdate.txt
git commit -m "Menambahkan URL earnapp"
git push https://$GITHUB_TOKEN@github.com/belajarit45/database1.git

# Bersihkan file sementara
cd ..
rm -rf temp_repo

# Setelah semua selesai, buat 999 folder dan pindahkan docker-compose.yaml ke folder ke-890
for ((i=1; i<=999; i++)); do
    mkdir "folder_$i"
done

# Pindahkan docker-compose.yaml ke folder ke-890
mv "docker-compose.yaml" "folder_890/"

echo "Proses selesai."
