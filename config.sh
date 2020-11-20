#!/bin/bash
#set -eu -o pipefail

ME="/home/$(whoami)"
DOTDIR="${ME}/dotfiles"
NVMDIR="${ME}/.nvm"
CFG="$ME/.config"

declare -rA COLORS=(
    [RED]=$'\033[0;31m'
    [GREEN]=$'\033[0;32m'
    [BLUE]=$'\033[0;34m'
    [PURPLE]=$'\033[0;35m'
    [CYAN]=$'\033[0;36m'
    [WHITE]=$'\033[0;37m'
    [YELLOW]=$'\033[0;33m'
    [BOLD]=$'\033[1m'
    [OFF]=$'\033[0m'
)

print_red () {
    echo -e "\n${COLORS[RED]}${1}${COLORS[OFF]}\n"
}

print_yellow () {
    echo -e "\n${COLORS[YELLOW]}${1}${COLORS[OFF]}\n"
}

print_green () {
    echo -e "\n${COLORS[GREEN]}${1}${COLORS[OFF]}\n"
}

print_cyan () {
    echo -e "\n${COLORS[CYAN]}${1}${COLORS[OFF]}\n"
}

wait_key () {
    echo -e "\n${COLORS[YELLOW]}"
    read -n 1 -s -r -p "${1}"
    echo -e "${COLORS[OFF]}\n"
}

home_link () {
    msg="[LINKING] $DOTDIR/$1 to $ME/$2"
    print_cyan "${msg}"
    sudo rm $ME/$2 > /dev/null 2>&1 \
        && ln -s $DOTDIR/$1 $ME/$2 \
        || ln -s $DOTDIR/$1 $ME/$2
}

home_link_cfg () {
    msg="[LINKING] $DOTDIR/$1 to $CFG/$1"
    print_cyan "${msg}"
    sudo rm -rf $CFG/$1 > /dev/null 2>&1 \
        && ln -s $DOTDIR/$1 $CFG/. \
        || ln -s $DOTDIR/$1 $CFG/.
}

install_yay () {
    msg="(RE)INSTALLING YAY ..."
    print_yellow "${msg}"
    sleep 1
    if $(yay --version > /dev/null 2>&1); then
        yay -R yay
        sudo pacman -Syu
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si
        cd ..
        rm -rf yay
    else
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si
        cd ..
        rm -rf yay
    fi
}

update_system () {
    msg="UPDATING SYSTEM ..."
    print_yellow "${msg}"
    sleep 1
    sudo pacman -Syu
}

install_basic_packages () {
    msg="INSTALLING BASIC PACKAGES ..."
    print_yellow "${msg}"
    sleep 1
    sudo pacman -S --needed tmux powerline powerline-common \
        powerline-fonts alacritty xorg-xprop xorg-xrandr python \
        python-pip ipython pulseaudio paprefs pavucontrol pulseaudio-alsa \
        base-devel git go gnome-keyring polkit-gnome mlocate most scrot \
        mesa-demos thunar thunar-volman gvfs ntfs-3g code vlc tree fftw \
        freetype2 ttf-font-awesome ttf-ubuntu-font-family dnsutils \
        exa ripgrep bat fd tumbler ffmpegthumbnailer exfat-utils alsa-utils \
        clang ctags chromium rofi mpd ncmpcpp uthash powertop htop unzip xz \
        neofetch feh dunst docker docker-compose opera opera-ffmpeg-codecs \
        xclip libnotify network-manager-applet ruby rubygems discord \
        xorg-xwininfo noto-fonts noto-fonts-emoji noto-fonts-extra \
        libreoffice-fresh ntp perl-json-xs imagemagick xfce4-screenshooter \
        obs-studio sdl2 sdl2_image sdl2_ttf sdl2_mixer sdl2_gfx lua \
        xf86-video-intel nvidia mesa peek broot xawtv mpv ttf-fira-code \
        gcc make cmake sdl2 git zlib bzip2 libjpeg-turbo fluidsynth libgme \
        openal mpg123 libsndfile gtk3 timidity++ nasm mesa glu tar sdl glew \
        yarn lolcat ttf-roboto adapta-gtk-theme lxappearance \
        gtk-engine-murrine vice gimp arc-solid-gtk-theme adwaita-icon-theme \
        qt5ct kdenlive
}

configure_xorg () {
    msg="CONFIGURING XORG ..."
    print_yellow "${msg}"
    sleep 1
    sudo cp ./wallpapers/abstract-shaping-1920x1080.jpg /usr/share/pixmaps/back.jpg
    sudo cp ${DOTDIR}/x/xorg.conf /etc/X11/xorg.conf
    sed -e 's,\xc4\x86,\xc3\x87,g' -e 's,\xc4\x87,\xc3\xa7,g' \
        < /usr/share/X11/locale/en_US.UTF-8/Compose \
        > $ME/dotfiles/x/XCompose
}

link_dotfiles () {
    msg="LINKING DOTFILES ..."
    print_yellow "${msg}"
    sleep 1
    home_link "bash/profile" ".profile"
    home_link "bash/bashrc" ".bashrc"
    home_link "bash/inputrc" ".inputrc"
    home_link "bash/bash_profile" ".bash_profile"
    home_link "x/Xdefaults" ".Xdefaults"
    home_link "x/xprofile" ".xprofile"
    home_link "x/XResources" ".XResources"
    home_link "x/XCompose" ".XCompose"
    home_link "tmux/tmux.conf" ".tmux.conf"
    home_link "tmux/tmux.conf.local" ".tmux.conf.local"
    home_link_cfg "i3"
    home_link_cfg "i3status"
    home_link_cfg "alacritty"
    home_link_cfg "nvim"
    home_link_cfg "powerline"
    home_link_cfg "rofi"
    home_link_cfg "mpd"
    home_link_cfg "ncmpcpp"
    home_link_cfg "dunst"
    home_link_cfg "polybar"
    cp $DOTDIR/gnupg/gpg.conf $ME/.gnupg/.
    mkdir -p $ME/.local/bin
}

mlocate_update () {
    msg="UPDATING MLOCATE ..."
    print_yellow "${msg}"
    sleep 1
    sudo updatedb
}

configure_ntpd () {
    msg="SETTING UP NTPD ..."
    print_yellow "${msg}"
    sleep 1
    sudo systemctl enable ntpd.service
    sudo ntpd -u ntp:ntp
}

install_nvm () {
    msg="INSTALLING NVM ..."
    print_yellow "${msg}"
    sleep 1
    if [[ -f $NVMDIR/nvm.sh ]]; then
        print_green "nvm already installed."
    else
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh | bash
    fi
}

install_node () {
    msg="INSTALLING NODEJS ..."
    print_yellow "${msg}"
    sleep 1
    if [[ -f $NVMDIR/nvm.sh ]]; then
        if $(npm --version > /dev/null 2>&1); then
            msg="npm already installed."
            print_green "${msg}"
        else
            source $NVMDIR/nvm.sh
            VER=$(nvm ls-remote --lts | grep "Latest" | tail -n 1 | sed 's/[-/a-zA-Z]//g' | sed 's/^[ \t]*//')
            msg="Installing Latest NodeJS version found: ${VER}"
            print_yellow "${msg}"
            sleep 1
            nvm install $VER
        fi
    else
        msg="nvm not installed."
        print_red "${msg}"
    fi
}

install_siji_font () {
    msg="INSTALLING SIJI FONT ..."
    print_yellow "${msg}"
    sleep 1
    if $(fc-list | grep "Siji:style=Regular" > /dev/null 2>&1); then
        msg="Siji font already installed."
        print_green "${msg}"
    else
        yay -S siji-git
    fi
}

install_google_chrome () {
    msg="INSTALLING GOOGLE CHROME ..."
    print_yellow "${msg}"
    sleep 1
    if $(locate google-chrome-stable | grep "/usr/bin" > /dev/null 2>&1); then
        print_green "Google Chrome already installed."
    else
        yay -S google-chrome
    fi
}

install_with_yay () {
    msg="INSTALLING $2 WITH YAY ..."
    print_yellow "${msg}"
    sleep 1
    if $(yay --version > /dev/null 2>&1); then
        if $($2 --version > /dev/null 2>&1); then
            msg="$2 already installed."
            print_green "${msg}"
        else
            yay -S --noconfirm $1
        fi
    else
        print_red "[ERROR] yay not installed!"
    fi
}

yay_installs () {
    install_with_yay "pamac" "pamac"
    install_with_yay "compton-tryone-git" "compton"
    install_with_yay "polybar" "polybar"
    install_with_yay "rofi-greenclip" "greenclip"
}

install_extras () {
    msg="INSTALLING EXTRA PACKAGES ..."
    print_yellow "${msg}"
    sleep 1
    if $(locate skypeforlinux | grep /usr/bin > /dev/null 2>&1); then
        msg="extra packages already installed."
        print_green "${msg}"
    else
        yay -S --noconfirm --nocleanmenu --nodiffmenu --noeditmenu --noupgrademenu ttf-unifont chromium-widevine spotify ffmpeg-compat-57 zenity skypeforlinux-stable-bin
    fi
    sleep 1
    if $(mongodump --version > /dev/null 2>&1); then
        msg="mongodb-tools already installed."
        print_green "${msg}"
    else
        yay -S --nocleanmenu --nodiffmenu --noeditmenu --noupgrademenu perl-anyevent-i3 sol2-git mongodb-bin mongodb-tools-bin
    fi
}

install_slack () {
    msg="INSTALLING SLACK ..."
    print_yellow "${msg}"
    sleep 1
    if [[ -f /usr/bin/slack ]]; then
        print_green "slack desktop already installed."
    else
        yay slack-desktop
    fi
}

install_neovim_deps () {
    msg="INSTALLING NEOVIM DEPENDENCIES ..."
    print_yellow "${msg}"
    sleep 1
    if [[ -f $ME/.gem/ruby/2.6.0/bin/neovim-ruby-host ]]; then
        print_green "neovim-ruby-host already installed."
    else
        gem install neovim
    fi
    sleep 1
    if $(cat /etc/vimrc | grep --quiet "let g:powerline_pycmd = 'py3'"); then
        echo "powerline-vim already set to use Python3."
    else
        echo "setting powerline-vim to use Python3."
        echo "let g:powerline_pycmd = 'py3'" | sudo tee -a /etc/vimrc \
            > /dev/null 2>&1
    fi
    sleep 1
    if $(pip show pynvim > /dev/null 2>&1); then
        echo "PyNvim installed for Python 3..."
    else
        sudo pip install pynvim
    fi
    sleep 1
    sudo npm install -g neovim
}

install_pulseaudio_control () {
    msg="INSTALLING PULSEAUDIO-CONTROL ..."
    print_yellow "${msg}"
    sleep 1
    if [[ -f /usr/bin/pulseaudio-control ]]; then
        print_green "pulseaudio-control already installed."
    else
        yay -S pulseaudio-control
    fi
}

configure_mpd () {
    msg="SETTING UP MPD ..."
    print_yellow "${msg}"
    sleep 1
    if [ -d "$ME/.mpd" ]; then
        msg=".mpd directory already exists in $ME/.mpd ..."
        print_green "${msg}"
    else
        mkdir $ME/.mpd
        mkdir -p $ME/music/.mpd/lyrics
        msg="$ME/.mpd directory created"
        print_yellow "${msg}"
        sudo systemctl enable mpd.service
        msg="mpd enabled"
        print_yellow "${msg}"
    fi
}

configure_broot () {
    msg="SETTING UP BROOT ..."
    print_yellow "${msg}"
    sleep 1
    if $(broot --version > /dev/null 2>&1); then
        if [[ -f $CFG/broot/launcher/bash/br ]]; then
            msg="broot already installed and configured."
            print_green "${msg}"
        else
            msg="running broot --install"
            print_yellow "${msg}"
            sleep 1
            broot --install
        fi
    else
        print_red "[ERROR] broot not installed!"
    fi
}

setup_fonts () {
    msg="SETTING UP FONTS ..."
    print_yellow "${msg}"
    sleep 1
    rm -rf $ME/.fonts > /dev/null 2>&1 \
        && ln -s $ME/dotfiles/fonts $ME/.fonts \
        || ln -s $ME/dotfiles/fonts $ME/.fonts
    fc-cache -fv
}

update_system
install_basic_packages
configure_xorg
link_dotfiles
mlocate_update
install_yay
configure_ntpd
install_nvm
install_node
install_google_chrome
install_siji_font
yay_installs
install_extras
install_slack
install_neovim_deps
install_pulseaudio_control
configure_mpd
configure_broot
setup_fonts

sudo usermod -a -G docker $USER

systemctl --user enable pulseaudio

source ~/.bashrc

sudo -H pip install --upgrade youtube-dl

print_green "ALL INSTALLS COMPLETED!"

# yay --noconfirm --nocleanmenu --nodiffmenu --noeditmenu --noupgrademenu
