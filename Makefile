CONST_NAME = .blocks
INSTALL_PATH = /usr/local/bin
MVDIR = /home/$(USER)/$(CONST_NAME)

all: bin test

bin:
	@$(MAKE) `uname`
test:
	./srlua-102/srglue srlua-102/srlua example/buildTest/helloWorld.lua example/buildTest/helloWorld.out
	./example/buildTest/helloWorld.out *
install:
	@cd srlua-102 && make && cd ..
	@./srlua-102/srglue srlua-102/srlua export_copy.lua blocks && chmod +x blocks
	@cd && pwd
	@if ! [ -d .blocks ]; then mkdir $(MVDIR) && cp Blocks.lua $(MVDIR) && cp config.yaml $(MVDIR); fi
	@if [ -d .blocks ]; then cp Blocks.lua $(MVDIR) && cp config.yaml $(MVDIR); fi
	@cd .blocks
	@cp blocks /home/$(USER)
	@sudo mv -f blocks $(INSTALL_PATH)
	@cd
	@if [[ -d Blocks ]] && ![[ -d .Blocks.update ]]; then rm -rf Blocks; fi
	@rm -rf $CONST_NAME.update
	@cd
Linux build:
	cd /
	./srlua-102/srglue srlua-102/srlua export_copy.lua blocks-build
	cp blocks-build $(INSTALL_PATH)
