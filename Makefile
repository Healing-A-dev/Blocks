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
	@mkdir $(MVDIR) && cp Blocks.lua $(MVDIR) && cp config.yaml $(MVDIR)
	@cp blocks /home/$(USER)
	@sudo mv -f blocks $(INSTALL_PATH)
	@if [[ -d Blocks ]] && ![[ -d .Blocks.update ]]; then cd rm -rf Blocks; fi 
	@if [ -d .Blocks.update ]; then echo "BRUVA" cd rm -rf .Blocks.update; fi
	@cd
Linux build:
	cd /
	./srlua-102/srglue srlua-102/srlua export_copy.lua blocks-build
	cp blocks-build $(INSTALL_PATH)
