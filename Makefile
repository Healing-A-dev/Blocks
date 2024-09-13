CONST_NAME = .blocks
INSTALL_PATH = /usr/local/bin
MVDIR = /home/$(USERNAME)/$(CONST_NAME)

all: bin test

bin:
	@$(MAKE) `uname`
test:
	./srlua-102/srglue srlua-102/srlua example/buildTest/helloWorld.lua example/buildTest/helloWorld.out
	./example/buildTest/helloWorld.out *
install:
	@cd srlua-102 && make && cd ..
	@./srlua-102/srglue srlua-102/srlua export_copy.lua blocks-build && chmod +x blocks-build
	@mkdir $(MVDIR) && cp Blocks.lua $(MVDIR)
	@cp blocks-build /home/$(USERNAME)
	@sudo mv -f blocks-build $(INSTALL_PATH)
	@cd && rm -rf Blocks
Linux build:
	cd /
	./srlua-102/srglue srlua-102/srlua export_copy.lua blocks-build
	cp blocks-build $(INSTALL_PATH)
