export TEMPDIR := $(shell mktemp -u)

npm_install: package.json
	npm install

lambda.zip: index.js npm_install
	echo $(TEMPDIR)
	mkdir -p $(TEMPDIR)
	cp *.js $(TEMPDIR)
	cp -r lib $(TEMPDIR)
	cp -r node_modules $(TEMPDIR)
	cd $(TEMPDIR) && zip --quiet -r lambda *
	cp $(TEMPDIR)/lambda.zip .
	rm -fr $(TEMPDIR)

upload: lambda.zip
	aws --region us-east-1 lambda update-function-code --function-name AlexaReadAssignments --zip-file fileb://lambda.zip
