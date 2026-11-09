local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local Run=game:GetService("RunService")
local Input=game:GetService("UserInputService")
local StarterGui=game:GetService("StarterGui")
local folder=RS:WaitForChild("HR_Boda",20)
assert(folder,"[HR BODA] Falta la configuracion.")
local C=require(folder:WaitForChild("Configuracion",10));local remote=folder:WaitForChild("Canal",10)
local stage=workspace:WaitForChild("HR_BodaActores",25)
local decor=workspace:WaitForChild("HR_Boda",20)
assert(stage and decor,"[HR BODA] Falta el reparto o el decorado.")
local actors={}
for _,role in ipairs(C.Roles) do
 local m=stage:WaitForChild(role,15)
 assert(m and m:WaitForChild("Head",10) and m:WaitForChild("HumanoidRootPart",10),"[HR BODA] Falta "..role)
 actors[role]=m
end
local deadline=os.clock()+20
while not folder:GetAttribute("ActoresListos") and os.clock()<deadline do task.wait(.1) end
assert(folder:GetAttribute("ActoresListos"),"[HR BODA] El reparto no termino de prepararse.")
local player=Players.LocalPlayer
local camera=workspace.CurrentCamera
while not camera do Run.RenderStepped:Wait();camera=workspace.CurrentCamera end
local saved={kind=camera.CameraType,subject=camera.CameraSubject,fov=camera.FieldOfView,cf=camera.CFrame,mode=camera.FieldOfViewMode}
local active=true;local connections={};local hidden={};local core={};local effects={}
for _,e in ipairs(camera:GetChildren()) do if e:IsA("PostEffect") then effects[e]=e.Enabled;e.Enabled=false end end
for _,kind in ipairs(Enum.CoreGuiType:GetEnumItems()) do
 if kind~=Enum.CoreGuiType.All then
  local ok,v=pcall(function() return StarterGui:GetCoreGuiEnabled(kind) end)
  if ok then core[kind]=v;pcall(function() StarterGui:SetCoreGuiEnabled(kind,false) end) end
 end
end
local function hideCharacter(m)
 local function hide(p)
  if p:IsA("BasePart") then
   if hidden[p]==nil then hidden[p]=p.LocalTransparencyModifier end
   p.LocalTransparencyModifier=1
  end
 end
 for _,p in ipairs(m:GetDescendants()) do hide(p) end
 table.insert(connections,m.DescendantAdded:Connect(function(p) if active then hide(p) end end))
end
if player.Character then hideCharacter(player.Character) end
table.insert(connections,player.CharacterAdded:Connect(function(m) if active then hideCharacter(m) end end))
local gui=Instance.new("ScreenGui");gui.Name="HR_BodaRodaje";gui.IgnoreGuiInset=true;gui.ResetOnSpawn=false;gui.Parent=player:WaitForChild("PlayerGui")
local caption=Instance.new("TextLabel");caption.AnchorPoint=Vector2.new(.5,.5);caption.Position=UDim2.fromScale(.5,.79)
caption.BackgroundTransparency=1;caption.TextColor3=Color3.new(1,1,1);caption.TextStrokeTransparency=0
caption.Font=Enum.Font.GothamBold;caption.TextScaled=true;caption.TextWrapped=true;caption.ZIndex=10;caption.Parent=gui
local limit=Instance.new("UITextSizeConstraint");limit.MaxTextSize=38;limit.MinTextSize=12;limit.Parent=caption
local countdown=Instance.new("TextLabel");countdown.Size=UDim2.fromScale(1,1);countdown.BackgroundColor3=Color3.new(0,0,0);countdown.BackgroundTransparency=.1
countdown.TextColor3=Color3.new(1,1,1);countdown.Font=Enum.Font.GothamBold;countdown.TextSize=72;countdown.ZIndex=20;countdown.Parent=gui
local left=Instance.new("Frame");left.Name="MargenIzquierdo";left.BackgroundColor3=Color3.new(0,0,0);left.BorderSizePixel=0;left.ZIndex=5;left.Parent=gui
local right=left:Clone();right.Name="MargenDerecho";right.Parent=gui
local visibility={}
for role,m in pairs(actors) do
 visibility[role]={}
 for _,p in ipairs(m:GetDescendants()) do if p:IsA("BasePart") then table.insert(visibility[role],{part=p,value=p.LocalTransparencyModifier}) end end
end
local function showRoles(roles)
 local visible={};for _,r in ipairs(roles) do visible[r]=true end
 for r,list in pairs(visibility) do for _,e in ipairs(list) do if e.part.Parent then e.part.LocalTransparencyModifier=visible[r] and e.value or 1 end end end
end
local binding="HR_Boda_Camara"
local function restore()
 if not active then return end
 active=false;Run:UnbindFromRenderStep(binding)
 for _,c in ipairs(connections) do c:Disconnect() end
 for p,v in pairs(hidden) do if p.Parent then p.LocalTransparencyModifier=v end end
 for kind,v in pairs(core) do pcall(function() StarterGui:SetCoreGuiEnabled(kind,v) end) end
 for e,v in pairs(effects) do if e.Parent then e.Enabled=v end end
 showRoles(C.Roles)
 camera.CameraType=saved.kind;camera.CameraSubject=saved.subject or (player.Character and player.Character:FindFirstChildOfClass("Humanoid"))
 camera.FieldOfView=saved.fov;camera.FieldOfViewMode=saved.mode;camera.CFrame=saved.cf;gui:Destroy()
end
local startTime,priorShot,frame,focus,lastAspect,relative,anchor
local guide=C.SubtitulosGuia
local origin=decor:GetAttribute("HR_Origen")
local references={}
for r,m in pairs(actors) do
 local h=m:GetAttribute("HR_AlturaRaiz");local p=C.Posiciones[r]
 local base=CFrame.lookAt(origin:PointToWorldSpace(Vector3.new(p.X,h+.22,p.Z)),origin:PointToWorldSpace(Vector3.new(p.X,h+.22,p.Z))+origin.ZVector)*CFrame.Angles(0,math.rad(C.Giros[r]),0)
 references[r]={height=h,base=base,headHeight=m.Head.Position.Y-m.HumanoidRootPart.Position.Y}
end
local function rootFor(role,t)
 local r=references[role]
 return C.RaizEn(role,t,r.height,r.base,origin)
end
table.insert(connections,Input.InputBegan:Connect(function(key,processed)
 if processed or not active then return end
 if key.KeyCode==Enum.KeyCode.P then restore()
 elseif key.KeyCode==Enum.KeyCode.R then remote:FireServer("REPLAY")
 elseif key.KeyCode==Enum.KeyCode.G then guide=not guide end
end))
table.insert(connections,remote.OnClientEvent:Connect(function(message,value)
 if message=="START" and type(value)=="number" and value~=startTime then startTime=value;priorShot=nil end
end))
local function box(points,cf,half)
 for _,x in ipairs({-1,1}) do for _,y in ipairs({-1,1}) do for _,z in ipairs({-1,1}) do table.insert(points,cf:PointToWorldSpace(half*Vector3.new(x,y,z))) end end end
end
local function prepare(shot,aspect,t)
 local points={};anchor=nil;relative=nil
 local front=origin:VectorToWorldSpace(CFrame.Angles(0,math.rad(shot.Angulo),0).ZVector)
 local slope=.07
 if shot.Tipo=="ENTRADA" then
  local heights={};for r,ref in pairs(references) do heights[r]=ref.height end
  return C.EncuadreEntrada(origin,heights,aspect,shot.Fov)
 end
 if shot.Tipo=="REVELACION" then
  -- Hombro de la novia en primer termino; nueva pareja al fondo, manteniendo el eje.
  local p=origin:PointToWorldSpace(Vector3.new(-3.3,4.8,8.6))
  local q=origin:PointToWorldSpace(Vector3.new(.8,4.0,.65))
  return CFrame.lookAt(p,q),q
 end
 for _,r in ipairs(shot.Roles) do
  local root=rootFor(r,t)
  local headPosition=root.Position+Vector3.yAxis*references[r].headHeight
  if shot.Tipo=="CARA" then
   box(points,CFrame.new(headPosition),Vector3.new(.78,.92,.64))
  elseif shot.Tipo=="ALTAR" or shot.Tipo=="ENTRADA" then
   box(points,CFrame.new(headPosition+Vector3.yAxis*.12),Vector3.new(.95,1.05,.70))
   table.insert(points,root.Position-Vector3.yAxis*references[r].height)
  elseif shot.Tipo=="CAMA" then
   box(points,CFrame.new(headPosition),Vector3.new(1.4,1.05,.7))
   table.insert(points,origin:PointToWorldSpace(Vector3.new(C.Dormitorio.X,1.2,.4)))
  else
   box(points,CFrame.new(headPosition+Vector3.yAxis*.05),Vector3.new(.92,1.0,.65))
   table.insert(points,root.Position-Vector3.yAxis*.4)
  end
 end
 local cf,target=C.Encuadrar(points,front,aspect,shot.Fov,1.08,slope)
 if #shot.Roles==1 and shot.Tipo~="CAMA" then
  anchor=shot.Roles[1]
  local root=rootFor(anchor,t)
  relative={cf=root:ToObjectSpace(cf),focus=root:PointToObjectSpace(target)}
 end
 return cf,target
end
Run:BindToRenderStep(binding,Enum.RenderPriority.Camera.Value+10,function()
 if not active then return end
 local raw=startTime and workspace:GetServerTimeNow()-startTime or -C.Preparacion
 local t=math.clamp(raw,0,C.Duracion);local shot,index=C.PlanoEn(t)
 local aspect=camera.ViewportSize.X/math.max(1,camera.ViewportSize.Y)
 countdown.Visible=raw<0;countdown.Text=startTime and tostring(math.max(1,math.ceil(-raw))) or "Preparando..."
 if priorShot~=index or lastAspect~=aspect then
  priorShot=index;lastAspect=aspect;frame,focus=prepare(shot,aspect,t)
  showRoles(shot.Roles)
  print("[HR BODA CAMARA] CORTE "..index.." / "..shot.Tipo)
 end
 camera.CameraType=Enum.CameraType.Scriptable;camera.FieldOfView=shot.Fov
 camera.FieldOfViewMode=Enum.FieldOfViewMode.Vertical
 local root=relative and rootFor(anchor,t)
 -- Asignacion directa en cada corte: no hay Tween, Lerp ni recorrido entre planos.
 camera.CFrame=relative and root*relative.cf or frame
 camera.Focus=CFrame.new(relative and root:PointToWorldSpace(relative.focus) or focus)
 local side=math.max(0,(1-C.FrenteSeguro/aspect)/2)
 left.Size=UDim2.fromScale(side,1);right.Size=UDim2.fromScale(side,1);right.Position=UDim2.fromScale(1-side,0)
 left.Visible=C.MarcoVertical;right.Visible=C.MarcoVertical
 local scene=C.EscenaEn(t)
 caption.Visible=guide and raw>=0 and raw<C.Duracion and scene.Voz~=nil
 if caption.Visible then
  caption.Size=UDim2.fromScale(math.min(.9,.86*C.FrenteSeguro/aspect),.14)
  caption.Text=scene.Texto
  caption.TextColor3=scene.Voz=="Invitada" and Color3.fromRGB(255,218,99) or Color3.fromRGB(255,255,250)
 end
end)
script.Destroying:Connect(restore)
task.spawn(function()
 local ready=os.clock()+20
 while active and not startTime and os.clock()<ready do remote:FireServer("READY");task.wait(.4) end
 if active and not startTime then warn("[HR BODA] No llego el inicio del servidor.");restore() end
end)
print("[HR BODA CAMARA] Lista. R repite; G oculta el texto de guia; P devuelve la camara.")
