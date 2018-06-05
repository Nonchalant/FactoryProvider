.PHONY : clean build test release xcodeproj

default: clean build

clean:
	swift package clean
	rm -rf .build ./FactoryGenerator.xcodeproj

build:
	swift build

test:
	swift test

release:
	swift build -c release -Xswiftc -static-stdlib

xcodeproj:
	swift package generate-xcodeproj
