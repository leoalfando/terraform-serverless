/* eslint-disable @typescript-eslint/no-unused-vars */
import { ResponseOutput } from '../models/ResponseOutput';
import { APIGatewayProxyEvent, APIGatewayProxyHandler, APIGatewayProxyResult } from 'aws-lambda';

export const handler:APIGatewayProxyHandler = async (_event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
    try {
        const response: ResponseOutput = ResponseOutput.createOkResponse("Mail has been sent succesfully!");

        return response;
    } catch (err) {
        return {
            statusCode: 500,
            body: 'An error occured',
        };
    }
};
