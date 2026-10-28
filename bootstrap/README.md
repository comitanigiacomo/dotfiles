# Ripristino su un PC nuovo

Obiettivo: installazione Fedora nuova → sistema identico a quello attuale,
con file, configurazioni, applicazioni e servizi.

## Prerequisiti

- Fedora **Workstation** installato, utente **`jack`** (lo snapshot usa `/home/jack`)
- Disco con LUKS + btrfs (come ora); `/home` sullo stesso volume va bene
- Connessione internet
- Bitwarden accessibile (voci `restic laptop` e `restic`)
- Il server raggiungibile: `100.90.133.13` (Tailscale) — se l'IP cambia,
  aggiorna `bootstrap/40-restore-home.sh` e `~/.ssh/config`

## Procedura

```bash
# 1. Clona i dotfiles (repo pubblico: non serve la chiave SSH)
git clone https://github.com/comitanigiacomo/dotfiles.git ~/projects/dotfiles
cd ~/projects/dotfiles

# 2. Ripristino completo (chiede conferma a ogni passo)
bash bootstrap/restore-all.sh

# 3. Riavvia e fai login
sudo reboot
```

Dopo il login:

```bash
sudo tailscale up        # se non e' partito prima
```

In `40-restore-home.sh` la password restic viene riscritta in
`~/.config/backup/restic-password`, quindi il comando `backup-now`
funziona subito senza altri passaggi.

Non ci sono timer ne' servizi di backup: il backup si lancia **a mano**,
una volta al mese, con `backup-now`.

## Cosa fa ogni script

| Script | Cosa fa |
|---|---|
| `10-repos.sh` | RPM Fusion, VS Code, Chrome, Tailscale, mise, Adoptium, Antigravity, COPR |
| `20-packages.sh` | reinstalla i ~570 rpm di `packages/dnf-packages.txt` |
| `30-flatpaks.sh` | Flathub + le 14 app Flatpak |
| `40-restore-home.sh` | crea la chiave SSH, la autorizza sul server, `restic restore latest`, ricrea il file password |
| `50-shell.sh` | zsh, oh-my-zsh, powerlevel10k, plugin, font, shell di login |
| `60-desktop.sh` | `dconf load` + installazione estensioni GNOME |
| `70-apps.sh` | Docker, Tailscale, estensioni VS Code, `mise install` |
| `80-verify.sh` | checklist finale |

Ogni script è idempotente: si può rilanciare singolarmente.

## Da dove arrivano i dati

- **Configurazioni e liste** → questo repo GitHub
- **File personali e config nascoste** → repo restic sul server:
  `sftp:server:/home/jack-server/backups/restic-laptop`
- **Retention**: 7 giornalieri, 4 settimanali, 6 mensili (calcolata sugli snapshot esistenti)
- **Backup**: nessun timer. Si lancia a mano con `backup-now`, una volta al mese

Contenuto del backup restic:

```
~/projects  ~/Documents  ~/personale
~/.zshrc ~/.p10k.zsh ~/.zsh_history ~/.bashrc ~/.bash_profile ~/.gitconfig
~/.ssh  ~/.gnupg  ~/.mozilla  ~/.jdks  ~/.texlive2026
~/.local/bin  ~/.local/share/fonts  ~/.local/share/keyrings
~/.config  (senza cache di Code/Chrome, log Nextcloud)
```

## Cosa NON viene ripristinato

| Cosa | Come recuperarlo |
|---|---|
| Android SDK (`~/Android`) | riscaricato da Android Studio |
| Profili Flatpak (`~/.var`: Zen, Telegram, Prism, Minecraft) | login/nuovo profilo |
| `~/Downloads` | scelta deliberata: non è un archivio |
| Cache, `node_modules`, build | si rigenerano |
| Volumi Docker (DB di sviluppo) | `docker compose up` nei progetti |
| Password del portachiavi | serve la **stessa password di login** di adesso, altrimenti il keyring non si sblocca |

## Ripristini parziali

```bash
# un singolo file
restic restore latest --target /tmp/ripristino --include /home/jack/Documents/qualcosa.pdf

# esplorare senza scrivere
restic ls latest /home/jack/Documents | less

# versione di 3 giorni fa
restic snapshots
restic restore <id> --target /tmp/ripristino
```

## Aggiornare il backup dei dotfiles

```bash
cd ~/projects/dotfiles && ./backup-dotfiles.sh   # poi: git push
```

## Se cambi macchina o utente

Lo snapshot contiene percorsi `/home/jack`. Con un altro nome utente,
ripristina in una directory temporanea e sposta i file a mano.
