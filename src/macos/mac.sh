#!/usr/bin/env bash

###
### Mac-specific settings
###

# cdf: Move to frontmost window of Finder
cdf () {
	currFolderPath=$( /usr/bin/osascript <<EOT
		tell application "Finder"
			try
		set currFolder to (folder of the front window as alias)
			on error
		set currFolder to (path to desktop folder as alias)
			end try
			POSIX path of currFolder
		end tell
EOT
		)
		echo "cd to \"$currFolderPath\""
		cd "$currFolderPath"
}

# wifi: Toggle Wi-Fi on/off
wifi () {
	local E_NOARGS=86

	if [[ -z "$1" ]]; then
		printf 'Usage: wifi {on|off}\n'

		return $E_NOARGS
	fi

	/usr/sbin/networksetup -setairportpower en1 "$1" ;
}

###
### Finder, Index searching
###

# ff: Find file under the current directory.
ff () {
	/usr/bin/find . -name "$@" ;
}

# ffe: Find file whose name ends with a given string.
ffe () {
	/usr/bin/find . -name '*'"$@" ;
}

# ffs: Find file whose name starts with a given string.
ffs () {
	/usr/bin/find . -name "$@"'*' ;
}

# chrome: Open file in Chrome.
chrome () {
	/usr/bin/open -a "Google Chrome.app" "$@" ;
}

# lime: Open file in Sublime Text 2.
lime () {
	/usr/bin/open -a "Sublime Text 2.app" "$@" ;
}

# preview: Open file in Preview.
preview () {
	/usr/bin/open -a "Preview.app" "$1" ;
}

# spotlight: Search for a file using MacOS Spotlight's metadata.
spotlight () {
	/usr/bin/mdfind "kMDItemDisplayName == '$@'wc" ;
}

# ted: Open file in TextEdit.
ted () {
	/usr/bin/open -a "TextEdit.app" "$@" ;
}

# showa: Remind yourself of an alias by giving some part of it.
showa () {
	/usr/bin/grep --color=always -i -a1 $@ "$HOME/Library/init/bash/aliases.bash" | grep -v '^\s*$' | less -FSRXc ;
}

# mkcd: Makes new directory and jumps inside.
mkcd () {
	mkdir -pv "$1" && cd "$1" ;
}

# ql: Opens any file in MacOS Quicklook Preview.
ql () {
	/usr/bin/qlmanage -p "$*" >& /dev/null ;
}

# excel: Open file(s) in Microsoft Excel.
excel () {
	/usr/bin/open -a "/Applications/Microsoft Excel.app" "$1" ;
}

# ppt: Open file(s) in Microsoft PowerPoint.
ppt () {
	/usr/bin/open -a "/Applications/Microsoft PowerPoint.app" "$1" ;
}

# quicktime: Open media file in QuickTime Player.
quicktime () {
	/usr/bin/open -a "/Applications/QuickTime Player.app" "$1" ;
}

# trash: Moves a file to the macOS trash
trash () {
	/bin/mv "$@" ~/.Trash ;
}
