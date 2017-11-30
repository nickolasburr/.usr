#!/usr/bin/env bash

# mans: Search manpage given in agument '$1' for term given in argument '$2' (case insensitive),
#       displays paginated result with colored search terms and two lines surrounding each hit.
#       e.g., `mans mplayer codec`
mans () {
	man $1 | grep -iC2 --color=always $2 | less ;
}

# zipf: Create a .zip archive.
zipf () {
	zip -r "$1".zip "$1" ;
}

# isInt: Check if argument is an integer.
isInt () {
	regex='^[0-9]+$'
	if [[ $1 =~ $regex ]]; then
		return 0
	else
		return 1
	fi
}

# httpHeaders: Grab HTTP headers from web page.
httpHeaders () {
	/usr/bin/curl -I -L $@ ;
}

# httpDebug: Fetch a web page and show information on what took time.
httpDebug () {
	/usr/bin/curl $@ -o /dev/null -w "\ndns: %{time_namelookup}\nconnect: %{time_connect}\npretransfer: %{time_pretransfer}\nstarttransfer: %{time_starttransfer}\ntotal: %{time_total}\n" ;
}
