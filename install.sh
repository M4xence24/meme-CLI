#!/usr/bin/env bash
# install.sh – Installe la commande 'meme' dans votre système

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MEME_SCRIPT="$SCRIPT_DIR/meme"
TARGET="/usr/local/bin/meme"

# Vérifie Python 3
if ! command -v python3 &>/dev/null; then
    echo "❌ Python 3 est requis. Installez-le d'abord."
    exit 1
fi

echo "📦 Installation de la commande 'meme'..."

# Rend le script exécutable
chmod +x "$MEME_SCRIPT"

# Crée un wrapper dans /usr/local/bin
sudo tee "$TARGET" > /dev/null <<EOF
#!/usr/bin/env bash
exec python3 "$MEME_SCRIPT" "\$@"
EOF
sudo chmod +x "$TARGET"

echo ""
echo "✅ Commande 'meme' installée !"
echo ""
echo "💡 Pour un meilleur affichage dans le terminal, installez chafa :"
echo "   macOS  : brew install chafa"
echo "   Ubuntu : sudo apt install chafa"
echo "   Arch   : sudo pacman -S chafa"
echo ""
echo "🚀 Exemples :"
echo "   meme distracted boyfriend"
echo "   meme \"this is fine\""
echo "   meme drake"
echo "   meme --list"
echo "   meme --add \"mon meme\" https://example.com/meme.jpg"
