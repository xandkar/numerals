OCAMLC_OPTIONS := -w A -warn-error A
OCAMLC_BYTE    := ocamlc.opt   $(OCAMLC_OPTIONS)
OCAMLC_NATIVE  := ocamlopt.opt $(OCAMLC_OPTIONS)
EXECUTABLES    := arabic binary roman

.PHONY: \
	build \
	clean \
	clean_bin \
	clean_objects \
	rebuild \
	test

.INTERMEDIATE: \
	$(foreach exe, $(EXECUTABLES), bin/exe/$(exe).o bin/exe/$(exe).cmx)

# =============================================================================
# Build
# =============================================================================

build: $(foreach exe, $(EXECUTABLES), bin/exe/$(exe))

rebuild:
	@$(MAKE) clean
	@$(MAKE) build

bin/exe/%: src/exe/%.ml bin/exe/%.cmx bin/exe/%.o
	@$(OCAMLC_NATIVE) -o $@ $(@D)/$*.cmx

bin/exe/%.cmi: src/exe/%.mli bin/exe
	@$(OCAMLC_NATIVE) -o $@ -c $<

bin/exe/%.cmx bin/exe/%.o: src/exe/%.ml bin/exe bin/exe/%.cmi
	@$(OCAMLC_NATIVE) -I $(@D) -o $@ -c $<

bin/exe/%.cmo: src/exe/%.ml bin/exe/%.cmi
	@$(OCAMLC_BYTE) -c $<

bin/exe:
	@mkdir -p bin/exe

# =============================================================================
# Test
# =============================================================================

test: test_binary

test_%: bin/exe/%
	./test.sh $*

# =============================================================================
# Clean
# =============================================================================

clean: clean_bin

clean_bin:
	@rm -rf bin
