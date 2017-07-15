OCAMLC_OPTIONS := -w A -warn-error A
OCAMLC_BYTE    := ocamlc.opt   $(OCAMLC_OPTIONS)
OCAMLC_NATIVE  := ocamlopt.opt $(OCAMLC_OPTIONS)

.PHONY: \
	build \
	clean \
	clean_bin \
	clean_objects \
	rebuild \
	test

# =============================================================================
# Build
# =============================================================================

build: \
	bin/arabic \
	bin/roman \
	bin/binary

rebuild:
	@$(MAKE) clean
	@$(MAKE) build

bin/%: %.ml %.cmx %.o bin
	@$(OCAMLC_NATIVE) -o $@ $*.cmx

%.cmi: %.mli
	@$(OCAMLC_NATIVE) -c $<

%.cmx %.o: %.ml %.cmi
	@$(OCAMLC_NATIVE) -c $<

%.cmo: %.ml %.cmi
	@$(OCAMLC_BYTE) -c $<

bin:
	@mkdir -p bin

# =============================================================================
# Test
# =============================================================================

test: test_binary

test_%: bin/%
	./test.sh $*

# =============================================================================
# Clean
# =============================================================================

clean: \
	clean_bin \
	clean_objects

clean_bin:
	@rm -rf bin

clean_objects:
	@rm -f {*.o,*.cm{i,x,o}}
