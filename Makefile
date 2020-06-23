prefix ?= /usr/local
bindir = /usr/local/bin
bashProfilePath = ~/.bash_profile
bashPath = export CODEGEN_PATH=/usr/local/Cellar/clicodegen/0.1.3/bin'
bashAlias = alias codegen='$CODEGEN_PATH'

build:
	swift build -c release --disable-sandbox

install: build
	install ".build/release/codegen" "$(bindir)"
	echo "${bashPath}" >> "${bashProfilePath}"
	echo "${bashAlias}" >> "${bashProfilePath}"
	source "${bashProfilePath}"
uninstall:
	rm -rf "$(bindir)/codegen"
	sed -i -e 's/"${bashPath}"/""/g' "${bashProfilePath}"
	sed -i -e 's/"${bashAlias}"/""/g' "${bashProfilePath}"
clean:
	rm -rf .build

.PHONY: build install uninstall clean