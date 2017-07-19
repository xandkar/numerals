OCAMLC_OPTIONS := -w A -warn-error A
OCAMLC_BYTE    := ocamlc.opt   $(OCAMLC_OPTIONS)
OCAMLC_NATIVE  := ocamlopt.opt $(OCAMLC_OPTIONS)

EXE_HOME_SRC := src/exe
EXE_HOME_BIN := bin/exe

EXE_NAMES   := arabic binary roman
EXE_PATHS   := $(addprefix $(EXE_HOME_BIN)/,$(EXE_NAMES))
EXE_OBJ_O   := $(addsuffix .o,$(EXE_PATHS))
EXE_OBJ_CMX := $(addsuffix .cmx,$(EXE_PATHS))
EXE_OBJ_CMI := $(addsuffix .cmi,$(EXE_PATHS))

.PHONY: \
	build \
	clean \
	rebuild \
	test

.INTERMEDIATE: \
	$(EXE_OBJ_CMI) \
	$(EXE_OBJ_CMX) \
	$(EXE_OBJ_O)

# =============================================================================
# Build
# =============================================================================

build \
: $(EXE_PATHS)

rebuild :
	@$(MAKE) clean
	@$(MAKE) build

$(EXE_HOME_BIN)/% \
: $(EXE_HOME_SRC)/%.ml $(EXE_HOME_BIN)/%.cmx $(EXE_HOME_BIN)/%.o
	@$(OCAMLC_NATIVE) -o $@ $(@D)/$*.cmx

$(EXE_HOME_BIN)/%.cmi \
: $(EXE_HOME_SRC)/%.mli \
| $(EXE_HOME_BIN)
	@$(OCAMLC_NATIVE) -o $@ -c $<

$(EXE_HOME_BIN)/%.cmx $(EXE_HOME_BIN)/%.o \
: $(EXE_HOME_SRC)/%.ml $(EXE_HOME_BIN)/%.cmi \
| $(EXE_HOME_BIN)
	@$(OCAMLC_NATIVE) -I $(@D) -o $@ -c $<

$(EXE_HOME_BIN)/%.cmo \
: $(EXE_HOME_SRC)/%.ml $(EXE_HOME_BIN)/%.cmi
	@$(OCAMLC_BYTE) -c $<

$(EXE_HOME_BIN) :
	@mkdir -p $(EXE_HOME_BIN)

# =============================================================================
# Test
# =============================================================================

test \
: test_binary

test_% \
: $(EXE_HOME_BIN)/%
	./test.sh $*

# =============================================================================
# Clean
# =============================================================================

clean :
	@rm -rf bin
