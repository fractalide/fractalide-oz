all: comp library

comp:
	cd components/ && ozc -c *.oz && cd ..

library:
	cd lib/ && ozc -c *.oz && cd ..

clean:
	rm -rf lib/*.ozf
	rm -rf components/*.ozf