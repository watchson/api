runtest:
	cargo test

build-image:
	docker build -f Dockerfile.build . -t lambda_builder

build-bin:
	docker run --rm -v ${PWD}:/code -v ${HOME}/.cargo/registry:/root/.cargo/registry -v ${HOME}/.cargo/git:/root/.cargo/git lambda_builder cargo build --release

build-zip:
	cp ./target/release/api ./bootstrap && zip lambda.zip bootstrap && rm bootstrap

release: build-bin build-zip

package: release
	sam package  --output-template-file packaged.yaml --s3-bucket watchson-api-deploy-bucket

deploy: package
	sam deploy --template-file packaged.yaml --stack-name watchson-api --capabilities CAPABILITY_NAMED_IAM