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
for i=1,C.CantidadDonuts do assert(food:WaitForChild(string.format("Donut_%02d",i),15),"[HR CAMARA DONUTS] No ha llegado el donut "..i) end
local deadline=os.clock()+20
while not folder:GetAttribute("ActoresListos") and os.clock()<deadline do task.wait(.1) end
assert(folder:GetAttribute("ActoresListos"),"[HR CAMARA DONUTS] El servidor no termino de preparar la escena.")
local camera=workspace.CurrentCamera
while not camera do Run.RenderStepped:Wait();camera=workspace.CurrentCamera end
local saved={kind=camera.CameraType,subject=camera.CameraSubject,fov=camera.FieldOfView,cf=camera.CFrame}
local cameraEffects={}
for _,effect in ipairs(camera:GetChildren()) do
 if effect:IsA("PostEffect") then cameraEffects[effect]=effect.Enabled;effect.Enabled=false end
end
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
local counter=Instance.new("TextLabel");counter.AnchorPoint=Vector2.new(.5,.5);counter.Position=UDim2.fromScale(.5,.65)
counter.Size=UDim2.fromScale(.3,.06);counter.BackgroundTransparency=1;counter.TextColor3=Color3.fromRGB(255,229,99)
counter.TextStrokeTransparency=0;counter.Font=Enum.Font.GothamBold;counter.TextSize=28;counter.Parent=gui
local leftMask=Instance.new("Frame");leftMask.Name="MargenIzquierdo";leftMask.BackgroundColor3=Color3.new(0,0,0);leftMask.BorderSizePixel=0;leftMask.ZIndex=5;leftMask.Parent=gui
local rightMask=leftMask:Clone();rightMask.Name="MargenDerecho";rightMask.Parent=gui
countdown.ZIndex=20;caption.ZIndex=10;counter.ZIndex=10
local guide=C.SubtitulosGuia
local binding="HR_PruebaReparto_Camara"
local startTime,priorShot,fixedFrame,fixedFocus,fittedAspect,solo
local actorVisibility={}
for role,model in pairs(actors) do
 actorVisibility[role]={}
 for _,p in ipairs(model:GetDescendants()) do
  if p:IsA("BasePart") then table.insert(actorVisibility[role],{part=p,value=p.LocalTransparencyModifier}) end
 end
end
local function showRoles(roles)
 local visible={}
 for _,role in ipairs(roles) do visible[role]=true end
 for role,list in pairs(actorVisibility) do
  for _,e in ipairs(list) do if e.part.Parent then e.part.LocalTransparencyModifier=visible[role] and e.value or 1 end end
 end
end
local function restore()
 if not active then return end
 active=false;Run:UnbindFromRenderStep(binding)
 for _,c in ipairs(connections) do c:Disconnect() end
 for p,value in pairs(hidden) do if p.Parent then p.LocalTransparencyModifier=value end end
 showRoles({"Madre","Hija"})
 for kind,value in pairs(core) do pcall(function() StarterGui:SetCoreGuiEnabled(kind,value) end) end
 for effect,value in pairs(cameraEffects) do if effect.Parent then effect.Enabled=value end end
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
 if message=="START" and type(value)=="number" and startTime~=value then startTime=value;priorShot=nil;solo=nil end
end))
local function box(points,cf,half)
 for _,x in ipairs({-1,1}) do for _,y in ipairs({-1,1}) do for _,z in ipairs({-1,1}) do
  table.insert(points,cf:PointToWorldSpace(half*Vector3.new(x,y,z)))
 end end end
end
local function pointsForBase()
 local points={}
 for _,role in ipairs({"Madre","Hija"}) do
  local model=actors[role]
  local head=model.Head
  box(points,CFrame.new(head.Position+Vector3.yAxis*.05),Vector3.new(.82,1.0,.65))
  table.insert(points,model.HumanoidRootPart.Position-Vector3.yAxis*.6)
 end
 -- La mesa ocupa el primer termino; los dos actores quedan juntos al fondo.
 for _,name in ipairs({"Donut_01","Donut_03","Donut_04","Donut_06"}) do
  table.insert(points,food[name]:GetPivot().Position)
 end
 return points
end
local basePoints=pointsForBase()
local function prepareSolo(shot,aspect)
 local actor=actors[shot.Roles[1]]
 local points={};local head=actor.Head
 if shot.Tipo=="REACCION" then
  box(points,CFrame.new(head.Position+Vector3.yAxis*.2),Vector3.new(1.45,1.30,.65))
  table.insert(points,actor.HumanoidRootPart.Position-Vector3.yAxis*.7)
 else
  box(points,CFrame.new(head.Position-Vector3.yAxis*.08),Vector3.new(.75,1.1,.60))
 end
 local cf,focus=C.EncuadreFrontal(points,folder:GetAttribute("Frente"),aspect,shot.Fov,1.06,.04)
 local root=actor.HumanoidRootPart
 return {anchor=root,relative=root.CFrame:ToObjectSpace(cf),relativeFocus=root.CFrame:PointToObjectSpace(focus),fixed=shot.Tipo=="REACCION",cf=cf,focus=focus}
end
Run:BindToRenderStep(binding,Enum.RenderPriority.Camera.Value+10,function()
 if not active then return end
 local raw=startTime and workspace:GetServerTimeNow()-startTime or -C.Preparacion
 local t=math.clamp(raw,0,C.Duracion)
 countdown.Visible=raw<0;countdown.Text=startTime and tostring(math.max(1,math.ceil(-raw))) or "Preparando..."
 local shot,index=C.PlanoEn(t)
 local aspect=camera.ViewportSize.X/math.max(1,camera.ViewportSize.Y)
 if not fixedFrame or fittedAspect~=aspect then
  fixedFrame,fixedFocus=C.EncuadreFrontal(basePoints,folder:GetAttribute("Frente"),aspect,50,1.03,.20)
  fittedAspect=aspect
  priorShot=nil
 end
 if priorShot~=index then
  priorShot=index
  showRoles(shot.Roles)
  solo=#shot.Roles==1 and prepareSolo(shot,aspect) or nil
  print("[HR CAMARA DONUTS] Plano "..index.." / "..shot.Tipo)
 end
 -- Los conjuntos usan un unico eje; los primeros planos tambien son frontales.
 camera.CameraType=Enum.CameraType.Scriptable;camera.FieldOfView=shot.Fov
 if solo then
  local cf=solo.fixed and solo.cf or solo.anchor.CFrame*solo.relative
  local focus=solo.fixed and solo.focus or solo.anchor.CFrame:PointToWorldSpace(solo.relativeFocus)
  camera.CFrame=cf;camera.Focus=CFrame.new(focus)
 else camera.CFrame=fixedFrame;camera.Focus=CFrame.new(fixedFocus) end
 local side=math.max(0,(1-C.FrenteSeguro/aspect)/2)
 leftMask.Size=UDim2.fromScale(side,1);rightMask.Size=UDim2.fromScale(side,1);rightMask.Position=UDim2.fromScale(1-side,0)
 leftMask.Visible=C.MarcoVertical;rightMask.Visible=C.MarcoVertical
 local scene=C.EscenaEn(t)
 counter.Visible=guide and raw>=C.MontajeInicio and raw<15.3
 if counter.Visible then
  local remaining=0
  for _,m in ipairs(food:GetChildren()) do if m:IsA("Model") and m:GetAttribute("HR_Visible")~=false then remaining+=1 end end
  counter.Text=raw>=C.Sorpresa.Inicio and "¡PICANTE!" or tostring(remaining)..(remaining==1 and " dónut" or " dónuts")
 end
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
