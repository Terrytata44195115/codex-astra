import fs from 'node:fs';
import path from 'node:path';
const {LuauState}=await import(process.env.LUAU_WEB_ENTRY || 'luau-web');
const source=fs.readFileSync(new URL('../Interpretacion.luau',import.meta.url),'utf8');
const output=process.argv[2];
if(!output) throw Error('Provide an output directory for temporary RGBA files');
fs.mkdirSync(output,{recursive:true});
const state=await LuauState.createAsync();
for(const key of ['NEUTRA','ALEGRE','INQUIETA','VERGUENZA','ENFADADA','ALARMA']) {
 for(const masked of [false,true]) {
  const code='local B=(function()\n'+source+'\nend)()\n'+
   `local p=B.PixelesCara(${JSON.stringify(key)},${masked})\n`+
   'local out={} for i=0,buffer.len(p)-1 do out[i+1]=string.format("%02x",buffer.readu8(p,i)) end return table.concat(out)';
  const [hex]=await state.loadstring(code,'face_preview',true)();
  fs.writeFileSync(path.join(output,key+(masked?'_MASCARA':'')+'.rgba'),Buffer.from(hex,'hex'));
 }
}
state.destroy();
console.log('Rendered actual Luau pixel output for 12 previews.');
