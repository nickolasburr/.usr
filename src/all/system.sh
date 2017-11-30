#!/usr/bin/env bash

### --------------------------------------
### System processes aliases & functions
### --------------------------------------

# memHogsTop, memHogsPs: Find memory consumption statistics
alias memHogsTop='top -l 1 -o rsize | head -20'
alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'

# cpuHogs: Find major consumers of CPU resources
alias cpuHogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

# ftop: Continual 'top' listing (updates every 5 seconds)
alias ftop='top -l 9999999 -s 5 -o cpu'

# ttop: Recommend 'top' invocation to minimize resources
alias ttop='top -R -F -s 10 -o rsize'

# myps: List processes owned by the current user
myps () {
	ps $@ -u $USER -o pid,%cpu,%mem,start,time,command ;
}

# findpid: Find the PID of a specific process
# @note: Without sudo, findPid will only find processes of the current user
findpid () {
	lsof -t -c "$@" ;
}
