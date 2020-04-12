runtest:
	cargo test

build-bin:
	docker run --rm \
		-v ${PWD}:/code \
		-v ${HOME}/.cargo/registry:/root/.cargo/registry \
		-v ${HOME}/.cargo/git:/root/.cargo/git \
		softprops/lambda-rust

release: build-bin

cdk-install:
	npm --prefix cdk install cdk

cdk-build: cdk-install
	npm --prefix cdk run build

deploy: release cdk-build
	cdk deploy *-stack --profile watchson --app "node cdk/index" --require-approval never
