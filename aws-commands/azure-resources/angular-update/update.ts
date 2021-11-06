import { CloudFormation } from 'aws-sdk';
import * as fs from 'fs';
import * as path from 'path';
//get API Gateway Id

// get UserPool Id

// get Coginto Login URL

// get Cognito UserPool Id

interface IEnvironmentData {
    webSocketUri: string;
    authUri: string;
    clientId: string;
}

function parseArgument(array: string[], key: string){
    let index = array.indexOf(key);
    return array[index + 1];
}

function beautify(data: any): string {
    let json = JSON.stringify(data, null, 2);
    return json.split('\n')
        .map((line) => {
            let colon = line.indexOf(':');
            if(colon > 0){
                let nameMatch = /\"([a-zA-Z$_]\w*)\"/ig.exec(line.substring(0, colon));
                let name = nameMatch[1];
                console.log('name:', name);
                return `  ${name}` + line.substr(colon);
            }
            else{
                return line;
            }
        }).join('\n');
}

async function updateAngularEnvironments(environmentsPath: string,
    application: string, region: string, environmentTarget: string,
    usersProjectName: string, userPoolName: string, userPoolClientName: string,
    apiGatewayProjectName: string, apiGatewayName: string) {
    let cfn = new CloudFormation({region: region});

    console.log('connect to cloudforamtion');

    let usersResources = await (cfn.describeStackResources({
        StackName: `${application}--${usersProjectName}--${region}--${environmentTarget}`
    }).promise());

    let userPoolPhysicalId: string = null;
    let userPoolClientPhysicalId: string = null;
    for(let resource of usersResources.StackResources){
        if(resource.LogicalResourceId == userPoolName){
            userPoolPhysicalId = resource.PhysicalResourceId;
        }
        if(resource.LogicalResourceId == userPoolClientName){
            userPoolClientPhysicalId = resource.PhysicalResourceId;
        }
    }

    console.log(`Resource: ${userPoolName} ==> ${userPoolPhysicalId}`);
    console.log(`Resource: ${userPoolClientName} ==> ${userPoolClientPhysicalId}`);

    let apiGatewayResources = await (cfn.describeStackResources({
        StackName: `${application}--${apiGatewayProjectName}--${region}--${environmentTarget}`
    }).promise());

    let apiGatewayPhysicalId: string = null;
    for(let resource of apiGatewayResources.StackResources){
        if(resource.LogicalResourceId == apiGatewayName){
            apiGatewayPhysicalId = resource.PhysicalResourceId;
        }
    }
    console.log(`Resource: ${apiGatewayName} ==> ${apiGatewayPhysicalId}`);

    let environments = fs.readdirSync(environmentsPath);
    for(let environment of environments){
        let lowerName = environment.toLowerCase();
        if(lowerName.startsWith('environment.') && lowerName.endsWith('.ts')){
            let fullpath = path.join(environmentsPath, environment);
            let script = fs.readFileSync(fullpath, {encoding: 'utf-8'});
            let start = script.indexOf('{'), end = script.lastIndexOf('}');
            let dict = script.substring(start, end + 1);
            let data: IEnvironmentData = eval(`(${dict})`);
            // console.log('data:', data);
            data.webSocketUri = `wss://${apiGatewayPhysicalId}.execute-api.${region}.amazonaws.com/prod`;
            data.authUri = `https://${application}-${usersProjectName}-login.auth.${region}.amazoncognito.com`
            data.clientId = userPoolClientPhysicalId;
            // console.log('beautify:', beautify(data));
            fs.writeFileSync(fullpath, `export const environment = ${beautify(data)};`);
        }
    }
    

}

let environmentsPath = parseArgument(process.argv, '--environment-path');
let application = process.env['Application'];
let region = process.env['AWSRegion'];
let environmentTarget = process.env['EnvironmentTarget']
let usersProjectName = parseArgument(process.argv, '--users-stack');
let userPoolName = parseArgument(process.argv, '--user-pool');
let userPoolClientName = parseArgument(process.argv, '--user-pool-client');
let apiGatewayProjectName = parseArgument(process.argv, '--api-gateway-stack');
let apiGatewayName = parseArgument(process.argv, '--api-gateway');

console.log('environmentsPath:', environmentsPath);
console.log('application:', application);
console.log('region:', region);
console.log('environmentTarget:', environmentTarget);
console.log('usersProjectName:', usersProjectName);
console.log('userPoolName:', userPoolName);
console.log('userPoolClientName:', userPoolClientName);
console.log('apiGatewayProjectName:', apiGatewayProjectName);
console.log('apiGatewayName:', apiGatewayName);

(async () => await updateAngularEnvironments(
    environmentsPath, application, region, environmentTarget,
    usersProjectName, userPoolName, userPoolClientName,
    apiGatewayProjectName, apiGatewayName) )();