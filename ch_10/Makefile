SRC_FILES := $(wildcard src/*.pl)
TEST_FILES := $(wildcard test/*_test.pl)

.PHONY: test console

default: test

test:
	swipl -p src=src/ -l test/load.pl -g run_tests,halt -t 'halt(1)'

console:
	swipl -p src=src/ -l load.pl
