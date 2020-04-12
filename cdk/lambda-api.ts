#!/usr/bin/env node
import { Construct, App, Stack, StackProps } from '@aws-cdk/core';
import { LambdaRestApi, LambdaIntegration } from '@aws-cdk/aws-apigateway';
import { AssetCode, Function, Runtime } from '@aws-cdk/aws-lambda';

export interface LambdaApiProps {
}

export class LambdaApi extends Construct {
    constructor(parent: Construct, name: string, props: LambdaApiProps) {
        super(parent, name);

        const lambdaApiFunction = new Function(this, 'lambda-api-function', {
            code: new AssetCode('target/lambda/release/api.zip'),
            handler: 'doesnt.matter',
            runtime: Runtime.PROVIDED
        });

        const watchsonApi = new LambdaRestApi(this, 'helloWorldLambdaRestApi', {
            restApiName: 'Watchson Api',
            handler: lambdaApiFunction,
            proxy: false,
        });

        const api = watchsonApi.root.addResource('api');
        const time = api.addResource('time');
        time.addMethod('PUT', new LambdaIntegration(lambdaApiFunction));
    }
}

export class LambdaApiStack extends Stack {
    constructor(parent: App, name: string, props: StackProps) {
        super(parent, name, props);

        new LambdaApi(this, `lambda-api`, {});
   }
}