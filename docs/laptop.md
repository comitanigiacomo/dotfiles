# Se si rompe il laptop

Serve: Fedora Workstation, utente `jack`, internet, password `restic laptop`
(Bitwarden) e password di `jack-server`.

## 1. Fedora

Installa Fedora Workstation creando l'utente `jack`. Il backup contiene `/home/jack`.

## 2. Ripristino

```bash
git clone https://github.com/comitanigiacomo/dotfiles.git ~/projects/dotfiles
cd ~/projects/dotfiles
bash bootstrap/restore-all.sh
```

Ogni passo chiede conferma; con `--yes` li esegue tutti.

Al passo 4 chiede la password `restic laptop`. Al primo collegamento al server
chiede anche la password di `jack-server`, per autorizzare la chiave SSH nuova.

## 3. Dopo il riavvio

```bash
sudo tailscale up
```

## Cosa resta a mano

- Nextcloud: login, poi le due cartelle (`~/projects`, `~/Documents`)
- Android Studio: riscarica l'SDK
- Profili Flatpak: Zen, Telegram, Prism/Minecraft
- Portachiavi: serve la stessa password di login

## Backup

Non ci sono timer. Una volta al mese:

```bash
backup-now
```

## Ripristino parziale

```bash
restic ls latest /home/jack/Documents | less
restic restore latest --target /tmp/x --include /home/jack/Documents/file.pdf
restic snapshots
```
