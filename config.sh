#!/bin/bash
ME="/home/$(whoami)"

sudo pacman -Syu

sudo pacman -S --noconfirm --needed tmux powerline powerline-common \
    powerline-fonts alacritty alacritty-terminfo xorg-xprop python \
    python-pip ipython pulseaudio paprefs pavucontrol pulseaudio-alsa \
    base-devel git go gnome-keyring polkit-gnome mlocate most scrot \
    mesa-demos thunar thunar-volman gvfs ntfs-3g code vlc tree fftw \
    freetype2 ttf-font-awesome ttf-ubuntu-font-family dnsutils python2-pip \
    exa ripgrep bat fd tumbler ffmpegthumbnailer exfat-utils alsa-utils \
    clang ctags chromium rofi mpd ncmpcpp uthash powertop htop unzip xz \
    neofetch feh dunst docker docker-compose opera opera-ffmpeg-codecs \
    xclip libnotify network-manager-applet ruby rubygems discord \
    xorg-xwininfo noto-fonts noto-fonts-emoji noto-fonts-extra \
    libreoffice-fresh

sudo updatedb

sudo usermod -a -G docker $USER

sudo cp ./wallpapers/abstract-shaping-1920x1080.jpg /usr/share/pixmaps/back.jpg

systemctl --user enable pulseaudio

if [ -d "$ME/.mpd" ]; then
    # Take action if $DIR exists. #
    echo ".mpd directory already exists in ${DIR}..."
else
    mkdir $ME/.mpd
    echo "$ME/.mpd directory created"
    sudo systemctl enable mpd.service
fi

if $(yay --version > /dev/null 2>&1); then
    echo "yay already installed."
else
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    rm -rf yay
fi

if $(fc-list | grep "Siji:style=Regular" > /dev/null 2>&1); then
    echo "Siji font already installed."
else
    yay -S siji-git
fi

if $(pamac --version > /dev/null 2>&1); then
    echo "pamac already installed."
else
    yay -S --noconfirm pamac
fi

if $(locate google-chrome-stable | grep "/usr/bin" > /dev/null 2>&1); then
    echo "Google Chrome already installed."
else
    yay -S google-chrome
fi

if $(compton --version > /dev/null 2>&1); then
    echo "compton already installed."
else
    yay -S --noconfirm compton-tryone-git
fi

if $(polybar --version > /dev/null 2>&1); then
    echo "polybar already installed."
else
    yay -S --noconfirm polybar
fi

if $(greenclip --version > /dev/null 2>&1); then
    echo "rofi-greenclip already installed."
else
    yay -S --noconfirm rofi-greenclip
fi

if [[ -f $ME/.nvm/nvm.sh ]]; then
    echo "nvm already installed."
else
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
fi

if [[ -f $ME/.gem/ruby/2.6.0/bin/neovim-ruby-host ]]; then
    echo "neovim-ruby-host already installed."
else
    gem install neovim
fi

source ~/.bashrc

if $(cat /etc/vimrc | grep --quiet "let g:powerline_pycmd = 'py3'"); then
    echo "powerline-vim already set to use Python3."
else
    echo "setting powerline-vim to use Python3."
    echo "let g:powerline_pycmd = 'py3'" | sudo tee -a /etc/vimrc \
        > /dev/null 2>&1
fi

if $(pip3 show pynvim > /dev/null 2>&1); then
    echo "PyNvim installed for Python 3..."
else
    sudo pip3 install pynvim
fi

if $(pip2 show pynvim > /dev/null 2>&1); then
    echo "PyNvim installed for Python 2..."
else
    sudo pip2 install pynvim
fi

if $(pip2 show neovim &> /dev/null); then
    echo "neovim installed for Python2..."
else
    sudo pip2 install neovim
fi

sudo -H pip install --upgrade youtube-dl

mkdir ~/music > /dev/null 2>&1

rm -rf $ME/.config/i3 > /dev/null 2>&1 \
    && ln -s $ME/dotfiles/i3 $ME/.config/. \
    || ln -s $ME/dotfiles/i3 $ME/.config/.

rm -rf $ME/.config/i3status > /dev/null 2>&1 \
    && ln -s $ME/dotfiles/i3status $ME/.config/. \
    || ln -s $ME/dotfiles/i3status $ME/.config/.

sed -e 's,\xc4\x86,\xc3\x87,g' -e 's,\xc4\x87,\xc3\xa7,g' \
    < /usr/share/X11/locale/en_US.UTF-8/Compose \
    > $ME/dotfiles/x/XCompose

rm $ME/.XCompose > /dev/null 2>&1 \
    && ln -s $ME/dotfiles/x/XCompose $ME/.XCompose \
    || ln -s $ME/dotfiles/x/XCompose $ME/.XCompose

rm $ME/.XResources > /dev/null 2>&1 \
    && ln -s $ME/dotfiles/x/XResources $ME/.XResources \
    || ln -s $ME/dotfiles/x/XResources $ME/.XResources

rm $ME/.bash_profile > /dev/null 2>&1 \
    && ln -s $ME/dotfiles/bash/bash_profile $ME/.bash_profile \
    || ln -s $ME/dotfiles/bash/bash_profile $ME/.bash_profile

rm $ME/.bashrc > /dev/null 2>&1 \
    && ln -s $ME/dotfiles/bash/bashrc $ME/.bashrc \
    || ln -s $ME/dotfiles/bash/bashrc $ME/.bashrc

rm $ME/.inputrc > /dev/null 2>&1 \
    && ln -s $ME/dotfiles/bash/inputrc $ME/.inputrc \
    || ln -s $ME/dotfiles/bash/inputrc $ME/.inputrc

rm $ME/.tmux.conf > /dev/null 2>&1 \
    && ln -s $ME/dotfiles/tmux/tmux.conf $ME/.tmux.conf \
    || ln -s $ME/dotfiles/tmux/tmux.conf $ME/.tmux.conf

rm $ME/.profile > /dev/null 2>&1 \
    && ln -s $ME/dotfiles/bash/profile $ME/.profile \
    || ln -s $ME/dotfiles/bash/profile $ME/.profile

rm $ME/.xprofile > /dev/null 2>&1 \
    && ln -s $ME/dotfiles/x/xprofile $ME/.xprofile \
    || ln -s $ME/dotfiles/x/xprofile $ME/.xprofile

rm -rf $ME/.config/nvim > /dev/null 2>&1 \
    && ln -s $ME/dotfiles/nvim $ME/.config/. \
    || ln -s $ME/dotfiles/nvim $ME/.config/.

rm -rf $ME/.config/powerline > /dev/null 2>&1 \
    && ln -s $ME/dotfiles/powerline $ME/.config/. \
    || ln -s $ME/dotfiles/powerline $ME/.config/.

rm -rf $ME/.config/rofi > /dev/null 2>&1 \
    && ln -s $ME/dotfiles/rofi $ME/.config/. \
    || ln -s $ME/dotfiles/rofi $ME/.config/.

rm -rf $ME/.fonts > /dev/null 2>&1 \
    && ln -s $ME/dotfiles/fonts $ME/.fonts \
    || ln -s $ME/dotfiles/fonts $ME/.fonts

rm -rf $ME/.config/mpd > /dev/null 2>&1 \
    && ln -s $ME/dotfiles/mpd $ME/.config/. \
    || ln -s $ME/dotfiles/mpd $ME/.config/.

rm -rf $ME/.config/ncmpcpp > /dev/null 2>&1 \
    && ln -s $ME/dotfiles/ncmpcpp $ME/.config/. \
    || ln -s $ME/dotfiles/ncmpcpp $ME/.config/.

rm -rf $ME/.config/alacritty > /dev/null 2>&1 \
    && ln -s $ME/dotfiles/alacritty $ME/.config/. \
    || ln -s $ME/dotfiles/alacritty $ME/.config/.

rm -rf $ME/.config/dunst > /dev/null 2>&1 \
    && ln -s $ME/dotfiles/dunst $ME/.config/. \
    || ln -s $ME/dotfiles/dunst $ME/.config/.

sudo npm install -g npm
sudo npm install -g neovim

if $(locate skypeforlinux | grep /usr/bin > /dev/null 2>&1); then
    echo "Extra packages already installed."
else
    yay -S --noconfirm --nocleanmenu --nodiffmenu --noeditmenu --noupgrademenu ttf-unifont chromium-widevine spotify ffmpeg-compat-57 zenity skypeforlinux-stable-bin
fi

