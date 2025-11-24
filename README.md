
# TP-LINK TL-WN722N V2/V3

![](https://github.com/fixploit03/TP-LINK-TL-WN722N-V2/blob/main/img/wi-fi-adapter-tp-link-tl-wn722n.jpeg)

## Disclaimer

> Repositori ini dibuat hanya untuk tujuan edukasi dan pembelajaran terkait perangkat TP-LINK TL-WN722N V2/V3, driver Linux, serta pengujian jaringan (network testing).
> 
> Semua informasi, tutorial, dan konfigurasi yang disediakan di dalam repositori ini tidak ditujukan untuk aktivitas ilegal atau penyalahgunaan terhadap jaringan yang bukan milik sendiri atau tanpa izin tertulis dari pemiliknya.
> 
> Penulis tidak bertanggung jawab atas segala bentuk kerusakan, pelanggaran hukum, kehilangan data, atau konsekuensi lain yang timbul akibat penggunaan informasi dari repositori ini, baik secara langsung maupun tidak langsung.

## Persyaratan

- PC/Laptop
- VirtualBox/VMware
- Kali Linux 2025.3
- Adapter Wi-Fi TP-LINK TL-WN722N V2/V3
- Koneksi internet

## Informasi Hardware

- **Chipset**: Realtek RTL8188EUS
- **Vendor ID (VID)**: 2357
- **Product ID (PID)**: 010C
- **Interface**: USB 2.0
- **Standar Wi-Fi**: 802.11 b/g/n (2.4 GHz)
- **Antena**: 4dBi
- **Kecepatan Maksimal**: 150 Mbps

## Informasi Driver dan Firmware

- **Driver**:
  - `rtl8xxxu` (Driver bawaan kernel)
  - `8188eu` (Driver alternatif)
- **Firmware**: `rtl8188eufw.bin`

## Masalah

![](https://github.com/fixploit03/TP-LINK-TL-WN722N-V2/blob/main/img/4.png)

Saat menggunakan adapter Wi-Fi TP-LINK TL-WN722N (V2/V3), sering mengalami masalah saat dipakai di Kali Linux, terutama saat melakukan scanning Wi-Fi dengan `airodump-ng`. Target Access Point kadang tidak muncul atau bahkan tidak terdeteksi sama sekali.

## Cara Mengatasi Masalah

### Cara Ke-1 (Langsung Running)

1. Cek apakah USB terdeteksi:

   ```
   lsusb
   ```

   Pastikan muncul output seperti ini:

   ```
   Bus 001 Device 002: ID 2357:010c TP-Link TL-WN722N v2/v3 [Realtek RTL8188EUS]
   ```
1. Cek apakah driver sudah didukung oleh kernel Linux:

   ```
   dmesg
   ```

   Kalau muncul output seperti ini:

   ```
   [  151.887560] usb 1-1: RTL8188EU rev D (TSMC) romver 0, 1T1R, TX queues 2, WiFi=1, BT=0, GPS=0, HI PA=0
   [  151.887568] usb 1-1: RTL8188EU MAC: 9c:53:22:84:f7:f9
   [  151.887572] usb 1-1: rtl8xxxu: Loading firmware rtlwifi/rtl8188eufw.bin
   [  151.890620] usb 1-1: Firmware revision 28.0 (signature 0x88e1)
   [  155.785883] usbcore: registered new interface driver rtl8xxxu
   ```

   Itu artinya, driver didukung oleh kernel Linux.
1. Cek apakah interfacenya muncul:

   ```
   iwconfig
   ```

   Pastikan muncul output seperti ini

   ```
   wlan0     IEEE 802.11  ESSID:off/any  
             Mode:Managed  Access Point: Not-Associated   Tx-Power=20 dBm   
             Retry short limit:7   RTS thr=2347 B   Fragment thr:off
             Encryption key:off
             Power Management:off
   ```
1. Hentikan semua proses yang dapat mengganggu:

   ```
   airmon-ng check kill
   ```
1. Ubah mode interface ke mode Monitor:

   Menggunakan `airmon-ng`:

   ```
   airmon-ng start wlan0
   ```

   Atau secara manual:
   
   ```
   ifconfig wlan0 down
   iw dev wlan0 set type monitor
   ifconfig wlan0 up
   ```
1. Verifikasi perubahan:

   ```
   iwconfig
   ```

   Pastikan muncul output seperti ini:

   ```
   wlan0     IEEE 802.11  Mode:Monitor  Frequency:2.412 GHz  Tx-Power=20 dBm   
             Retry short limit:7   RTS thr=2347 B   Fragment thr:off
             Power Management:off
   ```
1. Tes packet injection:

   ```
   aireplay-ng -9 wlan0
   ```

   Kalau muncul output seperti ini:

   ```
   21:06:24  Trying broadcast probe requests...
   21:06:26  No Answer...
   21:06:26  Found 0 APs
   ```

   Itu artinya, ada masalah pada packet injectionnya dan tidak bisa digunakan.

   Kalau muncul output seperti ini:
   
   ```
   21:18:07  Trying broadcast probe requests...
   21:18:07  Injection is working!
   21:18:09  Found 1 AP 

   21:18:09  Trying directed probe requests...
   21:18:09  E2:91:1E:D6:36:FB - channel: 11 - 'realme 3 Pro'
   21:18:10  Ping (min/avg/max): 3.668ms/11.966ms/18.433ms Power: -93.00
   21:18:10  30/30: 100%
   ```

   Itu artinya, tidak ada masalah pada packet injectionnya dan bisa digunakan.

### Cara Ke-2 (Instal Driver Via APT + DKMS)

Kalau cara pertama gagal, bisa menggunakan cara kedua. Ini caranya:

1. Cek versi kernel yang digunakan saat ini:
   
   ```
   uname -r
   ```
   
   Outputnya:
   
   ```
   6.12.38+kali-amd64
   ```
1. Instal driver:
   
   ```
   apt-get update
   apt-get install realtek-rtl8188eus-dkms
   ```
   
   Kalau muncul output seperti ini:
   
   ```
   Hit:1 http://http.kali.org/kali kali-rolling InRelease
   Reading package lists... Done
   Reading package lists... Done
   Building dependency tree... Done
   Reading state information... Done
   The following additional packages will be installed:
     dkms
   Suggested packages:
     menu
   The following NEW packages will be installed:
     dkms realtek-rtl8188eus-dkms
   0 upgraded, 2 newly installed, 0 to remove and 1183 not upgraded.
   Need to get 0 B/1,553 kB of archives.
   After this operation, 12.3 MB of additional disk space will be used.
   Do you want to continue? [Y/n] y
   Selecting previously unselected package dkms.
   (Reading database ... 416664 files and directories currently installed.)
   Preparing to unpack .../archives/dkms_3.2.2-1_all.deb ...
   Unpacking dkms (3.2.2-1) ...
   Selecting previously unselected package realtek-rtl8188eus-dkms.
   Preparing to unpack .../realtek-rtl8188eus-dkms_5.3.9~git20250929.52bd147-0kali1_all.deb ...
   Unpacking realtek-rtl8188eus-dkms (5.3.9~git20250929.52bd147-0kali1) ...
   Setting up dkms (3.2.2-1) ...
   Setting up realtek-rtl8188eus-dkms (5.3.9~git20250929.52bd147-0kali1) ...
   Loading new realtek-rtl8188eus/5.3.9~git20250929.52bd147 DKMS files...
   WARNING: No kernel headers were found, skipping module build.
            To get the headers for the running kernel (6.12.38+kali-amd64)
            please install the linux-headers-6.12.38+kali-amd64 package.
   Processing triggers for man-db (2.13.1-1) ...
   Processing triggers for kali-menu (2025.3.2) ...
   ```
   
   Itu artinya, driver gagal diinstal melalui APT + DKMS karena muncul output `WARNING: No kernel headers were found`, yang menandakan kernel headers belum terpasang. Untuk memastikan, bisa dicek status DKMS-nya.

   ```
   dkms status
   ```

   Outputnya:
   
   ```
   realtek-rtl8188eus/5.3.9~git20250929.52bd147: added
   ```
   
   Untuk menginstal kernel headers nya gunakan perintah ini:

   ```
   apt-get install linux-headers-6.12.38+kali-amd64
   ```

   Kalau muncul output error seperti ini:

   ```
   Reading package lists... Done
   Building dependency tree... Done
   Reading state information... Done
   E: Unable to locate package linux-headers-6.12.38+kali-amd64
   E: Couldn't find any package by glob 'linux-headers-6.12.38+kali-amd64'
   E: Couldn't find any package by regex 'linux-headers-6.12.38+kali-amd64'                                                                      
   ```

   Itu artinya, paket `linux-headers-6.12.38+kali-amd64` tidak ada di repositori Kali Linux.

   Solusinya, cari paket kernel headers nya yang ada di repositori Kali Linux menggunakan perintah ini:

   ```
   apt search linux-headers
   ```

   Cari yang belakangnya `+kali-amd64`.

   Instal kernel headers:

   ```
   apt-get install linux-headers-6.16.8+kali-amd64
   ```

   Blacklist driver bawaan kernel:

   ```
   nano /etc/modprobe.d/blacklist-rtl8xxxu.conf
   ```

   Isi dengan:

   ```
   blacklist rtl8xxxu
   blacklist r8188eu
   ```

   Unload driver lama dan load driver baru:
   
   ```
   modprobe -r rtl8xxxu
   modprobe 8188eu
   ```

   Restart Kali Linux:

   ```
   reboot
   ```

   Pilih yang **Advanced options for Kali GNU/Linux**:
   
   ![](https://github.com/fixploit03/TP-LINK-TL-WN722N-V2/blob/main/img/1.png)

   Pilih yang **Kali GNU/Linux, with Linux 6.16.8** yang paling atas:
   
   ![](https://github.com/fixploit03/TP-LINK-TL-WN722N-V2/blob/main/img/2.png)
1. Cek versi kernel yang digunakan saat ini:
   
   ```
   uname -r
   ```
   
   Outputnya:
   
   ```
   6.16.8+kali-amd64
   ```
   
   Versi kernel sudah diperbarui yang tadinya versi `6.12.38+kali-amd64` menjadi versi `6.16.8+kali-amd64`.
1. Pastikan driver sudah benar:
   
   ```
   ethtool -i wlan0
   ```

   Outputnya:

   ```
   driver: 8188eu
   ```
1. Instal lagi drivernya:
   
   ```
   apt-get install realtek-rtl8188eus-dkms
   ```
   
   Kalau muncul output seperti ini:
   
   ```
   Reading package lists... Done
   Building dependency tree... Done
   Reading state information... Done
   realtek-rtl8188eus-dkms is already the newest version (5.3.9~git20250929.52bd147-0kali1).
   0 upgraded, 0 newly installed, 0 to remove and 1171 not upgraded.
   ```
   
   Itu artinya, driver berhasil diinstal via APT + DKMS.

   Cek statusnya:
   
   ```
   dkms status
   ```
   
   Outputnya:
   
   ```
   realtek-rtl8188eus/5.3.9~git20250929.52bd147, 6.16.8+kali-amd64, x86_64: installed
   ```
1. Cek apakah interfacenya muncul:
   
   ```
   iwconfig
   ```
   
   Pastikan muncul output seperti ini:
   
   ```
   wlan0     unassociated  Nickname:"<WIFI@REALTEK>"
             Mode:Auto  Frequency=2.412 GHz  Access Point: Not-Associated   
             Sensitivity:0/0  
             Retry:off   RTS thr:off   Fragment thr:off
             Power Management:off
             Link Quality:0  Signal level:0  Noise level:0
             Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
             Tx excessive retries:0  Invalid misc:0   Missed beacon:0
   ```
1. Hentikan semua proses yang dapat mengganggu:
   
   ```
   airmon-ng check kill
   ```
1. Ubah mode interface ke mode Monitor:
   
   Menggunakan `airmon-ng`:
   
   ```
   airmon-ng start wlan0
   ```
   
   Atau secara manual:
   
   ```
   ifconfig wlan0 down
   iw dev wlan0 set type monitor
   ifconfig wlan0 up
   ```
1. Verifikasi perubahan:
   
   ```
   iwconfig
   ```
   
   Pastikan muncul output seperti ini:
   
   ```
   wlan0     unassociated  Nickname:"<WIFI@REALTEK>"
             Mode:Monitor  Frequency=2.457 GHz  Access Point: Not-Associated   
             Sensitivity:0/0  
             Retry:off   RTS thr:off   Fragment thr:off
             Encryption key:off
             Power Management:off
             Link Quality:0  Signal level:0  Noise level:0
             Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
             Tx excessive retries:0  Invalid misc:0   Missed beacon:0
   ```
1. Tes packet injection:
    
   ```
   aireplay-ng -9 wlan0
   ```
   
   Kalau muncul output seperti ini:

   ```
   21:06:24  Trying broadcast probe requests...
   21:06:26  No Answer...
   21:06:26  Found 0 APs
   ```

   Itu artinya, ada masalah pada packet injectionnya dan tidak bisa digunakan.
   
   Kalau muncul output seperti ini:

   ```
   21:18:07  Trying broadcast probe requests...
   21:18:07  Injection is working!
   21:18:09  Found 1 AP 

   21:18:09  Trying directed probe requests...
   21:18:09  E2:91:1E:D6:36:FB - channel: 11 - 'realme 3 Pro'
   21:18:10  Ping (min/avg/max): 3.668ms/11.966ms/18.433ms Power: -93.00
   21:18:10  30/30: 100%
   ```

   Itu artinya, tidak ada masalah pada packet injectionnya dan bisa digunakan.
   
### Cara Ke-3 (Instal Driver Secara Manual)

Kalau cara pertama dan kedua gagal, bisa menggunakan cara ketiga. Ini caranya:

1. Instal semua dependensi yang dibutuhkan:

   ```
   apt-get install dkms git build-essential linux-headers-$(uname -r) bc
   ```
1. Kloning driver:

   ```
   git clone https://github.com/aircrack-ng/rtl8188eus.git
   ```
1. Pindah ke direktori driver:

   ```
   cd rtl8188eus
   ```
1. Blacklist driver bawaan kernel:

   ```
   nano /etc/modprobe.d/blacklist-rtl8xxxu.conf
   ```

   Isi dengan:

   ```
   blacklist rtl8xxxu
   blacklist r8188eu
   ```
1. Instal driver:

   Ada 2 metode untuk menginstal driver secara manual, yaitu:

   - Compile
   - Via DKMS

   **Compile** adalah cara menginstal driver dengan membuatnya langsung dari source code supaya cocok dengan kernel yang sedang digunakan. Caranya, download source code driver, lalu compile menggunakan `make` agar bisa dipakai di sistem. Metode ini lebih fleksibel dan berguna jika driver belum tersedia di repositori resmi, namun setiap kali kernel diperbarui, driver harus di-compile ulang.

   **Via DKMS** adalah cara menginstal driver sehingga sistem akan otomatis mengurus proses compile setiap kali kernel diperbarui. Dengan cara ini, driver akan tetap terpasang dan kompatibel dengan kernel terbaru tanpa perlu compile manual. Metode ini lebih praktis dan stabil untuk penggunaan jangka panjang, terutama untuk driver yang sensitif terhadap versi kernel.

   **Compile**:

   ```
   # 1. Compile driver
   $ make

   # 2. Instal modul hasil compile ke sistem
   $ make install

   # 3. Unload driver lama
   modprobe -r rtl8xxxu

   # 4. Load driver baru
   modprobe 8188eu

   # 5. Restart Kali Linux
   $ reboot
   ```

   Kalau muncul output error seperti ini pada saat kompilasi:

   ```
   make ARCH=x86_64 CROSS_COMPILE= -C /lib/modules/6.16.8+kali-amd64/build M=/root/rtl8188eus  modules
   make[1]: Entering directory '/usr/src/linux-headers-6.16.8+kali-amd64'
   make[2]: Entering directory '/root/rtl8188eus'
     CC [M]  core/rtw_cmd.o
   core/rtw_cmd.c:17:10: fatal error: drv_types.h: No such file or directory
      17 | #include <drv_types.h>
         |          ^~~~~~~~~~~~~
   compilation terminated.
   make[4]: *** [/usr/src/linux-headers-6.16.8+kali-common/scripts/Makefile.build:292: core/rtw_cmd.o] Error 1
   make[3]: *** [/usr/src/linux-headers-6.16.8+kali-common/Makefile:2027: .] Error 2
   make[2]: *** [/usr/src/linux-headers-6.16.8+kali-common/Makefile:260: __sub-make] Error 2
   make[2]: Leaving directory '/root/rtl8188eus'
   make[1]: *** [/usr/src/linux-headers-6.16.8+kali-common/Makefile:260: __sub-make] Error 2
   make[1]: Leaving directory '/usr/src/linux-headers-6.16.8+kali-amd64'
   make: *** [Makefile:2065: modules] Error 2
   ```

   Error tersebut terjadi karena source driver `rtl8188eus` yang sedang dikompilasi tidak kompatibel dengan kernel Kali Linux versi `6.16.8`. Source code driver masih memanggil header `drv_types.h`, sementara file tersebut tidak ditemukan atau sudah tidak disertakan dalam struktur driver maupun tidak lagi sesuai dengan perubahan API pada kernel terbaru. Akibatnya, proses kompilasi gagal karena compiler tidak dapat menemukan dependensi yang dibutuhkan oleh file `rtw_cmd.c`.

   Dengan kata lain, driver yang digunakan merupakan versi lama yang belum mendukung kernel modern, sehingga terjadi konflik saat proses build dan menyebabkan error kompilasi.

   Bersihkan menggunakan:

   ```
   make clean
   ```

   Coba instal Via DKMS.
   
   **Via DKMS**:

   ```
   # 1. Instal driver Via DKMS
   $ ./dkms-install.sh

   # 2. Unload driver lama
   modprobe -r rtl8xxxu

   # 3. Load driver baru
   modprobe 8188eu

   # 4. Restart Kali Linux
   $ reboot
   ```

   Kalau muncul output error seperti ini pada saat menginstal driver via DKMS:

   ```
   About to run dkms install steps...
   Deprecated feature: REMAKE_INITRD (/usr/src/8188eu-5.3.9/dkms.conf)
   Creating symlink /var/lib/dkms/8188eu/5.3.9/source -> /usr/src/8188eu-5.3.9
   Deprecated feature: REMAKE_INITRD (/var/lib/dkms/8188eu/5.3.9/source/dkms.conf)
   Sign command: /lib/modules/6.16.8+kali-amd64/build/scripts/sign-file
   Signing key: /var/lib/dkms/mok.key
   Public certificate (MOK): /var/lib/dkms/mok.pub

   Building module(s)...(bad exit status: 2)
   Failed command:
   'make' -j3 KVER=6.16.8+kali-amd64 KSRC=/lib/modules/6.16.8+kali-amd64/build

   Error! Bad return status for module build on kernel: 6.16.8+kali-amd64 (x86_64)
   Consult /var/lib/dkms/8188eu/5.3.9/build/make.log for more information.
   Deprecated feature: REMAKE_INITRD (/var/lib/dkms/8188eu/5.3.9/source/dkms.conf)
   Sign command: /lib/modules/6.16.8+kali-amd64/build/scripts/sign-file
   Signing key: /var/lib/dkms/mok.key
   Public certificate (MOK): /var/lib/dkms/mok.pub

   Building module(s)...(bad exit status: 2)
   Failed command:
   'make' -j3 KVER=6.16.8+kali-amd64 KSRC=/lib/modules/6.16.8+kali-amd64/build

   Error! Bad return status for module build on kernel: 6.16.8+kali-amd64 (x86_64)
   Consult /var/lib/dkms/8188eu/5.3.9/build/make.log for more information.
   Finished running dkms install steps.
   ```
   
   Error ini terjadi karena driver `8188eu` yang dipasang lewat DKMS tidak kompatibel dengan kernel `6.16.8`, sehingga proses kompilasi modul gagal (`bad exit status: 2`). Peringatan `Deprecated feature: REMAKE_INITRD` hanyalah peringatan, sedangkan penyebab utama kegagalan adalah source driver lama yang tidak cocok dengan kernel modern. Solusinya, gunakan driver versi terbaru yang mendukung kernel `6.x` atau driver bawaan `rtl8xxxu`.

   Bersihkan menggunakan:

   ```
   dkms remove 8188eu/5.3.9 --all
   ```
   
   Kalau tidak ada error pada saat kompilasi baik menggunakan metode Compile atau Via DKMS bisa ke langkah selanjutnya.
1. Restart Kali Linux:

   ```
   reboot
   ```
1. Pastikan driver sudah benar:

   ```
   ethtool -i wlan0
   ```

   Outputnya:

   ```
   driver: 8188eu
   ```
1. Cek apakah interfacenya muncul:
   
   ```
   iwconfig
   ```
   
   Pastikan muncul output seperti ini:
   
   ```
   wlan0     unassociated  Nickname:"<WIFI@REALTEK>"
             Mode:Auto  Frequency=2.412 GHz  Access Point: Not-Associated   
             Sensitivity:0/0  
             Retry:off   RTS thr:off   Fragment thr:off
             Power Management:off
             Link Quality:0  Signal level:0  Noise level:0
             Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
             Tx excessive retries:0  Invalid misc:0   Missed beacon:0
   ```
1. Hentikan semua proses yang dapat mengganggu:
   
   ```
   airmon-ng check kill
   ```
1. Ubah mode interface ke mode Monitor:
   
   Menggunakan `airmon-ng`:
   
   ```
   airmon-ng start wlan0
   ```
   
   Atau secara manual:
   
   ```
   ifconfig wlan0 down
   iw dev wlan0 set type monitor
   ifconfig wlan0 up
   ```
1. Verifikasi perubahan:
   
   ```
   iwconfig
   ```
   
   Pastikan muncul output seperti ini:
   
   ```
   wlan0     unassociated  Nickname:"<WIFI@REALTEK>"
             Mode:Monitor  Frequency=2.457 GHz  Access Point: Not-Associated   
             Sensitivity:0/0  
             Retry:off   RTS thr:off   Fragment thr:off
             Encryption key:off
             Power Management:off
             Link Quality:0  Signal level:0  Noise level:0
             Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
             Tx excessive retries:0  Invalid misc:0   Missed beacon:0
   ```
1. Tes packet injection:
    
   ```
   aireplay-ng -9 wlan0
   ```
   
   Kalau muncul output seperti ini:

   ```
   21:06:24  Trying broadcast probe requests...
   21:06:26  No Answer...
   21:06:26  Found 0 APs
   ```

   Itu artinya, ada masalah pada packet injectionnya dan tidak bisa digunakan.
   
   Kalau muncul output seperti ini:

   ```
   21:18:07  Trying broadcast probe requests...
   21:18:07  Injection is working!
   21:18:09  Found 1 AP 

   21:18:09  Trying directed probe requests...
   21:18:09  E2:91:1E:D6:36:FB - channel: 11 - 'realme 3 Pro'
   21:18:10  Ping (min/avg/max): 3.668ms/11.966ms/18.433ms Power: -93.00
   21:18:10  30/30: 100%
   ```

   Itu artinya, tidak ada masalah pada packet injectionnya dan bisa digunakan.

### Cara Ke-4 (Downgrade Versi Kernel)

Kalau cara pertama, kedua, dan ketiga gagal, bisa menggunakan cara keempat. Ini caranya:

> Menggunakan kernel versi lama berarti sistem tidak lagi mendapatkan update keamanan dan patch bug terbaru, sehingga lebih rentan terhadap serangan. Selain itu, hardware modern mungkin tidak terdeteksi dengan baik dan beberapa aplikasi dapat mengalami error atau crash karena ketidakcocokan versi.

1. Download kernel versi 5.15.5:

   ```
   wget https://raw.githubusercontent.com/fixploit03/TP-LINK-TL-WN722N-V2/refs/heads/main/scripts/instal_kernel_linux_5.15.5.sh
   ```
1. Beri izin eksekusi:

   ```
   chmod +x instal_kernel_linux_5.15.5.sh
   ```
1. Jalankan scriptnya:

   ```
   ./instal_kernel_linux_5.15.5.sh
   ```
1. Pilih yang **Kali GNU/Linux, with Linux 5.15.5** yang atas:

   ![](https://github.com/fixploit03/TP-LINK-TL-WN722N-V2/blob/main/img/3.png)
1. Cek versi kernel yang digunakan saat ini:

   ```
   uname -r
   ```

   Outputnya:

   ```
   5.15.5-051505-generic
   ```
1. Cek apakah interfacenya muncul:
   
   ```
   iwconfig
   ```
   
   Pastikan muncul output seperti ini:
   
   ```
   wlan0     unassociated  Nickname:"<WIFI@REALTEK>"
             Mode:Auto  Frequency=2.412 GHz  Access Point: Not-Associated   
             Sensitivity:0/0  
             Retry:off   RTS thr:off   Fragment thr:off
             Encryption key:off
             Power Management:off
             Link Quality=0/100  Signal level=0 dBm  Noise level=0 dBm
             Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
             Tx excessive retries:0  Invalid misc:0   Missed beacon:0
   ```
1. Hentikan semua proses yang dapat mengganggu:
   
   ```
   airmon-ng check kill
   ```
1. Ubah mode interface ke mode Monitor:
   
   Menggunakan `airmon-ng`:
   
   ```
   airmon-ng start wlan0
   ```
   
   Atau secara manual:
   
   ```
   ifconfig wlan0 down
   iw dev wlan0 set type monitor
   ifconfig wlan0 up
   ```
1. Verifikasi perubahan:
   
   ```
   iwconfig
   ```
   
   Pastikan muncul output seperti ini:
   
   ```
   wlan0     unassociated  Nickname:"<WIFI@REALTEK>"
             Mode:Monitor  Frequency=2.457 GHz  Access Point: Not-Associated   
             Sensitivity:0/0  
             Retry:off   RTS thr:off   Fragment thr:off
             Power Management:off
             Link Quality=0/100  Signal level=0 dBm  Noise level=0 dBm
             Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
             Tx excessive retries:0  Invalid misc:0   Missed beacon:0
   ```
1. Tes packet injection:
    
   ```
   aireplay-ng -9 wlan0
   ```
   
   Kalau muncul output seperti ini:

   ```
   21:06:24  Trying broadcast probe requests...
   21:06:26  No Answer...
   21:06:26  Found 0 APs
   ```

   Itu artinya, ada masalah pada packet injectionnya dan tidak bisa digunakan.
   
   Kalau muncul output seperti ini:

   ```
   21:18:07  Trying broadcast probe requests...
   21:18:07  Injection is working!
   21:18:09  Found 1 AP 

   21:18:09  Trying directed probe requests...
   21:18:09  E2:91:1E:D6:36:FB - channel: 11 - 'realme 3 Pro'
   21:18:10  Ping (min/avg/max): 3.668ms/11.966ms/18.433ms Power: -93.00
   21:18:10  30/30: 100%
   ```

   Itu artinya, tidak ada masalah pada packet injectionnya dan bisa digunakan.

## Screenshot

### Hasil tes menggunakan Wifite:

![](https://github.com/fixploit03/TP-LINK-TL-WN722N-V2/blob/main/img/5.png)

### Hasil tes menggunakan Airodump-NG:

![](https://github.com/fixploit03/TP-LINK-TL-WN722N-V2/blob/main/img/6.png)

## Mengubah Mode `Monior` ke `Managed`

1. Menggunakan `airmon-ng`:

   ```
   airmon-ng stop wlan0
   systemctl restart NetworkManager
   ```
2. Secara manual:

   ```
   ifconfig wlan0 down
   iw dev wlan0 set type managed
   ifconfig wlan0 up
   systemctl restart NetworkManager
   ```
3. Tes koneksi internet:

   ```
   ping google.com
   ```

## Kesimpulan

TP-LINK TL-WN722N V2/V3 masih dapat digunakan di Kali Linux, namun memiliki banyak keterbatasan, terutama dalam penggunaan mode `Monitor` dan packet injection karena chipset Realtek RTL8188EUS yang kurang stabil di kernel Linux terbaru. Berbagai metode seperti instalasi driver tambahan atau downgrade kernel memang dapat menjadi solusi sementara, tetapi tidak menjamin kestabilan dan performa yang optimal.

Untuk kebutuhan pentesting yang serius dan jangka panjang, penggunaan TL-WN722N V2/V3 tidak direkomendasikan. Sebagai alternatif, lebih disarankan menggunakan TL-WN722N V1 atau adapter Wi-Fi dengan chipset Atheros yang telah terbukti lebih stabil dan kompatibel.

## Issues & Pertanyaan

Jika Anda mengalami masalah atau memiliki pertanyaan, silakan tanyakan di bagian [Issues](https://github.com/fixploit03/TP-LINK-TL-WN722N-V2/issues).

## Credits

- Realtek - [https://www.realtek.com](https://www.realtek.com)
- Kali Linux - [https://www.kali.org](https://www.kali.org)
- Aircrack-NG - [https://www.aircrack-ng.org](https://www.aircrack-ng.org)
- Wifite - [https://github.com/derv82/wifite2](https://github.com/derv82/wifite2)
- Fixploit03 - [https://github.com/fixploit03](https://github.com/fixploit03)
  
Dan semua orang yang mungkin menggunakan atau berkontribusi dalam bentuk apa pun. Terima kasih!
