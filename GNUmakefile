include $(GNUSTEP_MAKEFILES)/common.make

LIBRARY_NAME = libblindside

libblindside_HEADER_FILES_INSTALL_DIR = Blindside
libblindside_HEADER_FILES_DIR = Headers/Public
libblindside_HEADER_FILES = Blindside.h \
	BSBinder.h \
	BSBlockProvider.h \
	BSInitializer.h \
	BSInjector.h \
	BSModule.h \
	BSNullabilityCompat.h \
	BSNull.h \
	BSPropertySet.h \
	BSProvider.h \
	BSScope.h \
	BSSingleton.h \
	NSObject+Blindside.h

libblindside_OBJC_FILES = Source/Blindside.m \
	Source/BSBlockProvider.m \
	Source/BSClassProvider.m \
	Source/BSInitializer.m \
	Source/BSInitializerProvider.m \
	Source/BSInjectorImpl.m \
	Source/BSInstanceProvider.m \
	Source/BSNull.m \
	Source/BSProperty.m \
	Source/BSPropertySet.m \
	Source/BSSingleton.m \
	Source/NSObject+Blindside.m

ADDITIONAL_INCLUDE_DIRS = -IHeaders/Public -IHeaders/Private

include $(GNUSTEP_MAKEFILES)/library.make