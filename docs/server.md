# Se si rompe il server

Serve: password `restic` (Bitwarden), account Microsoft, un disco nuovo.

## 1. Debian

Installa Debian e crea l'utente `jack-server`.

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install docker.io docker-compose-v2 rclone restic -y
```

## 2. Password del backup

```bash
sudo mkdir -p /root/.config/restic
sudo nano /root/.config/restic/password
```

Incolla la password `restic` da Bitwarden, poi Ctrl+O, Invio, Ctrl+X.

## 3. Rclone temporaneo

Serve solo per scaricare: la configurazione vera è dentro il backup.

```bash
sudo rclone config
```

`n` per un nuovo remote, nome `onedrive_uni`, tipo `onedrive`, Client ID e Secret
vuoti, poi login con l'account Microsoft.

## 4. Ripristino

```bash
sudo restic -o rclone.program="rclone --config /root/.config/rclone/rclone.conf" \
  -r rclone:onedrive_uni:ResticBackup \
  --password-file /root/.config/restic/password \
  restore latest --target /
```

Sono ~28 GB: ci vuole tempo.

## 5. Container

```bash
for d in /home/jack-server/docker/*/; do
  [ -f "$d/docker-compose.yml" ] && (cd "$d" && sudo docker compose up -d)
done
```

## 6. Backup automatico

```bash
sudo crontab -e
```

Aggiungi questa riga:

```
30 3 * * * /home/jack-server/scripts/restic_backup.sh
```

Poi verifica:

```bash
sudo /home/jack-server/scripts/restic_backup.sh
grep Esiti ~/scripts/backup.log | tail -1
```

Deve finire con `backup=0 forget=0 check=0 read-data=0`.

## Cosa contiene il backup

`docker/` (Immich, Nextcloud, Vaultwarden, Minecraft e gli altri container),
`scripts/`, `.config/rclone/`, `/root/.config/restic/`, `backups/restic-laptop/`, `.ssh/`.

Destinazione: `rclone:onedrive_uni:ResticBackup`, ogni giorno alle 03:30.
