#!/bin/bash

# Function to display warning message and wait for user input
pause() {
    echo "Press Enter to continue..."
    read
}

echo "#######################################################"
echo "#              WARNING:                                #"
echo "# This script will temporarily add the StormOS        #"
echo "# repository and remove it afterwards.                #"
echo "#                                                     #"
echo "# Enter 1 to continue or 2 to exit installation.      #"
echo "#######################################################"
read -r choice

case $choice in
    1)
        # Add StormOS Repository
        echo "Adding StormOS Repository..."
        echo -e '\n[stormos]\nSigLevel = Never\nServer = https://bfitzgit23.github.io/$repo/$arch' | sudo tee -a /etc/pacman.conf
        sudo sed -i '/^\s*#\s*\[multilib\]/,/^$/ s/^#//' /etc/pacman.conf

        # Install packages
        echo "Installing required packages..."
        sudo pacman -S --noconfirm yay xfce4 xfce4-goodies stormos-xfce-config stormos-conf zensu manjaro-printer timeshift-bin surfn-icons-git xfce4-docklike-plugin xfce4-panel-profiles stormos-grub-theme qt5-style-plugins preload plymouth-git oh-my-bash-git ocs-url mintstick-git iohit-fonts libinput-gestures fonts-tlwg bdf-unifont asian-fonts aic94xx-firmware adw-gtk3 wd719x-firmware upd72020xx-fw wallpaper-archpaint2 chromium git base-devel

        # Clean up
        echo "Removing StormOS Repository..."
        sudo sed -i '/\[stormos\]/,/^\s*$/d' /etc/pacman.conf
        sudo pacman -Syu --noconfirm

        # Ask the user if they want to install pamac-all
        echo "Do you want to install pamac-all? (y/n)"
        read -r install_pamac

        if [[ $install_pamac == "y" ]]; then
            # Install Pamac if it's not installed
            if ! command -v pamac-all &> /dev/null; then
                echo "Installing Pamac..."
                yay -S --noconfirm pamac-all
            else
                echo "Pamac-all is already installed."
            fi
        fi

        # Install yay with --noconfirm
        echo "Installing yay with --noconfirm..."
        yay -S --noconfirm yay

        # Update yay with --noconfirm
        echo "Updating yay with --noconfirm..."
        yay -Syu --noconfirm

        # List downgraded packages
        downgraded_packages=$(pacman -Qu | grep "downgrade" | cut -d ' ' -f1)
        if [ -n "$downgraded_packages" ]; then
            echo "The following packages have been downgraded:"
            echo "$downgraded_packages"
        else
            echo "No packages have been downgraded."
        fi

        echo "Post installation completed."
        ;;
    2)
        echo "Exiting installation."
        exit 0
        ;;
    *)
        echo "Invalid choice. Exiting installation."
        exit 1
        ;;
esac
