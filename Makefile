.PHONY: all compile xref dialyzer test

all: compile test

compile:
	@rebar3 compile

xref:
	@rebar3 xref

dialyzer:
	@rebar3 dialyzer

test: xref
	@rebar3 eunit

clean:
	@rebar3 clean

distclean: clean
	@rm -rfv _build
