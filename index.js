import fs from 'fs';
import path from 'path';


const target_file_name = 'pico8_utils.lua'
const dir = 'src';

const readAll = () => {
  const files = fs.readdirSync(dir).filter(file => file.endsWith('.lua'));
  return files
}

const build = (files) => {
  let result = "";

  files.forEach(file => {
    console.log('INFO : Read ', file);
    result += `-- ${file}`;
    result += "\n";
    const content = fs.readFileSync(path.join(dir, file), 'utf-8');
    result += content
    result += "\n";
  });

  console.log(result);
  fs.writeFileSync(target_file_name, result);
  console.log('Written to ' + target_file_name);
}

const files = readAll();

build(files);