CONST_NAME = .blocks
INSTALL_PATH = /usr/local/bin
MVDIR = /home/$(USER)/$(CONST_NAME)

all: bin test

bin:
	@$(MAKE) `uname`
install:
	@cd srlua-102 && make && cd ..
	@./srlua-102/srglue srlua-102/srlua export_copy.lua blocks && chmod +x blocks
	@cd && mkdir $(MVDIR) && cd Blocks && cp Blocks.lua $(MVDIR) && cp config.yaml $(MVDIR)
	@cp blocks /home/$(USER)
	@sudo mv -f blocks $(INSTALL_PATH)
	@cd && rm -rf Blocks
Blocks_update:
	@echo "WORKING ON IT"
	@cd srlua-102 && make && cd ..
	@cd .. && ./.update/srlua-102/srglue .update/srlua-102/srlua .update/export_copy.lua blocks && chmod +x blocks
	@cd .. && pwd && cp .blocks/.update/Blocks.lua Blocks.lua && cp .blocks/.update/config.yaml config.yaml
	@cd && cp blocks /home/$(USER) && sudo mv -f blocks $(INSTALL_PATH)
	@cd .blocks && rm -rf .update
Linux build:
	cd /
	./srlua-102/srglue srlua-102/srlua export_copy.lua blocks-build
	cp blocks-build $(INSTALL_PATH)
