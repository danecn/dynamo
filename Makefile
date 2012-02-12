EBIN_DIR=ebin
ERLC=erlc -W0
ERL=erl -noshell -pa $(EBIN_DIR)

.PHONY: setup test clean

compile: ebin

setup:
	git submodule update --init
	cd deps/ibrowse && make
	cd deps/misultin && make

ebin: lib/*.ex lib/*/*.ex lib/*/*/*.ex
	@ rm -f ebin/::*.beam
	@ echo Compiling ...
	@ mkdir -p $(EBIN_DIR)
	@ touch $(EBIN_DIR)
	elixirc lib/*/*/*.ex lib/*/*.ex lib/*.ex -o ebin
	@ echo

test: compile
	@ echo Running tests ...
	time elixir -pa ebin "test/**/*_test.exs"
	@ echo

clean:
	rm -rf $(EBIN_DIR)
	@ echo
