
SOURCES = algo.lua main.lua conf.lua

guesser.zip: $(SOURCES)
	zip $@ $^

guesser.love: guesser.zip
	cp $< $@

