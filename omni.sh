#!/bin/bash

# OmniDeploy CLI Tool
# AIO tool for quickly deploying applications on Ubuntu

# ASCII Art
cat << "EOF"
  ____      _       _ _   ____       _
 / ___|_ __(_)_ __ (_) |_|  _ \ ___ | |
| |  _| '__| | '_ \| | __| | | / _ \| |
| |_| | |  | | | | | | |_| |_|  (_) | |
 \____|_|  |_|_| |_|_|\__|____ \___/|_|
 \____|_|  |_|_| |_|_|\__|____ \___/|_|
                                      
EOF

# Define applications and repositories
declare -A APPS
APPS=(
    ["Development Tools"]="git vim emacs code sublime-text eclipse pycharm-community atom intellij-idea-community netbeans build-essential"
    ["Web Browsers"]="firefox google-chrome-stable chromium-browser brave-browser opera-stable"
    ["Media Players"]="vlc audacious mpv smplayer clementine"
    ["Productivity"]="libreoffice thunderbird evolution wps-office onlyoffice-desktopeditors"
    ["Utilities"]="curl wget htop net-tools gnome-disk-utility filezilla gparted stacer timeshift guake bleachbit variety redshift synaptic virtualbox"
    ["AI Tools"]="tensorflow pytorch keras jupyter-notebook opencv-python scikit-learn r-base orange octave weka"
    ["Networking"]="openssh-server openvpn wireshark nmap transmission"
    ["Databases"]="mysql-server postgresql mongodb sqlite3 redis-server"
    ["Graphics and Design"]="gimp inkscape blender krita darktable"
    ["File Management"]="nautilus dolphin thunar mc doublecmd-gtk"
    ["System Monitoring"]="glances conky sysdig ksysguard bpytop"
    ["Text Editors"]="nano geany kate leafpad xed"
    ["Communication"]="skypeforlinux slack-desktop discord zoom telegram-desktop"
    ["Backup and Recovery"]="rsync deja-dup clonezilla backintime-qt duplicity"
    ["Cloud Storage"]="nautilus-dropbox nextcloud-desktop insync megasync"
    ["Security"]="clamav fail2ban ufw apparmor lynis gufw"
    ["Virtualization and Containers"]="docker-ce virtualbox qemu-kvm vagrant lxc"
    ["Fun and Entertainment"]="steam spotify vlc-browser"
    ["Creative Tools"]="krita blender audacity"
    ["Gaming"]="steam lutris wine"
)

# Add repositories
declare -A REPOS
REPOS=(
    ["google-chrome"]="deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main"
    ["docker"]="deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    ["sublime-text"]="deb https://download.sublimetext.com/ apt/stable/"
    ["brave-browser"]="deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"
    ["opera-stable"]="deb [arch=amd64] https://deb.opera.com/opera-stable/ stable non-free"
    ["skypeforlinux"]="deb [arch=amd64] https://repo.skype.com/deb stable main"
    ["slack-desktop"]="deb https://packagecloud.io/slacktechnologies/slack/debian/ jessie main"
    ["insync"]="deb http://apt.insync.io/ubuntu $(lsb_release -cs) non-free contrib"
    ["megasync"]="deb https://mega.nz/linux/repo/Ubuntu_$(lsb_release -rs)/ ."
    ["spotify"]="deb http://repository.spotify.com stable non-free"
    ["steam"]="deb [arch=amd64] https://repo.steampowered.com/steam/ stable steam"
)

# Function to add repositories
add_repos() {
    for repo in "${!REPOS[@]}"; do
        echo "Adding repository: $repo"
        sudo sh -c "echo '${REPOS[$repo]}' > /etc/apt/sources.list.d/$repo.list"
        
        if [[ $repo == "google-chrome" ]]; then
            wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
        elif [[ $repo == "docker" ]]; then
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        elif [[ $repo == "sublime-text" ]]; then
            wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
        elif [[ $repo == "brave-browser" ]]; then
            curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key add -
        elif [[ $repo == "opera-stable" ]]; then
            wget -qO - https://deb.opera.com/archive.key | sudo apt-key add -
        elif [[ $repo == "skypeforlinux" ]]; then
            wget -q -O - https://repo.skype.com/data/SKYPE-GPG-KEY | sudo apt-key add -
        elif [[ $repo == "slack-desktop" ]]; then
            wget -q -O - https://packagecloud.io/slacktechnologies/slack/gpgkey | sudo apt-key add -
        elif [[ $repo == "insync" ]]; then
            wget -qO - https://d2t3ff60b2tol4.cloudfront.net/repomgr/key.asc | sudo apt-key add -
        elif [[ $repo == "megasync" ]]; then
            wget -qO - https://mega.nz/linux/repo/MEGAsync-keys.asc | sudo apt-key add -
        elif [[ $repo == "spotify" ]]; then
            curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -
        elif [[ $repo == "steam" ]]; then
            wget -qO - https://repo.steampowered.com/steam/archive/precise/steam.gpg | sudo apt-key add -
        fi
    done
}

# Function to install applications
install_apps() {
    for category in "${!APPS[@]}"; do
        echo "$category:"
        for app in ${APPS[$category]}; do
            echo "  - $app"
        done
    done
    read -p "Enter the category of applications you want to install: " category
    if [[ -n "${APPS[$category]}" ]]; then
        echo "Installing ${APPS[$category]}..."
        sudo apt update
        sudo apt install -y ${APPS[$category]}
        
        # Check if Docker is being installed, then offer Docker Container tool
        if [[ "${APPS[$category]}" == *"docker-ce"* ]]; then
            read -p "Do you want to browse and deploy Docker containers? (Y/N): " deploy_docker
            if [[ $deploy_docker =~ ^[Yy]$ ]]; then
                echo "Launching Docker Container tool..."
                # Placeholder for Docker container tool
                echo "Placeholder for Docker Container tool"
            fi
        fi
    else
        echo "Invalid category."
    fi
}

# Interactive Menu
while true; do
    echo "Select an option:"
    echo "1. Add repositories"
    echo "2. Install applications"
    echo "3. Exit"
    read -p "Enter your choice [1-3]: " choice

    case $choice in
        1)
            add_repos
            ;;
        2)
            install_apps
            ;;
        3)
            echo "Exiting OmniDeploy."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please select 1, 2, or 3."
            ;;
    esac
done