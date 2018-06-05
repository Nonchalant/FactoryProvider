.PHONY : lint release

lint:
	pod lib lint --no-clean --allow-warnings

release:
	pod trunk push FactoryProvider.podspec
	