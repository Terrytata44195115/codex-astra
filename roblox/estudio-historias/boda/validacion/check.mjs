import fs from 'node:fs';
import {LuauState} from '/workspace/hr_entrega/validation/node_modules/luau-web/src/index.js';
const base=new URL('../',import.meta.url),read=n=>fs.readFileSync(new URL(n,base),'utf8');
const state=await LuauState.createAsync();
for(const name of ['Configuracion.luau','Vestuario.luau','Escena.luau','Servidor.luau','Camara.luau','DetallesCliente.luau','01_PREPARAR_BODA.txt','02_ACTIVAR_HISTORIA_BODA.txt','VOLVER_ESCENA_ANTERIOR.txt']){
 state.loadstring(read(name),name,true);console.log('Compilation PASS:',name);
}
const math=fs.readFileSync(new URL('../../madre-hija-donuts/validacion/matematicas.luau',import.meta.url),'utf8');
const config='local C=(function()\n'+read('Configuracion.luau')+'\nend)()\n';
console.log(await state.loadstring(math+config+`
for _,list in ipairs({C.Escenas,C.Planos}) do
 local t=0
 for _,s in ipairs(list) do assert(s.Inicio==t and s.Fin>t);t=s.Fin end
 assert(t==14)
end
assert(#C.Roles==4 and #C.Planos==11)
local original=CFrame.lookAt(Vector3.new(0,3.2,0),Vector3.new(0,3.2,1))
local origin=CFrame.new()
assert(C.RaizEn('Invitada',4.1,3,original,origin).LookVector:Dot(Vector3.zAxis)<-.99)
local before=C.RaizEn('Invitada',4,3,original,origin)
local after=C.RaizEn('Invitada',5.199,3,original,origin)
assert(before.Position.Z>14 and after.Position.Z<2.71 and after.Position.Z>2.69)
assert((C.RaizEn('Invitada',5.2,3,original,origin).Position-after.Position).Magnitude<.15)
assert(C.RaizEn('Hija',8,3,original,origin).Position.X==C.Dormitorio.X)
assert(C.RaizEn('Hija',11,3,original,origin).LookVector.Z<-.99)
assert(C.RaizEn('Hija',13,3,original,origin).LookVector.Z>.99)
assert(C.RaizEn('Novio',11,3,original,origin).LookVector.X<0)
assert(C.RaizEn('Invitada',11,3,original,origin).LookVector.X>0)
local points={Vector3.new(-2.7,5.3,0),Vector3.new(2.7,5.3,0),Vector3.new(-2.7,.2,0),Vector3.new(2.7,.2,0),Vector3.new(0,4.2,-2.3),Vector3.new(0,.2,15)}
for _,aspect in ipairs({16/9,9/16,.48}) do
 for _,slope in ipairs({.07,.72}) do
  local camera=C.Encuadrar(points,Vector3.zAxis,aspect,49,1.08,slope)
  local tv=math.tan(math.rad(49/2));local th=tv*math.min(aspect,9/16)
  for _,p in ipairs(points) do local q=camera:PointToObjectSpace(p);assert(q.Z<0 and math.abs(q.X)/(-q.Z*th)<1 and math.abs(q.Y)/(-q.Z*tv)<1) end
 end
end
return 'PASS: 14 seconds / 11 continuous shots; approach direction, reveal orientation, bedroom cut and portrait projection.'
`,'timeline_geometry',true)());

// Reuse the independent service/Instance harness, not any donut installation cases.
let mocks=fs.readFileSync(new URL('../../madre-hija-donuts/validacion/instalacion.luau',import.meta.url),'utf8').split('local oldFace=')[0];
mocks=mocks.replace('Color3={fromRGB=function(...) return {...} end}',`
local CM={};CM.__index=CM
Color3={new=function(r,g,b) return setmetatable({R=r,G=g,B=b},CM) end}
function Color3.fromRGB(r,g,b) return Color3.new(r/255,g/255,b/255) end
function CM:Lerp(c,t) return Color3.new(self.R+(c.R-self.R)*t,self.G+(c.G-self.G)*t,self.B+(c.B-self.B)*t) end
function methods:GetAttributes() return table.clone(self.attrs) end
`);
mocks+=`
Enum.Material.Grass=2;Enum.PartType.Cylinder=2;Enum.AccessoryType={Hair=41}
Enum.RaycastFilterType={Exclude=1};RaycastParams={new=function() return {} end}
UDim2={fromScale=function(...) return {...} end};UDim={new=function(...) return {...} end}
Vector2={new=function(...) return {...} end}
Enum.NormalId={Front=1}
function methods:Raycast() return {Position=Vector3.new(0,0,0)} end
`;
const inventory=JSON.parse(fs.readFileSync('/workspace/base_inspection/instances.json','utf8'));
const byId=new Map(inventory.map(o=>[o.id,o]));
const q=JSON.stringify,vec=a=>`Vector3.new(${a.join(',')})`;
function cf(v){
 const p=vec(v.position);
 if(v.rotation.matrix){const r=v.rotation.matrix;return `CFrame.fromMatrix(${p},${vec([r[0],r[3],r[6]])},${vec([r[1],r[4],r[7]])},${vec([r[2],r[5],r[8]])})`;}
 if(v.rotation.code!==2)throw Error('Unexpected rotation '+v.rotation.code);
 return `CFrame.new(${p})`;
}
let fixtures='local function populate(templates,roles)\n';
for(const [role,path] of [['Madre','Workspace.chicaB'],['Hija','Workspace.chicaX'],['Novio','ServerStorage.HR_AvataresRopa.chicoX']]){
 const id=inventory.find(o=>o.path===path).id;
 const nodes=inventory.filter(o=>o.id===id||o.path.startsWith(path+'.'));
 fixtures+='do local nodes={}\n';
 for(const o of nodes)fixtures+=`nodes[${o.id}]=Instance.new(${q(o.class)});nodes[${o.id}].Name=${q(o.name)}\n`;
 for(const o of nodes){
  if(o.id!==id)fixtures+=`nodes[${o.id}].Parent=nodes[${o.parent}]\n`;
  for(const [k,v] of Object.entries(o.props)){
   if(['CFrame','C0','C1','AttachmentPoint'].includes(k)&&v?.position)fixtures+=`nodes[${o.id}].${k}=${cf(v)}\n`;
   if(['Part0','Part1'].includes(k))fixtures+=`nodes[${o.id}].${k}=nodes[${v}]\n`;
   if(['size','Scale'].includes(k)&&Array.isArray(v)&&v.length===3)fixtures+=`nodes[${o.id}].${k==='size'?'Size':k}=${vec(v)}\n`;
  }
  if(o.class==='Attachment')fixtures+=`nodes[${o.id}].Position=nodes[${o.id}].CFrame.Position\n`;
  if(o.class==='Accessory')fixtures+=`nodes[${o.id}].AccessoryType=0\n`;
  if(o.class==='Humanoid')fixtures+=`nodes[${o.id}].RigType=Enum.HumanoidRigType.R15\n`;
 }
 fixtures+=`local m=nodes[${id}];m.Name=${q(role)};m.Parent=templates;m.PrimaryPart=m.HumanoidRootPart\nlocal link=make('ObjectValue',${q(role)},roles);link.Value=m\nend\n`;
}
fixtures+='end\n';
const quote=s=>'[======[\n'+s+']======]';
let tests=math+mocks+fixtures+`
local originalFace=${quote(fs.readFileSync(new URL('../../madre-hija-marcos/CarasCliente.luau',import.meta.url),'utf8'))}
local function setup(failAt)
 workspace=make('Model','Workspace')
 local svc={RunService={IsRunning=function() return false end},Selection={Set=function() end}}
 for _,n in ipairs({'ServerStorage','ReplicatedStorage','ServerScriptService','StarterPlayer','Lighting'}) do svc[n]=make('Folder',n) end
 local lighting=svc.Lighting
 lighting.Brightness=3;lighting.ExposureCompensation=1;lighting.ClockTime=14.5
 lighting.Ambient=Color3.fromRGB(200,200,200);lighting.OutdoorAmbient=lighting.Ambient
 lighting.EnvironmentDiffuseScale=1;lighting.EnvironmentSpecularScale=1;lighting.GlobalShadows=true
 lighting.ColorShift_Top=Color3.new(0,0,0);lighting.ColorShift_Bottom=lighting.ColorShift_Top;lighting.FogStart=0;lighting.FogEnd=100000
 make('BloomEffect','Bloom',lighting).Enabled=true
 local at=make('Atmosphere','Atmosphere',lighting);at.Density=.4;at.Haze=1;at.Glare=1
 local sps=make('Folder','StarterPlayerScripts',svc.StarterPlayer)
 local root=make('Folder','HR_PruebaReparto',svc.ReplicatedStorage,'HR_PRUEBA_REPARTO_1')
 make('ModuleScript','Interpretacion',root).Source='original poses'
 local server=make('Script','HR_PruebaRepartoServidor',svc.ServerScriptService,'HR_PRUEBA_REPARTO_1');server.Source='original server'
 local camera=make('LocalScript','HR_PruebaRepartoCamara',sps,'HR_PRUEBA_REPARTO_1');camera.Source='original camera'
 local face=make('LocalScript','HR_CarasMarcos',sps,'HR_PRUEBA_REPARTO_1');face.Source=originalFace
 local cast=make('Folder','HR_EstudioReparto',svc.ServerStorage,'HR_ESTUDIO_REPARTO_1')
 local roles=make('Folder','Reparto',cast);local templates=make('Folder','Personajes',cast);populate(templates,roles)
 local calls=0
 svc.ScriptEditorService={GetEditorSource=function(_,o) return o.Source end,UpdateSourceAsync=function(_,o,cb) calls+=1;if calls==failAt then error('injected source write failure') end;o.Source=cb(o.Source) end}
 game={GetService=function(_,name) assert(svc[name],name);return svc[name] end}
 return {svc=svc,sps=sps,face=face,server=server,camera=camera,roles=roles}
end
local function prepare()\n${read('01_PREPARAR_BODA.txt')}\nend
local function activate()\n${read('02_ACTIVAR_HISTORIA_BODA.txt')}\nend
local function restore()\n${read('VOLVER_ESCENA_ANTERIOR.txt')}\nend
do
 local f=setup();local oldRoot=f.roles.Hija.Value.HumanoidRootPart.CFrame
 prepare()
 local decor=workspace.HR_Boda;assert(decor and decor.Ceremonia.ArcoFloral and #decor.Reparto:GetChildren()==4)
 local seats,flowers,parts=0,0,0
 for _,d in ipairs(decor:GetDescendants()) do
  if d:IsA('BasePart') then parts+=1 end
  if d.Name=='Asiento' then seats+=1 end
  if d.Name=='Rosa' then flowers+=1 end
  if d:IsA('BaseScript') then assert(not d.Enabled) end
 end
 assert(seats==12 and flowers>=40 and parts<2000)
 assert(f.roles.Hija.Value.Pants and f.roles.Novio.Value.Shirt)
 assert((f.roles.Hija.Value.HumanoidRootPart.Position-oldRoot.Position).Magnitude<.00001)
 assert(not f.svc.Lighting.Bloom.Enabled and f.svc.Lighting.ExposureCompensation<0)
 assert(f.face.Source==originalFace and f.server.Enabled)
 prepare();assert(workspace.HR_Boda==decor)
 activate()
 assert(not f.face.Enabled and not f.server.Enabled and not f.camera.Enabled)
 assert(f.face.Source==originalFace and f.server.Source=='original server')
 assert(f.sps.HR_BodaCaras.Source:find('"Invitada"',1,true))
 assert(f.sps.HR_BodaCaras.Source:find('HR_CarasBodaLocales',1,true))
 local runtime=f.svc.ReplicatedStorage.HR_Boda
 activate();assert(f.svc.ReplicatedStorage.HR_Boda==runtime)
 restore()
 assert(f.face.Enabled and f.server.Enabled and f.camera.Enabled)
 assert(not workspace.HR_Boda and not f.svc.ReplicatedStorage.HR_Boda and not f.sps.HR_BodaCamara)
 assert(f.svc.Lighting.Brightness==3 and f.svc.Lighting.ExposureCompensation==1 and f.svc.Lighting.Bloom.Enabled)
 assert(f.roles.Hija.Value.Pants and f.roles.Novio.Value.Shirt)
end
for n=1,6 do
 local f=setup(n);prepare();assert(not pcall(activate))
 assert(f.face.Enabled and f.server.Enabled and f.camera.Enabled and f.face.Source==originalFace)
 assert(not f.svc.ReplicatedStorage.HR_Boda and not f.sps.HR_BodaCaras and not f.svc.ServerStorage.HR_BodaAntesHistoria)
 assert(workspace.HR_Boda)
end
do
 local f=setup();f.face.Source=originalFace:gsub('ipairs%({"Madre","Hija","Novio"}%)','ipairs({"Madre","Hija"})')
 local before=f.face.Source;prepare();activate()
 assert(f.face.Source==before and f.sps.HR_BodaCaras.Source:find('"Invitada"',1,true))
 restore();assert(f.face.Source==before and f.face.Enabled)
end
do
 local f=setup();f.svc.Lighting.rejectProperty='ExposureCompensation';f.svc.Lighting.rejectOnce=true
 assert(not pcall(prepare));assert(not workspace.HR_Boda)
 assert(f.svc.Lighting.Brightness==3 and f.svc.Lighting.ExposureCompensation==1 and f.svc.Lighting.Bloom.Enabled)
end
do
 local f=setup();prepare();f.face.Source='unknown face renderer';assert(not pcall(activate))
 assert(f.face.Enabled and f.server.Enabled and not f.svc.ReplicatedStorage.HR_Boda)
end
do
 local f=setup();prepare();restore();assert(not workspace.HR_Boda and f.server.Enabled)
end
return 'PASS: real R15 fixtures, four costumes, 12 seats and floral arch; idempotent preparation/activation, preserved original face source, restore; six injected source failures and partial lighting failure roll back.'
`;
fs.writeFileSync('/tmp/boda-installation-test.luau',tests);
console.log(await state.loadstring(tests,'installation',true)());
state.destroy();
