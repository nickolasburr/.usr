###
### Makefile
###

TOOLS = tools
ANYALL = "all"
OSNAME ?= "macos"

.PHONY: all

all:
	@cd $(TOOLS) && ./setup.sh --type ${OSNAME} --type ${ANYALL}
