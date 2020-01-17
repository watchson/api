runtest:
	cargo test

build-bin:
	docker run --rm \
		-v ${PWD}:/code \
		-v ${HOME}/.cargo/registry:/root/.cargo/registry \
		-v ${HOME}/.cargo/git:/root/.cargo/git \
		softprops/lambda-rust

release: build-bin

package: release
	sam package  --output-template-file packaged.yaml --s3-bucket watchson-api-deploy-bucket

deploy: package
	sam deploy --template-file packaged.yaml --stack-name watchson-api --capabilities CAPABILITY_NAMED_IAM