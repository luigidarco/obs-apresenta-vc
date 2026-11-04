import fs from 'node:fs';import path from 'node:path';import os from 'node:os';
const legacy=path.join(os.homedir(),'Library/Application Support/DiarioFluminenseStudio');
export const DATA=process.env.DF_STUDIO_DATA||(fs.existsSync(path.join(legacy,'mysql-config.json'))||fs.existsSync(path.join(legacy,'studio.sqlite'))?legacy:path.join(os.homedir(),'Library/Application Support/ApresentaVC'));
