import fs from 'node:fs';
import {LuauState} from '/workspace/hr_entrega/validation/node_modules/luau-web/src/index.js';
const base=new URL('../',import.meta.url);
const read=f=>fs.readFileSync(new URL(f,base),'utf8');
const s=await LuauState.createAsync();
for(const name of ['Configuracion.luau','Donuts.luau','Brazo.luau','PrepararReparto.luau','Servidor.luau','Camara.luau','AjustarMesa.luau','Aspecto.luau','03_INSTALAR_HISTORIA_DONUTS.txt','04_RETO_6_DONUTS.txt','05_SUSURRO_PICANTE_Y_LUZ.txt','VOLVER_A_MARCOS.txt']){
 s.loadstring(read(name),name,true);console.log('Compilation PASS:',name);
}
const math=read('validacion/matematicas.luau');
const c='local C=(function()\n'+read('Configuracion.luau')+'\nend)()\n';
let timeline=math+c+`
local function contiguous(items)
 local t=0
 for _,item in ipairs(items) do assert(item.Inicio==t and item.Fin>t);t=item.Fin end
 assert(t==20)
end
contiguous(C.Escenas);contiguous(C.Planos)
assert(#C.Planos==14 and #C.Interacciones==5 and C.CantidadDonuts==6)
for _,shot in ipairs(C.Planos) do assert(shot.Angulo==0 and shot.Acercar==0 and #shot.Roles>=1 and shot.Fov>=42) end
assert(C.Interacciones[5].Donut=='Donut_05' and C.Interacciones[5].Morder==C.Sorpresa.Inicio)
assert(C.EscenaEn(13).Caras.Hija=='ENFADADA')
assert(C.PlanoEn(3).Tipo=='SUSURRO' and C.PlanoEn(3).Roles[1]=='Madre' and #C.PlanoEn(3).Roles==1)
assert(C.PlanoEn(14).Tipo=='CARA' and C.PlanoEn(14).Roles[1]=='Hija')
assert(C.EscenaEn(3).Texto=='Hay uno que pica, pero mi hija no lo sabe.' and C.EscenaEn(3).Acciones.Madre=='SUSURRAR')
assert(C.Apertura.GiroFin<C.Apertura.Senalar and C.Apertura.Fin==C.PlanoEn(3).Inicio)
assert(C.Saltos[#C.Saltos].Fin<C.PlanoEn(14).Inicio)
for _,item in ipairs(C.Interacciones) do assert(item.Donut~='Donut_06') end
for _,s in ipairs(C.Escenas) do
 assert(s.Acciones.Novio==nil and s.Caras.Novio==nil)
 for _,role in ipairs({'Madre','Hija'}) do assert(s.Caras[role] and s.Acciones[role]) end
end
for _,item in ipairs(C.Interacciones) do
 local a={item.Inicio,item.Agarre,item.Alzar,item.Boca,item.Morder,item.Retirar,item.Fin}
 for i=1,#a-1 do assert(a[i]<a[i+1]) end
 assert(item.Fin<20)
end
local pts={Vector3.new(-3.4,5,-4),Vector3.new(2.8,5.2,-4),Vector3.new(-3,2.2,-4),Vector3.new(2.5,2.2,-4),Vector3.new(-2.9,2.7,.8),Vector3.new(1.9,2.7,.8)}
for _,aspect in ipairs({16/9,9/16,.48}) do
 local camera,focus=C.EncuadreFrontal(pts,Vector3.zAxis,aspect)
 for _,p in ipairs(pts) do
  local q=camera:PointToObjectSpace(p);assert(q.Z<0)
  local tv=math.tan(math.rad(50/2));local th=tv*math.min(aspect,9/16)
  assert(math.abs(q.X)/(-q.Z*th)<1 and math.abs(q.Y)/(-q.Z*tv)<1)
 end
end
return 'PASS: 20 seconds, 14 shots, 4 montage bites then the spicy fifth; mother whisper alone, red angry daughter close-up; projected points fit portrait frame.'
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
 rig+=`local faceAttachment={Position=Vector3.new(0,0,-.57*${scale})};local hatAttachment={Position=Vector3.new(0,.57*${scale},0)}\n`;
 rig+=`parts.Head.FindFirstChild=function(_,name) if name=='FaceFrontAttachment' then return faceAttachment elseif name=='HatAttachment' then return hatAttachment end end\n`;
 rig+=`parts.Head.FindFirstChildOfClass=function(_,name) if name=='SpecialMesh' then return {Scale=Vector3.new(1.25,1.25,1.25)} end end\n`;
 const grip=inventory.find(o=>o.path===prefix+'.RightHand.RightGripAttachment').props.CFrame.position;
 rig+=`parts.RightHand.FindFirstChild=function(_,name) if name=='RightGripAttachment' then return {Position=${vec(grip.map(v=>v*scale))}} end end\n`;
 const leftGrip=inventory.find(o=>o.path===prefix+'.LeftHand.LeftGripAttachment').props.CFrame.position;
 rig+=`parts.LeftHand.FindFirstChild=function(_,name) if name=='LeftGripAttachment' then return {Position=${vec(leftGrip.map(v=>v*scale))}} end end\n`;
 rig+=`local actor={root=parts.HumanoidRootPart,model={Name='${role}',Head=parts.Head,RightHand=parts.RightHand,LeftHand=parts.LeftHand},joints={}}\n`;
 for(const m of motors){const prop=m.props;rig+=`actor.joints[${JSON.stringify(m.name.replaceAll(' ',''))}]={motor={Part0=parts[${JSON.stringify(byId.get(prop.Part0).name)}],Part1=parts[${JSON.stringify(byId.get(prop.Part1).name)}],C0=${cf(prop.C0,scale)},C1=${cf(prop.C1,scale)}},base=${cf(prop.C0,scale)}}\n`;}
 rig+=`
actor.arm=A.Cadena(actor)
actor.leftArm=A.Cadena(actor,'Left')
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
local donut=CFrame.new(${role==='Madre'?-3.15:1.1},2.647,-2.5)*rootCF.Rotation
local hold=A.SoporteMano(parts.RightHand)
local hand,excess=A.Resolver(actor,donut*hold:Inverse(),1)
assert(excess<.08,'Grip out of reach: ${role} '..excess)
assert(((hand*hold).Position-donut.Position).Magnitude<.08)
print('Actual rig grip PASS: ${role}; clamp excess '..excess)
for _,j in pairs(actor.joints) do j.motor.C0=j.base end
actor.root.CFrame=rootCF
local head=A.Marcos(actor)[parts.Head]
local bite=A.Bocado(parts.Head,head)
local localTouch=head:PointToObjectSpace(bite:PointToWorldSpace(Vector3.new(0,0,.72)))
assert(math.abs(localTouch.X)<.00001)
assert(math.abs(localTouch.Y-(-1.14*${scale}*.20))<.00001)
assert(math.abs(localTouch.Z-(-(.95*${scale}/2*1.25)-1.14*${scale}*.04-.035))<.00001)
local biteHand,biteExcess=A.Resolver(actor,bite*hold:Inverse(),1)
assert(biteExcess<.08,'Bite out of reach: ${role} '..biteExcess)
assert(((biteHand*hold).Position-bite.Position).Magnitude<.08)
print('Actual rig bite PASS: ${role}; clamp excess '..biteExcess)
for _,j in pairs(actor.joints) do j.motor.C0=j.base end
local whisperErrors=A.Susurrar(actor,1)
assert(whisperErrors[1]<.08 and whisperErrors[2]<.08,'Whisper reach error: ${role}')
local whisperFrames=A.Marcos(actor)
for _,side in ipairs({'Right','Left'}) do
 local hand=whisperFrames[parts[side..'Hand']]
 local maxY=-math.huge
 for _,x in ipairs({-1,1}) do for _,y in ipairs({-1,1}) do for _,z in ipairs({-1,1}) do
  local point=head:PointToObjectSpace(hand:PointToWorldSpace(parts[side..'Hand'].Size/2*Vector3.new(x,y,z)))
  maxY=math.max(maxY,point.Y)
 end end end
 assert(maxY<.08*${scale},'Whisper hand occludes eyes: ${role} '..maxY)
end
print('Actual rig whisper PASS: ${role}; both arms reach; hands below eyes')
end
`;
}
rig+="return 'PASS: both recorded rigs, grip/bite contact, bone lengths, clamping and two-handed whisper without covering eyes.'";
console.log(await s.loadstring(rig,'actual_rig_ik',true)());
const originalFaces=fs.readFileSync(new URL('../../madre-hija-marcos/CarasCliente.luau',import.meta.url),'utf8');
const transaction=math+'\n'+read('validacion/instalacion.luau')
 .replace('__ORIGINAL_FACE_SOURCE__','[====[\n'+originalFaces+']====]')
 .replace('__INSTALLER__',read('03_INSTALAR_HISTORIA_DONUTS.txt'))
 .replace('__RESTORE__',read('VOLVER_A_MARCOS.txt'))
 .replace('__PATCH__',read('04_RETO_6_DONUTS.txt'));
console.log(await s.loadstring(transaction,'installation_transactions',true)());
s.destroy();
