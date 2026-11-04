// Test-only schemas are isolated from the production studio and removed on completion.
import mysql from 'mysql2/promise';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import crypto from 'node:crypto';
export async function mysqlFixture(){
 const database='apresenta_test_'+process.pid+'_'+crypto.randomBytes(5).toString('hex');
 const folder=fs.mkdtempSync(path.join(os.tmpdir(),'apresenta-test-'));
 fs.chmodSync(folder,0o700);
 const config={host:'127.0.0.1',port:3306,user:'root',password:'',socketPath:'/tmp/mysql.sock',database};
 const admin=await mysql.createConnection({user:'root',socketPath:'/tmp/mysql.sock'});
 await admin.query('CREATE DATABASE `'+database+'` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
 fs.writeFileSync(path.join(folder,'mysql-config.json'),JSON.stringify(config),{mode:0o600});
 const previousData=process.env.DF_STUDIO_DATA;
 process.env.DF_STUDIO_DATA=folder;
 process.env.DF_ACTIVE_HOTKEYS='0';
 return {folder,config,database,async cleanup(){await admin.query('DROP DATABASE `'+database+'`');await admin.end();fs.rmSync(folder,{recursive:true,force:true});if(previousData===undefined)delete process.env.DF_STUDIO_DATA;else process.env.DF_STUDIO_DATA=previousData;}};
}
