clean:
	rm -f build/function.zip
build_lambda_dependencies:
	bundle install --path build/dependencies
build_lambda: clean build_lambda_dependencies
	zip -r build/function.zip main_controller.rb app build/dependencies
