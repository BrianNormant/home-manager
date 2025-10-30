NAMES=$(cat <<EOL
󰊗
󰝚

EOL
)

SELECTED=$(echo -e "$NAMES" | walker --dmenu 2> /dev/null)
echo "$SELECTED"

niri msg action set-workspace-name "$SELECTED"
