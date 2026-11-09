local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local Run=game:GetService("RunService")
local Input=game:GetService("UserInputService")
local StarterGui=game:GetService("StarterGui")
local folder=RS:WaitForChild("HR_PruebaReparto",15)
assert(folder,"[HR CAMARA DONUTS] Falta el sistema.")
local C=require(folder:WaitForChild("Configuracion",10))
local remote=folder:WaitForChild("Canal",10)
local player=Players.LocalPlayer
local stage=workspace:WaitForChild("HR_PruebaActores",20)
local decor=workspace:WaitForChild("HR_RetoDonuts",20)
assert(stage and decor,"[HR CAMARA DONUTS] Faltan los actores o el decorado.")
local actors={}
for _,role in ipairs({"Madre","Hija"}) do
 local model=stage:WaitForChild(role,15)
 assert(model and model:WaitForChild("Head",10) and model:WaitForChild("HumanoidRootPart",10),"[HR CAMARA DONUTS] Falta "..role)
 actors[role]=model
end
local food=decor:WaitForChild("Donuts",15)
assert(food,"[HR CAMARA DONUTS] Faltan los donuts.")
for i=1,18 do assert(food:WaitForChild(string.format("Donut_%02d",i),15),"[HR CAMARA DONUTS] No ha llegado el donut "..i) end
local deadline=os.clock()+20
while not folder:GetAttribute("ActoresListos") and os.clock()<deadline do task.wait(.1) end
assert(folder:GetAttribute("ActoresListos"),"[HR CAMARA DONUTS] El servidor no termino de preparar la escena.")
local camera=workspace.CurrentCamera
while not camera do Run.RenderStepped:Wait();camera=workspace.CurrentCamera end
local saved={kind=camera.CameraType,subject=camera.CameraSubject,fov=camera.FieldOfView,cf=camera.CFrame}
local active=true;local connections={};local hidden={};local core={}
for _,kind in ipairs(Enum.CoreGuiType:GetEnumItems()) do
 if kind~=Enum.CoreGuiType.All then
  local ok,value=pcall(function() return StarterGui:GetCoreGuiEnabled(kind) end)
  if ok then core[kind]=value;pcall(function() StarterGui:SetCoreGuiEnabled(kind,false) end) end
 end
end
local function hideCharacter(model)
 local function hide(part)
  if part:IsA("BasePart") then
   if not hidden[part] then hidden[part]=part.LocalTransparencyModifier end
   part.LocalTransparencyModifier=1
  end
 end
 for _,part in ipairs(model:GetDescendants()) do hide(part) end
 table.insert(connections,model.DescendantAdded:Connect(function(part) if active then hide(part) end end))
end
if player.Character then hideCharacter(player.Character) end
table.insert(connections,player.CharacterAdded:Connect(function(model) if active then hideCharacter(model) end end))
local gui=Instance.new("ScreenGui");gui.Name="HR_DonutsRodaje";gui.IgnoreGuiInset=true;gui.ResetOnSpawn=false;gui.Parent=player:WaitForChild("PlayerGui")
local countdown=Instance.new("TextLabel");countdown.Size=UDim2.fromScale(1,1)
countdown.BackgroundColor3=Color3.new(0,0,0);countdown.BackgroundTransparency=.15
countdown.TextColor3=Color3.new(1,1,1);countdown.Font=Enum.Font.GothamBold;countdown.TextSize=72;countdown.Text="Preparando...";countdown.Parent=gui
local caption=Instance.new("TextLabel");caption.AnchorPoint=Vector2.new(.5,.5);caption.Position=UDim2.fromScale(.5,.78)
caption.Size=UDim2.fromScale(.3,.15);caption.BackgroundTransparency=1;caption.TextColor3=Color3.new(1,1,1)
caption.TextStrokeTransparency=0;caption.Font=Enum.Font.GothamBold;caption.TextScaled=true;caption.TextWrapped=true;caption.Parent=gui
local maximum=Instance.new("UITextSizeConstraint");maximum.MaxTextSize=38;maximum.MinTextSize=12;maximum.Parent=caption
local guide=C.SubtitulosGuia
local binding="HR_PruebaReparto_Camara"
local startTime,priorShot,cached
local function restore()
 if not active then return end
 active=false;Run:UnbindFromRenderStep(binding)
 for _,c in ipairs(connections) do c:Disconnect() end
 for p,value in pairs(hidden) do if p.Parent then p.LocalTransparencyModifier=value end end
 for kind,value in pairs(core) do pcall(function() StarterGui:SetCoreGuiEnabled(kind,value) end) end
 camera.CameraType=saved.kind;camera.CameraSubject=saved.subject or (player.Character and player.Character:FindFirstChildOfClass("Humanoid"))
 camera.FieldOfView=saved.fov;camera.CFrame=saved.cf;gui:Destroy()
 print("[HR CAMARA DONUTS] Camara del jugador restaurada. Stop termina la prueba.")
end
table.insert(connections,Input.InputBegan:Connect(function(input,processed)
 if processed or not active then return end
 if input.KeyCode==Enum.KeyCode.P then restore()
 elseif input.KeyCode==Enum.KeyCode.R then remote:FireServer("REPLAY")
 elseif input.KeyCode==Enum.KeyCode.G then guide=not guide end
end))
table.insert(connections,remote.OnClientEvent:Connect(function(message,value)
 if message=="START" and type(value)=="number" and startTime~=value then startTime=value;priorShot=nil;cached=nil end
end))
local function box(points,cf,half)
 for _,x in ipairs({-1,1}) do for _,y in ipairs({-1,1}) do for _,z in ipairs({-1,1}) do
  table.insert(points,cf:PointToWorldSpace(half*Vector3.new(x,y,z)))
 end end end
end
local function pointsFor(shot)
 local points={}
 if shot.Tipo=="DONUT" or shot.Tipo=="DETALLE" then
  local donut=food[shot.Donut]
  box(points,donut:GetPivot(),Vector3.new(.95,.55,.95))
  if shot.Tipo=="DETALLE" then
   local hand=actors[shot.Roles[1]].RightHand
   box(points,hand.CFrame,hand.Size*.65)
  end
  return points
 end
 for _,role in ipairs(shot.Roles) do
  local model=actors[role]
  for _,part in ipairs(model:GetDescendants()) do
   if part:IsA("BasePart") and part.Name~="HumanoidRootPart" then
    local n=part.Name
    local accessory=part.Parent:IsA("Accessory")
    local include=shot.Tipo=="CARA" and (n=="Head" or accessory) or
     shot.Tipo~="CARA" and (n=="Head" or n:find("Torso") or n:find("Arm") or n:find("Hand") or accessory)
    if include then box(points,part.CFrame,part.Size/2) end
   end
  end
  if shot.Tipo~="CARA" then
   local head=model.Head;local root=model.HumanoidRootPart
   box(points,CFrame.new(head.Position+Vector3.yAxis*.05),Vector3.new(1.6,.80,.65))
   table.insert(points,root.Position-Vector3.yAxis*.6)
  end
 end
 if shot.Tipo=="MESA" then
  for _,name in ipairs({"Donut_02","Donut_05","Donut_14","Donut_17"}) do
   box(points,food[name]:GetPivot(),Vector3.new(.8,.25,.8))
  end
 end
 return points
end
local function fit(shot)
 local points=pointsFor(shot);assert(#points>0,"[HR CAMARA DONUTS] No hay puntos para el plano.")
 local low=Vector3.new(math.huge,math.huge,math.huge);local high=-low
 for _,p in ipairs(points) do low=low:Min(p);high=high:Max(p) end
 local focus=(low+high)/2
 local front=folder:GetAttribute("Frente")
 local direction=CFrame.Angles(0,math.rad(shot.Angulo),0):VectorToWorldSpace(front)
 direction=(direction+Vector3.yAxis*((shot.Tipo=="DETALLE" or shot.Tipo=="DONUT") and .85 or shot.Tipo=="MESA" and .30 or .06)).Unit
 local axes=CFrame.lookAt(focus,focus-direction)
 local aspect=math.min(C.FrenteSeguro,camera.ViewportSize.X/math.max(1,camera.ViewportSize.Y))
 local tanV=math.tan(math.rad(42/2));local tanH=tanV*math.max(aspect,.05)
 local distance=1;local margin=shot.Margen or 1.20
 for _,p in ipairs(points) do
  local q=axes:PointToObjectSpace(p)
  distance=math.max(distance,q.Z+math.abs(q.X)*margin/tanH,q.Z+math.abs(q.Y)*margin/tanV,q.Z+.8)
 end
 local cf=axes*CFrame.new(0,0,distance)
 if shot.Tipo=="DONUT" or shot.Tipo=="DETALLE" then
  return {donut=food[shot.Donut],direction=direction,distance=distance,focus=focus,offset=focus-food[shot.Donut]:GetPivot().Position}
 elseif #shot.Roles==1 then
  local anchor=actors[shot.Roles[1]].HumanoidRootPart
  return {anchor=anchor,relative=anchor.CFrame:ToObjectSpace(cf),relativeFocus=anchor.CFrame:PointToObjectSpace(focus)}
 end
 return {camera=cf,focus=focus}
end
Run:BindToRenderStep(binding,Enum.RenderPriority.Camera.Value+10,function()
 if not active then return end
 local raw=startTime and workspace:GetServerTimeNow()-startTime or -C.Preparacion
 local t=math.clamp(raw,0,C.Duracion)
 countdown.Visible=raw<0;countdown.Text=startTime and tostring(math.max(1,math.ceil(-raw))) or "Preparando..."
 local shot,index=C.PlanoEn(t)
 if priorShot~=index or not cached then
  cached=fit(shot);priorShot=index
  print("[HR CAMARA DONUTS] Plano "..index.." / "..shot.Tipo)
 end
 local cf,focus
 if cached.donut then
  focus=cached.donut:GetPivot().Position+cached.offset
  cf=CFrame.lookAt(focus+cached.direction*cached.distance,focus)
 elseif cached.anchor then cf=cached.anchor.CFrame*cached.relative;focus=cached.anchor.CFrame:PointToWorldSpace(cached.relativeFocus)
 else cf=cached.camera;focus=cached.focus end
 local u=math.clamp((t-shot.Inicio)/(shot.Fin-shot.Inicio),0,1)
 camera.CameraType=Enum.CameraType.Scriptable;camera.FieldOfView=42
 camera.CFrame=CFrame.lookAt(cf.Position:Lerp(focus,(shot.Acercar or 0)*u),focus);camera.Focus=CFrame.new(focus)
 local scene=C.EscenaEn(t)
 caption.Visible=guide and raw>=0 and raw<C.Duracion and scene.Voz~=nil
 if caption.Visible then
  caption.Text=C.Nombres[scene.Voz]..": "..scene.Texto
  local aspect=camera.ViewportSize.X/math.max(1,camera.ViewportSize.Y)
  caption.Size=UDim2.fromScale(math.min(.9,.85*C.FrenteSeguro/aspect),.14)
 end
end)
script.Destroying:Connect(restore)
task.spawn(function()
 local deadlineReady=os.clock()+20
 while active and not startTime and os.clock()<deadlineReady do remote:FireServer("READY");task.wait(.4) end
 if active and not startTime then warn("[HR CAMARA DONUTS] No llego el inicio del servidor.");restore() end
end)
print("[HR CAMARA DONUTS] Lista. R repite; G muestra/oculta el dialogo; P devuelve la camara.")
