#!/bin/bash

# Make the script executable
chmod +x /usr/local/bin/

# Download the wp_quick_install.sh script
curl -o /usr/local/bin/ https://raw.githubusercontent.com/jaydip-ahir/wp_quick_install/master/wpinstall.sh


# Notify the user
echo "wp_quick_install has been installed. You can now run it by typing 'wp_quick_install' in your terminal."
