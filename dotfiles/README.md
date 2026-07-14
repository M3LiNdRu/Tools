# Dotfiles

Personal shell and Git configuration files for a Debian/WSL2 development environment.

---

## Files

### `.bashrc`

Interactive Bash shell configuration. Key features:

| Feature | Details |
|---|---|
| **History** | Deduplication via `HISTCONTROL=ignoreboth`; 1 000 commands in memory, 2 000 on disk; always appended (never overwritten) |
| **Prompt** | `user@host path (git-branch) $` — current directory in green, Git branch in yellow |
| **GPG as SSH agent** | `SSH_AUTH_SOCK` is redirected to the `gpg-agent` socket so GPG manages SSH keys; `GPG_TTY` is exported and the agent is refreshed on every shell start |
| **`gpg-connect` alias** | Shorthand for `gpg-connect-agent updatestartuptty /bye` — refreshes the GPG agent TTY |
| **`vs` function** | Launches **Visual Studio Pro 2022** from WSL without UNC path warnings. Usage: `vs` (open VS), `vs .` (open first `*.sln` in current dir), `vs <path>` (open specific solution) |
| **NVM** | Loads [Node Version Manager](https://github.com/nvm-sh/nvm) and its Bash completion if `~/.nvm` exists |
| **Bash completion** | Sources system-wide completion scripts (`/usr/share/bash-completion/bash_completion` or `/etc/bash_completion`) |
| **Colour `ls`** | `ls --color=auto` alias when `dircolors` is available |

### `.gitconfig`

Global Git configuration.

| Setting | Value |
|---|---|
| **Editor** | `vim` |
| **User name** | Roger Calaf Planell |
| **User email** | roger.calaf@gmail.com |
| **GPG signing** | Enabled for every commit (`gpgsign = true`) |
| **Signing key** | `69E6996256E762B1` (full fingerprint `A6826CDBE45ED628CF9885D969E6996256E762B1`) |
| **GPG program** | `/usr/bin/gpg` |
| **`git logline`** | Alias for `git log --oneline` |
| **Credential helper** | `store` with `useHttpPath = true` (credentials stored per URL path) |

---

## Copying to a target machine

### 1. Clone or download this repo

```bash
git clone git@github.com:M3LiNdRu/Tools.git ~/apps/Tools
```

### 2. Copy the dotfiles to `$HOME`

```bash
cp ~/apps/Tools/dotfiles/.bashrc    ~/.bashrc
cp ~/apps/Tools/dotfiles/.gitconfig ~/.gitconfig
```

Or use symlinks so future pulls are picked up automatically:

```bash
ln -sf ~/apps/Tools/dotfiles/.bashrc    ~/.bashrc
ln -sf ~/apps/Tools/dotfiles/.gitconfig ~/.gitconfig
```

### 3. Reload the shell

```bash
source ~/.bashrc
```

---

## Prerequisites

| Prerequisite | Required by | Install |
|---|---|---|
| `gpg` / `gpg-agent` | `.bashrc` (SSH agent redirect, TTY refresh) | `sudo apt install gnupg` |
| GPG key imported & trusted | `.gitconfig` (commit signing) | `gpg --import <key.asc>` |
| NVM | `.bashrc` (Node Version Manager) | [nvm install script](https://github.com/nvm-sh/nvm#installing-and-updating) |
| Visual Studio Pro 2022 (Windows) | `.bashrc` (`vs` function, WSL only) | Install on the Windows host |
| `vim` | `.gitconfig` (editor) | `sudo apt install vim` |
