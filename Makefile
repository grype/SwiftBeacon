SCHEME := Beacon

.PHONY: default all clean build test linuxmain install-git-hooks

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

install-git-hooks:
	cp scripts/git-hooks/pre-commit.sh .git/hooks/pre-commit
	chmod a+x .git/hooks/pre-commit
