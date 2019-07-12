clean:
	rm -f build/*.zip

runtest:
	bundle exec rake spec

build_dependencies:
	bundle install --path build/dependencies

build_lambda:
	zip -r "build/watchson_api.zip" main_controller.rb app build/dependencies

release: clean build_dependencies runtest build_lambda

package: release
	sam package  --output-template-file packaged.yaml --s3-bucket watchson-api-deploy-bucket

deploy: package
	sam deploy --template-file packaged.yaml --stack-name watchson-api --capabilities CAPABILITY_NAMED_IAM