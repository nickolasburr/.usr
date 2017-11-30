#!/usr/bin/env bash

### ---------------------------
### Git aliases & functions
### ---------------------------

alias branch='git branch'
alias branches='git branch -a'
alias checkout='git checkout'
alias commit='git commit --wait'
alias giff='git diff --color-words'
alias gk='gitk --all&'
alias gx='gitx --all'
alias remotes="git remote -v"
alias status='git status'

# clip: Delete local branch, with option to force delete unmerged branches.
clip () {
	# Return if we're not inside an actual work tree
	if [[ ! "$(git rev-parse --is-inside-work-tree)" ]] 2>/dev/null; then
		echo "fatal: Not a git repository (or any of the parent directories): .git"

		return 1
	fi

	if [[ $# -eq 0 ]]; then
		printf 'Usage: clip [-h|--help] [-F|--force] <branchref>\n'

		return 1
	fi

	while [[ $# -gt 0 ]]; do
		case "$1" in
			-h|--help)
				printf 'Usage: clip [-h|--help] [-F|--force] <branchref>\n'
			;;
			-F|--force)
				shift

				git branch -D "$1"

				break
			;;
			*)
				git branch -d "$1"

				break
			;;
		esac
	done
}

# rclip: Delete remote branch from specificed remote repository.
rclip () {
	git push "$1" --delete "$2" ;
}

# rprune: Prune remote branch from list of remote branches.
rprune () {
	git remote prune "$1" ;
}

# log: Pretty format `git log` with options for refining log output.
log () {
	# Return if we're not inside an actual work tree
	if [[ ! "$(git rev-parse --is-inside-work-tree)" ]] 2>/dev/null; then
		echo "fatal: Not a git repository (or any of the parent directories): .git"

		return 1
	fi

	# Decorated `git log` graph format style.
	local FORMAT='%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'

	# Total number of commits for the repo.
	local TOTAL="$(git rev-list HEAD --count)"

	# Default output, if no options were given to `log`.
	if [[ $# -eq 0 ]]; then
		if [[ "$TOTAL" -gt 10 ]]; then
			printf '\n********** \033[1;32mShowing last %s of %s total commits\033[0m **********\n\n' "10" "$TOTAL"
			git log --graph --pretty=format:"$FORMAT" --abbrev-commit --date=relative --max-count="10"
		else
			printf '\n********** \033[1;32mShowing all %s commits\033[0m **********\n\n' "$TOTAL"
			git log --graph --pretty=format:"$FORMAT" --abbrev-commit --date=relative
		fi

		return 0
	fi

	while [[ $# -gt 0 ]]; do
		case "$1" in
			-h|--help)
				printf 'Usage: log [-h|--help] [-A|--all] [-L|--last <count>]\n'

				break
			;;
			-A|--all)
				shift

				printf '\n********** \033[1;32mShowing all %s commits\033[0m **********\n\n' "$TOTAL"
				git log --graph --pretty=format:"$FORMAT" --abbrev-commit --date=relative

				break
			;;
			-L|--last)
				shift

				local NUM="$1"
				local REGEX='^[0-9]+$'

				if ! [[ $NUM =~ $REGEX ]]; then
					NUM="1"
				fi

				if [[ $NUM -gt $TOTAL ]]; then
					NUM=$TOTAL
				fi

				printf '\n********** \033[1;32mShowing last %s of %s commits\033[0m **********\n\n' "$NUM" "$TOTAL"
				git log --graph --pretty=format:"$FORMAT" --abbrev-commit --date=relative --max-count="$NUM"

				break
			;;
			*)
				printf 'Invalid option %s\n\nUsage: log [-h|--help] [-A|--all] [-L|--last <count>]\n' "$1"

				break
			;;
		esac
	done
}

# reflog: Pretty format `git reflog show` with optional flag options for refining reflog output.
reflog () {
	if [[ ! "$(git rev-parse --is-inside-work-tree)" ]] 2>/dev/null; then
		echo "fatal: Not a git repository (or any of the parent directories): .git"

		return 1
	fi

	# Decorated `git reflog show` graph format style.
	local FORMAT='%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'

	# All refs contained in the reflog.
	local REFS="$(git --no-pager reflog show --pretty=format:'%gd')"

	# Total number of refs in reflog.
	local TOTAL=0

	for i in $REFS; do
		let TOTAL++
	done

	# Default output, if no options were given to `reflog`.
	if [[ $# -eq 0 ]]; then
		if [[ "$TOTAL" -gt 10 ]]; then
			printf '\n********** \033[1;32mShowing last %s of %s entries\033[0m **********\n\n' "10" "$TOTAL"
			git reflog show --pretty=format:"$FORMAT" --abbrev-commit --date=relative --max-count="10"
		else
			printf '\n********** \033[1;32mShowing all %s entries\033[0m **********\n\n' "$TOTAL"
			git reflog show --pretty=format:"$FORMAT" --abbrev-commit --date=relative
		fi

		return 0
	fi

	# Wrangle the given options.
	while [[ $# -gt 0 ]]; do
		case "$1" in
			-h|--help)
				printf 'Usage: reflog [-h|--help] [-A|--all] [-L|--last <count>]\n' "$1"

				break
			;;
			-A|--all)
				printf '\n********** \033[1;32mShowing all %s entries\033[0m **********\n\n' "$TOTAL"

				git reflog show --pretty=format:"$FORMAT" --abbrev-commit --date=relative

				break
			;;
			-L|--last)
				shift

				local NUM="$1"
				local REGEX='^[0-9]+$'

				if ! [[ $NUM =~ $REGEX ]]; then
					NUM="1"
				fi

				if [[ $NUM -gt $TOTAL ]]; then
					NUM=$TOTAL
				fi

				printf '\n********** \033[1;32mShowing last %s of %s total entries\033[0m **********\n\n' "$NUM" "$TOTAL"
				git reflog show --pretty=format:"$FORMAT" --abbrev-commit --date=relative --max-count="$NUM"

				break
			;;
			*)
				printf 'Invalid option %s\n\nUsage: reflog [-h|--help] [-A|--all] [-L|--last <count>]\n' "$1"

				break
			;;
		esac
	done
}
