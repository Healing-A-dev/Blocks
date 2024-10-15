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
	@cd && rename .blocks .blocks.update
	@if [ -d .blocks ]; then echo "BOOOO"; cp .blocks.update/Blocks.lua $(MVDIR) && cp .blocks.update/config.yaml $(MVDIR); fi
	@if [ ! -d .blocks ]; then echo "HEHEHE"; mkdir $(MVDIR) && cp .blocks.update/Blocks.lua $(MVDIR) && cp .blocks.update/config.yaml $(MVDIR); fi
	@cd .blocks.update
	@cp blocks /home/$(USER)
	@sudo mv -f blocks $(INSTALL_PATH)
	@cd
	@rm -rf $CONST_NAME.update
	@cd
Linux build:
	cd /
	./srlua-102/srglue srlua-102/srlua export_copy.lua blocks-build
	cp blocks-build $(INSTALL_PATH)
