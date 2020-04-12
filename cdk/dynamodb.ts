import { App, Stack, StackProps } from '@aws-cdk/core';
import dynamodb = require('@aws-cdk/aws-dynamodb');

export class DynamoDBStack extends Stack {
    public readonly timeTable: dynamodb.Table;

    constructor(parent: App, name: string, props: StackProps) {
        super(parent, name, props);

        this.timeTable = new dynamodb.Table(this, 'Time', {
            tableName: 'Time',
            partitionKey: {
                name: 'user_id',
                type: dynamodb.AttributeType.STRING
            },
            sortKey: {
                name: 'registered_date',
                type: dynamodb.AttributeType.NUMBER
            },
            serverSideEncryption: false,
            pointInTimeRecovery: false,
            billingMode: dynamodb.BillingMode.PAY_PER_REQUEST
        });
   }
}