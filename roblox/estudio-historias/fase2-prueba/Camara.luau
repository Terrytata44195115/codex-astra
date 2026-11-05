local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local Run=game:GetService("RunService")
local Input=game:GetService("UserInputService")
local StarterGui=game:GetService("StarterGui")
local folder=RS:WaitForChild("HR_PruebaReparto",15)
assert(folder and folder:GetAttribute("HR_Owner")=="HR_PRUEBA_REPARTO_1","[HR CAMARA PRUEBA] Falta la instalacion reconocida.")
local C=require(folder:WaitForChild("Configuracion",10))
local remote=folder:WaitForChild("Canal",10)
local player=Players.LocalPlayer
local stage=workspace:WaitForChild("HR_PruebaActores",20)
assert(stage,"[HR CAMARA PRUEBA] No llegaron los actores. Revisa la Salida del servidor.")
local actors={}
for _,role in ipairs({"Madre","Hija","Novio"}) do
 local model=stage:WaitForChild(role,15)
 assert(model and model:WaitForChild("Head",10) and model:WaitForChild("HumanoidRootPart",10),"[HR CAMARA PRUEBA] Rig incompleto: "..role)
 actors[role]=model
end
local deadline=os.clock()+20
while not folder:GetAttribute("ActoresListos") and os.clock()<deadline do task.wait(0.1) end
assert(folder:GetAttribute("ActoresListos"),"[HR CAMARA PRUEBA] La preparacion del servidor no termino.")
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
gui.Name="HR_PruebaCuentaAtras";gui.IgnoreGuiInset=true;gui.ResetOnSpawn=false;gui.Parent=player:WaitForChild("PlayerGui")
local label=Instance.new("TextLabel")
label.Size=UDim2.fromScale(1,1);label.BackgroundColor3=Color3.new(0,0,0);label.BackgroundTransparency=0.2
label.TextColor3=Color3.new(1,1,1);label.Font=Enum.Font.GothamBold;label.TextSize=72;label.Text="Preparando...";label.Parent=gui
local startTime
local priorShot
local frame
local binding="HR_PruebaReparto_Camara"
local function restore()
 if not active then return end
 active=false
 Run:UnbindFromRenderStep(binding)
 for _,connection in ipairs(connections) do connection:Disconnect() end
 for item,value in pairs(hidden) do if item.Parent then item[value[1]]=value[2] end end
 for kind,enabled in pairs(core) do pcall(function() StarterGui:SetCoreGuiEnabled(kind,enabled) end) end
 camera.CameraType=saved.kind;camera.CameraSubject=saved.subject or (player.Character and player.Character:FindFirstChildOfClass("Humanoid"));camera.FieldOfView=saved.fov;camera.CFrame=saved.cf
 gui:Destroy()
 print("[HR CAMARA PRUEBA] Camara del jugador restaurada. Stop para terminar la prueba.")
end
table.insert(connections,Input.InputBegan:Connect(function(input,processed)
 if not processed and input.KeyCode==Enum.KeyCode.P then restore() end
end))
table.insert(connections,remote.OnClientEvent:Connect(function(message,value)
 if message=="START" and not startTime and type(value)=="number" then startTime=value end
end))
local function corners(shot)
 local points={}
 for _,role in ipairs(shot.Roles) do
  for _,part in ipairs(actors[role]:GetDescendants()) do
   if part:IsA("BasePart") and part.Name~="HumanoidRootPart" then
    local include=not shot.Medio or part.Name=="Head" or part.Name=="UpperTorso" or part.Name=="LowerTorso" or part.Parent:IsA("Accessory")
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
local function fit(shot)
 local points=corners(shot)
 assert(#points>0,"[HR CAMARA PRUEBA] No hay partes para encuadrar.")
 local low=Vector3.new(math.huge,math.huge,math.huge)
 local high=Vector3.new(-math.huge,-math.huge,-math.huge)
 for _,p in ipairs(points) do low=low:Min(p);high=high:Max(p) end
 local center=(low+high)/2
 local angle=math.rad(shot.Angulo)
 local direction=(folder:GetAttribute("Frente")*math.cos(angle)+folder:GetAttribute("Lado")*math.sin(angle)+Vector3.yAxis*0.10).Unit
 local axes=CFrame.lookAt(center,center-direction)
 -- Se protege el centro 9:16 aunque la ventana de Studio sea horizontal.
 local aspect=math.min(9/16,camera.ViewportSize.X/math.max(1,camera.ViewportSize.Y))
 local tanV=math.tan(math.rad(42/2))
 local tanH=tanV*math.max(aspect,0.05)
 local distance=1
 for _,p in ipairs(points) do
  local q=axes:PointToObjectSpace(p)
  distance=math.max(distance,q.Z+math.abs(q.X)*1.12/tanH,q.Z+math.abs(q.Y)*1.12/tanV,q.Z+0.8)
 end
 return axes*CFrame.new(0,0,distance),center
end
Run:BindToRenderStep(binding,Enum.RenderPriority.Camera.Value+10,function(dt)
 if not active then return end
 local t=startTime and workspace:GetServerTimeNow()-startTime or -C.Preparacion
 gui.Enabled=t<0
 label.Text=startTime and tostring(math.max(1,math.ceil(-t))) or "Preparando..."
 local index=1
 for i,shot in ipairs(C.Planos) do if t>=shot.Inicio then index=i end end
 local wanted,focus=fit(C.Planos[index])
 if priorShot~=index or not frame then
  frame=wanted;priorShot=index
  print("[HR CAMARA PRUEBA] Plano "..index..": "..table.concat(C.Planos[index].Roles,", "))
 else frame=frame:Lerp(wanted,1-math.exp(-dt*8)) end
 camera.CameraType=Enum.CameraType.Scriptable
 camera.FieldOfView=42;camera.CFrame=frame;camera.Focus=CFrame.new(focus)
end)
print("[HR CAMARA PRUEBA] Lista. Encuadre central 9:16. P recupera la camara del jugador.")
task.spawn(function()
 local readyDeadline=os.clock()+20
 while active and not startTime and os.clock()<readyDeadline do remote:FireServer("READY");task.wait(0.5) end
 if active and not startTime then
  warn("[HR CAMARA PRUEBA] El servidor no confirmo el inicio. Se restaura la camara.")
  restore()
 end
end)
