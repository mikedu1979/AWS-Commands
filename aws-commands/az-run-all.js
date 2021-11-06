let fs = require('fs');
let child_process = require('child_process');
let branch = process.argv[2];

function runPipeline(pipeline) {
    return new Promise((resolve, reject) => {
        let cmd = child_process.exec(`az-run ${pipeline} ${branch}`);
        cmd.stderr.on('data', (chunk) => {
            console.warn(chunk);
        });
        cmd.stdout.on('data', (chunk) => {
            console.log(chunk);
        });
        cmd.on('close', () => {
            resolve();
        });
    })
}

async function runAll(){
    for(let folder of fs.readdirSync('.')){
        if(fs.statSync(folder).isDirectory()){
            if(fs.existsSync(`${folder}/pipeline.yml`)){
                console.log(`Run Pipeline -> ${folder}/pipeline.yml`);
                await runPipeline(folder);
            }
        }
    }
}

runAll().then();
