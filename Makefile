
INSTALL_PATH = /usr/local/bin

all: bin test

bin:
	@$(MAKE) `uname`
test:
	./srlua-102/srglue srlua-102/srlua example/buildTest/helloWorld.lua example/buildTest/helloWorld.out
	./example/buildTest/helloWorld.out *
install:
	./srlua-102/srglue srlua-102/srlua export_copy.lua blocks-build
	cp blocks-build $(INSTALL_PATH)
Linux build:
	cd /
	./srlua-102/srglue srlua-102/srlua export_copy.lua blocks-build
	cp blocks-build $(INSTALL_PATH)

