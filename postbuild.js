import { writeFile } from 'node:fs/promises';

await writeFile('.yarn.installed', new Date().toISOString());
