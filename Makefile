all: library comp test

comp:
	cd components/ && ozc -c *.oz && cd ..
	cd components/ui && ozc -c *.oz && cd ../..
	cd components/gates && ozc -c *.oz && cd ../..

library:
	cd lib/ && ozc -c *.oz && cd ..

test:
	ozc -c *.oz

clean:
	rm -Rrf lib/*.ozf
	rm -Rrf components/*.ozf
	rm -Rrf *.ozf
