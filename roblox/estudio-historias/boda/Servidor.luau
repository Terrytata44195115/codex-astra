local RS=game:GetService("ReplicatedStorage")
local Storage=game:GetService("ServerStorage")
local Run=game:GetService("RunService")
local Players=game:GetService("Players")
local folder=RS:WaitForChild("HR_Boda",15)
assert(folder and folder:GetAttribute("HR_Owner")=="HR_BODA_1","[HR BODA] Falta el sistema.")
local C=require(folder:WaitForChild("Configuracion",10))
local A=require(folder:WaitForChild("Brazos",10))
local B=require(RS:WaitForChild("HR_PruebaReparto",15):WaitForChild("Interpretacion",10))
local remote=folder:WaitForChild("Canal",10)
local decor=workspace:WaitForChild("HR_Boda",15)
assert(decor and decor:FindFirstChild("Reparto"),"[HR BODA] Ejecuta primero 01_PREPARAR_BODA.")
assert(not workspace:FindFirstChild("HR_BodaActores"),"[HR BODA] Ya hay otro reparto activo.")
local stage=Instance.new("Folder");stage.Name="HR_BodaActores";stage:SetAttribute("HR_Owner","HR_BODA_1")
local origin=decor:GetAttribute("HR_Origen")
local cast={}
local function a(x,y,z) return CFrame.Angles(math.rad(x or 0),math.rad(y or 0),math.rad(z or 0)) end
local function smooth(t) t=math.clamp(t,0,1);return t*t*(3-2*t) end
for _,role in ipairs(C.Roles) do
 local m=decor.Reparto:FindFirstChild(role):Clone();m.Name=role
 local root=m.HumanoidRootPart;local joints={};local clothing={}
 for _,d in ipairs(m:GetDescendants()) do
  if d:IsA("BaseScript") then d.Enabled=false end
  if d:IsA("BasePart") then d.Anchored=d==root;d.CanCollide=false end
  if d:IsA("Motor6D") then
   local key=d.Name:gsub("%s+","")
   assert(not joints[key],"Articulacion duplicada: "..key)
   joints[key]={motor=d,base=d.C0};d.Transform=CFrame.identity
  end
  if d:IsA("BasePart") and (d:GetAttribute("HR_Falda") or d:GetAttribute("HR_Velo")) then
   local weld=d:FindFirstChildOfClass("Weld")
   table.insert(clothing,{part=d,value=d.Transparency,size=d.Size,weld=weld,offset=weld and weld.C0})
  end
 end
 local actor={model=m,root=root,joints=joints,baseCF=root.CFrame,offset=root.CFrame:ToObjectSpace(m:GetPivot()),clothing=clothing,height=m:GetAttribute("HR_AlturaRaiz")}
 actor.arm=A.Cadena(actor);actor.leftArm=A.Cadena(actor,"Left")
 B.Preparar(actor);B.Cara(actor,"NEUTRA");m.Parent=stage;cast[role]=actor
end
stage.Parent=workspace
folder:SetAttribute("ActoresListos",false)
local parked=Instance.new("Folder");parked.Name="HR_BodaOriginalesDurantePlay";parked.Parent=Storage
decor.Reparto.Parent=parked
for _,name in ipairs({"HR_RevisionReparto","HR_RetoDonuts","chicaB","chicaX","cute girl","perroB","perroX"}) do
 local old=workspace:FindFirstChild(name)
 if old and old:IsA("Model") then old.Parent=parked end
end
local startTime,director,finished,previousScene
local lastReplay=-math.huge
local function reset()
 finished=false;previousScene=nil
 for _,actor in pairs(cast) do
  actor.model:PivotTo(actor.baseCF*actor.offset)
  for _,j in pairs(actor.joints) do j.motor.C0=j.base;j.motor.Transform=CFrame.identity end
  for _,p in ipairs(actor.clothing) do p.part.Transparency=p.value;p.part.Size=p.size;if p.weld then p.weld.C0=p.offset end end
  B.Cara(actor,"NEUTRA");actor.model.Head:SetAttribute("HR_Lagrimas",false)
 end
 startTime=workspace:GetServerTimeNow()+C.Preparacion
 folder:SetAttribute("Inicio",startTime);remote:FireAllClients("START",startTime)
end
remote.OnServerEvent:Connect(function(player,message)
 if not player:IsDescendantOf(Players) then return end
 if message=="READY" then
  if not startTime then director=player;reset() end
  remote:FireClient(player,"START",startTime)
 elseif message=="REPLAY" and player==director and os.clock()-lastReplay>1 then lastReplay=os.clock();reset() end
end)
local function pose(actor,targets,dt)
 for key,j in pairs(actor.joints) do j.motor.C0=j.motor.C0:Lerp(j.base*(targets[key] or CFrame.identity),1-math.exp(-dt*22)) end
end
Run.Heartbeat:Connect(function(dt)
 if not startTime or finished then return end
 local raw=workspace:GetServerTimeNow()-startTime
 if raw<0 then return end
 local t=math.min(raw,C.Duracion);local scene,index=C.EscenaEn(t);local lt=t-scene.Inicio
 if previousScene~=index then
  previousScene=index
  print(string.format("[HR BODA] %.1f–%.1f | %s: %s",scene.Inicio,scene.Fin,C.Nombres[scene.Voz] or "Accion",scene.Texto))
 end
 -- Todas las raices cambian antes de resolver contactos entre dos actores.
 for _,role in ipairs(C.Roles) do
  local actor=cast[role];actor.model:PivotTo(C.RaizEn(role,t,actor.height,actor.baseCF,origin)*actor.offset)
 end
 for _,role in ipairs(C.Roles) do
  local actor=cast[role];local action=scene.Acciones[role]
  local targets=B.Pose(action,lt)
  if action=="CEREMONIA" then
   targets.LeftShoulder=a(25,0,8);targets.LeftElbow=a(95);targets.RightShoulder=a(48,0,-25);targets.RightElbow=a(35)
  elseif action=="CORRER" then
   local phase=(t-4)*19;local swing=math.sin(phase)*34
   targets.RightHip=a(swing);targets.LeftHip=a(-swing)
   targets.RightShoulder=a(-swing);targets.LeftShoulder=a(swing)
   targets.RightElbow=a(65);targets.LeftElbow=a(65)
   targets.RightKnee=a(math.max(0,-math.sin(phase))*60);targets.LeftKnee=a(math.max(0,math.sin(phase))*60)
  elseif action=="OPONER" then
   targets.RightShoulder=a(150,0,-12);targets.RightElbow=a(12)
   targets.LeftShoulder=a(25,0,20);targets.LeftElbow=a(60);targets.Waist=a(-4)
  elseif action=="DESPERTAR" then
   targets.RightHip=a(-75,0,-18);targets.LeftHip=a(-75,0,18)
   targets.RightKnee=a(75);targets.LeftKnee=a(75)
   if lt<.8 then targets.RightShoulder=a(90,0,-8);targets.LeftShoulder=a(90,0,8);targets.RightElbow=a(110);targets.LeftElbow=a(110)
   else targets.RightShoulder=a(20,0,-20);targets.LeftShoulder=a(20,0,20);targets.RightElbow=a(55);targets.LeftElbow=a(55) end
  elseif action=="ABRAZAR" then
   targets.RightShoulder=a(65,0,-18);targets.LeftShoulder=a(65,0,18)
   targets.RightElbow=a(75);targets.LeftElbow=a(75);targets.Neck=a(2,0,role=="Novio" and -10 or 10)
  elseif action=="LLORAR" then
   targets.RightHip=a(-65,0,-20);targets.LeftHip=a(-65,0,20)
   targets.RightKnee=a(75);targets.LeftKnee=a(75)
   targets.RightShoulder=a(18,0,-48);targets.LeftShoulder=a(18,0,48)
   targets.RightElbow=a(50);targets.LeftElbow=a(50);targets.Neck=a(0,0,math.sin(lt*12)*5)
  end
  pose(actor,targets,dt)
  if action=="NERVIOSO" then
   local frames=A.Marcos(actor);local head=frames[actor.model.Head]
   local grip=head*CFrame.new(.62,.22,.10)*a(-70,0,-20)
   A.Resolver(actor,grip*A.SoporteMano(actor.model.RightHand):Inverse(),smooth(lt/.25))
  elseif action=="ABRAZAR" then
   local other=cast[role=="Novio" and "Invitada" or "Novio"]
   local torso=A.Marcos(other)[other.model.UpperTorso]
   for _,side in ipairs({"Right","Left"}) do
    local target=torso*CFrame.new(side=="Right" and .38 or -.38,-.32,-.23)
    local hand=actor.model[side.."Hand"]
    A.Resolver(actor,target*A.SoporteMano(hand):Inverse(),smooth((t-10.6)/.3),side=="Right" and actor.arm or actor.leftArm)
   end
  end
  local sleep=role=="Hija" and t>=7.2 and t<10.6
  for _,p in ipairs(actor.clothing) do
   p.part.Transparency=sleep and 1 or p.value
   local scale=role=="Hija" and t>=12.2 and p.part.Name=="PliegueFalda" and .52 or 1
   p.part.Size=Vector3.new(p.size.X,p.size.Y*scale,p.size.Z)
   if p.weld then
    local pos=p.offset.Position
    p.weld.C0=CFrame.new(pos.X,pos.Y*scale,pos.Z)*p.offset.Rotation
   end
  end
  B.Cara(actor,scene.Caras[role]);actor.model.Head:SetAttribute("HR_Lagrimas",role=="Hija" and t>=12.2)
 end
 if raw>=C.Duracion then finished=true;remote:FireAllClients("FIN");print("[HR BODA] FIN. R repite; G oculta el dialogo; P devuelve la camara.") end
end)
folder:SetAttribute("ActoresListos",true)
print("[HR BODA] Cuatro actores preparados. Esperando al cliente de camara.")
