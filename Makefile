bundle_name="watchson_api"

clean:
	rm -f build/*.zip

build_lambda_dependencies:
	bundle install --path build/dependencies

build_lambda: clean build_lambda_dependencies
	zip -r build/$(bundle_name).zip main_controller.rb app build/dependencies

deploy_upload_artifact: build_lambda
	aws s3 cp build/watchson_api.zip s3://watchson-api-deploy-bucket --profile watchson

deploy_lambda:
	aws cloudformation update-stack \
		--stack-name watchsonApiLambdaDeploy \
		--template-body file://$(PWD)/cloudformation/deploy_lambdas.yml \
		--capabilities CAPABILITY_NAMED_IAM \
		--profile watchson

deploy: deploy_upload_artifact deploy_lambda
	echo "Lambda Deployed"

create_bucket:
	aws cloudformation create-stack \
		--stack-name watchsonApiBucketDeploy \
		--template-body file://$(PWD)/cloudformation/create-bucket.yml \
		--profile watchson
