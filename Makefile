NOW := $(shell date +%s)
bundle_name = "watchson_api_$(NOW).zip"

clean:
	rm -f build/*.zip

build_lambda_dependencies:
	bundle install --path build/dependencies

build_lambda: clean build_lambda_dependencies
	zip -r build/$(bundle_name) main_controller.rb app build/dependencies

deploy_upload_artifact: build_lambda
	aws s3 cp \
		build/$(bundle_name) \
		s3://watchson-api-deploy-bucket

wait:
	sleep 15

delete_upload_artifact: build_lambda wait
	aws s3 rm \
		s3://watchson-api-deploy-bucket/$(bundle_name)

deploy_lambda:
	aws cloudformation update-stack \
		--stack-name watchsonApiLambdaDeploy \
		--template-body file://$(PWD)/cloudformation/deploy_lambdas.yml \
		--capabilities CAPABILITY_NAMED_IAM \
		--parameters ParameterKey=CodeFilename,ParameterValue=$(bundle_name)

check_deploy_status:
	aws cloudformation describe-stack-events \
		--stack-name watchsonApiLambdaDeploy \
		--max-items 1

deploy: deploy_upload_artifact deploy_lambda
	echo "Lambda Deployed as $(bundle_name)"

create_bucket:
	aws cloudformation create-stack \
		--stack-name watchsonApiBucketDeploy \
		--template-body file://$(PWD)/cloudformation/create-bucket.yml

test:
	bundle exec rake spec