#!/bin/bash

# Disable default GNOME screenshot shortcuts
echo "Disabling default GNOME screenshot shortcuts..."

# Disable "Take a screenshot" (usually Print or Shift+Print)
gsettings set org.gnome.shell.keybindings screenshot '[]'
#gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot '[]'

# Disable "Take an interactive screenshot" (usually Alt+Print or similar)
gsettings set org.gnome.shell.keybindings show-screenshot-ui '[]'

# Disable area screenshot
#gsettings set org.gnome.settings-daemon.plugins.media-keys area-screenshot '[]'

# Disable window screenshot
#gsettings set org.gnome.settings-daemon.plugins.media-keys window-screenshot '[]'
#gsettings set org.gnome.shell.keybindings screenshot-window '[]'

# Disable clipboard screenshot variants
#gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot-clip '[]'
#gsettings set org.gnome.settings-daemon.plugins.media-keys area-screenshot-clip '[]'
#gsettings set org.gnome.settings-daemon.plugins.media-keys window-screenshot-clip '[]'

echo "Default screenshot shortcuts disabled"

# Define the custom keybinding path
CUSTOM_KEY="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"

# Get existing keybindings
EXISTING_KEYS=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)

if [[ $EXISTING_KEYS == *"$CUSTOM_KEY"* ]]; then
  echo "Custom keybinding already exists"
else
  # Check if array is empty
  if [[ $EXISTING_KEYS == "@as []" ]] || [[ $EXISTING_KEYS == "[]" ]]; then
    # Empty array - set directly without comma
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['$CUSTOM_KEY']"
  else
    # Non-empty array - append with comma
    UPDATED_KEYS=$(echo $EXISTING_KEYS | sed "s|]$|, '$CUSTOM_KEY']|")
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$UPDATED_KEYS"
  fi
  echo "Added custom keybinding to list"
fi

# Set the name, command, and binding for Flameshot
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$CUSTOM_KEY name 'Flameshot'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$CUSTOM_KEY command 'strace -e none flameshot gui'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$CUSTOM_KEY binding 'Print'

echo "Flameshot Print Screen keybinding applied."

