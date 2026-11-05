-- Solo dirige copias del reparto. El proyecto de edicion no se altera durante Play.
local RS=game:GetService("ReplicatedStorage")
local Storage=game:GetService("ServerStorage")
local Run=game:GetService("RunService")
local Players=game:GetService("Players")
local folder=RS:WaitForChild("HR_PruebaReparto",15)
assert(folder and folder:GetAttribute("HR_Owner")=="HR_PRUEBA_REPARTO_1","[HR PRUEBA] Falta la instalacion reconocida.")
assert(not workspace:FindFirstChild("HR_PruebaActores"),"[HR PRUEBA] Ya existe HR_PruebaActores en el proyecto. Revisar antes de duplicar.")
assert(not Storage:FindFirstChild("HR_PruebaOriginalesDurantePlay"),"[HR PRUEBA] Ya existe una carpeta de originales de prueba.")
local C=require(folder:WaitForChild("Configuracion",10))
local remote=folder:WaitForChild("Canal",10)
local source=Storage:FindFirstChild("HR_EstudioReparto")
assert(source and source:GetAttribute("HR_Owner")=="HR_ESTUDIO_REPARTO_1","[HR PRUEBA] Falta la fase 1.")
local roles=source:FindFirstChild("Reparto")
local galleryLink=folder:FindFirstChild("Galeria")
local gallery=galleryLink and galleryLink.Value
assert(roles and gallery and gallery.Parent==workspace and gallery:GetAttribute("HR_Owner")=="HR_ESTUDIO_REPARTO_1","[HR PRUEBA] No se reconoce el reparto.")
local reference=gallery:FindFirstChild("Hija")
assert(reference and reference:FindFirstChild("HumanoidRootPart"),"[HR PRUEBA] Falta Hija en la galeria.")
local center=reference.HumanoidRootPart.Position
local front=reference.HumanoidRootPart.CFrame.LookVector*Vector3.new(1,0,1)
assert(front.Magnitude>0.1,"[HR PRUEBA] Orientacion de referencia no valida.")
front=front.Unit
local side=front:Cross(Vector3.yAxis).Unit
local referenceFoot=reference:FindFirstChild("LeftFoot")
assert(referenceFoot,"[HR PRUEBA] Falta el pie de referencia.")
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
 assert(link and link:IsA("ObjectValue") and link.Value and link.Value:IsDescendantOf(source),"[HR PRUEBA] Referencia no valida: "..role)
 local model=link.Value:Clone()
 model.Name=role
 local h=model:FindFirstChildOfClass("Humanoid")
 local root=model:FindFirstChild("HumanoidRootPart")
 local foot=model:FindFirstChild("LeftFoot")
 assert(h and h.RigType==Enum.HumanoidRigType.R15 and root and foot,"[HR PRUEBA] Rig incompleto: "..role)
 local joints={}
 for _,item in ipairs(model:GetDescendants()) do
  assert(not item:IsA("AnimationConstraint"),"[HR PRUEBA] Rig incompatible: "..role)
  if item:IsA("BaseScript") then item.Enabled=false end
  if item:IsA("BasePart") then item.Anchored=item==root;item.CanCollide=false end
  if item:IsA("Motor6D") then
   local key=item.Name:gsub("%s+","")
   assert(not joints[key],"[HR PRUEBA] Motor duplicado: "..role.."."..key)
   joints[key]={motor=item,base=item.C0}
  end
 end
 for _,key in ipairs({"Waist","Neck","RightShoulder","LeftShoulder","RightElbow","LeftElbow","RightHip","LeftHip","RightKnee","LeftKnee"}) do
  assert(joints[key] and joints[key].motor.Part0 and joints[key].motor.Part1,"[HR PRUEBA] Motor ausente: "..role.."."..key)
 end
 h.AutomaticScalingEnabled=false;h.AutoRotate=false
 h.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None
 model.ModelStreamingMode=Enum.ModelStreamingMode.Persistent
 local target=center+side*((i-2)*3.2)
 target=Vector3.new(target.X,floorY+root.Position.Y-(foot.Position.Y-foot.Size.Y/2),target.Z)
 local actor={model=model,humanoid=h,joints=joints,tracks={},target=target,offset=root.CFrame:ToObjectSpace(model:GetPivot())}
 actor.start=role=="Novio" and target-front*4.5+side*4.5 or target
 actor.runFacing=role=="Novio" and (target-actor.start).Unit or front
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
print("[HR PRUEBA] Tres copias R15 listas. Comprobando correr y saludar...")
local jobs={
 {actor=cast.Novio,key="Correr",loop=true},
 {actor=cast.Novio,key="Saludar",loop=false},
 {actor=cast.Hija,key="Saludar",loop=false},
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
   print("[HR PRUEBA] Pista cargada: "..job.actor.model.Name.." / "..job.key.." / "..C.Animaciones[job.key])
  end)
  if not ok then
   if track then track:Destroy() end
   warn("[HR PRUEBA] "..job.actor.model.Name.." / "..job.key..": gesto procedural de respaldo. "..tostring(err))
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
 if track then track:Play(0.15) end
end
local startTime
local finished=false
remote.OnServerEvent:Connect(function(player,message)
 if message~="READY" or not player:IsDescendantOf(Players) then return end
 if not startTime then
  startTime=workspace:GetServerTimeNow()+C.Preparacion
  folder:SetAttribute("Inicio",startTime)
  print("[HR PRUEBA] Camara confirmada. La prueba empieza tras la cuenta atras.")
 end
 remote:FireClient(player,"START",startTime)
end)
local connection
connection=Run.Heartbeat:Connect(function(dt)
 if not startTime then return end
 local t=workspace:GetServerTimeNow()-startTime
 if t<0 then return end
 for role,actor in pairs(cast) do
  local targets={}
  local key="Reposo"
  if role=="Novio" and t<C.Entrada then
   key="Correr"
   local u=math.clamp(t/C.Entrada,0,1)
   position(actor,actor.start:Lerp(actor.target,u),actor.runFacing)
   if not actor.tracks.Correr then
    local swing=math.sin(t*15)
    targets.RightHip=angles(swing*34);targets.LeftHip=angles(-swing*34)
    targets.RightKnee=angles(math.max(0,-swing)*45);targets.LeftKnee=angles(math.max(0,swing)*45)
    targets.RightShoulder=angles(-swing*35);targets.LeftShoulder=angles(swing*35)
    targets.RightElbow=angles(70);targets.LeftElbow=angles(70);targets.Waist=angles(7)
   end
  else
   position(actor,actor.target)
   if (role=="Novio" and t>=2.5 and t<5) or (role=="Hija" and t>=5 and t<7.5) then
    key="Saludar"
    if not actor.tracks.Saludar then
     targets.RightShoulder=angles(110,0,-25)
     targets.RightElbow=angles(50,0,math.sin(t*10)*24)
    end
   elseif role=="Madre" and t>=5 and t<7.5 then
    targets.Neck=angles(6,math.sin((t-5)*7)*16,0)
   elseif t>=7.5 and t<9.5 then
    targets.RightShoulder=angles(15,0,-38);targets.LeftShoulder=angles(15,0,38)
    targets.RightElbow=angles(30);targets.LeftElbow=angles(30)
   end
  end
  action(actor,key)
  pose(actor,targets,dt)
 end
 if t>=C.Duracion and not finished then
  finished=true
  print("[HR PRUEBA] FIN: entrada, saludo y cuatro planos. El ultimo encuadre se mantiene hasta Stop.")
  print("[HR PRUEBA] Si una pista uso respaldo procedural, aun queda pendiente validar su animacion real.")
  remote:FireAllClients("FIN")
  -- Se permite un breve asentamiento de las poses antes de dejar el plano fijo.
  task.delay(0.5,function() if connection then connection:Disconnect() end end)
 end
end)
print("[HR PRUEBA] Esperando confirmacion de la camara del jugador...")
