all: library comp test

comp:
	cd components/ && ~/oz/bin/ozc -c *.oz && cd ..
	cd components/ui && ~/oz/bin/ozc -c *.oz && cd ../..
	cd components/gates && ~/oz/bin/ozc -c *.oz && cd ../..
	cd components/calculator && ~/oz/bin/ozc -c *.oz && cd ../../
	cd components/ui/canvas && ~/oz/bin/ozc -c *.oz && cd ../../
	cd components/dnd/ && ~/oz/bin/ozc -c *.oz && cd ../../

editor:
	cd components/editor && ~/oz/bin/ozc -c *.oz && cd ../../
	cd components/editor/link && ~/oz/bin/ozc -c *.oz && cd ../../../
	cd components/editor/component && ~/oz/bin/ozc -c *.oz && cd ../../../
	cd components/graph && ~/oz/bin/ozc -c *.oz && cd ../../
	cd components/mouse && ~/oz/bin/ozc -c *.oz && cd ../../



library:
	cd lib/ && ~/oz/bin/ozc -c *.oz && cd ..

test:
	~/oz/bin/ozc -c *.oz

clean:
	rm -Rrf lib/*.ozf
	rm -Rrf components/*.ozf
	rm -Rrf *.ozf
