###
### Makefile
###

PREFIX ?= /usr/local
BINDIR := $(PREFIX)/bin

KERNEL := $(shell sh -c 'uname -s 2>/dev/null || echo unknown')

ifeq "$(KERNEL)" "Darwin"
OSNAME := "macos"
endif

.PHONY: all

all:
	./setup.sh --type ${OSNAME} --type ${ALL}
