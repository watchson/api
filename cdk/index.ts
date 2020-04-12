#!/usr/bin/env node
import cdk = require('@aws-cdk/core');
import { LambdaApiStack } from './lambda-api';

const app = new cdk.App();

new LambdaApiStack(app, `lambda-api-stack`, { 
    env: { 
        region: 'us-east-1',
        account: '064638649248'        
    }
});

app.synth();