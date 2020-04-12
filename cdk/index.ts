#!/usr/bin/env node
import cdk = require('@aws-cdk/core');
import { LambdaApiStack } from './lambda-api';
import { DynamoDBStack } from './dynamodb';

const app = new cdk.App();

const stackProps = {
    env: { 
        region: 'us-east-1',
        account: '064638649248'        
    }
}

const dynamoDB = new DynamoDBStack(app, 'dynamo-db-stack', stackProps);
new LambdaApiStack(app, 'lambda-api-stack', dynamoDB, stackProps);

app.synth();