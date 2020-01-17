ARCHS = arm64 arm64e
TARGET = iphone:clang::11.0

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = libskittycolor

libskittycolor_FILES = $(wildcard *.m)
libskittycolor_PRIVATE_FRAMEWORKS = Preferences
libskittycolor_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/library.mk

setup::
	@make
	@echo "Copying library and headers..."
	@cp $(THEOS_OBJ_DIR)/libskittycolor.dylib $(THEOS)/lib/libskittycolor.dylib
	@mkdir $(THEOS)/include/libskittycolor/
	@cp SkittyColorCell.h $(THEOS)/include/libskittycolor/SkittyColorCell.h
	@echo "Done."
