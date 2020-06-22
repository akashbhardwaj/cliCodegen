prefix ?= /usr/local
bindir = $(prefix)/bin

build:
	swift build -c release

install: build
	install ".build/release/codegen" "$(bindir)"
	install_name_tool -change \
		"$(bindir)/codegen"

uninstall:
	rm -rf "$(bindir)/codegen"

clean:
	rm -rf .build

.PHONY: build install uninstall clean