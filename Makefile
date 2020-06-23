prefix ?= /usr/local
bindir = $(prefix)/bin
envVariableName = "#$CODEGEN_PATH"
bashProfilePath = "${HOME}/.bash_profile"
bashPath = export ${envVariableName}=${bindir}/bin
bashAlias = "alias codegen=${bindir}/bin"

build:
	swift build -c release --disable-sandbox

install: build
	echo "${bindir}"
	install ".build/release/codegen" "$(bindir)"
	# echo "${bashPath}" >> "${bashProfilePath}"
	echo ${bashAlias} >> ${bashProfilePath}
	source ${bashProfilePath}
uninstall:
	rm -rf $(bindir)/bin
	# sed -i -e 's/"${bashPath}"/""/g' "${bashProfilePath}"
	sed -i -e 's/"${bashAlias}"/"#"/g' "${bashProfilePath}"
clean:
	rm -rf .build

.PHONY: build install uninstall clean