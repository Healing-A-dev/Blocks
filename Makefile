CONST_NAME = .blocks
INSTALL_PATH = /usr/local/bin
MVDIR = /home/$(USER)/$(CONST_NAME)

install:
	@cd srlua-102 && make && cd ..
	@./srlua-102/srglue srlua-102/srlua export_copy.lua blocks && chmod +x blocks
	@cd && mkdir $(MVDIR) && cd Blocks && cp Blocks.lua $(MVDIR) && cp config.yaml $(MVDIR)
	@cp blocks /home/$(USER)
	@sudo mv -f blocks $(INSTALL_PATH)
	@cd && cd && echo '__NAME: "Blocks"' >> .blocks/config.yaml && rm -rf Blocks 
Blocks_update:
	@cd srlua-102 && make && cd ..
	@cd .. && ./.update/srlua-102/srglue .update/srlua-102/srlua .update/export_copy.lua blocks && chmod +x blocks
	@cd && cp $(CONST_NAME)/.update/Blocks.lua $(CONST_NAME)/Blocks.lua && cp $(CONST_NAME)/.update/config.yaml $(CONST_NAME)/config.yaml
	@cd .. && cp blocks /home/$(USER) && sudo mv -f blocks $(INSTALL_PATH)
	@cd && cd $(CONST_NAME) && rm -rf .update blocks
