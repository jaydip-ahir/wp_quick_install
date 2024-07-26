#!/bin/bash

# Ensure curl is installed
if ! command -v curl &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y curl
fi

# Download the wp_quick_install.sh script and save it to /usr/local/bin/wp_quick_install
sudo curl -o /usr/local/bin/wp_quick_install https://raw.githubusercontent.com/jaydip-ahir/wp_quick_install/master/wpinstall.sh

# Make the script executable
sudo chmod +x /usr/local/bin/wp_quick_install

# Notify the user
echo "wp_quick_install has been installed. You can now run it by typing 'wp_quick_install' in your terminal."
