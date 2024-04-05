#!/usr/bin/env bash

for i in 2 30; do
    echo -en "\033]${i};StormOS Post Script\007"
done

clear
tput setaf 5
echo "#######################################################################"
echo "#          Welcome to StormOS Arch Post install script.          #"
echo "#                                                                     #"
echo "# This will add the StormOS repository required to install the Desktop, toolkit, #"
echo "#     AUR helper and more. Just close window if you do not agree.     #"
echo "#######################################################################"
tput sgr0

pamac=("pamac-all")
echo
pamac="NONE"
for i in ${pamac-all[@]}; do
  if command -v $i; then
    pamac="$i"
    echo
echo "Pamac detected, shall we proceed ?"
echo ""
echo "y. Yes Please."
echo "n. No thank you."
echo ""
echo "Type y or n to continue."
echo ""

read CHOICE

case $CHOICE in

y)
echo
echo "Adding StormOS Repository..."
echo
echo -e '\n[stormos]\nSigLevel = Never\nServer = https://bfitzgit23.github.io/$repo/$arch' | sudo tee -a /etc/pacman.conf
sudo sed -i '/^\s*#\s*\[multilib\]/,/^$/ s/^#//' /etc/pacman.conf
echo
echo "Installing & Starting the Post Install of AUR, Desktop, Toolkit and apps..."
echo
sudo pacman -Syy --noconfirm  && clear && sudo pacman -Sy yay xfce4 xfce4-goodies stormos-xfce-config stormos-conf zensu manjaro-printer timeshift-bin surfn-icons-git xfce4-docklike-plugin xfce4-panel-profiles stormos-grub-theme qt5-style-plugins preload plymouth-git oh-my-bash-git ocs-url mugshot mintstick-git iohit-fonts libinput-gestures fonts-tlwg bdf-unifont asian-fonts aic94xx-firmware adw-gtk3 wd719x-firmware upd72020xx-fw wallpaper-archpaint2 chromium git base-devel
;;

n)
echo
exit 0
;;

esac
  fi
done

if [[ $pamac == "NONE" ]]; then
  echo
  echo "No Pamac detected, required by the toolkit."
  echo ""
  echo "Pamac"
  echo ""
  read -p "Choose your Helper : " number_chosen

  case $number_chosen in
    1)
      echo
      echo "###########################################"
      echo "           Installing Pamac           "
      echo "###########################################"
      echo
      echo "Adding StormOS Repository..."
      echo
      sudo cp /etc/pacman.conf /etc/pacman.conf.backup && \
      echo -e '\n[stormos]\nSigLevel = Never\nServer = https://bfitzgit23.github.io/$repo/$arch' | sudo tee -a /etc/pacman.conf
      sudo sed -i '/^\s*#\s*\[multilib\]/,/^$/ s/^#//' /etc/pacman.conf
      sleep 2
      echo
      echo "Installing Pamac..."
      echo
      yay -Syy --noconfirm pamac-all && yay -Y --devel --save && yay -Y --gendb
      echo
      clear
    ;;
  esac
fi
