
ifeq ($(OS),Windows_NT)
	EXE_EXT := .exe
	MINGW32 := mingw32-
	NULL    := NUL
	SLASH   := \\
	EXTRA_CFLAGS :=
	EXTRA_LFLAGS :=
else
	EXE_EXT :=
	MINGW32 :=
	NULL    := /dev/null
	SLASH   := /
	EXTRA_CFLAGS := -extra-cflags="-O2"
	EXTRA_LFLAGS := -extra-lflags="-s -fPIC -no-pie"
endif

EUC  := euc$(EXE_EXT)
GREP := grep$(EXE_EXT)
MAKE := $(MINGW32)make$(EXE_EXT)
TR   := tr$(EXE_EXT)
WGET := wget$(EXE_EXT)

BUILD_DIR  := build
PROJECT    := cipher76
TARGET     := $(PROJECT)$(EXE_EXT)
E_SOURCE   := $(PROJECT).ex
MAKEFILE   := $(PROJECT).mak

$(TARGET) : $(BUILD_DIR)/$(MAKEFILE) $(WORDS_FILE)
	$(MAKE) -C $(BUILD_DIR) -f $(MAKEFILE)

$(BUILD_DIR)/$(MAKEFILE) : $(E_SOURCE)
	$(EUC) -D TRANSLATE -build-dir $(BUILD_DIR) -makefile $(EXTRA_CFLAGS) $(EXTRA_LFLAGS) -o $(TARGET) $(E_SOURCE)

clean :
	@rm -f $(TARGET)
	@rm -f $(BUILD_DIR)$(SLASH)*.c
	@rm -f $(BUILD_DIR)$(SLASH)*.h
	@rm -f $(BUILD_DIR)$(SLASH)*.o
	@rm -f $(BUILD_DIR)$(SLASH)*.mak
	@if [ -d $(BUILD_DIR) ]; then rmdir $(BUILD_DIR); fi
