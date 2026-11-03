local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local F = RS:WaitForChild("HR_Cine")
local C = require(F:WaitForChild("Configuracion"))
local remote = F:WaitForChild("Preparado")

local warned = {}
local function say(text)
	print("[HR] " .. text)
end
local function warnOnce(key, text)
	if not warned[key] then
		warned[key] = true
		warn("[HR] " .. text)
	end
end
local function A(x,y,z)
	return CFrame.Angles(math.rad(x or 0),math.rad(y or 0),math.rad(z or 0))
end
local function flat(v)
	v = Vector3.new(v.X,0,v.Z)
	assert(v.Magnitude > 0.001, "[HR] Las chicas estan en la misma posicion.")
	return v.Unit
end
local function partsOf(object)
	local list = object:GetDescendants()
	if object:IsA("BasePart") then table.insert(list,object) end
	local result = {}
	for _, item in ipairs(list) do
		if item:IsA("BasePart") then table.insert(result,item) end
	end
	return result
end
local function inspectScripts(object)
	for _, item in ipairs(object:GetDescendants()) do
		if item:IsA("BaseScript") and item.Enabled then
			warnOnce(item,
				"Script activo identificado: " .. item:GetFullName() ..
				". No se modifica. Puede competir si mueve este modelo.")
		end
	end
end
local function uniqueModel(name)
	local matches = {}
	for _, item in ipairs(workspace:GetDescendants()) do
		if item:IsA("Model") and item.Name == name then
			table.insert(matches,item)
		end
	end
	assert(#matches == 1, "[HR] Debe existir un unico Model llamado " .. name)
	return matches[1]
end

local function actor(name)
	local model = uniqueModel(name)
	model.ModelStreamingMode = Enum.ModelStreamingMode.Persistent
	local humanoid = model:FindFirstChildOfClass("Humanoid")
	local root = model:FindFirstChild("HumanoidRootPart")
	local head = model:FindFirstChild("Head")
	assert(humanoid and root and head, "[HR] Rig incompleto: " .. name)
	assert(humanoid.RigType == Enum.HumanoidRigType.R15,
		"[HR] Se necesita R15: " .. name)

	local data = {
		model=model, humanoid=humanoid, root=root, head=head,
		pivot=model:GetPivot(), originalRoot=root.CFrame,
		joints={}, pose={}, legs={},
	}
	inspectScripts(model)

	local ambiguous = {}
	for _, item in ipairs(model:GetDescendants()) do
		if item:IsA("Motor6D") and item.Part0 and item.Part1 then
			local key = item.Name:gsub("%s+","")
			if data.joints[key] then ambiguous[key]=true end
			data.joints[key] = {motor=item, base=item.C0}
		elseif item:IsA("AnimationConstraint") then
			warnOnce(item,"AnimationConstraint: " .. item:GetFullName() ..
				". Se requiere un rig Motor6D compatible; no se altera esta constraint.")
		end
	end

	local expected = {
		Waist={"LowerTorso","UpperTorso"},
		Neck={"UpperTorso","Head"},
		RightShoulder={"UpperTorso","RightUpperArm"},
		LeftShoulder={"UpperTorso","LeftUpperArm"},
		RightElbow={"RightUpperArm","RightLowerArm"},
		LeftElbow={"LeftUpperArm","LeftLowerArm"},
		RightHip={"LowerTorso","RightUpperLeg"},
		LeftHip={"LowerTorso","LeftUpperLeg"},
		RightKnee={"RightUpperLeg","RightLowerLeg"},
		LeftKnee={"LeftUpperLeg","LeftLowerLeg"},
		RightAnkle={"RightLowerLeg","RightFoot"},
		LeftAnkle={"LeftLowerLeg","LeftFoot"},
	}
	for key, names in pairs(expected) do
		local joint = data.joints[key]
		assert(joint and not ambiguous[key]
			and joint.motor.Part0.Name == names[1]
			and joint.motor.Part1.Name == names[2],
			"[HR] Articulacion ausente o incompatible: " .. name .. "." .. key)
	end

	local faces = {}
	for _, item in ipairs(head:GetChildren()) do
		if item:IsA("Decal") and item.Face == Enum.NormalId.Front then
			table.insert(faces,item)
		end
	end
	if #faces == 1 then
		data.face=faces[1]
		data.originalTexture=faces[1].Texture
	else
		warnOnce(name.."face","No hay un unico Decal frontal en " .. name ..
			". No se modifica la cara.")
	end

	data.animator=humanoid:FindFirstChildOfClass("Animator")
	if not data.animator then
		data.animator=Instance.new("Animator")
		data.animator.Parent=humanoid
	end
	say(name .. ": conexiones R15 Motor6D comprobadas.")
	return data
end

-- Los originales permanecen guardados en el escenario de edicion.
-- Durante Play se crean actores nuevos desde las plantillas de ServerStorage.
local function spawnNewActors()
	if not C.CrearAvatares then return end
	local templates=game:GetService("ServerStorage"):FindFirstChild("HR_AvataresRopa")
	assert(templates and templates:GetAttribute("HR_Avatares")=="ROPA_CHICOS_1",
		"[HR ROPA] Faltan las bases R15. Ejecuta el activador del paquete Ropa.")
	local entries={{C.Personajes.X,"chicaX"},{C.Personajes.B,"chicaB"}}
	for _,entry in ipairs(entries) do
		assert(not workspace:FindFirstChild(entry[1]),"[HR ROPA] Ya existe "..entry[1].." en Workspace. No se sustituye.")
		assert(templates:FindFirstChild(entry[1]),"[HR ROPA] Falta la plantilla "..entry[1])
		assert(workspace:FindFirstChild(entry[2]),"[HR ROPA] Falta el modelo de referencia "..entry[2])
	end
	for _,entry in ipairs(entries) do
		local reference=workspace[entry[2]]
		local referenceRoot=reference:FindFirstChild("HumanoidRootPart")
		local referenceFoot=reference:FindFirstChild("LeftFoot")
		assert(referenceRoot and referenceFoot,"[HR ROPA] Referencia sin root/pie: "..entry[2])
		local clone=templates[entry[1]]:Clone()
		local root=clone:FindFirstChild("HumanoidRootPart")
		local foot=clone:FindFirstChild("LeftFoot")
		assert(root and foot,"[HR ROPA] Plantilla sin root/pie.")
		local height=root.Position.Y-(foot.Position.Y-foot.Size.Y/2)
		local floor=referenceFoot.Position.Y-referenceFoot.Size.Y/2
		local position=Vector3.new(referenceRoot.Position.X,floor+height,referenceRoot.Position.Z)
		local cf=CFrame.new(position)*referenceRoot.CFrame.Rotation
		local offset=root.CFrame:ToObjectSpace(clone:GetPivot())
		for _,part in ipairs(partsOf(clone)) do
			part.Anchored=part==root
			part.CanCollide=false
		end
		clone:PivotTo(cf*offset)
		clone:SetAttribute("HR_ActorDurantePlay",true)
		clone.Parent=workspace
		if C.OcultarOriginales then
			for _,item in ipairs(reference:GetDescendants()) do
				if item:IsA("BasePart") then
					item.Transparency=1
					item.Anchored=true
					item.CanCollide=false
					item.CanQuery=false
				elseif item:IsA("Decal") or item:IsA("Texture") then item.Transparency=1
				elseif item:IsA("BillboardGui") or item:IsA("SurfaceGui") then item.Enabled=false
				elseif item:IsA("ParticleEmitter") or item:IsA("Trail") or item:IsA("Beam") then item.Enabled=false end
			end
		end
	end
	for _,name in ipairs(C.OcultarDurantePlay or {}) do
		local object=workspace:FindFirstChild(name)
		if object then
			for _,item in ipairs(object:GetDescendants()) do
				if item:IsA("BasePart") then
					item.Transparency=1
					item.Anchored=true
					item.CanCollide=false
					item.CanQuery=false
				elseif item:IsA("Decal") or item:IsA("Texture") then item.Transparency=1
				elseif item:IsA("BillboardGui") or item:IsA("SurfaceGui") then item.Enabled=false end
			end
			if object:IsA("BasePart") then
				object.Transparency=1; object.Anchored=true; object.CanCollide=false; object.CanQuery=false
			end
		end
	end
end
spawnNewActors()

local X = actor(C.Personajes.X)
local B = actor(C.Personajes.B)
local direction = flat(B.root.Position-X.root.Position)
local front = flat(direction:Cross(Vector3.yAxis))

local function facing(position, look)
	return CFrame.lookAt(position,position+look)
end
X.stage=facing(X.root.Position,direction)
B.stage=facing(B.root.Position,-direction)

local function place(a,cf)
	a.model:PivotTo(cf*a.originalRoot:ToObjectSpace(a.pivot))
end
local function prepareParts(object,root)
	for _, part in ipairs(partsOf(object)) do
		part.Anchored=(part==root)
		part.CanCollide=false
		part.CanTouch=false
	end
end

local function dog(name)
	local value=F:WaitForChild(name).Value
	if not value then return nil end
	assert(value:IsDescendantOf(workspace), "[HR] " .. name .. " debe estar en Workspace.")
	assert(value:IsA("Model") or value:IsA("BasePart") or value:IsA("Accessory"),
		"[HR] Asigna un Model, MeshPart/Part o Accessory a " .. name)

	for _, actress in ipairs({X.model,B.model}) do
		assert(value~=actress and not value:IsDescendantOf(actress)
			and not actress:IsDescendantOf(value),
			"[HR] " .. name .. " no puede ser una chica ni contenerla.")
	end

	local parts=partsOf(value)
	assert(#parts>0, "[HR] El perro no contiene piezas: " .. name)

	if value:IsA("Model") then
		value.ModelStreamingMode=Enum.ModelStreamingMode.Persistent
	end
	local root
	if value:IsA("BasePart") then
		root=value
	elseif value:IsA("Model") then
		root=value.PrimaryPart or value:FindFirstChild("HumanoidRootPart")
	end
	root=root or value:FindFirstChild("Handle") or parts[1]

	local d={object=value,root=root,parts=parts,joints={},name=name}
	inspectScripts(value)

	-- Evita mover un accesorio unido a un objeto exterior.
	local member={}
	for _, part in ipairs(parts) do member[part]=true end
	for _, part in ipairs(parts) do
		for _, connected in ipairs(part:GetConnectedParts(true)) do
			assert(member[connected],
				"[HR] " .. name .. " esta unido a una pieza exterior. " ..
				"Revisa el modelo antes de animarlo.")
		end
	end

	local motorCount=0
	for _, item in ipairs(value:GetDescendants()) do
		if item:IsA("Motor6D") and item.Part0 and item.Part1 then
			motorCount+=1
			local n=item.Part1.Name:lower()
			local jointName=item.Name:lower()
			local kind
			if n=="head" or jointName=="neck" then kind="head"
			elseif n:find("front") and (n:find("leg") or n:find("paw")) then kind="front" end
			if kind then
				table.insert(d.joints,{motor=item,base=item.C0,kind=kind})
			end
		elseif item:IsA("AnimationConstraint") then
			warnOnce(item,name .. ": AnimationConstraint sin adaptador; reaccion del conjunto.")
		end
	end

	d.original={}
	for _, part in ipairs(parts) do d.original[part]=part.CFrame end
	d.pivot=value:IsA("Model") and value:GetPivot() or root.CFrame

	local low=math.huge
	for _, part in ipairs(parts) do
		low=math.min(low,part.Position.Y-part.Size.Magnitude/2)
	end
	d.bottom=Vector3.new(d.pivot.Position.X,low,d.pivot.Position.Z)

	say(name .. ": " .. value:GetFullName() .. " [" .. value.ClassName ..
		"], motores=" .. motorCount .. ", gestos reconocidos=" .. #d.joints)
	if #d.joints==0 then
		warnOnce(name.."static",name .. ": solo movimiento suave del conjunto; " ..
			"no se simularan patas inexistentes.")
	end
	return d
end

local DX=C.UsarPerros and dog("DobbyX") or nil
local DB=C.UsarPerros and dog("DobbyB") or nil
if DX and DB then
	assert(DX.object~=DB.object
		and not DX.object:IsDescendantOf(DB.object)
		and not DB.object:IsDescendantOf(DX.object),
		"[HR] Los dos perros deben ser objetos diferentes sin solaparse.")
end

assert(C.Modo=="ESCENA" or C.Modo=="COMPLETA" or C.Modo=="PAUSAS",
	"[HR] Modo no valido.")
assert(C.Escenas[C.Escena], "[HR] Numero de escena no valido.")
assert(C.VelocidadCarrera>0 and C.DuracionPaso>0, "[HR] Carrera mal configurada.")

local selected={}
if C.Modo=="ESCENA" then
	selected={C.Escena}
else
	for i=C.DesdeEscena or 1,C.HastaEscena or #C.Escenas do
		assert(C.Escenas[i],"[HR] Rango de escenas no valido.")
		table.insert(selected,i)
	end
end
local needsDogs=false
for _, i in ipairs(selected) do
	local action=C.Escenas[i].Accion
	if action=="LLAMAR" or action=="LADRAR" or action=="FINAL" then needsDogs=true end
end
if needsDogs then
	assert(DX and DB,
		"[HR] Faltan perros. Asigna HR_Cine.DobbyX.Value y DobbyB.Value " ..
		"a los dos objetos existentes. No se han adivinado sus identidades.")
end

-- La preparacion comienza solo despues de terminar las comprobaciones.
for _, a in ipairs({X,B}) do
	prepareParts(a.model,a.root)
	a.humanoid.AutoRotate=false
end
for _, d in ipairs({DX or false,DB or false}) do
	if d then
		if #d.joints>0 then
			prepareParts(d.object,d.root)
		else
			-- Conjunto rigido: cada pieza conserva su desplazamiento original.
			for _, part in ipairs(d.parts) do
				part.Anchored=true
				part.CanCollide=false
			end
		end
	end
end

local targets=Instance.new("Model")
targets.ModelStreamingMode=Enum.ModelStreamingMode.Persistent
targets.Name="HR_ObjetivosDurantePlay"
targets.Parent=workspace

for _, side in ipairs({"Left","Right"}) do
	local foot=X.model:FindFirstChild(side.."Foot")
	local upper=X.model:FindFirstChild(side.."UpperLeg")
	assert(foot and upper,"[HR] Faltan piezas para IK de piernas.")
	local target=Instance.new("Part")
	target.Name=side.."Foot"
	target.Size=Vector3.new(0.1,0.1,0.1)
	target.Transparency=1
	target.Anchored=true
	target.CanCollide=false
	target.CanQuery=false
	target.CanTouch=false
	target.CFrame=foot.CFrame
	target.Parent=targets

	local ik=Instance.new("IKControl")
	ik.Name="HR_"..side.."Leg"
	ik.Type=Enum.IKControlType.Transform
	ik.ChainRoot=upper
	ik.EndEffector=foot
	ik.Target=target
	ik.SmoothTime=0.025
	ik.Weight=1
	ik.Priority=10
	ik.Enabled=false
	ik.Parent=X.humanoid

	table.insert(X.legs,{
		control=ik,target=target,foot=foot,
		offset=X.originalRoot:ToObjectSpace(foot.CFrame),
	})
end

-- Objetivo de barbilla real, adaptado al tamano de la cabeza.
-- Solo se crea durante Play; no modifica ropa, pelo ni la cara.
local hand=B.model:FindFirstChild("RightHand")
local upperArm=B.model:FindFirstChild("RightUpperArm")
local wrist=B.joints.RightWrist
if hand and upperArm and wrist and wrist.motor.Part1==hand then
	local target=Instance.new("Attachment")
	target.Name="HR_Barbilla"
	target.Position=Vector3.new(B.head.Size.X*0.15,-B.head.Size.Y*0.5-0.12,-B.head.Size.Z*0.5-0.18)
	target.Parent=B.head
	local pole=Instance.new("Attachment")
	pole.Name="HR_CodoPensativo"
	pole.Position=Vector3.new(1.5,0.5,-0.4)
	pole.Parent=B.root
	local ik=Instance.new("IKControl")
	ik.Name="HR_Pensar"
	ik.Type=Enum.IKControlType.Position
	ik.ChainRoot=upperArm
	ik.EndEffector=hand
	ik.Target=target
	ik.Pole=pole
	ik.Priority=20
	ik.Weight=1
	ik.SmoothTime=0.12
	ik.Enabled=false
	ik.Parent=B.humanoid
	B.thinkIK=ik
else
	warnOnce("thinkIK","No hay cadena completa de brazo/mano para IK de barbilla. Se conserva el gesto por motores.")
end

local ray=RaycastParams.new()
ray.FilterType=Enum.RaycastFilterType.Exclude
ray.RespectCanCollide=true
local function refreshRay()
	local ignored={X.model,B.model,targets}
	if DX then table.insert(ignored,DX.object) end
	if DB then table.insert(ignored,DB.object) end
	for _, p in ipairs(Players:GetPlayers()) do
		if p.Character then table.insert(ignored,p.Character) end
	end
	ray.FilterDescendantsInstances=ignored
end
local function ground(position)
	return workspace:Raycast(position+Vector3.new(0,4,0),Vector3.new(0,-12,0),ray)
end

local scene
local run
local function route(start,look,length)
	refreshRay()
	local initial=ground(start)
	if not initial then return 0,"no se detecta suelo bajo el recorrido" end
	local footLow=math.min(X.model.LeftFoot.Position.Y-X.model.LeftFoot.Size.Y/2,
		X.model.RightFoot.Position.Y-X.model.RightFoot.Size.Y/2)
	local bodyHeight=math.max(1,X.head.Position.Y+X.head.Size.Y/2-footLow)
	local torso=X.model:FindFirstChild("UpperTorso")
	local radius=math.max(0.25,(torso and torso.Size.X or X.root.Size.X)*0.48)
	local clearance=math.max(0.08,bodyHeight*0.025)
	-- El volumen comienza POR ENCIMA del suelo, incluso con avatares pequenos.
	-- No usa las alturas fijas -1/0/1.5 que podian interceptar el suelo.
	local boxHeight=bodyHeight*0.88
	local boxCenter=Vector3.new(start.X,initial.Position.Y+clearance+boxHeight/2,start.Z)
	local hit=workspace:Blockcast(CFrame.lookAt(boxCenter,boxCenter+look),
		Vector3.new(radius*2,boxHeight,radius*1.4),look*length,ray)
	local reason="recorrido libre"
	if hit then
		length=math.max(0,math.min(length,hit.Distance-0.15))
		reason="obstaculo: "..hit.Instance:GetFullName()
	end
	local safe=0
	local count=math.max(1,math.ceil(length/0.2))
	local side=Vector3.yAxis:Cross(look)
	for step=0,count do
		local distance=length*step/count
		for _,offset in ipairs({-radius*0.65,0,radius*0.65}) do
			local floor=ground(start+look*distance+side*offset)
			if not floor then return safe,"sin suelo a "..string.format("%.1f",distance).." studs" end
			if floor.Normal.Y<0.85 then return safe,"superficie inclinada: "..floor.Instance:GetFullName() end
			if math.abs(floor.Position.Y-initial.Position.Y)>0.3 then
				return safe,"desnivel: "..floor.Instance:GetFullName()
			end
		end
		safe=distance
	end
	return safe,reason
end
local function makeRun(start,look,length,turnFrom,turn)
	local cf=facing(start,look)
	local feet={}
	for i,leg in ipairs(X.legs) do feet[i]=cf*leg.offset end
	local ramp=0.15
	return {root=cf,look=look,length=length,feet=feet,
		turnFrom=turnFrom or cf,turn=turn or 0,
		duration=length/(C.VelocidadCarrera*(1-ramp)),ramp=ramp}
end
local function candidateDirections()
	local list={}
	for _,angle in ipairs({0,30,-30,60,-60,85,-85}) do
		local v=CFrame.Angles(0,math.rad(angle),0):VectorToWorldSpace(direction)
		table.insert(list,{look=v,angle=angle})
	end
	return list
end
local function planRun()
	local reasons={}
	for _,candidate in ipairs(candidateDirections()) do
		local look=-candidate.look
		local length,why=route(X.stage.Position,look,C.DistanciaCarrera)
		if length>=3 then
			say(string.format("Ruta de huida: %.1f studs, angulo %d.",length,candidate.angle))
			return makeRun(X.stage.Position,look,length,X.stage,0.25)
		end
		table.insert(reasons,string.format("%d grados: %.1f studs (%s)",candidate.angle,length,why))
	end
	error("[HR RUTA] No hay salida segura. "..table.concat(reasons,"; "))
end
local function planArrival()
	local reasons={}
	for _,candidate in ipairs(candidateDirections()) do
		local incoming=candidate.look
		local length,why=route(X.stage.Position,-incoming,C.DistanciaEntrada)
		if length>=3 then
			local start=X.stage.Position-incoming*length
			local available,forwardWhy=route(start,incoming,length)
			if available>=length-0.05 then
				local result=makeRun(start,incoming,length)
				assert(result.duration+0.3<scene.Entrada,
					"[HR RUTA] Aumenta Entrada para la distancia y velocidad configuradas.")
				result.arrival=true
				say(string.format("Ruta de llegada: %.1f studs, angulo %d. Suelo comprobado.",length,candidate.angle))
				return result
			end
			why=forwardWhy
		end
		table.insert(reasons,string.format("%d grados: %.1f studs (%s)",candidate.angle,length,why))
	end
	error("[HR RUTA] No se encontro entrada segura. "..table.concat(reasons,"; "))
end
local function runPose(t)
	if not run then return false end
	if t<run.turn then
		place(X,run.turnFrom:Lerp(run.root,t/run.turn))
		return false
	end
	local elapsed=t-run.turn
	local u=math.clamp(elapsed/run.duration,0,1)
	local ramp=run.ramp
	local progress
	if u<ramp then progress=u*u/(2*ramp*(1-ramp))
	elseif u>1-ramp then progress=1-(1-u)^2/(2*ramp*(1-ramp))
	else progress=(u-ramp/2)/(1-ramp) end
	local distance=run.length*progress
	local moving=u<1
	place(X,run.root+run.look*distance)
	local stride=C.VelocidadCarrera*C.DuracionPaso
	local cycle=distance/stride
	for i,leg in ipairs(X.legs) do
		leg.control.Enabled=true
		local offset=i==1 and 0 or 0.5
		local p=cycle+offset
		local count=math.floor(p)
		local phase=p-count
		local from=math.max(0,(count-offset)*stride)
		local to=math.max(0,(count+1-offset)*stride)
		local blend=0
		local lift=0
		if phase>0.55 then
			local v=(phase-0.55)/0.45
			blend=v*v*(3-2*v)
			lift=math.sin(v*math.pi)*C.AlturaPaso
		end
		local travel=from+(to-from)*blend
		local cf=run.feet[i]
		local position=cf.Position+run.look*travel
		-- Asienta ambos pies al detenerse.
		local settle=math.clamp((u-0.88)/0.12,0,1)
		position=position:Lerp(cf.Position+run.look*run.length,settle)
		lift*=1-settle
		local floor=ground(position)
		if floor then
			position=Vector3.new(position.X,floor.Position.Y+leg.foot.Size.Y/2+lift,position.Z)
		end
		leg.target.CFrame=CFrame.new(position)*cf.Rotation
	end
	if run.arrival and not moving then
		local settle=math.clamp((elapsed-run.duration)/0.28,0,1)
		place(X,(run.root+run.look*run.length):Lerp(X.stage,settle))
		for _,leg in ipairs(X.legs) do
			leg.control.Weight=1-settle
			if settle>=1 then leg.control.Enabled=false end
		end
	else
		for _,leg in ipairs(X.legs) do leg.control.Weight=1 end
	end
	return moving,cycle
end

local function face(a,name)
	if a.lastFace==name then return end
	a.lastFace=name
	if not a.face then return end
	local spec=C.Expresiones[name]
	if F:GetAttribute("TexturaFallida_"..name) then
		a.face.Texture=a.originalTexture
		return
	end
	if spec and spec.Confirmada and type(spec.Textura)=="string"
		and spec.Textura:match("^rbxassetid://%d+$") then
		a.face.Texture=spec.Textura
	else
		a.face.Texture=a.originalTexture
		warnOnce("face"..tostring(name),
			"Sin textura confirmada para " .. tostring(name) ..
			". Se conserva la cara original.")
	end
end

local function look(a,position)
	local v=a.root.CFrame:VectorToObjectSpace(position-a.root.Position)
	local yaw=math.deg(math.atan2(-v.X,-v.Z))
	a.pose.Neck=A(0,math.clamp(yaw,-35,35),0)
end
local function cross(a)
	a.pose.RightShoulder=A(48,-16,-47)
	a.pose.LeftShoulder=A(48,16,47)
	a.pose.RightElbow=A(105,0,0)
	a.pose.LeftElbow=A(105,0,0)
end
local function crying(a,t)
	cross(a)
	a.pose.Neck=A(13,0,2)
	a.pose.Waist=A(5+math.sin(t*15)*1.4,0,math.sin(t*11)*0.7)
end
local function thinking(a,t)
	a.thinking=true
	a.pose.Neck=A(-13,math.sin(t)*3,15)
	a.pose.RightShoulder=A(54,-12,-18)
	a.pose.RightElbow=A(120,0,0)
end
local function pointing(a,pulse,soft)
	a.pose.RightShoulder=A((soft and 53 or 78)+pulse*7,-8,-8)
	a.pose.RightElbow=A(soft and 22 or 8,0,0)
	a.pose.Waist=A(soft and 2 or 7,0,0)
end

local function moveDog(d,t,bark,react)
	if not d then return end
	local pulse=0
	if bark then
		for _, time in ipairs({0.25,1.1}) do
			local q=(t-time)/0.15
			pulse+=math.exp(-q*q)
		end
	elseif react then
		pulse=math.sin(t*5)*0.15
	end

	local humanoid=d.object:FindFirstChildWhichIsA("Humanoid",true)
	local animator=humanoid and humanoid:FindFirstChildOfClass("Animator")
	if animator then
		for _, track in ipairs(animator:GetPlayingAnimationTracks()) do track:Stop(0) end
	end

	if #d.joints>0 then
		for _, j in ipairs(d.joints) do
			j.motor.Transform=CFrame.identity
			j.motor.C0=j.base*A(j.kind=="head" and -pulse*10 or pulse*9,0,0)
		end
	else
		local pivot=CFrame.new(d.bottom)
		local delta=pivot*A(-pulse*2,0,0)*pivot:Inverse()
		for part,original in pairs(d.original) do
			part.CFrame=delta*original
		end
	end
end

local time=0
local phase="ESPERA"
local startTime=0
local connection

local function resetActor(a)
	place(a,a.stage)
	for _, j in pairs(a.joints) do
		j.motor.C0=j.base
		j.motor.Transform=CFrame.identity
	end
	for _, leg in ipairs(a.legs) do leg.control.Enabled=false end
	a.lastFace=nil
	if a.thinkIK then a.thinkIK.Enabled=false end
end

local function runArms(a,cycle)
	local swing=math.sin((cycle or 0)*math.pi*2)
	a.pose.Waist=A(7+math.abs(swing),0,swing*0.8)
	a.pose.Neck=A(3,0,0)
	a.pose.RightShoulder=A(swing*32,0,-5)
	a.pose.LeftShoulder=A(-swing*32,0,5)
	a.pose.RightElbow=A(75,0,0)
	a.pose.LeftElbow=A(75,0,0)
end
local function update(t,dt,snap)
	local action=scene.Accion
	X.pose={}
	B.pose={}
	X.thinking=false
	B.thinking=false
	look(X,B.head.Position)
	look(B,X.head.Position)
	X.pose.Waist=A(math.sin(t*2)*0.35,0,0)
	B.pose.Waist=A(math.sin(t*2+0.5)*0.35,0,0)

	if action=="ACUSAR" then
		if t<scene.Entrada then
			local moving,cycle=runPose(t)
			if moving then runArms(X,cycle)
			else X.pose.Waist=A(3,0,0) end
			look(B,X.head.Position)
			B.pose.Neck=B.pose.Neck*A(-3,0,-5)
		else
			if run then runPose(scene.Entrada) end
			local q=t-scene.Entrada
			local pulse=0
			for _, at in ipairs({0.6,2}) do pulse+=math.exp(-((q-at)/0.25)^2) end
			local engage=math.clamp(q/0.35,0,1)
			pointing(X,pulse,false)
			X.pose.RightShoulder=CFrame.identity:Lerp(X.pose.RightShoulder,engage)
			B.pose.Waist=A(-6*engage,0,0)
			B.pose.Neck=A(-4,0,-5)
		end

	elseif action=="DEFENDER" then
		if t<0.85 then
			thinking(B,t)
		else
			local q=t-0.85
			if q<2.8 then face(B,"ENFADADA") else face(B,"PREOCUPADA") end
			local open=math.clamp(q/0.45,0,1)
			local close=math.clamp((q-2.5)/0.8,0,1)
			local spread=open*(1-close*0.45)
			B.pose.RightShoulder=A(12,0,-58*spread)
			B.pose.LeftShoulder=A(12,0,58*spread)
			B.pose.RightElbow=A(36,0,0)
			B.pose.LeftElbow=A(36,0,0)
			local shake=0
			if q>=0.3 and q<=2.2 then shake=math.sin((q-0.3)/1.9*math.pi*4)*15 end
			B.pose.Neck=A(-3,shake,-2)
			if q>2.2 then
				local explain=math.clamp((q-2.2)/0.4,0,1)
				B.pose.RightShoulder=A(12+explain*32,0,-58*spread+explain*36)
				B.pose.RightElbow=A(36+explain*65,0,0)
				B.pose.Waist=A(explain*3,0,0)
			end
		end
		X.pose.Waist=A(4,0,0)
		X.pose.Neck=A(2,-4,-5)
		X.pose.LeftShoulder=A(4,0,12)
		X.pose.LeftElbow=A(25,0,0)

	elseif action=="LLORAR" then
		crying(X,t)
		thinking(B,t)
		if t<0.55 then face(X,"ENFADADA") else face(X,"LLORANDO") end
		if t>2.5 then
			X.pose.RightShoulder=A(65,-10,-9)
			X.pose.RightElbow=A(122,0,0)
		end

	elseif action=="RECORDAR" then
		crying(X,t)
		thinking(B,t)
		B.pose.Waist=A(-2,0,0)

	elseif action=="TRAICION" then
		crying(X,t)
		X.pose.Neck=A(13,math.sin(t)*6,1)
		B.pose.Neck=A(5,-7,-5)
		if t>=2.1 and t<3.5 then
			X.pose.RightShoulder=A(67,-10,-10)
			X.pose.RightElbow=A(123,0,0)
		end

	elseif action=="FINAL_ROPA" then
		if t<2.2 then
			face(X,"ENFADADA")
			pointing(X,math.max(0,math.sin(t*4)),false)
			look(X,B.head.Position)
		else
			face(X,"LLORANDO")
			crying(X,t)
			if t>3.2 then
				X.pose.RightShoulder=A(67,-10,-10)
				X.pose.RightElbow=A(123,0,0)
			end
		end
		if t<1.2 then
			B.pose.Waist=A(-5,0,0)
			B.pose.Neck=A(-5,0,-7)
			face(B,"SORPRENDIDA")
		elseif t<2.9 then
			thinking(B,t)
			face(B,"PENSATIVA")
		else
			B.pose.Neck=A(5,0,-4)
			face(B,"PREOCUPADA")
		end

	elseif action=="LLAMAR" then
		look(B,DB.root.Position)
		pointing(B,math.max(0,math.sin(t*2))*0.15,true)
		B.pose.Waist=A(3,12,0)
		look(X,DB.root.Position)

	elseif action=="LADRAR" then
		look(X,DB.root.Position)
		look(B,DB.root.Position)
		B.pose.Neck=B.pose.Neck*A(8,0,0)

	elseif action=="FINAL" then
		if t<1.8 then
			look(X,(t<0.9 and DX or DB).root.Position)
		elseif t<3.2 then
			face(X,"ENFADADA")
			pointing(X,math.max(0,math.sin((t-1.8)*5)),false)
			look(X,DB.root.Position)
		elseif t<4.6 then
			face(X,"LLORANDO")
			crying(X,t)
			X.pose.RightShoulder=A(67,-10,-10)
			X.pose.RightElbow=A(123,0,0)
		else
			face(X,"LLORANDO")
			local moving,cycle=runPose(t-4.6)
			if moving then runArms(X,cycle) else crying(X,t) end
			look(B,X.root.Position)
		end
	end

	for _, a in ipairs({X,B}) do
		for _, track in ipairs(a.animator:GetPlayingAnimationTracks()) do
			warnOnce(track.Animation or track,"Pista identificada y detenida durante la toma: "..a.model.Name)
			track:Stop(0)
		end
		if a.thinkIK then a.thinkIK.Enabled=a.thinking==true end
		local alpha=snap and 1 or (1-math.exp(-dt*12))
		for name,j in pairs(a.joints) do
			j.motor.C0=j.motor.C0:Lerp(j.base*(a.pose[name] or CFrame.identity),alpha)
			-- PreAnimation: el IK de piernas puede resolver DESPUES de esta limpieza.
			j.motor.Transform=CFrame.identity
		end
	end
	moveDog(DX,t,false,action=="FINAL" and t>=4.6)
	moveDog(DB,t,action=="LADRAR",action=="FINAL" and t>=4.6)
end

F:SetAttribute("Frente",front)
F:SetAttribute("Centro",(X.stage.Position+B.stage.Position)/2)
F:SetAttribute("Separacion",(X.stage.Position-B.stage.Position).Magnitude)
F:SetAttribute("Fase","ESPERA")
F:SetAttribute("Escena",0)

local ready={}
remote.OnServerEvent:Connect(function(player,kind)
	if kind=="READY" then ready[player]=true end
end)
-- HR_SERVIDOR_LISTO_V3
F:SetAttribute("ServidorListo", true)
remote.OnServerEvent:Connect(function(player,kind,name)
	if kind=="TEXTURA_FALLIDA" and type(name)=="string" and C.Expresiones[name] then
		F:SetAttribute("TexturaFallida_"..name,true)
		for _,a in ipairs({X,B}) do
			if a.lastFace==name and a.face then a.face.Texture=a.originalTexture end
		end
	end
end)
say("Controlador preparado. Esperando a la camara del jugador.")


local function hasViewer()
	for player in pairs(ready) do
		if player.Parent==Players then return true end
	end
	return false
end
while not hasViewer() do task.wait(0.1) end

connection=RunService.PreAnimation:Connect(function(dt)
	if not scene or phase=="ERROR" then return end
	if phase=="TOMA" then
		time=math.min(workspace:GetServerTimeNow()-startTime,scene.Duracion)
	end
	local ok,err=pcall(update,time,dt,false)
	if not ok then
		phase="ERROR"
		F:SetAttribute("Fase","ERROR")
		warn("[HR] Error de movimiento: " .. tostring(err))
	end
end)

local function take(index)
	assert(phase~="ERROR","[HR] La coreografia se detuvo por un error.")
	scene=C.Escenas[index]
	time=0
	resetActor(X)
	resetActor(B)
	face(X,scene.X)
	face(B,scene.B)
	run=nil
	if scene.Accion=="FINAL" then run=planRun()
	elseif scene.Accion=="ACUSAR" then run=planArrival() end

	phase="PREPARACION"
	F:SetAttribute("Escena",index)
	F:SetAttribute("Fase",phase)
	update(0,0,true)

	if C.Modo=="PAUSAS" then
		for count=C.Preparacion,1,-1 do
			F:SetAttribute("Cuenta",count)
			task.wait(1)
		end
	end

	startTime=workspace:GetServerTimeNow()
	F:SetAttribute("Inicio",startTime)
	phase="TOMA"
	F:SetAttribute("Fase",phase)
	say("ESCENA " .. index .. " | " .. scene.Dialogo)

	while workspace:GetServerTimeNow()-startTime<scene.Duracion do
		assert(phase~="ERROR","[HR] Revisa el error anterior.")
		RunService.Heartbeat:Wait()
	end

	time=scene.Duracion
	update(time,0,true)
	phase="PAUSA"
	F:SetAttribute("Fase",phase)
	if C.Modo=="PAUSAS" then task.wait(C.Pausa) end
end

local ok,err=xpcall(function()
	if C.Modo=="ESCENA" then
		take(C.Escena)
	else
		for _,index in ipairs(selected) do take(index) end
	end
	F:SetAttribute("Fase","FIN")
	say("FIN. Encuadre conservado hasta Stop.")
end,debug.traceback)

if not ok then
	phase="ERROR"
	F:SetAttribute("Fase","ERROR")
	warn("[HR] " .. tostring(err))
end
