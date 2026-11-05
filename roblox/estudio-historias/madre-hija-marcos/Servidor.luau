-- Solo dirige copias del reparto. El proyecto de edicion no se altera durante Play.
local RS=game:GetService("ReplicatedStorage")
local Storage=game:GetService("ServerStorage")
local Run=game:GetService("RunService")
local Players=game:GetService("Players")
local folder=RS:WaitForChild("HR_PruebaReparto",15)
assert(folder and folder:GetAttribute("HR_Owner")=="HR_PRUEBA_REPARTO_1","[HR HISTORIA] Falta la instalacion reconocida.")
assert(not workspace:FindFirstChild("HR_PruebaActores"),"[HR HISTORIA] Ya existe HR_PruebaActores en el proyecto. Revisar antes de duplicar.")
assert(not Storage:FindFirstChild("HR_PruebaOriginalesDurantePlay"),"[HR HISTORIA] Ya existe una carpeta de originales de prueba.")
local C=require(folder:WaitForChild("Configuracion",10))
local remote=folder:WaitForChild("Canal",10)
local B=require(folder:WaitForChild("Interpretacion",10))
local source=Storage:FindFirstChild("HR_EstudioReparto")
assert(source and source:GetAttribute("HR_Owner")=="HR_ESTUDIO_REPARTO_1","[HR HISTORIA] Falta la fase 1.")
local roles=source:FindFirstChild("Reparto")
local galleryLink=folder:FindFirstChild("Galeria")
local gallery=galleryLink and galleryLink.Value
assert(roles and gallery and gallery.Parent==workspace and gallery:GetAttribute("HR_Owner")=="HR_ESTUDIO_REPARTO_1","[HR HISTORIA] No se reconoce el reparto.")
local reference=gallery:FindFirstChild("Hija")
assert(reference and reference:FindFirstChild("HumanoidRootPart"),"[HR HISTORIA] Falta Hija en la galeria.")
local center=reference.HumanoidRootPart.Position
local front=reference.HumanoidRootPart.CFrame.LookVector*Vector3.new(1,0,1)
assert(front.Magnitude>0.1,"[HR HISTORIA] Orientacion de referencia no valida.")
front=front.Unit
local side=front:Cross(Vector3.yAxis).Unit
local referenceFoot=reference:FindFirstChild("LeftFoot")
assert(referenceFoot,"[HR HISTORIA] Falta el pie de referencia.")
local floorY=referenceFoot.Position.Y-referenceFoot.Size.Y/2
local stage=Instance.new("Folder")
stage.Name="HR_PruebaActores"
stage:SetAttribute("HR_Owner","HR_PRUEBA_REPARTO_1")
local cast={}
local function angles(x,y,z)
 return CFrame.Angles(math.rad(x or 0),math.rad(y or 0),math.rad(z or 0))
end
local function position(actor,p,facing)
 local cf=CFrame.lookAt(p,p+(facing or front))
 actor.model:PivotTo(cf*actor.offset)
end
for i,role in ipairs({"Madre","Hija","Novio"}) do
 local link=roles:FindFirstChild(role)
 assert(link and link:IsA("ObjectValue") and link.Value and link.Value:IsDescendantOf(source),"[HR HISTORIA] Referencia no valida: "..role)
 local model=link.Value:Clone()
 model.Name=role
 local h=model:FindFirstChildOfClass("Humanoid")
 local root=model:FindFirstChild("HumanoidRootPart")
 local foot=model:FindFirstChild("LeftFoot")
 assert(h and h.RigType==Enum.HumanoidRigType.R15 and root and foot,"[HR HISTORIA] Rig incompleto: "..role)
 local joints={}
 for _,item in ipairs(model:GetDescendants()) do
  assert(not item:IsA("AnimationConstraint"),"[HR HISTORIA] Rig incompatible: "..role)
  if item:IsA("BaseScript") then item.Enabled=false end
  if item:IsA("BasePart") then item.Anchored=item==root;item.CanCollide=false end
  if item:IsA("Motor6D") then
   local key=item.Name:gsub("%s+","")
   assert(not joints[key],"[HR HISTORIA] Motor duplicado: "..role.."."..key)
   joints[key]={motor=item,base=item.C0}
  end
 end
 for _,key in ipairs({"Waist","Neck","RightShoulder","LeftShoulder","RightElbow","LeftElbow","RightHip","LeftHip","RightKnee","LeftKnee"}) do
  assert(joints[key] and joints[key].motor.Part0 and joints[key].motor.Part1,"[HR HISTORIA] Motor ausente: "..role.."."..key)
 end
 h.AutomaticScalingEnabled=false;h.AutoRotate=false
 model.PrimaryPart=root
 h.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None
 h.DisplayName=C.Nombres[role]
 model.ModelStreamingMode=Enum.ModelStreamingMode.Persistent
 local target=center+(role=="Madre" and -side*1.1 or role=="Hija" and side*1.1 or front*4.2)
 target=Vector3.new(target.X,floorY+root.Position.Y-(foot.Position.Y-foot.Size.Y/2),target.Z)
 local actor={model=model,humanoid=h,joints=joints,tracks={},target=target,offset=root.CFrame:ToObjectSpace(model:GetPivot())}
 actor.start=role=="Novio" and target+front*5+side*8 or target
 actor.runFacing=role=="Novio" and (target-actor.start).Unit or front
 B.Preparar(actor)
 if role=="Novio" and C.AccesoriosProvisionales then B.Complementos(actor) end
 B.Cara(actor,"NEUTRA")
 position(actor,actor.start,actor.runFacing)
 model.Parent=stage
 cast[role]=actor
end
stage.Parent=workspace
-- Esta carpeta solo existe dentro de Play: Stop devuelve todo a su sitio.
local parked=Instance.new("Folder");parked.Name="HR_PruebaOriginalesDurantePlay";parked.Parent=Storage
gallery.Parent=parked
for _,name in ipairs({"chicaX","chicaB"}) do
 local original=workspace:FindFirstChild(name)
 if original and original:IsA("Model") then original.Parent=parked end
end
folder:SetAttribute("Frente",front)
folder:SetAttribute("Lado",side)
print("[HR HISTORIA] Reparto listo: madre, hija y Marcos. Comprobando las pistas...")
local jobs={
 {actor=cast.Novio,key="Correr",loop=true},
 {actor=cast.Novio,key="Saludar",loop=false},
}
local pending=#jobs
local closed=false
for _,job in ipairs(jobs) do
 task.spawn(function()
  local track
  local ok,err=pcall(function()
   local animator=job.actor.humanoid:FindFirstChildOfClass("Animator")
   if not animator then animator=Instance.new("Animator");animator.Parent=job.actor.humanoid end
   local animation=Instance.new("Animation");animation.AnimationId=C.Animaciones[job.key]
   local loaded,message=pcall(function() return animator:LoadAnimation(animation) end)
   animation:Destroy()
   assert(loaded,message)
   track=message
   local deadline=os.clock()+7
   while track.Length<=0 and os.clock()<deadline and not closed do task.wait(0.1) end
   assert(not closed and track.Length>0,"La pista no devolvio duracion")
   track.Priority=Enum.AnimationPriority.Action
   track.Looped=job.loop
   job.actor.tracks[job.key]=track
   print("[HR HISTORIA] Pista cargada: "..job.actor.model.Name.." / "..job.key.." / "..C.Animaciones[job.key])
  end)
  if not ok then
   if track then track:Destroy() end
   warn("[HR HISTORIA] "..job.actor.model.Name.." / "..job.key..": gesto procedural de respaldo. "..tostring(err))
  end
  pending-=1
 end)
end
local deadline=os.clock()+8
while pending>0 and os.clock()<deadline do task.wait(0.1) end
closed=true
folder:SetAttribute("ActoresListos",true)
local function pose(actor,targets,dt)
 local alpha=1-math.exp(-dt*16)
 for key,joint in pairs(actor.joints) do
  joint.motor.C0=joint.motor.C0:Lerp(joint.base*(targets[key] or CFrame.identity),alpha)
 end
end
local function action(actor,key)
 if actor.action==key then return end
 -- Solo se detienen las pistas que pertenece a esta prueba, al cambiar de accion.
 for _,track in pairs(actor.tracks) do if track.IsPlaying then track:Stop(0.15) end end
 actor.action=key
 local track=actor.tracks[key]
 if track then track:Play(0.15);if key=="Correr" then track:AdjustSpeed(0.8) end end
end
local startTime
local director
local finished=false
local previousScene
local lastReplay=-math.huge
local function reset()
 finished=false;previousScene=nil
 for _,actor in pairs(cast) do
  actor.action=nil
  for _,track in pairs(actor.tracks) do if track.IsPlaying then track:Stop(0) end end
  for _,joint in pairs(actor.joints) do joint.motor.C0=joint.base end
  B.Cara(actor,"NEUTRA");B.Palidez(actor,0)
  position(actor,actor.start,actor.runFacing)
 end
 startTime=workspace:GetServerTimeNow()+C.Preparacion
 folder:SetAttribute("Inicio",startTime)
 remote:FireAllClients("START",startTime)
end
remote.OnServerEvent:Connect(function(player,message)
 if not player:IsDescendantOf(Players) then return end
 if message=="READY" then
  if not startTime then director=player;reset() end
  remote:FireClient(player,"START",startTime)
 elseif message=="REPLAY" and player==director and os.clock()-lastReplay>=1 then
  lastReplay=os.clock();reset()
 end
end)
local function facing(role,t)
 local actor=cast[role]
 if role=="Novio" then return ((cast.Madre.target+cast.Hija.target)/2-actor.target).Unit end
 local friend=role=="Madre" and cast.Hija or cast.Madre
 local initial=(friend.target-actor.target).Unit
 local meeting=(cast.Novio.target-actor.target).Unit
 local u=math.clamp((t-3)/1,0,1)
 return initial:Lerp(meeting,u).Unit
end
Run.Heartbeat:Connect(function(dt)
 if not startTime or finished then return end
 local raw=workspace:GetServerTimeNow()-startTime
 if raw<0 then return end
 local t=math.min(raw,C.Duracion)
 local scene,index=C.EscenaEn(t)
 local localTime=t-scene.Inicio
 if previousScene~=index then
  previousScene=index
  print(string.format("[HR HISTORIA] %.1f-%.1f | %s: %s",scene.Inicio,scene.Fin,scene.Voz and C.Nombres[scene.Voz] or "Entrada",scene.Texto))
 end
 for role,actor in pairs(cast) do
  local direction=facing(role,t)
  local p=actor.target
  if role=="Novio" then
   local u=math.clamp((t-C.Entrada.Inicio)/(C.Entrada.Fin-C.Entrada.Inicio),0,1)
   p=actor.start:Lerp(actor.target,u)
   if t<C.Entrada.Fin then
    direction=actor.runFacing:Lerp(direction,math.clamp((u-0.7)/0.3,0,1)).Unit
   end
  elseif role=="Madre" and t>=10 then
   p=p-direction*(0.32*math.clamp((t-10)/0.35,0,1))
  end
  position(actor,p,direction)
 end
 for role,actor in pairs(cast) do
  local gesture=scene.Acciones[role]
  local key=gesture=="CORRER" and "Correr" or gesture=="SALUDAR" and "Saludar" or "Reposo"
  action(actor,key)
  local targets=B.Pose(gesture,localTime)
  if gesture=="CORRER" and not actor.tracks.Correr then
   local swing=math.sin(localTime*15)
   targets.RightHip=angles(swing*36);targets.LeftHip=angles(-swing*36)
   targets.RightKnee=angles(math.max(0,-swing)*55);targets.LeftKnee=angles(math.max(0,swing)*55)
   targets.RightShoulder=angles(-swing*40);targets.LeftShoulder=angles(swing*40)
   targets.RightElbow=angles(75);targets.LeftElbow=angles(75);targets.Waist=angles(7)
  elseif gesture=="SALUDAR" and not actor.tracks.Saludar then
   targets.RightShoulder=angles(110,0,-25);targets.RightElbow=angles(50,0,math.sin(localTime*9)*22)
  end
  local other=cast[scene.Miradas[role]]
  if other and gesture~="CORRER" then
   local root=actor.model.HumanoidRootPart
   local d=root.CFrame:VectorToObjectSpace(other.model.Head.Position-actor.model.Head.Position)
   local yaw=math.clamp(math.deg(math.atan2(-d.X,-d.Z)),-35,35)
   targets.Neck=(targets.Neck or CFrame.identity)*angles(0,yaw)
  end
  if scene.Voz==role and gesture=="ESCUCHAR" then
   targets.Neck=(targets.Neck or CFrame.identity)*angles(math.sin(localTime*7)*2)
  end
  pose(actor,targets,dt)
  B.Cara(actor,scene.Caras[role])
  B.Palidez(actor,role=="Madre" and math.clamp((t-10)/0.5,0,1) or role=="Hija" and math.clamp((t-14)/0.5,0,1)*0.4 or 0)
 end
 if raw>=C.Duracion then
  finished=true
  for _,actor in pairs(cast) do action(actor,"Reposo") end
  print("[HR HISTORIA] FIN: 24 segundos. R repite con cuenta atras; P recupera la camara; Stop termina.")
  remote:FireAllClients("FIN")
 end
end)
print("[HR HISTORIA] Preparada. Esperando la camara del jugador...")
