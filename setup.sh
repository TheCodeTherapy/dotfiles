#!/usr/bin/env bash
# vim: noai:ts=4:sw=4:expandtab

muser="marcogomez"
raw="https://raw.githubusercontent.com/mgzme/dotfiles/master"
echo "Your user: $muser. Enter and repeat your password:"
useradd -m -g users -G wheel,storage,power,video,network -s /bin/bash "$muser"
passwd "$muser"
pacman -S sudo --noconfirm
sed -i "s/^root ALL=(ALL) ALL$/root ALL=(ALL) ALL\n${muser} ALL=(ALL) ALL\n/" /etc/sudoers
wget "$raw/x/Xdefaults" -O /home/${muser}/.Xdefaults 2>/dev/null
echo "exec i3" > /home/${muser}/.xinitrc && echo "tput bold" >> /home/${muser}/.bashrc
echo "xrdb .Xdefaults" >> /home/${muser}/.bashrc
echo "Success: user create and included on group sudo"

pacman -S vim xorg-server xf86-input-mouse xf86-input-keyboard xf86-video-vesa xorg-xinit i3-wm i3status i3lock dmenu awesome-terminal-fonts terminus-font ttf-dejavu xterm git lightdm lightdm-gtk-greeter firefox firefox-i18n-pt-br bash-completion --noconfirm

pacman -S i3

systemctl enable lightdm
sed -i 's/^#greeter-session.*/greeter-session=lightdm-gtk-greeter/' /etc/lightdm/lightdm.conf
sed -i '/^#greeter-hide-user=/s/#//' /etc/lightdm/lightdm.conf
wget "$raw/wallpapers/abstract-shaping-1920x1080.jpg" -O /usr/share/pixmaps/back.jpg 2>/dev/null
wget "$raw/x/xorg_conf/10-evdev.conf" -O /etc/X11/xorg.conf.d/10-evdev.conf 2>/dev/null
wget "$raw/x/xorg_conf/70-synaptics.conf" -O /etc/X11/xorg.conf.d/70-synaptics.conf 2>/dev/null
echo -e "[greeter]\nbackground=/usr/share/pixmaps/back.jpg" > /etc/lightdm/lightdm-gtk-greeter.conf

