let child_process = require('child_process');
let indexOrganization = process.argv.indexOf('--organization');
let indexProject = process.argv.indexOf('--project');
let indexName = process.argv.indexOf('--name');


async function run(command) {
    return new Promise((resolve, reject) => {
        let process = child_process.exec(command);
        let out = [], err = [];
        process.stdout.on('data', (data) => {
            out.push(data);
        });
        process.stderr.on('data', (data) => {
            err.push(data);
        });
        process.on('close', (code, signal) => {
            // console.log('out:', out);
            // console.log('err:', err);
            if(code == 0){
                resolve(out.join('\n'));
            }
            else{
                reject(err.join('\n'));
            }
        });
    })
}

async function deletePipeline() {
    let commandShow = `az pipelines show --organization "${process.argv[indexOrganization+1]}" --project "${process.argv[indexProject+1]}" --name "${process.argv[indexName+1]}"`;
    console.log(commandShow);
    let result = await run(commandShow);
    let setting = JSON.parse(result);
    let commandDelete = `az pipelines delete --organization "${process.argv[indexOrganization+1]}" --project "${process.argv[indexProject+1]}" --id "${setting['id']}" --yes`;
    console.log(commandDelete);
    await run(commandDelete);
}

deletePipeline().then(); 