import { App, Stack, StackProps } from '@aws-cdk/core';
import { LambdaRestApi, LambdaIntegration } from '@aws-cdk/aws-apigateway';
import { AssetCode, Function, Runtime } from '@aws-cdk/aws-lambda';
import { DynamoDBStack } from './dynamodb';

export class LambdaApiStack extends Stack {
    readonly dynamoStack: DynamoDBStack;
    constructor(parent: App, name: string, dynamoStack: DynamoDBStack, props: StackProps) {
        super(parent, name, props);

        const lambdaApiFunction = new Function(this, 'lambda-api-function', {
            code: new AssetCode('target/lambda/release/api.zip'),
            handler: 'doesnt.matter',
            runtime: Runtime.PROVIDED
        });
        dynamoStack.timeTable.grantReadWriteData(lambdaApiFunction.role);

        const watchsonApi = new LambdaRestApi(this, 'watchson-api', {
            restApiName: 'Watchson Api',
            handler: lambdaApiFunction,
            proxy: false,
        });

        const api = watchsonApi.root.addResource('api');
        const time = api.addResource('time');
        time.addMethod('PUT', new LambdaIntegration(lambdaApiFunction));
   }
}