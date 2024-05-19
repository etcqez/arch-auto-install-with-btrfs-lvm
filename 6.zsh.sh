sh -c "$(curl -fsSL https://install.ohmyz.sh/)"
#ZSH_CUSTOM=~/.oh-my-zsh/custom
#git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
#git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
#sed -Ei '/^plugins=/s/\)$/ zsh-autosuggestions zsh-syntax-highlighting\)/' ~/.zshrc

sed -Ei '/^plugins=/s/\)$/ sudo\)/' ~/.zshrc
sudo pacman -S --noconfirm zsh-autosuggestions zsh-syntax-highlighting eza
cat >>~/.zshrc <<EOF
# myconf########################################################################
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/myconfig/zshalias
EOF
