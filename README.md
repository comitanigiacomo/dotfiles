# dotfiles

Configurazione di Fedora Workstation: dotfiles, liste pacchetti, script di ripristino.

## Installazione

Su un PC nuovo:

```bash
git clone https://github.com/comitanigiacomo/dotfiles.git ~/projects/dotfiles
cd ~/projects/dotfiles
bash bootstrap/restore-all.sh
```

Serve la password `restic laptop` da Bitwarden. Dettagli in [docs/laptop.md](docs/laptop.md).

## Aggiornamento

```bash
cd ~/projects/dotfiles
./backup-dotfiles.sh
git push
```

## Documentazione

- [docs/laptop.md](docs/laptop.md): se si rompe il laptop
- [docs/server.md](docs/server.md): se si rompe il server
