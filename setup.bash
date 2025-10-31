#! /bin/bash
echo "Installing git"
sudo -i
pacman -S git
exit # give up su

if [ -f ~/Temp ]; then
 cd ~/Temp
 git clone https://github.com/Game-Glide/glides-dotfiles.git --depth=1
 cd glides-dotfiles
else
 touch ~/Temp
 cd ~/Temp
 git clone https://github.com/Game-Glide/glides-dotfiles.git --depth=1
 cd glides-dotfiles
fi

echo -e "\e[31mMAKE SURE TO HAVE GPU DRIVERS INSTALLED YOURSELF ALREADY\e[0m"
read -p "Press enter to continue..."
os_check
cleanup

os_check() {
 if [ -f /etc/os-release ]; then
 . /etc/os-release
 if [[ $NAME == "Arch Linux" ]]; then
    # On Arch proceed.
    package_install
    copy_config
    # we install this later as its literally a config
    # for quickshell and will get removed by copy config
    install_hyprquickshot

    echo "Package installations complete"
    read -p "Install sddm themes? (y/n): " response
    case $response in
        [Yy]* ) sh -c "$(curl -fsSL https://raw.githubusercontent.com/keyitdev/sddm-astronaut-theme/master/setup.sh)"; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
    echo "Finished."
 else
    echo "Only works on arch bbg"
  fi
 fi
}

package_install() {
   sudo -i # elevate privileges
   echo "Installing base hyprland packages"
   sudo pacman -S hyprland pipewire neovim wireplumber pavucontrol pulseaudio pulseaudio-alsa fish unimatrix cava sddm base-devel hyprlock hypridle grim imagemagick wl-clipboard fastfetch

   echo "Finished... Installing Dependencies"
   curl -sS https://starship.rs/install.sh | sh

   sudo curl -L https://raw.githubusercontent.com/will8211/unimatrix/master/unimatrix.py -o /usr/local/bin/unimatrix
   sudo chmod a+rx /usr/local/bin/unimatrix

   exit # give up su privileges

   yay -S ags-hyprpanel-git tty-clock vicinae quickshell mpvpaper
}

install_hyprquickshot() {
   # create config dir for hyprquickshot
   if [ -d ~/.config/quickshell/hyprquickshot ]; then
    git clone https://github.com/jamdon2/hyprquickshot ~/.config/quickshell/hyprquickshot
   else
    touch ~/.config/quickshell/hyprquickshot
    git clone https://github.com/jamdon2/hyprquickshot ~/.config/quickshell/hyprquickshot
   fi
}

copy_config() {
   # create backup
   cp ~/.config/ ~/backups/.config
   rm -rf ~/.config
   cp -r ./.config/ ~/.config/

   cp -r ./wallpapers/ ~/wallpapers
}

cleanup() {
 rm -rf ~/Temp
}
