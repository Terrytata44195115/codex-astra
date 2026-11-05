import fs from 'node:fs';
const {LuauState}=await import(process.env.LUAU_WEB_ENTRY || 'luau-web');

const root=new URL('../',import.meta.url);
const state=await LuauState.createAsync();
for (const name of ['Configuracion.luau','Interpretacion.luau','Servidor.luau','Camara.luau','PEGAR_HISTORIA_MARCOS.txt','VOLVER_HISTORIA_ANTERIOR.txt']) {
  state.loadstring(fs.readFileSync(new URL(name,root),'utf8'),name,true);
  console.log('Compilation PASS:',name);
}
const harness=fs.readFileSync(new URL('installer-harness.luau',import.meta.url),'utf8');
const installer=fs.readFileSync(new URL('PEGAR_HISTORIA_MARCOS.txt',root),'utf8');
const restore=fs.readFileSync(new URL('VOLVER_HISTORIA_ANTERIOR.txt',root),'utf8');
const test=harness.replace('__RUN_INSTALLER__',installer).replace('__RUN_RESTORE__',restore);
console.log(await state.loadstring(test,'transaction_checks',true)());
const config=fs.readFileSync(new URL('Configuracion.luau',root),'utf8');
const timeline=fs.readFileSync(new URL('timeline-checks.luau',import.meta.url),'utf8');
console.log(await state.loadstring('local C=(function()\n'+config+'\nend)()\n'+timeline,'story_timeline',true)());
state.destroy();
