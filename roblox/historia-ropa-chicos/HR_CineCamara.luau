local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local RunService=game:GetService("RunService")
local StarterGui=game:GetService("StarterGui")
local ContentProvider=game:GetService("ContentProvider")
local UserInputService=game:GetService("UserInputService")
local player=Players.LocalPlayer
local F=RS:WaitForChild("HR_Cine")
local C=require(F:WaitForChild("Configuracion"))
local remote=F:WaitForChild("Preparado")

local function waitActor(name)
	local model=workspace:WaitForChild(name,45)
	assert(model and model:IsA("Model"),"[HR CAMARA] No llego "..name)
	assert(model:WaitForChild("Head",30),"[HR CAMARA] Falta Head de "..name)
	assert(model:WaitForChild("HumanoidRootPart",30),"[HR CAMARA] Falta HumanoidRootPart de "..name)
	return model
end
local X=waitActor(C.Personajes.X)
local B=waitActor(C.Personajes.B)
local camera=workspace.CurrentCamera
while not camera do RunService.RenderStepped:Wait(); camera=workspace.CurrentCamera end
local savedCamera={kind=camera.CameraType,subject=camera.CameraSubject,fov=camera.FieldOfView}
local savedCore={}
local hidden={}
local savedNames={}
local connections={}
local active=true
local started=false
local lastKey
local previousTime=0
local warned={}
local function warning(key,text)
	if not warned[key] then warned[key]=true; warn("[HR CAMARA] "..text) end
end

local gui=Instance.new("ScreenGui")
gui.Name="HR_Preparacion"
gui.IgnoreGuiInset=true
gui.ResetOnSpawn=false
gui.Enabled=false
gui.Parent=player:WaitForChild("PlayerGui")
local label=Instance.new("TextLabel")
label.Size=UDim2.fromScale(1,1)
label.BackgroundColor3=Color3.new(0,0,0)
label.BackgroundTransparency=0
label.TextColor3=Color3.new(1,1,1)
label.Font=Enum.Font.GothamBold
label.TextSize=90
label.Parent=gui

for _,kind in ipairs(Enum.CoreGuiType:GetEnumItems()) do
	if kind~=Enum.CoreGuiType.All then
		local ok,value=pcall(function() return StarterGui:GetCoreGuiEnabled(kind) end)
		if ok then savedCore[kind]=value end
	end
end
local function hidePart(item)
	local property
	if item:IsA("BasePart") then property="LocalTransparencyModifier"
	elseif item:IsA("Decal") then property="Transparency"
	elseif item:IsA("BillboardGui") then property="Enabled" end
	if property then
		if not hidden[item] then hidden[item]={property,item[property]} end
		if property=="Enabled" then item[property]=false else item[property]=1 end
	end
end
local function hideCharacter(character)
	assert(character~=X and character~=B,"[HR CAMARA] El jugador no debe ser una actriz.")
	for _,item in ipairs(character:GetDescendants()) do hidePart(item) end
	table.insert(connections,character.DescendantAdded:Connect(function(item)
		if active then hidePart(item) end
	end))
end
local function hideName(item)
	if item:IsA("Humanoid") then
		if not savedNames[item] then savedNames[item]=item.DisplayDistanceType end
		item.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None
	end
end
for _,item in ipairs(workspace:GetDescendants()) do hideName(item) end
table.insert(connections,workspace.DescendantAdded:Connect(function(item) if active then hideName(item) end end))
if player.Character then hideCharacter(player.Character) end
table.insert(connections,player.CharacterAdded:Connect(hideCharacter))

local function restore()
	if not active then return end
	active=false
	gui.Enabled=false
	RunService:UnbindFromRenderStep("HR_CineCamara")
	for _,connection in ipairs(connections) do connection:Disconnect() end
	for item,state in pairs(hidden) do if item.Parent then item[state[1]]=state[2] end end
	for item,value in pairs(savedNames) do if item.Parent then item.DisplayDistanceType=value end end
	for kind,value in pairs(savedCore) do pcall(function() StarterGui:SetCoreGuiEnabled(kind,value) end) end
	camera.CameraType=savedCamera.kind
	camera.CameraSubject=savedCamera.subject
	camera.FieldOfView=savedCamera.fov
	print("[HR CAMARA] Camara de jugador recuperada. Stop termina la prueba.")
end
-- P permite recuperar el control al revisar, sin insertar controles en pantalla.
table.insert(connections,UserInputService.InputBegan:Connect(function(input,processed)
	if not processed and input.KeyCode==Enum.KeyCode.P then restore() end
end))

local function body(model)
	local low=math.huge
	local high=-math.huge
	local width=0
	local r=model:FindFirstChild("HumanoidRootPart")
	local h=model:FindFirstChild("Head")
	if not r or not h then return nil end
	for _,part in ipairs(model:GetChildren()) do
		if part:IsA("BasePart") and part.Name~="HumanoidRootPart" then
			local half=part.Size/2
			local cf=part.CFrame
			local extent=math.abs(cf.RightVector.Y)*half.X+math.abs(cf.UpVector.Y)*half.Y+math.abs(cf.LookVector.Y)*half.Z
			low=math.min(low,part.Position.Y-extent)
			high=math.max(high,part.Position.Y+extent)
			width=math.max(width,part.Size.X)
		end
	end
	return {root=r,head=h,low=low,high=high,height=math.max(3,high-low),width=math.max(2,width)}
end
local function dogInfo(name)
	if not C.UsarPerros then return nil end
	local reference=F:FindFirstChild(name)
	local object=reference and reference.Value
	if not object then return nil end
	if object:IsA("Model") then
		local cf,size=object:GetBoundingBox()
		return {position=cf.Position,size=size}
	end
	local part=object:IsA("BasePart") and object or object:FindFirstChild("Handle")
	if part then return {position=part.Position,size=part.Size} end
end
local function horizontal(vector)
	local flat=Vector3.new(vector.X,0,vector.Z)
	return flat.Magnitude>0.001 and flat.Unit or Vector3.new(0,0,1)
end
local function frame(scene,t,index)
	local ax,ab=body(X),body(B)
	local front=F:GetAttribute("Frente")
	if not ax or not ab or not front then return nil end
	local cut=scene.Cortes[index]
	local shot=cut[2]
	local fov=cut[3] or 44
	local finish=scene.Cortes[index+1] and scene.Cortes[index+1][1] or scene.Duracion
	local u=math.clamp((t-cut[1])/math.max(0.01,finish-cut[1]),0,1)
	local ease=u*u*(3-2*u)
	local actualAspect=camera.ViewportSize.X/math.max(1,camera.ViewportSize.Y)
	local aspect=math.min(actualAspect,C.Camara.AspectoObjetivo or actualAspect)
	local tangent=math.tan(math.rad(fov/2))
	local function fit(w,h)
		return math.max(h/(2*tangent),w/(2*tangent*aspect))*1.12
	end
	local target,view,distance
	local push=0.025
	local travel=0.08
	local dx,db=dogInfo("DobbyX"),dogInfo("DobbyB")
	if shot=="AMBAS" or shot=="CARRERA" then
		local line=horizontal(ab.root.Position-ax.root.Position)
		view=horizontal(front*0.85+line*0.35)
		target=(ax.root.Position+ab.root.Position)/2+Vector3.new(0,0.5,0)
		distance=fit((ax.root.Position-ab.root.Position).Magnitude+3,math.max(ax.height,ab.height)+0.8)
		push=0.01
	elseif shot=="PERROS" and dx and db then
		view=front
		target=(dx.position+db.position)/2
		distance=fit((dx.position-db.position).Magnitude+math.max(dx.size.X,db.size.X)+1,math.max(dx.size.Y,db.size.Y)+1)
	elseif shot=="DOBBY" and db then
		view=front
		target=db.position
		distance=fit(math.max(db.size.X,db.size.Z)+0.7,db.size.Y+0.7)
		push=0.045
	elseif shot=="MIRADA" and db then
		view=front
		target=ab.head.Position:Lerp(db.position,ease)
		distance=fit(3.5,4)
	elseif shot=="FINAL" then
		view=front
		target=db and (ab.root.Position+db.position)/2+Vector3.new(0,1.3,0) or ab.root.Position+Vector3.new(0,0.8,0)
		distance=fit(db and (ab.root.Position-db.position).Magnitude+4 or 4,ab.height+1.5)
		push=0
	else
		local a=shot:sub(1,1)=="B" and ab or ax
		local look=horizontal(a.root.CFrame.LookVector)
		-- Mismo lado del eje de conversacion y frente visible de la actriz.
		view=horizontal(front*0.6+look*0.9)
		if C.Camara.ParaEditar then
			-- Toma individual abierta, con cuerpo y manos para hacer zoom en edicion.
			target=Vector3.new(a.root.Position.X,(a.low+a.high)/2,a.root.Position.Z)
			distance=fit(math.max(3.8,a.width+1.5),a.height+0.8)*(C.Camara.Entero or 1)
			push=0
		elseif shot=="ENTRADA" then
			view=horizontal(front*0.85+look*0.6)
			target=Vector3.new(a.root.Position.X,(a.low+a.high)/2,a.root.Position.Z)
			distance=fit(a.width+1.7,a.height+0.8)*(C.Camara.Entero or 1)
			push=0
		elseif shot:find("MEDIO") then
			local bottom=a.root.Position.Y-0.35
			target=Vector3.new(a.head.Position.X,(a.high+bottom)/2,a.head.Position.Z)
			distance=fit(3.6,math.max(3.2,a.high-bottom)+0.4)*(C.Camara.Medio or 1)
		elseif shot:find("BRAZOS") then
			target=a.root.Position+Vector3.new(0,0.8,0)
			distance=fit(3.1,3)*(C.Camara.Detalle or 1)
		else
			target=a.head.Position+Vector3.new(0,-0.12,0)
			distance=fit(math.max(1.9,a.head.Size.X*1.7),math.max(2.1,a.head.Size.Y*2.4))*(C.Camara.Cara or 1)
			push=shot=="X_LAGRIMA" and 0.04 or 0.02
		end
	end
	if C.Camara.ParaEditar then push=0; travel=0 end
	local side=horizontal(Vector3.yAxis:Cross(view))
	local sign=index%2==0 and -1 or 1
	local position=target+view*distance*(1-push*ease)+side*(ease-0.5)*travel*sign
	return CFrame.lookAt(position,target),fov,target
end

-- Precarga antes del READY; una textura fallida conserva la cara original.
for name,spec in pairs(C.Expresiones) do
	if spec.Confirmada and spec.Textura then
		local failed=false
		local ok=pcall(function()
			ContentProvider:PreloadAsync({spec.Textura},function(_,status)
				if status~=Enum.AssetFetchStatus.Success then failed=true end
			end)
		end)
		if not ok or failed then
			remote:FireServer("TEXTURA_FALLIDA",name)
			warning(name,"No se pudo cargar "..name.."; se conserva la cara original.")
		end
	end
end
local deadline=os.clock()+45
while active and F:GetAttribute("ServidorListo")~=true and os.clock()<deadline do task.wait(0.1) end
assert(F:GetAttribute("ServidorListo")==true,"[HR CAMARA] El servidor no termino la preparacion.")
if not active then return end
for attempt=1,3 do
	local ok=pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All,false) end)
	if ok then break end
	task.wait(0.1)
end
RunService:BindToRenderStep("HR_CineCamara",Enum.RenderPriority.Camera.Value+1,function()
	if not active then return end
	local ok,err=pcall(function()
		local phase=F:GetAttribute("Fase")
		if phase=="ERROR" then
			warning("servererror","La toma se detuvo en el servidor; revisa el mensaje [HR RUTA] en Salida.")
			restore()
			return
		end
		local index=F:GetAttribute("Escena")
		local scene=index and C.Escenas[index]
		gui.Enabled=C.Modo=="PAUSAS" and phase=="PREPARACION"
		if gui.Enabled then label.Text=tostring(F:GetAttribute("Cuenta") or "") end
		if not scene then return end
		local t=0
		if phase=="TOMA" then
			t=math.clamp(workspace:GetServerTimeNow()-(F:GetAttribute("Inicio") or 0),0,scene.Duracion)
			previousTime=t
		elseif phase=="FIN" or phase=="PAUSA" then t=scene.Duracion
		elseif phase=="ERROR" then t=previousTime end
		local cut=1
		for i,item in ipairs(scene.Cortes) do if t>=item[1] then cut=i end end
		local cf,fov,target=frame(scene,t,cut)
		if not cf then
			warning("pieces","Faltan piezas para encuadrar. Se recupera la camara de jugador.")
			restore()
			return
		end
		camera=workspace.CurrentCamera or camera
		camera.CameraType=Enum.CameraType.Scriptable
		camera.CFrame=cf
		camera.Focus=CFrame.new(target)
		camera.FieldOfView=fov
	end)
	if not ok then warning("render",tostring(err)); restore() end
end)
print("[HR CAMARA] Preparada. P recupera la camara de jugador durante la revision.")
remote:FireServer("READY")
