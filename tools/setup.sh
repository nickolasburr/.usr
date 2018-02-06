#!/usr/bin/env bash
shopt -s nullglob

# Make symlink from arguments
mkln () {
	# Verify source inode exists; if not, notify the user and exit
	if [[ ! -e "$1" ]]; then
		printf 'Cannot create symlink from %s, it is not a valid inode\n' "$1"
		exit 1
	fi

	# Create symlink, source -> target
	ln -fns "$1" "$2"
}

# Symlink dotfiles stored in ~/.usr/** -> ~
dotusr () {
	# Verify this script is ran inside ~/.usr
	if [[ ! "$PWD" -ef "$HOME/.usr"  ]]; then
		printf 'This script must be ran inside ~/.usr\n'
		exit 1
	fi

	# Group type (defaults -> all, macos, linux)
	local GROUPTYPE="$1"

	cd bin

	# ~/.usr/bin executables
	for EXEC in $GROUPTYPE/{.[^.,gitkeep],}*; do
		local EXECNAME="$(basename $EXEC)"

		mkln "$EXEC" "$EXECNAME"
	done

	cd ../etc

	# ~/.usr/etc user configs
	for CONF in $GROUPTYPE/{.[^.,gitkeep],}*; do
		local BASENAME="$(basename $CONF)"

		# If $BASENAME doesn't have a dot prefix, prepend one
		if [[ ${BASENAME:0:1} != "." ]]; then
			BASENAME=".$BASENAME"
		fi

		# If a directory or file with the same name already exists in $HOME,
		# ask the user whether they want to remove it entirely or skip it
		if [[ -e "$HOME/$BASENAME" && ! -L "$HOME/$BASENAME" ]]; then
			read -p "A directory or file with the name $BASENAME was found in your home directory. Do you want to remove it? [yN]: " ANSWER
			case $ANSWER in
				[yY]*)
					rm -rf "$HOME/$BASENAME"
					mkln "$DOTUSR/etc/$CONF" "$HOME/$BASENAME"
				;;
				[nN]*)
					echo "Okay, skipping $BASENAME..."
					continue
				;;
				*)
					echo "Invalid response. Skipping $BASENAME..."
					continue
				;;
			esac
		else
			mkln "$DOTUSR/etc/$CONF" "$HOME/$BASENAME"
		fi
	done

	cd ..
}

if [[ -z "$DOTUSR" ]]; then
	export DOTUSR="$HOME/.usr"
fi

while [[ $# -gt 0 ]]; do
	case "$1" in
		-h|--help)
			printf 'Usage: ./setup.sh {-t|--type} group\n'
			exit 0
		;;
		-t|--type)
			shift
			dotusr "$1"
			shift
		;;
		*)
			printf 'Invalid option "%s"\n\nUsage: ./setup.sh {-t|--type} group\n' "$1"
			exit 0
		;;
	esac
done

cat <<EOF

  To finalize setup, add the following exports to your profile:

  export DOTUSR="\$HOME/.usr"
  export PATH="\$PATH:\$DOTUSR/bin"

EOF
