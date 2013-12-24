all: library comp test

comp:
	cd components/ && ozc -c *.oz && cd ..

library:
	cd lib/ && ozc -c *.oz && cd ..

test:
	ozc -c *.oz

clean:
	rm -rf lib/*.ozf
	rm -rf components/*.ozf
	rm -rf *.ozf
