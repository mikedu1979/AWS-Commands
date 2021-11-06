import { ApiGatewayManagementApi, DynamoDB } from 'aws-sdk';
import * as jwt from 'jsonwebtoken';
import * as jwkToPem from 'jwk-to-pem';
import * as https from 'https';

interface IIdentity {
    sourceIp: string;
}

interface IRequestContext{
    connectedAt: number;
    requestTimeEpoch: number;
    requestId: string;
    messageId: string;
    routeKey: string;
    eventType: 'CONNECT' | 'MESSAGE';
    extendedRequestId: string;
    requestTime: string;
    messageDirection: 'IN';
    disconnectReason: string;
    domainName: string;
    stage: string;
    identity: IIdentity;
    connectionId: string;
    apiId: string;
}

interface IBodyBase {
    action: string;
    value: any;
}

interface IEvent<T>{
    requestContext: IRequestContext;
    queryStringParameters: {[key: string]: string};
    multiValueQueryStringParameters: {[key: string]: string[]};
    headers: {[key: string]: string};
    isBase64Encoded: boolean;
    body: T;
}

interface JsonWebKey {
    alg: string;
    e: string;
    kid: string;
    kty: string;
    n: string;
    use: string;
}

interface JsonWebKeys {
    keys: JsonWebKey[];
}

interface IJWTHeader {
    kid: string;
    alg: string;
}

interface IPayloadData {
    sub: string;
    'cognito:groups': string[];
    token_use: string;
    scope: string;
    auth_time: number;
    iss: string;
    exp: number;
    iat: number;
    version: number;
    jti: string;
    client_id: string;
    username: string;
}

interface IJWTData{
    header: IJWTHeader;
    payload: IPayloadData;
    signature: string;
}

interface IConnection {
    ConnectionId: string;
    ConnectTime: number;
}

interface IWebSocketUser {
    Username: DynamoDB.AttributeValue;
    Connections: DynamoDB.AttributeValue;
    Groups: DynamoDB.AttributeValue;
    LastVisit: DynamoDB.AttributeValue;
    LastConnection: DynamoDB.AttributeValue;
}

interface IWebSocketConnection {
    ConnectionId: DynamoDB.AttributeValue;
    Username: DynamoDB.AttributeValue;
    ConnectTime: DynamoDB.AttributeValue;
}

let UserPoolId = process.env['UserPoolId'];
let region = process.env['AWS_REGION'];
let WebSocketConnectionsTable = process.env['WebSocketConnectionsTable']
let WebSocketUsersTable = process.env['WebSocketUsersTable']
// this is used to improve performance of JWT verification
let jsonCache: {[key: string]: string} = {};

export function atob(data: string) {
    let buff = Buffer.from(data, 'base64');
    return buff.toString('ascii');
}

export function decodeJWT(token: string): IJWTData {
    let sections = token.split('.');
    let header = sections[0], payload = sections[1], signature = sections[2];
    return {
        header: JSON.parse(atob(header)),
        payload: JSON.parse(atob(payload)),
        signature: signature
    };
}

function download(url: string): Promise<string> {
    return new Promise<string>((resolve, reject) => {
        https.get(url, response => {
            let body = '';
            response.on('data', chunk => {
                body += chunk;
            });
            response.on('end', () => {
                resolve(body);
            });
        }).on('error', message => {
            reject(message);
        });
    });
}

async function downloadJSON(url: string): Promise<any> {
    if(!(url in jsonCache)){
        let json = JSON.parse(await download(url));
        jsonCache[url] = json;
        return json;
    }
    console.log('using cached json:', url, '==>', jsonCache[url]);
    return jsonCache[url];
}

function JWTVerify(pem: string, token: string): Promise<IPayloadData> {
    return new Promise( (resolve, reject) => {
        jwt.verify(token, pem, { algorithms: ['RS256'] }, (err, decodedToken) => {
            if(err){
                reject(err);
            }
            else {
                resolve(decodedToken as any);
            }
        });
    });
}

function matchJWK(jwtHeader: IJWTHeader,  jwks: JsonWebKeys): JsonWebKey{
    for(let key of jwks.keys){
        if(key.kid == jwtHeader.kid) {
            return key;
        }
    }
    return null;
}

export async function handler (event: IEvent<IBodyBase>) {
    console.log(event);
    let dynamoDb = new DynamoDB();
    switch(event.requestContext.routeKey){
        case '$connect': {
            let token = event.queryStringParameters['token'];
            let tokenData = decodeJWT(token);
            let jwkUrl = `https://cognito-idp.${region}.amazonaws.com/${UserPoolId}/.well-known/jwks.json`
            let jwks = await downloadJSON(jwkUrl) as JsonWebKeys;
            let jwk: jwkToPem.JWK = matchJWK(tokenData.header, jwks) as any;
            // console.log(`connecting: token: ${tokenData}`);
            let pem = jwkToPem(jwk);
            // console.log('pem:', pem);
            let decoded: IPayloadData = await JWTVerify(pem, token);
            // console.log('WebSocketConnectionsTable:', WebSocketConnectionsTable);
            // console.log('WebSocketUsersTable:', WebSocketUsersTable);
            await (dynamoDb.putItem({
                TableName: WebSocketConnectionsTable,
                Item: {
                    ConnectionId: {
                        S: event.requestContext.connectionId
                    },
                    Username: {
                        S: decoded.username
                    },
                    ConnectTime: {
                        S: Date.now().toString()
                    }
                }
            }).promise());
            console.log(`Connection(${event.requestContext.connectionId}) -> User(${decoded.username})`);
            // console.log('step: 2');
            let user: IWebSocketUser = (await (dynamoDb.getItem({
                TableName: WebSocketUsersTable,
                Key: {
                    Username: {
                        S: decoded.username
                    }
                }
            }).promise()))?.Item as any;
            // console.log('step: 3');
            user = user ?? {Username: {S: decoded.username}, Connections: {S: '[]'}, LastConnection: {}, LastVisit: {}, Groups: {S: '[]'}} as any;
            let connections: IConnection[] = JSON.parse(user.Connections.S);
            let now = Date.now();
            // console.log('step: 4');
            connections = connections.filter(connection => connection.ConnectTime + 86400000 > now);
            // console.log('step: 5');
            connections.push({
                ConnectionId: event.requestContext.connectionId,
                ConnectTime: now
            });
            // console.log('step: 6');
            user.Connections.S = JSON.stringify(connections);
            user.LastConnection.S = event.requestContext.connectionId;
            user.LastVisit.S = now.toString();
            user.Groups.S = JSON.stringify(decoded['cognito:groups']);
            // console.log('step: 7');
            await (dynamoDb.putItem({
                TableName: WebSocketUsersTable,
                Item: user as any
            }).promise());
            // console.log('step: 8');
            return {
                statusCode: 200,
                body: 'Connected.'
            };
        }
        case '$disconnect': {
            console.log('disconnecting');
            // get user
            let disconnection: IWebSocketConnection = (await (dynamoDb.getItem({
                TableName: WebSocketConnectionsTable,
                Key: {
                    ConnectionId: {
                        S: event.requestContext.connectionId
                    }
                }
            }).promise()))?.Item as any;


            // delete connection from dynamoDb
            await (dynamoDb.deleteItem({
                TableName: WebSocketConnectionsTable,
                Key: {
                    ConnectionId: {
                        S: event.requestContext.connectionId
                    }
                }
            }).promise());

            if(disconnection){
                let user: IWebSocketUser = (await (dynamoDb.getItem({
                    TableName: WebSocketUsersTable,
                    Key: {
                        Username: {
                            S: disconnection.Username.S
                        }
                    }
                }).promise()))?.Item as any;
                user = user ?? {ConnectionId: {S: disconnection.Username.S}, Connections: {}, LastConnection: {}, LastVisit: {}} as any;
                let connections: IConnection[] = JSON.parse(user.Connections.S);
                let now = Date.now();
                connections = connections.filter(connection => 
                    connection.ConnectTime + 86400000 > now && connection.ConnectionId != disconnection.ConnectionId.S
                    );
                user.Connections.S = JSON.stringify(connections);
                user.LastConnection.S = event.requestContext.connectionId;
                user.LastVisit.S = now.toString();
                await (dynamoDb.putItem({
                    TableName: WebSocketUsersTable,
                    Item: user as any
                }).promise());
            }

            return {
                statusCode: 200,
                body: 'Disconnected.'
            }
        }
        case 'echo': {
            let agm = new ApiGatewayManagementApi({
                endpoint: `${event.requestContext.domainName}/${event.requestContext.stage}`
            });

            await (agm.postToConnection({
                ConnectionId: event.requestContext.connectionId,
                Data: event.body
            }).promise());

            return {
                statusCode: 202,
                body: 'Accepted.'
            }
        }
    }
};
