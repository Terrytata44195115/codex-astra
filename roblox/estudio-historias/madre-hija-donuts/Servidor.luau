local RS=game:GetService("ReplicatedStorage")
local Storage=game:GetService("ServerStorage")
local Run=game:GetService("RunService")
local Players=game:GetService("Players")
local folder=RS:WaitForChild("HR_PruebaReparto",15)
assert(folder and folder:GetAttribute("HR_Owner")=="HR_PRUEBA_REPARTO_1","[HR DONUTS] Falta el sistema de historias.")
local C=require(folder:WaitForChild("Configuracion",10))
local B=require(folder:WaitForChild("Interpretacion",10))
local D=require(folder:WaitForChild("Donuts",10))
local A=require(folder:WaitForChild("BrazoDonut",10))
local remote=folder:WaitForChild("Canal",10)
local decor=workspace:WaitForChild("HR_RetoDonuts",15)
local preview=decor and decor:FindFirstChild("RepartoDonuts")
local food=decor and decor:FindFirstChild("Donuts")
local floor=decor and decor:FindFirstChild("Sala") and decor.Sala:FindFirstChild("Suelo")
assert(preview and food and floor,"[HR DONUTS] Faltan el reparto, los donuts o el suelo.")
assert(not workspace:FindFirstChild("HR_PruebaActores"),"[HR DONUTS] Ya hay actores activos: revisa los controladores antes de duplicarlos.")
folder:SetAttribute("ActoresListos",false)
local stage=Instance.new("Folder");stage.Name="HR_PruebaActores";stage:SetAttribute("HR_Owner","HR_PRUEBA_REPARTO_1")
local cast={};local states={}
local function angles(x,y,z) return CFrame.Angles(math.rad(x or 0),math.rad(y or 0),math.rad(z or 0)) end
local function smooth(x) x=math.clamp(x,0,1);return x*x*(3-2*x) end
local origin=decor:GetAttribute("HR_Origen")
assert(typeof(origin)=="CFrame","[HR DONUTS] Falta el origen del decorado.")
folder:SetAttribute("Frente",origin.ZVector)
folder:SetAttribute("Lado",origin.XVector)
for _,role in ipairs({"Madre","Hija"}) do
 local source=preview:FindFirstChild(role)
 assert(source and source:IsA("Model"),"[HR DONUTS] Falta "..role)
 local model=source:Clone();model.Name=role
 local h=model:FindFirstChildOfClass("Humanoid")
 local root=model:FindFirstChild("HumanoidRootPart")
 assert(h and root and model:FindFirstChild("Head"),"[HR DONUTS] Rig incompleto: "..role)
 local joints={}
 for _,item in ipairs(model:GetDescendants()) do
  assert(not item:IsA("AnimationConstraint"),"[HR DONUTS] El rig necesita sus Motor6D compatibles.")
  if item:IsA("BaseScript") then item.Enabled=false end
  if item:IsA("BillboardGui") then item.Enabled=false end
  if item:IsA("BasePart") then item.Anchored=item==root;item.CanCollide=false end
  if item:IsA("Motor6D") then
   local key=item.Name:gsub("%s+","")
   assert(not joints[key],"[HR DONUTS] Articulacion duplicada: "..key)
   item.Transform=CFrame.identity;joints[key]={motor=item,base=item.C0}
  end
 end
 h.AutomaticScalingEnabled=false;h.AutoRotate=false;h.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None
 h.DisplayName=role;model.PrimaryPart=root;model.ModelStreamingMode=Enum.ModelStreamingMode.Persistent
 local actor={model=model,root=root,joints=joints,baseCF=root.CFrame,offset=root.CFrame:ToObjectSpace(model:GetPivot())}
 actor.arm=A.Cadena(actor)
 actor.leftArm=A.Cadena(actor,"Left")
 actor.hold=A.SoporteMano(model.RightHand)
 B.Preparar(actor);B.Cara(actor,"NEUTRA")
 model.Parent=stage;cast[role]=actor
end
stage.Parent=workspace
local parked=Instance.new("Folder");parked.Name="HR_DonutsOriginalesDurantePlay";parked.Parent=Storage
preview.Parent=parked
for _,name in ipairs({"HR_RevisionReparto","chicaX","chicaB","cute girl","perroX","perroB"}) do
 local old=workspace:FindFirstChild(name)
 if old and old:IsA("Model") then old.Parent=parked end
end
for _,part in ipairs(decor.Marcas:GetChildren()) do if part:IsA("BasePart") then part.Transparency=1 end end
for i=1,C.CantidadDonuts do
 local m=food:FindFirstChild(string.format("Donut_%02d",i))
 assert(m and m:IsA("Model") and m.PrimaryPart,"[HR DONUTS] Falta el donut "..i)
 states[m.Name]={model=m,initial=m:GetPivot(),visible=true,bitten=false}
end
local fx=Instance.new("Part");fx.Name="HR_Picante";fx.Size=Vector3.new(.1,.1,.1);fx.Anchored=true;fx.Transparency=1
fx.CanCollide=false;fx.CanTouch=false;fx.CanQuery=false;fx.CastShadow=false;fx.Parent=stage
local emitter=Instance.new("ParticleEmitter");emitter.Name="Sorpresa"
emitter.Texture="rbxasset://textures/particles/smoke_main.dds";emitter.Rate=0
emitter.Lifetime=NumberRange.new(.4,.9);emitter.Speed=NumberRange.new(2,4)
emitter.SpreadAngle=Vector2.new(35,35);emitter.Acceleration=Vector3.new(0,3,0)
emitter.Rotation=NumberRange.new(-180,180);emitter.RotSpeed=NumberRange.new(-160,160)
emitter.Size=NumberSequence.new({NumberSequenceKeypoint.new(0,.13),NumberSequenceKeypoint.new(.8,.13),NumberSequenceKeypoint.new(1,0)})
emitter.Color=ColorSequence.new(Color3.fromRGB(255,161,82),Color3.fromRGB(255,228,189))
emitter.LightEmission=.35;emitter.Parent=fx
local function foodState(s,visible,bitten)
 if s.visible~=visible or s.bitten~=bitten then
  D.Estado(s.model,visible,bitten);s.visible=visible;s.bitten=bitten;s.model:SetAttribute("HR_Visible",visible)
 end
end
local function interaction(role,t)
 for _,item in ipairs(C.Interacciones) do if item.Rol==role and t>=item.Inicio and t<item.Fin then return item end end
end
local function pose(actor,targets,dt)
 local alpha=1-math.exp(-dt*17)
 for key,j in pairs(actor.joints) do j.motor.C0=j.motor.C0:Lerp(j.base*(targets[key] or CFrame.identity),alpha) end
end
local function donutPath(actor,item,t,frames)
 local original=CFrame.new(states[item.Donut].initial.Position)*actor.root.CFrame.Rotation
 local head=frames[actor.model.Head] or actor.model.Head.CFrame
 local mouth=A.Bocado(actor.model.Head,head)
 if item.Montaje then return mouth end
 local chest=CFrame.new(original.Position+Vector3.yAxis*.8)*original.Rotation
 if t<item.Alzar then return original:Lerp(chest,smooth((t-item.Agarre)/(item.Alzar-item.Agarre))) end
 return chest:Lerp(mouth,smooth((t-item.Alzar)/(item.Boca-item.Alzar)))
end
local startTime,director,finished,previousScene
local lastReplay=-math.huge
local confetti=false
local function reset()
 finished=false;previousScene=nil;confetti=false;emitter:Clear()
 for _,actor in pairs(cast) do
  actor.reachWarned=false
  actor.model:PivotTo(actor.baseCF*actor.offset)
  for _,j in pairs(actor.joints) do j.motor.C0=j.base;j.motor.Transform=CFrame.identity end
  B.Cara(actor,"NEUTRA")
  for _,entry in ipairs(actor.skin) do entry.part.Color=entry.color end
 end
 for _,s in pairs(states) do s.model:PivotTo(s.initial);D.Estado(s.model,true,false);s.visible=true;s.bitten=false;s.model:SetAttribute("HR_Visible",true) end
 startTime=workspace:GetServerTimeNow()+C.Preparacion
 folder:SetAttribute("Inicio",startTime);remote:FireAllClients("START",startTime)
end
remote.OnServerEvent:Connect(function(player,message)
 if not player:IsDescendantOf(Players) then return end
 if message=="READY" then
  if not startTime then director=player;reset() end
  remote:FireClient(player,"START",startTime)
 elseif message=="REPLAY" and player==director and os.clock()-lastReplay>=1 then lastReplay=os.clock();reset() end
end)
Run.Heartbeat:Connect(function(dt)
 if not startTime or finished then return end
 local raw=workspace:GetServerTimeNow()-startTime
 if raw<0 then return end
 local t=math.min(raw,C.Duracion);local scene,index=C.EscenaEn(t);local lt=t-scene.Inicio
 if previousScene~=index then
  previousScene=index
  print(string.format("[HR DONUTS] %.2f-%.2f | %s: %s",scene.Inicio,scene.Fin,scene.Voz or "Accion",scene.Texto))
 end
 for role,actor in pairs(cast) do
  local item=interaction(role,t)
  local approach=0
  if item and not item.Montaje then approach=smooth((t-item.Inicio)/.55)*(1-smooth((t-item.Alzar)/(item.Boca-item.Alzar))) end
  local jump=0
  if role==C.Sorpresa.Rol then
   for _,hop in ipairs(C.Saltos) do jump+=hop.Altura*math.sin(math.pi*math.clamp((t-hop.Inicio)/(hop.Fin-hop.Inicio),0,1)) end
  end
  local opening=t<C.Apertura.Fin
  local phase=t-(role=="Hija" and .10 or 0)
  local spin=opening and smooth((phase-C.Apertura.GiroInicio)/(C.Apertura.GiroFin-C.Apertura.GiroInicio))*math.pi*2 or 0
  if opening then jump+=.42*math.sin(math.pi*math.clamp(phase/.65,0,1)) end
  local cf=actor.baseCF+origin.ZVector*(approach*.40)+Vector3.yAxis*jump
  cf=cf*CFrame.Angles(0,spin,0)
  actor.model:PivotTo(cf*actor.offset)
  local targets=B.Pose(scene.Acciones[role],lt)
  if item then
   targets.Waist=angles(-30*approach)
   targets.LeftElbow=angles(25)
  end
  if opening and t>=C.Apertura.Senalar then targets=B.Pose("SENALAR",.4) end
  if jump>.02 then
   targets.RightHip=angles(-10);targets.LeftHip=angles(-8)
   targets.RightKnee=angles(20);targets.LeftKnee=angles(20)
  end
  if scene.Acciones[role]=="ENFADO" then
   targets.RightShoulder=angles(12,0,-18);targets.LeftShoulder=angles(12,0,18)
   targets.RightElbow=angles(70);targets.LeftElbow=angles(70)
   targets.Neck=angles(0,math.sin(lt*9)*5)
  end
  local targetKey=scene.Miradas[role]
  local other=cast[targetKey]
  local target=other and other.model.Head.Position or states[targetKey] and states[targetKey].model:GetPivot().Position
  if target then
   local d=actor.root.CFrame:VectorToObjectSpace(target-actor.model.Head.Position)
   local yaw=math.clamp(math.deg(math.atan2(-d.X,-d.Z)),-32,32)
   targets.Neck=(targets.Neck or CFrame.identity)*angles(0,yaw)
  end
  if scene.Voz==role then targets.Neck=(targets.Neck or CFrame.identity)*angles(math.sin(lt*7)*1.5) end
  -- Durante el agarre/mordisco no se gira la cabeza hacia el otro personaje.
  local whisper=scene.Acciones[role]=="SUSURRAR"
  if item or opening or whisper then targets.Neck=CFrame.identity end
  pose(actor,targets,dt)
  if item or whisper then actor.joints.Neck.motor.C0=actor.joints.Neck.base end
  if whisper then A.Susurrar(actor,smooth(lt/.22)) end
  if opening and t>=C.Apertura.Senalar then
   local chosen=states[role=="Madre" and "Donut_04" or "Donut_05"].initial.Position
   local desired=CFrame.new(chosen+Vector3.yAxis*.45)*actor.root.CFrame.Rotation
   A.Resolver(actor,desired*actor.hold:Inverse(),smooth((t-C.Apertura.Senalar)/.2)*.80)
  end
  B.Cara(actor,scene.Caras[role])
  local heat=role==C.Sorpresa.Rol and smooth((t-C.Sorpresa.Inicio)/.3)*.65 or 0
  for _,entry in ipairs(actor.skin) do entry.part.Color=entry.color:Lerp(Color3.fromRGB(255,87,74),heat) end
  if item then
   local s=states[item.Donut]
   local frames=A.Marcos(actor)
   local wanted=donutPath(actor,item,t,frames)
   local weight=smooth((t-item.Inicio)/(item.Agarre-item.Inicio))*(1-smooth((t-item.Retirar)/(item.Fin-item.Retirar)))
   local hand,excess=A.Resolver(actor,wanted*actor.hold:Inverse(),weight)
   if t>=item.Agarre then
    s.model:PivotTo(hand*actor.hold)
    foodState(s,t<item.Retirar,t>=item.Morder)
   end
   if t>=item.Agarre and t<item.Alzar and excess>.22 and not actor.reachWarned then
    actor.reachWarned=true
    warn(string.format("[HR DONUTS] Revisar alcance de %s: objetivo %.2f studs fuera del brazo; la mano y el donut permanecen unidos.",role,excess))
   end
  end
 end
 for _,item in ipairs(C.Interacciones) do if t>=item.Retirar then foodState(states[item.Donut],false,true) end end
 if t>=C.Sorpresa.Inicio and not confetti then
  confetti=true;fx.CFrame=CFrame.new(cast[C.Sorpresa.Rol].model.Head.Position+Vector3.yAxis*.7);emitter:Emit(18)
 end
 if raw>=C.Duracion then finished=true;remote:FireAllClients("FIN");print("[HR DONUTS] FIN: 20 segundos. Queda un donut sin comer. R repite; P devuelve la camara; Stop termina.") end
end)
folder:SetAttribute("ActoresListos",true)
print("[HR DONUTS] Madre, hija y 6 donuts preparados. Esperando la camara...")
local lighting=game:GetService("Lighting")
print(string.format("[HR DONUTS] Luz en Play: brillo %.2f; exposicion %.2f.",lighting.Brightness,lighting.ExposureCompensation))
