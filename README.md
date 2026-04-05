# Instal Driver TP-LINK TL-WN722N V2/V3 di Kali Linux

![](https://github.com/fixploit03/TP-LINK-TL-WN722N-V2/blob/main/img/wi-fi-adapter-tp-link-tl-wn722n.jpeg)

## Informasi Hardware
- Chipset: Realtek RTL8188EUS
- Vendor ID (VID): 2357
- Product ID (PID): 010C
- Interface: USB 2.0
- Standar Wi-Fi: 802.11 b/g/n (2.4 GHz)
- Antena: 4dBi
- Kecepatan Maksimal: 150 Mbps

## Instalasi

### Instal Melalui APT

```bash
sudo apt-get update
sudo apt-get install dkms linux-headers-$(uname -r)
sudo apt-get install realtek-rtl8188eus-dkms
echo 'blacklist r8188eu' | sudo tee -a /etc/modprobe.d/realtek.conf
echo 'blacklist rtl8xxxu' | sudo tee -a /etc/modprobe.d/realtek.conf
sudo rmmod r8188eu rtl8xxxu 8188eu
sudo modprobe 8188eu
```

### Instal Secara Manual

```bash
sudo apt-get update
sudo apt-get install dkms git build-essential linux-headers-$(uname -r) bc
git clone https://github.com/aircrack-ng/rtl8188eus.git
cd rtl8188eus
make
sudo make install
echo 'blacklist r8188eu' | sudo tee -a /etc/modprobe.d/realtek.conf
echo 'blacklist rtl8xxxu' | sudo tee -a /etc/modprobe.d/realtek.conf
sudo rmmod r8188eu rtl8xxxu 8188eu
sudo modprobe 8188eu
```

## Verifikasi

```bash
lsmod | grep "8188eu"
```

## Testing

![](https://github.com/fixploit03/TP-LINK-TL-WN722N-V2/blob/main/img/6.png)
![](https://github.com/fixploit03/TP-LINK-TL-WN722N-V2/blob/main/img/5.png)

## Masalah

Kalau ada masalah atau kendala saat proses instalasi, bisa ditanyakan [di sini](https://github.com/fixploit03/TP-LINK-TL-WN722N-V2/issues).

## Credits
- [https://github.com/aircrack-ng/rtl8188eus](https://github.com/aircrack-ng/rtl8188eus)
- [https://github.com/fixploit03/TP-LINK-TL-WN722N-V2](https://github.com/fixploit03/TP-LINK-TL-WN722N-V2)
