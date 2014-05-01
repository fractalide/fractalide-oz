all: library comp test

comp:
	cd components/ && $(OZHOME)/bin/ozc -c *.oz && cd ..
	cd components/ui && $(OZHOME)/bin/ozc -c *.oz && cd ../..
	cd components/gates && $(OZHOME)/bin/ozc -c *.oz && cd ../..
	cd components/calculator && $(OZHOME)/bin/ozc -c *.oz && cd ../../
	cd components/ui/canvas && $(OZHOME)/bin/ozc -c *.oz && cd ../../
	cd components/dnd/ && $(OZHOME)/bin/ozc -c *.oz && cd ../../
	cd components/failure/ && $(OZHOME)/bin/ozc -c *.oz && cd ../../

editor:
	cd components/editor && $(OZHOME)/bin/ozc -c *.oz && cd ../../
	cd components/editor/link && $(OZHOME)/bin/ozc -c *.oz && cd ../../../
	cd components/editor/component && $(OZHOME)/bin/ozc -c *.oz && cd ../../../
	cd components/editor/labelentry && $(OZHOME)/bin/ozc -c *.oz && cd ../../../
	cd components/graph && $(OZHOME)/bin/ozc -c *.oz && cd ../../
	cd components/mouse && $(OZHOME)/bin/ozc -c *.oz && cd ../../
	cd components/editor/editPanel && $(OZHOME)/bin/ozc -c *.oz && cd ../../../


library:
	cd lib/ && $(OZHOME)/bin/ozc -c *.oz && cd ..

test:
	$(OZHOME)/bin/ozc -c *.oz

clean:
	rm -Rrf lib/*.ozf
	rm -Rrf components/*.ozf
	rm -Rrf *.ozf
