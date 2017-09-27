BUILD_OPTS=-Xlinker -L/usr/lib -Xlinker -lcurl

SWIFTC=swiftc
SWIFT=swift
ifdef SWIFTPATH
	SWIFTC=$(SWIFTPATH)/bin/swiftc
	SWIFT=$(SWIFTPATH)/bin/swift
endif

OS := $(shell uname)
ifeq ($(OS),Darwin)
	SWIFTC=xcrun -sdk macosx swiftc
	BUILD_OPTS=-Xlinker -lcurl
endif

OSVER=$(shell lsb_release -sr)
ifeq ($(OSVER),14.04)
	BUILD_OPTS+=-Xswiftc -DLIBCURL_OLD
endif

all: debug

release: CONF_ENV=release 
release: build_;

debug: CONF_ENV=debug
debug: build_;

build_:
	$(SWIFT) build --configuration $(CONF_ENV) $(BUILD_OPTS)
	
clean:
	$(SWIFT) package clean
	
distclean:
	$(SWIFT) package reset
	
test:
	$(SWIFT) test $(BUILD_OPTS)
	
genxcodeproj:
	$(SWIFT) package generate-xcodeproj --enable-code-coverage --xcconfig-overrides=Config.xcconfig