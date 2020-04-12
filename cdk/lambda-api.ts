#!/usr/bin/env node
import cdk = require('@aws-cdk/core');
import { Construct } from '@aws-cdk/core';

export interface LambdaApiProps {    

}

export class LambdaApi extends Construct {
    constructor(parent: Construct, name: string, props: LambdaApiProps) {
        super(parent, name);        
    }
}

export class LambdaApiStack extends cdk.Stack {
    constructor(parent: cdk.App, name: string, props: cdk.StackProps) {
        super(parent, name, props);

        new LambdaApi(this, `lambda-api`, {});
   }
}