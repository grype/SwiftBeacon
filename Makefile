SCHEME := Beacon

.PHONY: default all clean build test linuxmain

default: all 

all: clean build test

clean:
	xcodebuild -scheme $(SCHEME) clean

build:
	xcodebuild -scheme $(SCHEME) build

test: build
	xcodebuild -scheme $(SCHEME) test

linuxmain:
	swift test --generate-linuxmain
