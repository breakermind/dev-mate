# Instalacja dla desktop: lemp, vhosts, php-fpm, postfix, ufw firewall, tools, mate-tweak

```sh
sudo bash desktop.sh
```

## Instalacja systemu (user: max)
Podczas ponownej instalacji nie formatuj drugiej partycji pliki i ustawienia użytkowników zostaną na dysku.
```txt
Instalując system utwórz cztery linuksowe partycje (ext4):
- główna z punktem montowania (/) na system
- druga (/home) na pliki i ustawienia użytkowników (ikony, skórki, klucze ssh, strony www)
- trzecia (swap) ok 4GB na pliki tymczasowe
- czwartą partycję windows (fat32) na backup plików.
```
