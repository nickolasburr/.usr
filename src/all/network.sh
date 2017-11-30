#!/usr/bin/env bash

### ---------------------------
### Network aliases & functions
### ---------------------------

alias myip='wget -qO- https://ipinfo.io/ip'       # myip:        Public facing IP Address
alias netcons='lsof -i'                           # netcons:     Show all open TCP/IP sockets
alias flushdns='dscacheutil -flushcache'          # flushdns:    Flush out the DNS Cache
alias lsock='sudo /usr/sbin/lsof -i -P'           # lsock:       Display open sockets
alias lsocku='sudo /usr/sbin/lsof -nP | grep UDP' # lsocku:      Display only open UDP sockets
alias lsockt='sudo /usr/sbin/lsof -nP | grep TCP' # lsockt:      Display only open TCP sockets
alias ipinfo0='ipconfig getpacket en0'            # ipinfo0:     Get info on connections for en0
alias ipinfo1='ipconfig getpacket en1'            # ipinfo1:     Get info on connections for en1
alias openports='sudo lsof -i | grep LISTEN'      # openports:   All listening connections
alias showblocked='sudo ipfw list'                # showblocked: All ipfw rules inc/ blocked IPs

# ii: Display useful host related informaton
ii () {
	echo -e "\nYou are logged on $HOSTNAME"
	echo -e "\nAdditional information: " ; uname -a
	echo -e "\nUsers logged on: " ; w -h
	echo -e "\nCurrent date: " ; date
	echo -e "\nMachine stats: " ; uptime
	echo -e "\nCurrent network location: " ; scselect
	echo -e "\nPublic facing IP Address: " ; myip
	echo
}
