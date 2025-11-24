#!/bin/bash
#-----------------------------------------------------------------------------------------------------
#
# + Script Bash untuk menginstal kernel Linux versi 5.15.5 di Kali Linux
# + Dibuat oleh: Rofi (Fixploit03)
# + Lisensi: MIT
# + GitHub: https://github.com/fixploit03/TP-LINK-TL-WN722N-V2
#
# DISCLAIMER:
# -----------
# Script ini dibuat untuk memperbaiki masalah pada adapter Wi-Fi TP-LINK TL-WN722N V2/V3,
# terutama saat scanning jaringan Wi-Fi (airodump-ng tidak menampilkan target).
#
# Berdasarkan uji coba, kernel Linux versi 5.15.5 lebih kompatibel dengan chipset Realtek RTL8188EUS
# yang digunakan di adapter TP-LINK TL-WN722N V2/V3.
#
# PERINGATAN!
# -----------
# Script ini GRATIS (Open Source) dan tidak untuk diperjualbelikan.
#
#-----------------------------------------------------------------------------------------------------

# Variabel warna
m="\e[1;31m"   # Merah
h="\e[1;32m"   # Hijau
b="\e[1;34m"   # Biru
p="\e[1;37m"   # Putih
r="\e[0m"      # Reset
ib=$'\e[1;34m' # Input read Biru
ip=$'\e[1;37m' # Input read Putih

# Cek apakah script dijalankan sebagai root apa kaga
if [[ $EUID -ne 0 ]]; then
        echo -e "${m}[-] ${p}Script ini harus dijalankan sebagai root.${r}"
        echo -e "${b}[*] ${p}Jalankan menggunakan perintah ini: '${h}sudo bash $0'${r}"
        exit 1
fi

# Menampilkan banner
clear
echo ""
echo -e "${p}+----------------------------------------------------------------------------------------------+${r}"
echo -e "${p}|                                                                                              |${r}"
echo -e "${p}| ${b}██${p}╗  ${b}██${p}╗${b}███████${p}╗${b}██████${p}╗ ${b}███${p}╗   ${b}██${p}╗${b}███████${p}╗${b}██${p}╗         ${b}██${p}╗     ${b}██${p}╗${b}███${p}╗   ${b}██${p}╗${b}██${p}╗   ${b}██${p}╗${b}██${p}╗  ${b}██${p}╗ |${r}"
echo -e "${p}| ${b}██${p}║ ${b}██${p}╔╝${b}██${p}╔════╝${b}██${p}╔══${b}██${p}╗${b}████${p}╗  ${b}██${p}║${b}██${p}╔════╝${b}██${p}║         ${b}██${p}║     ${b}██${p}║${b}████${p}╗  ${b}██${p}║${b}██${p}║   ${b}██${p}║╚${b}██${p}╗${b}██${p}╔╝ |${r}"
echo -e "${p}| ${b}█████${p}╔╝ ${b}█████${p}╗  ${b}██████${p}╔╝${b}██${p}╔${b}██${p}╗ ${b}██${p}║${b}█████${p}╗  ${b}██${p}║         ${b}██${p}║     ${b}██${p}║${b}██${p}╔${b}██${p}╗ ${b}██${p}║${b}██${p}║   ${b}██${p}║ ╚${b}███${p}╔╝  |${r}"
echo -e "${p}| ${b}██${p}╔═${b}██${p}╗ ${b}██${p}╔══╝  ${b}██${p}╔══${b}██${p}╗${b}██${p}║╚${b}██${p}╗${b}██${p}║${b}██${p}╔══╝  ${b}██${p}║         ${b}██${p}║     ${b}██${p}║${b}██${p}║╚${b}██${p}╗${b}██${p}║${b}██${p}║   ${b}██${p}║ ${b}██${p}╔${b}██${p}╗  |${r}"
echo -e "${p}| ${b}██${p}║  ${b}██${p}╗${b}███████${p}╗${b}██${p}║  ${b}██${p}║${b}██${p}║ ╚${b}████${p}║${b}███████${p}╗${b}███████${p}╗    ${b}███████${p}╗${b}██${p}║${b}██${p}║ ╚${b}████${p}║╚${b}██████${p}╔╝${b}██${p}╔╝ ${b}██${p}╗ |${r}"
echo -e "${p}| ${p}╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝    ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝ |${r}"
echo -e "${p}|                                                                                ${h}Versi: ${p}5.15.5 |${r}"
echo -e "${p}|                                                               ${h}Dibuat oleh: ${p}Rofi (Fixploit03) |${r}"
echo -e "${p}|                                                                                              |${r}"
echo -e "${p}+----------------------------------------------------------------------------------------------+${r}"
echo ""

# Nanya mau instal apa kaga
read -p "${ib}[#] ${ip}Apakah Anda ingin menginstal kernel linux versi 5.15.5 [Y/n]: " nanya

# Iya
if [[ "${nanya}" == "y" || "${nanya}" == "Y" ]]; then
        :
# Kaga
elif [[ "${nanya}" == "n" || "${nanya}" == "N" ]]; then
        echo -e "${b}[*] ${p}Keluar dari script.${r}"
        exit 0
# Inputan salah
else
        echo -e "${m}[-] ${p}Masukkan tidak valid. Harap masukkan Y/n.${r}"
        exit 1
fi

# Cek apakah kernel linux versi 5.15.5 sudah terinstal apa belum
echo -e "${b}[*] ${p}Mengecek apakah kernel linux versi 5.15.5 sudah terinstal...${r}"
sleep 3
if dpkg -l | grep -q "linux-image-unsigned-5.15.5"; then
        echo -e "${h}[+] ${p}Kernel linux versi 5.15.5 sudah terinstal.${r}"
        echo -e "${b}[*] ${p}Proses instalasi dibatalkan.${r}"
        echo -e "${b}[*] ${p}Keluar dari script.${r}"
        exit 1
else
        echo -e "${m}[-] ${p}Kernel linux versi 5.15.5 belum terinstal.${r}"
        echo -e "${b}[*] ${p}Menginstal kernel linux versi 5.15.5...${r}"
        sleep 3
fi

# Cek koneksi internet
echo -e "${b}[*] ${p}Mengecek koneksi internet Anda...${r}"
sleep 3
if ping -c 1 8.8.8.8 &> /dev/null; then
    echo -e "${h}[+] ${p}Anda memiliki koneksi internet.${r}"
else
    echo -e "${m}[-] ${p}Anda tidak memliki koneksi internet. Pastikan Anda memiliki koneksi internet untuk menggunakan script ini.${r}"
    exit 1
fi

# File deb kernel 5.15.5
file_deb=(
        "https://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb"
        "https://kernel.ubuntu.com/mainline/v5.15.5/amd64/linux-image-unsigned-5.15.5-051505-generic_5.15.5-051505.202111250933_amd64.deb"
        "https://kernel.ubuntu.com/mainline/v5.15.5/amd64/linux-modules-5.15.5-051505-generic_5.15.5-051505.202111250933_amd64.deb"
        "https://kernel.ubuntu.com/mainline/v5.15.5/amd64/linux-headers-5.15.5-051505_5.15.5-051505.202111250933_all.deb"
        "https://kernel.ubuntu.com/mainline/v5.15.5/amd64/linux-headers-5.15.5-051505-generic_5.15.5-051505.202111250933_amd64.deb"
)

# Melakukan blacklist pada driver bawaan kernel Linux
echo -e "${b}[*] ${p}Melakukan blacklist pada driver bawaan kernel Linux...${r}"
sleep 3
if echo 'blacklist r8188eu' | sudo tee '/etc/modprobe.d/realtek.conf'; then
        echo -e "${h}[+] ${p}Driver bawaan kernel Linux 'r8188eu' berhasil di blacklist.${r}"
else
        echo -e "${m}[-] ${p}Gagal melakukan blacklist pada driver bawaan kernel Linux 'r8188eu'.${r}"
        exit 1
fi
if echo 'blacklist rtl8xxxu' | sudo tee -a '/etc/modprobe.d/realtek.conf'; then
        echo -e "${h}[+] ${p}Driver bawaan kernel Linux 'rtl8xxxu' berhasil di blacklist.${r}"
else
        echo -e "${m}[-] ${p}Gagal melakukan blacklist pada driver bawaan kernel Linux 'rtl8xxxu'.${r}"
        exit 1
fi

# Mendownload semua file DEB yang dibutuhkan
echo -e "${b}[*] ${p}Mendownload semua file DEB yang dibutuhkan...${r}"
sleep 3

for download_file in "${file_deb[@]}"; do
        nama_file=$(basename "${download_file}")
        echo -e "${b}[*] ${p}Mendownload file DEB '${nama_file}'...${r}"
        sleep 3
        # Berhasil
        if wget -c "${download_file}"; then
                echo -e "${h}[+] ${p}File DEB '${nama_file}'. berhasil didownload.${r}"
        # Gagal
        else
                echo -e "${m}[-] ${p}Gagal mendownload file DEB '${nama_file}'.${r}"
                exit 1
        fi
done
echo -e "${h}[+] ${p}Semua file DEB yang dibutuhkan berhasil didownload.${r}"

# Menginstal semua file DEB yang dibutuhkan
echo -e "${b}[*] ${p}Menginstal semua file DEB yang dibutuhkan...${r}"
sleep 3
if dpkg -i *.deb; then
        echo -e "${h}[+] ${p}Semua file DEB yang dibutuhkan berhasil diinstal.${r}"
        echo -e "${h}[+] ${p}Kernel linux versi 5.15.5 berhasil diinstal.${r}"

else
        echo -e "${m}[-] ${p}Ada file DEB yang gagal diinstal.${r}"
        echo -e "${b}[*] ${p}Memperbaiki dependensi yang rusak...${r}"
        sleep 3
        if apt --fix-broken install -y; then
                echo -e "${h}[+] ${p}Dependensi berhasil diperbaiki.${r}"
                echo -e "${b}[*] ${p}Mengulang instalasi file DEB...${r}"
                if dpkg -i *.deb; then
                        echo -e "${h}[+] ${p}Kernel linux versi 5.15.5 berhasil diinstal setelah perbaikan.${r}"
                else
                        echo -e "${m}[-] ${p}Masih ada error saat instalasi kernel. Silakan cek manual.${r}"
                        exit 1
                fi
        else
                echo -e "${m}[-] ${p}Gagal memperbaiki dependensi. Silakan cek manual.${r}"
                echo -e "${h}[-] ${p}Gagal menginstal Kernel linux versi 5.15.5.${r}"
                exit 1
        fi
fi

# Memperbarui konfigurasi GRUB
echo -e "${b}[*] ${p}Memperbarui konfigurasi GRUB...${r}"
sleep 3
# Berhasil
if update-grub; then
        echo -e "${h}[+] ${p}Konfigurasi GRUB berhasil diperbarui.${r}"
# Gagal
else
        echo -e "${m}[-] ${p}Gagal memperbarui konfigurasi GRUB.${r}"
        exit 1
fi

# Nanya mau reboot apa kaga
read -p "${ib}[#] ${ip}Apakah Anda ingin me-reboot sistem Anda? [Y/n]: " nanya_reboot

# Iya
if [[ "${nanya_reboot}" == "y" || "${nanya_reboot}" == "Y" ]]; then
        reboot
# Kaga
elif [[ "${nanya_reboot}" == "n" || "${nanya_reboot}" == "N" ]]; then
        echo -e "${b}[*] ${p}Keluar dari script.${r}"
        exit 0
# Inputan salah
else
        echo -e "${m}[-] ${p}Masukkan tidak valid. Harap masukkan Y/n.${r}"
        exit 1
fi

# Selesai
#
# Semoga bermanfaat ^_^
