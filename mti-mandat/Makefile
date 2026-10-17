SHELL := /bin/bash

MD      := Edit-Here.md
OUT     := out
DOCX    := $(OUT)/Mandat_2026SC_06.docx
BIB     := references.bib
CSL     := ../assets/csl/apa.csl
FIGURES := $(wildcard figures/*)

.PHONY: build sections refs template styles check clean

build: $(DOCX)

$(DOCX): $(MD) reference.docx landscape.lua $(BIB) $(CSL) $(FIGURES)
	@mkdir -p $(OUT)
	pandoc $(MD) -f markdown -t docx --citeproc --bibliography=$(BIB) --csl=$(CSL) --resource-path=figures --reference-doc=reference.docx --lua-filter=landscape.lua -o $@

sections: build
	@echo "pgSz per <w:sectPr>, in document order:"
	@unzip -p $(DOCX) word/document.xml | tr -d '\r\n' \
	  | sed 's|<w:sectPr|\n<w:sectPr|g' | grep '<w:sectPr' \
	  | grep -o '<w:pgSz[^/]*/>' | nl -ba

refs: build
	@echo "=== header/footer references (document.xml) ==="
	@unzip -p $(DOCX) word/document.xml | tr -d '\r\n' \
	  | grep -o '<w:headerReference[^/]*/>\|<w:footerReference[^/]*/>' \
	  | sed -E 's| />|/>|g; s|r:id="([^"]*)" w:type="([^"]*)"|w:type="\2" r:id="\1"|' | sort -u
	@echo "=== header/footer relationships (document.xml.rels) ==="
	@unzip -p $(DOCX) word/_rels/document.xml.rels \
	  | sed 's|/>|/>\n|g' | grep -E 'relationships/(header|footer)"'

template:
	@echo "=== sectPr of reference.docx ==="
	@unzip -p reference.docx word/document.xml | tr -d '\r\n' \
	  | grep -o '<w:sectPr[^>]*>.*</w:sectPr>'
	@echo "=== evenAndOddHeaders in settings.xml ==="
	@echo "present: $$(unzip -p reference.docx word/settings.xml | grep -q 'evenAndOddHeaders' && echo yes || echo no)"
	@echo "=== PAGE field instrText in footer XML files ==="
	@unzip -p reference.docx 'word/footer*.xml' \
	  | grep -o '<w:instrText[^>]*>[^<]*</w:instrText>' | grep -i PAGE || echo "(none)"

styles: build
	@echo "=== styleIds used in document.xml (pStyle/rStyle) ==="
	@unzip -p $(DOCX) word/document.xml | tr -d '\r\n' \
	  | grep -o 'w:pStyle w:val="[^"]*"\|w:rStyle w:val="[^"]*"' \
	  | grep -o 'w:val="[^"]*"' | sed 's/w:val="//; s/"//' | sort -u
	@echo "=== styleIds defined in styles.xml ==="
	@unzip -p $(DOCX) word/styles.xml | tr -d '\r\n' \
	  | grep -o 'w:styleId="[^"]*"' | sed 's/w:styleId="//; s/"//' | sort -u
	@echo "=== used but NOT defined (missing from template) ==="
	@comm -23 \
	  <(unzip -p $(DOCX) word/document.xml | tr -d '\r\n' | grep -o 'w:pStyle w:val="[^"]*"\|w:rStyle w:val="[^"]*"' | grep -o 'w:val="[^"]*"' | sed 's/w:val="//; s/"//' | sort -u) \
	  <(unzip -p $(DOCX) word/styles.xml | tr -d '\r\n' | grep -o 'w:styleId="[^"]*"' | sed 's/w:styleId="//; s/"//' | sort -u) \
	  || true

check: build
	@set -u; \
	DOC="$$(unzip -p $(DOCX) word/document.xml | tr -d '\r\n')"; \
	echo "=== (a) landscape sectPr present ==="; \
	if printf '%s' "$$DOC" | grep -q 'w:orient="landscape"'; then echo "OK: landscape pgSz found"; else echo "FAIL: no landscape sectPr"; exit 1; fi; \
	echo "=== (b) sectPr count ==="; \
	n="$$(printf '%s' "$$DOC" | grep -o '<w:sectPr' | wc -l)"; \
	divs="$$(grep -cE '^::: *landscape *$$' $(MD))"; \
	exp="$$((1 + 2*divs))"; \
	echo "sectPr=$$n expected=$$exp (landscape divs=$$divs)"; \
	if [ "$$n" -eq "$$exp" ]; then echo "OK: sectPr count matches"; else echo "FAIL: sectPr count mismatch"; exit 1; fi; \
	echo "=== (c) landscape.lua REFS vs final sectPr ==="; \
	norm='s/.*w:(header|footer)Reference.*w:type="([a-z]*)".*r:id="(rId[0-9]*)".*/\1 \2 \3/; s/.*w:(header|footer)Reference.*r:id="(rId[0-9]*)".*w:type="([a-z]*)".*/\1 \3 \2/'; \
	lua_refs="$$(grep -oE '<w:(header|footer)Reference[^/]*/?>' landscape.lua | sed -E "$$norm" | sort)"; \
	final="$$(printf '%s' "$$DOC" | sed 's|<w:sectPr|\n<w:sectPr|g' | grep '<w:sectPr' | tail -1)"; \
	out_refs="$$(printf '%s' "$$final" | grep -oE '<w:(header|footer)Reference[^/]*/?>' | sed -E "$$norm" | sort)"; \
	echo "--- landscape.lua ---"; printf '%s\n' "$$lua_refs"; \
	echo "--- final sectPr  ---"; printf '%s\n' "$$out_refs"; \
	if [ "$$lua_refs" = "$$out_refs" ]; then echo "OK: rIds match"; else echo "FAIL: rId mismatch"; exit 1; fi; \
	echo "ALL CHECKS PASSED"

clean:
	rm -rf $(OUT)
