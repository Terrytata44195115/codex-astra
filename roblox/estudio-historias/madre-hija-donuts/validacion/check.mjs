import fs from 'node:fs';
import {LuauState} from '/workspace/hr_entrega/validation/node_modules/luau-web/src/index.js';
const base=new URL('../',import.meta.url);
const read=f=>fs.readFileSync(new URL(f,base),'utf8');
const s=await LuauState.createAsync();
for(const name of ['Configuracion.luau','Donuts.luau','Brazo.luau','PrepararReparto.luau','Servidor.luau','Camara.luau','03_INSTALAR_HISTORIA_DONUTS.txt','VOLVER_A_MARCOS.txt']){
 s.loadstring(read(name),name,true);console.log('Compilation PASS:',name);
}
const math=read('validacion/matematicas.luau');
const c='local C=(function()\n'+read('Configuracion.luau')+'\nend)()\n';
let timeline=math+c+`
local function contiguous(items)
 local t=0
 for _,item in ipairs(items) do assert(item.Inicio==t and item.Fin>t);t=item.Fin end
 assert(t==23)
end
contiguous(C.Escenas);contiguous(C.Planos)
assert(#C.Planos==22 and #C.Interacciones==2)
for _,s in ipairs(C.Escenas) do
 assert(s.Acciones.Novio==nil and s.Caras.Novio==nil)
 for _,role in ipairs({'Madre','Hija'}) do assert(s.Caras[role] and s.Acciones[role]) end
end
for _,item in ipairs(C.Interacciones) do
 local a={item.Inicio,item.Agarre,item.Alzar,item.Boca,item.Morder,item.Retirar,item.Fin}
 for i=1,#a-1 do assert(a[i]<a[i+1]) end
 assert(item.Fin<23)
end
return 'PASS: 23 seconds, 22 contiguous shots, two ordered grab/bite/release paths and only two roles.'
`;
console.log(await s.loadstring(timeline,'timeline',true)());
const inventory=JSON.parse(fs.readFileSync('/workspace/base_inspection/instances.json','utf8'));
const byId=new Map(inventory.map(x=>[x.id,x]));
const vec=a=>`Vector3.new(${a.join(',')})`;
function cf(v,scale=1){
 const pos=v.position.map(x=>x*scale);
 if(v.rotation.matrix){const r=v.rotation.matrix;return `CFrame.new(${pos.join(',')})*CFrame.fromMatrix(Vector3.zero,${vec([r[0],r[3],r[6]])},${vec([r[1],r[4],r[7]])},${vec([r[2],r[5],r[8]])})`;}
 if(v.rotation.code!==2)throw Error('Unexpected rotation '+v.rotation.code);
 return `CFrame.new(${pos.join(',')})`;
}
let rig=math+'\nlocal A=(function()\n'+read('Brazo.luau')+'\nend)()\n';
for(const [role,prefix,scale,x] of [['Hija','Workspace.chicaX',1,1.8],['Madre','Workspace.chicaB',1.05,-2.4]]){
 const parts=inventory.filter(o=>o.parent===inventory.find(o=>o.path===prefix).id&&['Part','MeshPart'].includes(o.class));
 const motors=inventory.filter(o=>o.path.startsWith(prefix+'.')&&o.class==='Motor6D');
 const root=parts.find(o=>o.name==='HumanoidRootPart'),foot=parts.find(o=>o.name==='LeftFoot');
 const height=(root.props.CFrame.position[1]-foot.props.CFrame.position[1]+foot.props.size[1]/2)*scale;
 rig+=`do\nlocal srcRoot=${cf(root.props.CFrame)}\nlocal rootCF=CFrame.lookAt(Vector3.new(${x},${height},-4.1),Vector3.new(${x},${height},-3.1))\nlocal parts={}\n`;
 for(const p of parts){rig+=`do local rel=srcRoot:ToObjectSpace(${cf(p.props.CFrame)});parts[${JSON.stringify(p.name)}]={Name=${JSON.stringify(p.name)},CFrame=rootCF*CFrame.new(rel.Position*${scale})*rel.Rotation,Size=${vec(p.props.size.map(v=>v*scale))}} end\n`;}
 rig+=`local actor={root=parts.HumanoidRootPart,model={Name='${role}'},joints={}}\n`;
 for(const m of motors){const prop=m.props;rig+=`actor.joints[${JSON.stringify(m.name.replaceAll(' ',''))}]={motor={Part0=parts[${JSON.stringify(byId.get(prop.Part0).name)}],Part1=parts[${JSON.stringify(byId.get(prop.Part1).name)}],C0=${cf(prop.C0,scale)},C1=${cf(prop.C1,scale)}},base=${cf(prop.C0,scale)}}\n`;}
 rig+=`
actor.arm=A.Cadena(actor)
local base=A.Marcos(actor)
local s=actor.joints.RightShoulder
local shoulder=(base[s.motor.Part0]*s.base).Position
for _,offset in ipairs({Vector3.new(.2,.1,.6),Vector3.new(.1,.7,.4),Vector3.new(-.2,.2,.9),Vector3.new(.8,-.1,.3),Vector3.new(0,0,4)}) do
 for _,j in pairs(actor.joints) do j.motor.C0=j.base end
 local wrist=shoulder+offset
 local target=CFrame.new(wrist)*rootCF.Rotation*CFrame.new(-actor.joints.RightWrist.motor.C1.Position)
 local hand,excess=A.Resolver(actor,target,1)
 local fk=A.Marcos(actor)
 local solvedWrist=(hand*actor.joints.RightWrist.motor.C1).Position
 if offset.Magnitude<actor.arm.l1+actor.arm.l2-.002 then assert((solvedWrist-wrist).Magnitude<.00001) end
 local es=(fk[actor.joints.RightElbow.motor.Part0]*actor.joints.RightElbow.motor.C0).Position
 local ee=(fk[actor.joints.RightElbow.motor.Part1]*actor.joints.RightElbow.motor.C1).Position
 assert((es-ee).Magnitude<.00001)
 assert(math.abs((es-shoulder).Magnitude-actor.arm.l1)<.00001)
 assert(math.abs((solvedWrist-es).Magnitude-actor.arm.l2)<.00001)
end
-- Verify the actual nearest donut grip with the approach and waist bend used in the story.
for _,j in pairs(actor.joints) do j.motor.C0=j.base end
actor.root.CFrame=rootCF+Vector3.new(0,0,.4)
actor.joints.Waist.motor.C0=actor.joints.Waist.base*CFrame.Angles(math.rad(-30),0,0)
local donut=CFrame.new(${role==='Madre'?-3.15:1.05},3.41,-2.5)*rootCF.Rotation
local hold=CFrame.new(0,-parts.RightHand.Size.Y*.42,-.12)
local hand,excess=A.Resolver(actor,donut*hold:Inverse(),1)
assert(excess<.08,'Grip out of reach: ${role} '..excess)
assert(((hand*hold).Position-donut.Position).Magnitude<.08)
print('Actual rig grip PASS: ${role}; clamp excess '..excess)
for _,j in pairs(actor.joints) do j.motor.C0=j.base end
actor.root.CFrame=rootCF
local head=A.Marcos(actor)[parts.Head]
local faceRadius=.57*${scale}
local bite=head*CFrame.new(0,-parts.Head.Size.Y*.82,-faceRadius-.35)*CFrame.Angles(math.rad(68),0,0)
local biteHand,biteExcess=A.Resolver(actor,bite*hold:Inverse(),1)
assert(biteExcess<.08,'Bite out of reach: ${role} '..biteExcess)
assert(((biteHand*hold).Position-bite.Position).Magnitude<.08)
print('Actual rig bite PASS: ${role}; clamp excess '..biteExcess)
end
`;
}
rig+="return 'PASS: IK on both recorded rigs, reachable targets, unreachable clamping, bone lengths, elbow connectivity and scene grip positions.'";
console.log(await s.loadstring(rig,'actual_rig_ik',true)());
const originalFaces=fs.readFileSync(new URL('../../madre-hija-marcos/CarasCliente.luau',import.meta.url),'utf8');
const transaction=math+'\n'+read('validacion/instalacion.luau')
 .replace('__ORIGINAL_FACE_SOURCE__','[====[\n'+originalFaces+']====]')
 .replace('__INSTALLER__',read('03_INSTALAR_HISTORIA_DONUTS.txt'))
 .replace('__RESTORE__',read('VOLVER_A_MARCOS.txt'));
console.log(await s.loadstring(transaction,'installation_transactions',true)());
s.destroy();
