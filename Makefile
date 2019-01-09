# Makefile

SRCTOP=..
include $(SRCTOP)/build/vars.mak

build: package
unittest:
systemtest: test-setup test-run
silktest:
	$(MAKE) NTESTFILES="systemtest/silk.ntest" RUNFLOGTESTS=1 test-setup test-run

NTESTFILES ?= systemtest

test-setup:
	$(EC_PERL) ../EC-SilkTest/systemtest/setup.pl $(TEST_SERVER) $(PLUGINS_ARTIFACTS)

test-run: systemtest-run

include $(SRCTOP)/build/rules.mak
