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
local guide=C.SubtitulosGuia
local binding="HR_PruebaReparto_Camara"
local startTime,priorShot,fixedFrame,fixedFocus,fittedAspect
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
 if message=="START" and type(value)=="number" and startTime~=value then startTime=value;priorShot=nil end
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
  for _,part in ipairs(model:GetDescendants()) do
   if part:IsA("BasePart") and part.Name~="HumanoidRootPart" then
    local n=part.Name
    local accessory=part.Parent:IsA("Accessory")
    if n=="Head" or n:find("Torso") or accessory then box(points,part.CFrame,part.Size/2) end
   end
  end
 end
 -- La mesa ocupa el primer termino; los dos actores quedan juntos al fondo.
 for _,name in ipairs({"Donut_01","Donut_03","Donut_04","Donut_06"}) do
  box(points,food[name]:GetPivot(),Vector3.new(.8,.25,.8))
 end
 return points
end
local basePoints=pointsForBase()
Run:BindToRenderStep(binding,Enum.RenderPriority.Camera.Value+10,function()
 if not active then return end
 local raw=startTime and workspace:GetServerTimeNow()-startTime or -C.Preparacion
 local t=math.clamp(raw,0,C.Duracion)
 countdown.Visible=raw<0;countdown.Text=startTime and tostring(math.max(1,math.ceil(-raw))) or "Preparando..."
 local shot,index=C.PlanoEn(t)
 local aspect=camera.ViewportSize.X/math.max(1,camera.ViewportSize.Y)
 if not fixedFrame or fittedAspect~=aspect then
  fixedFrame,fixedFocus=C.EncuadreFrontal(basePoints,folder:GetAttribute("Frente"),aspect)
  fittedAspect=aspect
 end
 if priorShot~=index then
  priorShot=index
  print("[HR CAMARA DONUTS] Plano "..index.." / "..shot.Tipo)
 end
 -- Una sola posicion y un solo eje durante toda la toma. El zoom solo cambia el FOV.
 camera.CameraType=Enum.CameraType.Scriptable;camera.FieldOfView=shot.Fov
 camera.CFrame=fixedFrame;camera.Focus=CFrame.new(fixedFocus)
 local scene=C.EscenaEn(t)
 counter.Visible=guide and raw>=4.5 and raw<17
 if counter.Visible then
  local remaining=0
  for _,m in ipairs(food:GetChildren()) do if m:IsA("Model") and m:GetAttribute("HR_Visible")~=false then remaining+=1 end end
  counter.Text=raw>=C.Sorpresa.Inicio and "¡PICANTE!" or tostring(remaining).." dónuts"
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
