#! /bin/bash
echo "Installing git, requesting elevated perms"
sudo pacman -Syu
sudo pacman -S git

install_yay() {
   git clone https://aur.archlinux.org/yay.git
   cd yay
   makepkg -si
   cd ..
}

if [ -d ~/.temp ]; then
 cd ~/.temp
 install_yay
 git clone https://github.com/Game-Glide/glides-dotfiles.git --depth=1
 cd glides-dotfiles
else
 mkdir ~/.temp
 cd ~/.temp
 install_yay
 git clone https://github.com/Game-Glide/glides-dotfiles.git --depth=1
 cd glides-dotfiles
fi

echo -e "\e[31mMAKE SURE TO HAVE GPU DRIVERS INSTALLED YOURSELF ALREADY\e[0m"
read -p "Press enter to continue..."

package_install() {
   echo "Installing base hyprland packages"
   sudo pacman -S hyprland pipewire neovim wireplumber pavucontrol pulseaudio pulseaudio-alsa fish unimatrix cava sddm base-devel hyprlock hypridle grim imagemagick wl-clipboard fastfetch ttf-jetbrains-mono-nerd ttf-cascadia-code-nerd python python-pip cmake nautilus
   
   echo "Finished... Installing Dependencies"
   curl -sS https://starship.rs/install.sh | sh

   pip install git+https://github.com/will8211/unimatrix.git

   yay -S ags-hyprpanel-git tty-clock vicinae quickshell mpvpaper
}

install_hyprquickshot() {
   # create config dir for hyprquickshot
   if [ -d ~/.config/quickshell/hyprquickshot ]; then
    git clone https://github.com/jamdon2/hyprquickshot ~/.config/quickshell/hyprquickshot
   else
    mkdir ~/.config/quickshell/hyprquickshot
    git clone https://github.com/jamdon2/hyprquickshot ~/.config/quickshell/hyprquickshot
   fi
}

copy_config() {
   # Create backup
   if [ -d ~/.config ]; then
      cp ~/.config/ ~/backups/.config
      # Copy config
      rm -rf ~/.config
      cp -r ./.config/ ~/.config/
   else
      mkdir ~/.config
      cp -r ./.config/ ~/.config/
   fi
    
   # Copy wallpapers
   mkdir ~/wallpapers
   cp -r ./wallpapers/ ~/wallpapers

   if [ -d ~/usr/share/themes/ && ~/usr/share/icons/ ]; then
      # Copy gtk themes
      sudo cp -r ./gtk-themes/color-themes/ ~/usr/share/themes/
      sudo cp -r ./gtk-themes/cursor-themes/ ~/usr/share/icons/
      sudo cp -r ./gtk-themes/icon-themes/ ~/usr/share/icons/
   else
      mkdir ~/usr/share/themes/
      mkdir ~/usr/share/icons/

      sudo cp -r ./gtk-themes/color-themes/ ~/usr/share/themes/
      sudo cp -r ./gtk-themes/cursor-themes/ ~/usr/share/icons/
      sudo cp -r ./gtk-themes/icon-themes/ ~/usr/share/icons/
   fi

   # Setup hyprland plugins
   hyprpm add https://github.com/hyprwm/hyprland-plugins
   hyprpm enable hyprexpo
}

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

cleanup() {
 rm -rf ~/.temp
}

os_check
cleanup
