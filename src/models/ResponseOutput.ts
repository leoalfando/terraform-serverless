import { ErrorStatus } from '../utils/ErrorStatus';
import Errors from './Errors';

export class ResponseOutput {

    public static createOkResponse(body: any, header?: any): ResponseOutput {
        return this.createResponse(200, body, header);
    }

    public static createNoContentResponse(): ResponseOutput {
        return this.createResponse(204, null);
    }

    public static createCreatedRequestResponse(body: any): ResponseOutput {
        return this.createResponse(201, body);
    }

    public static createNotModifiedResponse(body: any, header?: any): ResponseOutput {
        return this.createResponse(304, body, header);
    }

    public static createBadRequestResponse(errors?: ErrorStatus | ErrorStatus[]): ResponseOutput {
        return this.createErrorResponses(400, errors);
    }

    public static createUnauthorizedResponse(): ResponseOutput {
        return this.createErrorResponses(401, ErrorStatus.UNAUTHENTICATED_HTTP_RESPONSES);
    }

    public static createForbiddenRequestResponse(errors?: ErrorStatus | ErrorStatus[]): ResponseOutput {
        return this.createErrorResponses(403, errors);
    }

    public static createNotFoundRequestResponse(): ResponseOutput {
        return this.createErrorResponses(404, undefined);
    }

    public static createConflictRequestResponse(errors?: ErrorStatus | ErrorStatus[]): ResponseOutput {
        return this.createErrorResponses(409, errors);
    }

    public static createInternalServerErrorRequestResponse(errors?: ErrorStatus | ErrorStatus[]): ResponseOutput {
        return this.createErrorResponses(500, errors);
    }

    public static createErrorResponses(statusCode: number, errors?: ErrorStatus | ErrorStatus[]): ResponseOutput {
        if (errors) {
            const errorObj = new Errors();
            if (Array.isArray(errors)) {
                errors?.forEach(error => {
                    errorObj.errors.push(error);
                })
            } else {
                errorObj.errors.push(errors);
            }
            return this.createResponse(statusCode, errorObj);
        }
        return this.createResponse(statusCode);
    }

    public static createResponse(statusCode: number, body?: any, header?: any): ResponseOutput {
        const response = new ResponseOutput();
        response.statusCode = statusCode;
        if (body) {
            response.body = body;
        }
        if (header) {
            response.header = header;
        }

        return response;
    }

    public static createExternalResponse(statusCode: number, body?: any, header?: any): ResponseOutput {
        const response = new ResponseOutput();
        response.statusCode = statusCode == 500? 551 :statusCode;
        if (body) {
            response.body = body;
        }
        if (header) {
            response.header = header;
        }

        return response;
    }

    public statusCode!: number;
    public header: any;
    public body: any;

    public isOK(): boolean {
        let ok = true;
        if (this.statusCode >= 400) {
            ok = false;
        }
        return ok;
    }
}
