# 🎭 meme-cli

> Cherche et affiche des mèmes directement dans ton terminal.

![demo](https://img.shields.io/badge/platform-macOS%20%7C%20Linux%20%7C%20Windows-blue)
![python](https://img.shields.io/badge/python-3.7%2B-yellow)
![license](https://img.shields.io/badge/license-MIT-green)

```
meme "absolute cinema"
meme --render hd "distracted boyfriend"
meme --render ascii --bw stonks
```

---

## ✨ Fonctionnalités

- 🔍 **Recherche intelligente** — DuckDuckGo Images → Reddit → Know Your Meme
- 🧠 **Tolérance aux fautes** — `sonks` trouve `stonks`, `distarcted` trouve `distracted boyfriend`
- 🖼️ **4 modes d'affichage** — HD natif, emoji, ASCII, auto
- ⬛ **Mode noir & blanc** — combinable avec tous les modes
- 💾 **Base locale** — sauvegarde tes mèmes favoris avec `--add`
- 📦 **Cache automatique** — les images téléchargées sont réutilisées
- 🐍 **Zéro dépendance obligatoire** — fonctionne avec Python 3 standard

---

## 📦 Installation

### 1. Cloner le repo

```bash
git clone https://github.com/ton-username/meme-cli.git
cd meme-cli
```

### 2. Lancer l'installeur

```bash
bash install.sh
```

L'installeur crée la commande `meme` dans `/usr/local/bin` et la rend disponible partout dans le terminal.

> **Windows** : copie `meme` dans un dossier de ton `PATH` (ex: `C:\Users\<toi>\AppData\Local\Programs\`) et ajoute un fichier `meme.bat` :
> ```bat
> @echo off
> python "%~dp0meme" %*
> ```

---

## 🛠️ Dépendances

### Python (requis)

| Dépendance | Rôle | Installation |
|---|---|---|
| **Python 3.7+** | Requis | Voir ci-dessous |
| **Pillow** | Modes hd/emoji/ascii + `--bw` | Auto-installé au premier lancement |

Tout le reste utilise la bibliothèque standard Python (`urllib`, `difflib`, `ssl`…).

### Renderer terminal (optionnel mais recommandé)

Le mode `--render hd` détecte automatiquement le meilleur protocole disponible dans cet ordre :

| Priorité | Protocole | Terminal | Qualité |
|---|---|---|---|
| 1 | **Kitty Graphics** | kitty | ✅ HD natif |
| 2 | **iTerm2 Inline Images** | iTerm2, Ghostty | ✅ HD natif |
| 3 | **WezTerm imgcat** | WezTerm | ✅ HD natif |
| 4 | **Sixel** | xterm, mlterm, foot | ✅ HD natif |
| 5 | **viu** | tous | 🟡 semi-HD |
| 6 | **chafa** | tous | 🟡 caractères |
| 7 | **timg** | tous | 🟡 caractères |
| 8 | App système | tous | ↗️ ouvre en dehors |

---

## 🍎 macOS

```bash
# Recommandé : iTerm2 (meilleur support HD)
brew install --cask iterm2

# Fallback universel
brew install chafa

# Sixel (optionnel)
brew install libsixel   # fournit img2sixel

# Pillow (auto-installé, mais tu peux le faire manuellement)
pip3 install pillow
```

> **Terminal.app** (le terminal par défaut macOS) ne supporte aucun protocole graphique natif.
> meme-cli ouvrira l'image avec l'app par défaut du système en fallback.

---

## 🐧 Linux

```bash
# Ubuntu / Debian
sudo apt install chafa libsixel-bin python3-pip
pip3 install pillow

# Arch
sudo pacman -S chafa python-pillow
# libsixel : disponible via AUR → yay -S libsixel

# Fedora
sudo dnf install chafa python3-pillow

# Kitty (recommandé)
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh
```

---

## 🪟 Windows

```powershell
# Windows Terminal (supporte les couleurs 24-bit)
winget install Microsoft.WindowsTerminal   # probablement déjà installé

# WezTerm (meilleur support HD sur Windows)
winget install wez.wezterm

# chafa via scoop
scoop install chafa

# Python + Pillow
winget install Python.Python.3
pip install pillow
```

> Les modes `emoji` et `ascii` fonctionnent nativement dans Windows Terminal sans aucun outil supplémentaire.

---

## 🚀 Utilisation

### Syntaxe générale

```
meme [OPTIONS] <recherche>
meme [COMMANDE]
```

### Recherche simple

```bash
meme stonks
meme "absolute cinema"
meme distracted boyfriend      # pas besoin de guillemets
meme suprized pickachu         # tolérant aux fautes d'orthographe
```

### Options d'affichage

```bash
meme --render hd   "glass up leo"        # HD natif (défaut)
meme --render emoji doge                 # mosaïque de blocs colorés
meme --render ascii "this is fine"       # art ASCII coloré
```

### Noir & blanc

```bash
meme --bw stonks                         # auto + noir et blanc
meme --render hd    --bw drake           # HD noir et blanc
meme --render emoji --bw "two buttons"
meme --render ascii --bw "change my mind"
```

### Gestion de la base locale

```bash
# Ajouter un mème
meme --add "mon meme" https://example.com/meme.jpg

# Ajouter depuis un fichier local
meme --add "pepe triste" /Users/moi/images/pepe.png

# Lister la base locale
meme --list
```

### Aide

```bash
meme --help
meme -h
meme ?
```

---

## 🔍 Fonctionnement de la recherche

```
┌─────────────────────────────────────────────────────────────┐
│  meme "distarcted boyfrend"                                  │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
         ┌───────────────────────┐
         │   1. Base locale      │  fuzzy match via difflib
         │   meme_db.json        │  tolérance fautes : ~80%
         └───────────┬───────────┘
                     │ non trouvé
                     ▼
         ┌───────────────────────┐
         │   2. DuckDuckGo       │  recherche "<query> meme"
         │   Images API          │  retourne la 1ère image
         └───────────┬───────────┘
                     │ non trouvé
                     ▼
         ┌───────────────────────┐
         │   3. Reddit           │  r/memes, r/dankmemes,
         │   JSON API            │  r/AdviceAnimals, r/me_irl
         └───────────┬───────────┘
                     │ non trouvé
                     ▼
         ┌───────────────────────┐
         │   4. Know Your Meme   │  scraping léger, og:image
         └───────────┬───────────┘
                     │
                     ▼
              Image affichée
              + mise en cache
```

Les images téléchargées sont mises en cache dans `.meme_cache/` pour éviter de re-télécharger.

---

## 📁 Structure du projet

```
meme-cli/
├── meme              # script principal (Python)
├── meme_db.json      # base locale (~36 mèmes classiques pré-chargés)
├── install.sh        # installeur (macOS / Linux)
├── README.md
└── .meme_cache/      # cache des images téléchargées (auto-créé)
```

---

## 🗂️ Base locale pré-chargée

La base `meme_db.json` contient ~36 mèmes classiques prêts à l'emploi :

`distracted boyfriend` · `drake pointing` · `this is fine` · `doge` · `stonks` · `surprised pikachu` · `woman yelling at cat` · `mocking spongebob` · `bernie mittens` · `change my mind` · `two buttons` · `galaxy brain` · `gru plan` · `always has been` · `panik kalm` · `is this a pigeon` · et plus…

---

## ⚙️ Référence des options

| Option | Description |
|---|---|
| `--render hd` | Affichage HD via protocole graphique natif du terminal *(défaut)* |
| `--render emoji` | Mosaïque de blocs `██` colorés en 24-bit |
| `--render ascii` | Art ASCII coloré, 70 niveaux de luminosité |
| `--bw` | Noir et blanc — combinable avec tous les modes |
| `--add <nom> <url>` | Ajoute un mème à la base locale |
| `--list` | Liste tous les mèmes de la base locale |
| `--help`, `-h`, `?` | Affiche l'aide |

---

## 🤝 Contribuer

Les contributions sont les bienvenues ! Quelques idées :

- Ajouter des sources de recherche supplémentaires
- Améliorer le scoring de la recherche floue
- Ajouter le support Giphy / Tenor pour les GIFs
- Support Windows natif (`.bat` ou `.ps1`)

```bash
# Fork → clone → modifie → PR
git checkout -b feature/ma-feature
git commit -m "feat: ajoute support Giphy"
git push origin feature/ma-feature
```

---

## 📄 Licence

MIT — fais-en ce que tu veux.
