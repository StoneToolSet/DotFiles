echo "📦 Starting system update..."

echo "⚙️ Updating with yay..."
yay -Syu --noconfirm
    
# Update zinit and plugins
echo "🔌 Updating zinit plugins..."
zinit self-update
zinit update --parallel

# Update other package managers if installed
if command -v flatpak &>/dev/null; then
    echo "📄 Updating flatpak packages..."
    flatpak update -y
fi
    
if command -v snap &>/dev/null; then
    echo "📱 Updating snap packages..."
    sudo snap refresh
fi
    
# Clean up orphaned packages
echo "🧹 Cleaning up orphaned packages..."
pacman -Qtdq | sudo pacman -Rns - 2>/dev/null || echo "No orphaned packages to remove"
    
# Clean package cache
echo "🧼 Cleaning package cache..."
yay -Sc --noconfirm
    
echo "✅ System update complete!"
