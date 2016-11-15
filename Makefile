lua_content = $(wildcard luaxml-*.lua) 
tex_content = $(wildcard *.tex)

name = luaxml
VERSION:= $(shell git --no-pager describe --tags --always )
DATE := $(firstword $(shell git --no-pager show --date=short --format="%ad" --name-only))
doc_file = luaxml.pdf
TEXMFHOME = $(shell kpsewhich -var-value=TEXMFHOME)
INSTALL_DIR = $(TEXMFHOME)/scripts/lua/$(name)
MANUAL_DIR = $(TEXMFHOME)/doc/latex/$(name)
SYSTEM_BIN = /usr/local/bin
BUILD_DIR = build
BUILD_LUAXML = $(BUILD_DIR)/$(name)

all: doc

doc: $(doc_file) 
	
$(doc_file): $(name).tex
	latexmk -pdf -pdflatex='lualatex "\def\version{${VERSION}}\def\gitdate{${DATE}}\input{%S}"' $(name).tex


build: doc $(lua_content) $(filters)
	@rm -rf build
	@mkdir -p $(BUILD_LUAXML)
	@mkdir -p $(BUILD_LUAXML)/filters
	@cp $(lua_content) $(tex_content)  luaxml-doc.pdf $(BUILD_LUAXML)
	@cp $(filters) $(BUILD_LUAXML)/filters
	@cp README.md $(BUILD_LUAXML)/README
	@cd $(BUILD_DIR) && zip -r luaxml.zip luaxml

install: doc $(lua_content) $(filters)
	mkdir -p $(INSTALL_DIR)
	mkdir -p $(MANUAL_DIR)
	mkdir -p $(FILTERS_DIR)
	cp  $(doc_file) $(MANUAL_DIR)
	cp $(lua_content) $(INSTALL_DIR)
	cp $(filters) $(FILTERS_DIR)
	chmod +x $(INSTALL_DIR)/luaxml
	ln -s $(INSTALL_DIR)/luaxml $(SYSTEM_BIN)/luaxml
