#!/usr/bin/env bash

set -x
shopt -s nullglob

[[ -z "$DOTUSR" ]] && export DOTUSR="$HOME/.usr"

ETCDIR="$DOTUSR/etc"

while [[ $# -gt 0 ]]; do
	case "$1" in
		-h|--help)
			printf 'Usage: ./setup.sh {-t|--type} <group>\n'

			exit 0
		;;
		-t|--type)
			shift

			if [[ ! "$PWD" -ef "$DOTUSR"  ]]; then
				cd "$DOTUSR"
			fi

			GROUP="$1"

			cd bin

			# ~/.usr/bin executables
			for EXEC in $GROUP/{.[^.,gitkeep],}*; do
				EXECNAME="$(basename $EXEC)"

				if [[ ! -e "$EXEC" ]]; then
					printf 'Cannot create symlink from source %s, it is not a valid file or directory.\n' "$EXEC"

					exit 1
				fi

				# Create symlink, source -> target
				ln -fns "$EXEC" "$EXECNAME"
			done

			cd ../etc

			# ~/.usr/etc configuration files.
			for CONF in $GROUP/{.[^.,gitkeep],}*; do
				BASENAME="$(basename $CONF)"

				# If $BASENAME doesn't have a dot prefix, prepend one.
				if [[ ${BASENAME:0:1} != "." ]]; then
					BASENAME=".$BASENAME"
				fi

				# If a directory or file with the same name already exists in $HOME,
				# ask the user whether they want to remove it entirely or skip it.
				if [[ -e "$HOME/$BASENAME" && ! -L "$HOME/$BASENAME" ]]; then
					read -p "~/$BASENAME already exists. Do you want to remove it? [yN]: " ANSWER

					case $ANSWER in
						[yY]*)
							rm -rf "$HOME/$BASENAME"

							if [[ ! -e "$ETCDIR/$CONF" ]]; then
								printf 'Cannot create symlink from source %s, it is not a valid file or directory.\n' "$ETCDIR/$CONF"

								exit 1
							fi

							# Create symlink, source -> target
							ln -fns "$ETCDIR/$CONF" "$HOME/$BASENAME"
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
					if [[ ! -e "$ETCDIR/$CONF" ]]; then
						printf 'Cannot create symlink from source %s, it is not a valid file or directory.\n' "$ETCDIR/$CONF"

						exit 1
					fi

					# Create symlink, source -> target
					ln -fns "$ETCDIR/$CONF" "$HOME/$BASENAME"
				fi
			done

			cd ..

			shift
		;;
		*)
			printf 'Invalid option %s\n\nUsage: ./setup.sh {-t|--type} <group>\n' "$1"

			exit 0
		;;
	esac
done

cat <<EOF

  To finalize setup, add the following exports to your profile:

  export DOTUSR="\$HOME/.usr"
  export PATH="\$PATH:\$DOTUSR/bin"

EOF
