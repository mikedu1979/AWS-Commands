let child_process = require('child_process');

let AzureDevOpsOrganization = process.env['AzureDevOpsOrganization'];
let AzureDevOpsProject = process.env['AzureDevOpsProject'];

function listPipelines() {
    return new Promise((resolve, reject) => {
        let json = '';
        let cmd = child_process.exec(`az pipelines list --organization ${AzureDevOpsOrganization} --project ${AzureDevOpsProject}`);
        cmd.stderr.on('data', (chunk) => {
            // console.warn(chunk);
        });
        cmd.stdout.on('data', (chunk) => {
            // console.log(chunk);
            json += chunk;
        });
        cmd.on('close', () => {
            resolve(json);
        });
    })
};

async function run(){
    let json = await listPipelines();
    let pipelines = JSON.parse(json);
    for(let pipeline of pipelines){
        console.log(`(${pipeline['id']}) ${pipeline['name']}`);  // @ ${pipeline['project']['name']}
    }
}

run().then();
