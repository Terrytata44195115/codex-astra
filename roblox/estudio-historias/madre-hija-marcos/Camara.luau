local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local Run=game:GetService("RunService")
local Input=game:GetService("UserInputService")
local StarterGui=game:GetService("StarterGui")
local folder=RS:WaitForChild("HR_PruebaReparto",15)
assert(folder and folder:GetAttribute("HR_Owner")=="HR_PRUEBA_REPARTO_1","[HR CAMARA HISTORIA] Falta la instalacion reconocida.")
local C=require(folder:WaitForChild("Configuracion",10))
local remote=folder:WaitForChild("Canal",10)
local player=Players.LocalPlayer
local stage=workspace:WaitForChild("HR_PruebaActores",20)
assert(stage,"[HR CAMARA HISTORIA] No llegaron los actores. Revisa la Salida del servidor.")
local actors={}
for _,role in ipairs({"Madre","Hija","Novio"}) do
 local model=stage:WaitForChild(role,15)
 assert(model and model:WaitForChild("Head",10) and model:WaitForChild("HumanoidRootPart",10),"[HR CAMARA HISTORIA] Rig incompleto: "..role)
 actors[role]=model
end
local deadline=os.clock()+20
while not folder:GetAttribute("ActoresListos") and os.clock()<deadline do task.wait(0.1) end
assert(folder:GetAttribute("ActoresListos"),"[HR CAMARA HISTORIA] La preparacion del servidor no termino.")
local camera=workspace.CurrentCamera
while not camera do Run.RenderStepped:Wait();camera=workspace.CurrentCamera end
local saved={kind=camera.CameraType,subject=camera.CameraSubject,fov=camera.FieldOfView,cf=camera.CFrame}
local core={}
for _,kind in ipairs(Enum.CoreGuiType:GetEnumItems()) do
 if kind~=Enum.CoreGuiType.All then
  local ok,enabled=pcall(function() return StarterGui:GetCoreGuiEnabled(kind) end)
  if ok then core[kind]=enabled;pcall(function() StarterGui:SetCoreGuiEnabled(kind,false) end) end
 end
end
local active=true
local hidden={}
local connections={}
local function hide(item)
 local prop
 if item:IsA("BasePart") then prop="LocalTransparencyModifier"
 elseif item:IsA("Decal") then prop="Transparency"
 elseif item:IsA("BillboardGui") then prop="Enabled" end
 if prop then
  if not hidden[item] then hidden[item]={prop,item[prop]} end
  if prop=="Enabled" then item[prop]=false else item[prop]=1 end
 end
end
local function hideModel(model)
 for _,item in ipairs(model:GetDescendants()) do hide(item) end
 table.insert(connections,model.DescendantAdded:Connect(function(item) if active then hide(item) end end))
end
if player.Character then hideModel(player.Character) end
table.insert(connections,player.CharacterAdded:Connect(function(model) if active then hideModel(model) end end))
for _,name in ipairs({"cute girl","perroX","perroB"}) do
 local model=workspace:FindFirstChild(name)
 if model then hideModel(model) end
end
local gui=Instance.new("ScreenGui")
gui.Name="HR_HistoriaCuentaAtras";gui.IgnoreGuiInset=true;gui.ResetOnSpawn=false;gui.Parent=player:WaitForChild("PlayerGui")
local label=Instance.new("TextLabel")
label.Size=UDim2.fromScale(1,1);label.BackgroundColor3=Color3.new(0,0,0);label.BackgroundTransparency=0.2
label.TextColor3=Color3.new(1,1,1);label.Font=Enum.Font.GothamBold;label.TextSize=72;label.Text="Preparando...";label.Parent=gui
local guide=Instance.new("ScreenGui")
guide.Name="HR_GuiaDialogo";guide.ResetOnSpawn=false;guide.Enabled=false;guide.Parent=player.PlayerGui
local caption=Instance.new("TextLabel")
caption.AnchorPoint=Vector2.new(0.5,0.5);caption.Position=UDim2.fromScale(0.5,0.78);caption.Size=UDim2.fromScale(0.32,0.14)
caption.BackgroundTransparency=1;caption.TextColor3=Color3.new(1,1,1);caption.TextStrokeTransparency=0
caption.Font=Enum.Font.GothamBold;caption.TextScaled=true;caption.TextWrapped=true;caption.Parent=guide
local actorProperties={}
for role,model in pairs(actors) do
 local list={}
 for _,item in ipairs(model:GetDescendants()) do
  if item:IsA("BasePart") then table.insert(list,{item,"LocalTransparencyModifier",item.LocalTransparencyModifier})
  elseif item:IsA("SurfaceGui") then table.insert(list,{item,"Enabled",item.Enabled}) end
 end
 actorProperties[role]=list
end
local function show(roles)
 local visible={}
 for _,role in ipairs(roles) do visible[role]=true end
 for role,list in pairs(actorProperties) do
  for _,entry in ipairs(list) do
   if visible[role] then entry[1][entry[2]]=entry[3]
   elseif entry[2]=="Enabled" then entry[1][entry[2]]=false else entry[1][entry[2]]=1 end
  end
 end
end
local startTime
local priorShot
local cached
local binding="HR_PruebaReparto_Camara"
local function restore()
 if not active then return end
 active=false
 Run:UnbindFromRenderStep(binding)
 for _,connection in ipairs(connections) do connection:Disconnect() end
 for item,value in pairs(hidden) do if item.Parent then item[value[1]]=value[2] end end
 for _,list in pairs(actorProperties) do
  for _,entry in ipairs(list) do if entry[1].Parent then entry[1][entry[2]]=entry[3] end end
 end
 for kind,enabled in pairs(core) do pcall(function() StarterGui:SetCoreGuiEnabled(kind,enabled) end) end
 camera.CameraType=saved.kind;camera.CameraSubject=saved.subject or (player.Character and player.Character:FindFirstChildOfClass("Humanoid"));camera.FieldOfView=saved.fov;camera.CFrame=saved.cf
 gui:Destroy();guide:Destroy()
 print("[HR CAMARA HISTORIA] Camara del jugador restaurada. Stop para terminar.")
end
table.insert(connections,Input.InputBegan:Connect(function(input,processed)
 if processed or not active then return end
 if input.KeyCode==Enum.KeyCode.P then restore()
 elseif input.KeyCode==Enum.KeyCode.R then remote:FireServer("REPLAY") end
end))
table.insert(connections,remote.OnClientEvent:Connect(function(message,value)
 if message=="START" and type(value)=="number" and startTime~=value then
  startTime=value;priorShot=nil;cached=nil
 end
end))
local function corners(shot)
 local points={}
 for _,role in ipairs(shot.Roles) do
  for _,part in ipairs(actors[role]:GetDescendants()) do
   if part:IsA("BasePart") and part.Name~="HumanoidRootPart" then
    local n=part.Name
    local accessory=part.Parent:IsA("Accessory") or part:GetAttribute("HR_Complemento")==true
    local include=shot.Tipo=="ENTERO" or
     (shot.Tipo=="CARA" and (n=="Head" or accessory)) or
     ((shot.Tipo=="MEDIO" or shot.Tipo=="HOMBRO") and (n=="Head" or n:find("Torso") or n:find("Arm") or n:find("Hand") or accessory)) or
     (shot.Tipo=="PANTALON" and (n=="LowerTorso" or n:find("Leg")))
    if include then
     local h=part.Size/2
     for _,x in ipairs({-1,1}) do for _,y in ipairs({-1,1}) do for _,z in ipairs({-1,1}) do
      table.insert(points,part.CFrame:PointToWorldSpace(h*Vector3.new(x,y,z)))
     end end end
    end
   end
  end
 end
 return points
end
local function fit(shot,direction)
 local points=corners(shot)
 assert(#points>0,"[HR CAMARA HISTORIA] No hay partes para encuadrar.")
 local low=Vector3.new(math.huge,math.huge,math.huge)
 local high=Vector3.new(-math.huge,-math.huge,-math.huge)
 for _,p in ipairs(points) do low=low:Min(p);high=high:Max(p) end
 local focus=(low+high)/2
 local axes=CFrame.lookAt(focus,focus-direction)
 local aspect=math.min(C.FrenteSeguro,camera.ViewportSize.X/math.max(1,camera.ViewportSize.Y))
 local tanV=math.tan(math.rad(42/2));local tanH=tanV*math.max(aspect,0.05)
 local distance=1
 local margin=shot.Margen or 1.18
 -- Margen conservador: el acercamiento posterior no llega a agotar esta reserva.
 for _,p in ipairs(points) do
  local q=axes:PointToObjectSpace(p)
  distance=math.max(distance,q.Z+math.abs(q.X)*margin/tanH,q.Z+math.abs(q.Y)*margin/tanV,q.Z+0.8)
 end
 return axes*CFrame.new(0,0,distance),focus
end
local function prepare(shot)
 if shot.Tipo=="HOMBRO" then
  local observer=actors[shot.Sobre].Head.Position
  local target=actors[shot.Roles[1]].UpperTorso.Position+Vector3.yAxis*0.5
  local d=(target-observer)*Vector3.new(1,0,1);d=d.Unit
  local cam=observer-d*1.5+d:Cross(Vector3.yAxis)*1.2+Vector3.yAxis*0.25
  return {shoulder=shot.Sobre,camera=cam,targetRole=shot.Roles[1]}
 end
 local direction
 if #shot.Roles==1 then direction=actors[shot.Roles[1]].HumanoidRootPart.CFrame.LookVector
 else direction=folder:GetAttribute("Frente") end
 direction=CFrame.Angles(0,math.rad(shot.Angulo),0):VectorToWorldSpace(direction)
 direction=(direction+Vector3.yAxis*(shot.Altura or 0.08)).Unit
 local cf,focus=fit(shot,direction)
 if #shot.Roles==1 then
  local root=actors[shot.Roles[1]].HumanoidRootPart
  return {anchor=root,relative=root.CFrame:ToObjectSpace(cf),relativeFocus=root.CFrame:PointToObjectSpace(focus)}
 end
 return {camera=cf,focus=focus}
end
local function shotFrame(shot,u)
 local cf,focus
 if cached.shoulder then
  local target=actors[cached.targetRole].UpperTorso.Position+Vector3.yAxis*0.5
  local direction=(cached.camera-target).Unit
  local fitted
  fitted,focus=fit(shot,direction)
  local distance=math.max((cached.camera-focus).Magnitude,(fitted.Position-focus).Magnitude)
  cf=CFrame.lookAt(focus+direction*distance,focus)
 elseif cached.anchor then
  cf=cached.anchor.CFrame*cached.relative
  focus=cached.anchor.CFrame:PointToWorldSpace(cached.relativeFocus)
 else cf=cached.camera;focus=cached.focus end
 local position=cf.Position:Lerp(focus,(shot.Acercar or 0)*u)
 return CFrame.lookAt(position,focus),focus
end
Run:BindToRenderStep(binding,Enum.RenderPriority.Camera.Value+10,function()
 if not active then return end
 local raw=startTime and workspace:GetServerTimeNow()-startTime or -C.Preparacion
 local t=math.clamp(raw,0,C.Duracion)
 gui.Enabled=raw<0
 label.Text=startTime and tostring(math.max(1,math.ceil(-raw))) or "Preparando..."
 local shot,index=C.PlanoEn(t)
 if priorShot~=index or not cached then
  show(shot.Visibles or shot.Roles)
  cached=prepare(shot);priorShot=index
  print("[HR CAMARA HISTORIA] Plano "..index.." / "..shot.Tipo.." / "..table.concat(shot.Roles,", "))
 end
 local u=math.clamp((t-shot.Inicio)/(shot.Fin-shot.Inicio),0,1)
 local frame,focus=shotFrame(shot,u)
 camera.CameraType=Enum.CameraType.Scriptable;camera.FieldOfView=42
 camera.CFrame=frame;camera.Focus=CFrame.new(focus)
 guide.Enabled=C.SubtitulosGuia and raw>=0 and raw<C.Duracion
 if guide.Enabled then
  local scene=C.EscenaEn(t)
  caption.Text=scene.Voz and C.Nombres[scene.Voz]..": "..scene.Texto or ""
 end
end)
print("[HR CAMARA HISTORIA] Lista: planos de conversacion y reacciones. R repite; P vuelve al jugador.")
task.spawn(function()
 local readyDeadline=os.clock()+20
 while active and not startTime and os.clock()<readyDeadline do remote:FireServer("READY");task.wait(0.5) end
 if active and not startTime then
  warn("[HR CAMARA HISTORIA] El servidor no confirmo el inicio. Se restaura la camara.");restore()
 end
end)
