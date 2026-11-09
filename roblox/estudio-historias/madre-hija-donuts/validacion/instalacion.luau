local print=function() end
local methods={};local mt={}
local function detach(item)
 local p=item.data.Parent
 if p then for i,x in ipairs(p.children) do if x==item then table.remove(p.children,i);break end end end
end
mt.__index=function(a,k)
 if methods[k] then return methods[k] end
 if a.data[k]~=nil then return a.data[k] end
 if k=="Position" and (a.ClassName=="Part" or a.ClassName=="MeshPart") then return a.data.CFrame.Position end
 for _,x in ipairs(a.children) do if x.Name==k then return x end end
end
mt.__newindex=function(a,k,v)
 if a.data.rejectOnce and a.data.rejectProperty==k then a.data.rejectOnce=false;error("injected visual property write failure") end
 if k=="Parent" then detach(a);a.data.Parent=v;if v then table.insert(v.children,a) end else a.data[k]=v end
end
Instance={new=function(class)
 return setmetatable({data={Name=class,ClassName=class,Source="",Enabled=true,CFrame=CFrame.identity,Size=Vector3.new(1,1,1),Color=Color3 and Color3.fromRGB(163,163,163),Reflectance=0},children={},attrs={}},mt)
end}
function methods:IsA(class)
 return self.ClassName==class or class=="BaseScript" and (self.ClassName=="Script" or self.ClassName=="LocalScript") or class=="BasePart" and (self.ClassName=="Part" or self.ClassName=="MeshPart") or class=="Light" and (self.ClassName=="PointLight" or self.ClassName=="SurfaceLight") or class=="PostEffect" and (self.ClassName=="BloomEffect" or self.ClassName=="ColorCorrectionEffect")
end
function methods:FindFirstChild(name) for _,x in ipairs(self.children) do if x.Name==name then return x end end end
function methods:FindFirstChildOfClass(name) for _,x in ipairs(self.children) do if x:IsA(name) then return x end end end
function methods:GetChildren() return table.clone(self.children) end
function methods:GetDescendants()
 local r={}
 for _,x in ipairs(self.children) do table.insert(r,x);for _,y in ipairs(x:GetDescendants()) do table.insert(r,y) end end
 return r
end
function methods:SetAttribute(k,v) self.attrs[k]=v end
function methods:GetAttribute(k) return self.attrs[k] end
function methods:IsDescendantOf(parent) local p=self.Parent;while p do if p==parent then return true end;p=p.Parent end;return false end
function methods:Destroy() while #self.children>0 do self.children[1]:Destroy() end;self.Parent=nil end
function methods:GetPivot() return self.PrimaryPart and self.PrimaryPart.CFrame or self.data.pivot or CFrame.identity end
function methods:PivotTo(cf)
 local d=cf*self:GetPivot():Inverse()
 for _,x in ipairs(self:GetDescendants()) do if x:IsA("BasePart") then x.CFrame=d*x.CFrame end end
 self.data.pivot=cf
end
function methods:Clone()
 local map={}
 local function copy(node)
  local c=Instance.new(node.ClassName);map[node]=c
  for k,v in pairs(node.data) do if k~="Parent" then c.data[k]=v end end
  c.attrs=table.clone(node.attrs)
  for _,child in ipairs(node.children) do copy(child).Parent=c end
  return c
 end
 local out=copy(self)
 for _,c in pairs(map) do for k,v in pairs(c.data) do if map[v] then c.data[k]=map[v] end end end
 return out
end
local function make(class,name,parent,owner)
 local o=Instance.new(class);o.Name=name;o.Parent=parent;if owner then o:SetAttribute("HR_Owner",owner) end;return o
end
Color3={fromRGB=function(...) return {...} end}
Enum={HumanoidRigType={R15=1},HumanoidDisplayDistanceType={None=0},ModelStreamingMode={Persistent=1},SurfaceType={Smooth=1},Material={SmoothPlastic=1},PartType={Ball=1}}
local realTypeof=typeof
typeof=function(v) if type(v)=="table" and getmetatable(v)==getmetatable(CFrame.identity) then return "CFrame" end;return realTypeof(v) end
local oldFace=__ORIGINAL_FACE_SOURCE__
local OWNER="HR_PRUEBA_REPARTO_1"
local function setup(failAt)
 workspace=make("Model","Workspace")
 local svc={RunService={IsRunning=function() return false end},Selection={Set=function() end}}
 for _,name in ipairs({"ServerStorage","ReplicatedStorage","ServerScriptService","StarterPlayer","Lighting"}) do svc[name]=make("Folder",name) end
 local lighting=svc.Lighting
 lighting.Brightness=3;lighting.ExposureCompensation=1;lighting.ClockTime=14.5
 lighting.Ambient=Color3.fromRGB(70,70,70);lighting.OutdoorAmbient=lighting.Ambient
 lighting.EnvironmentDiffuseScale=1;lighting.EnvironmentSpecularScale=1;lighting.GlobalShadows=true
 lighting.ColorShift_Top=Color3.fromRGB(20,15,20);lighting.ColorShift_Bottom=lighting.ColorShift_Top
 lighting.FogStart=0;lighting.FogEnd=100000
 make("BloomEffect","Bloom",lighting).Enabled=true
 local atmosphere=make("Atmosphere","Atmosphere",lighting);atmosphere.Density=.3;atmosphere.Haze=1;atmosphere.Glare=.7
 local sps=make("Folder","StarterPlayerScripts",svc.StarterPlayer)
 local root=make("Folder","HR_PruebaReparto",svc.ReplicatedStorage,OWNER)
 make("ModuleScript","Interpretacion",root).Source="preserve poses"
 make("RemoteEvent","Canal",root)
 local config=make("ModuleScript","Configuracion",root,OWNER);config.Source="old configuration"
 local server=make("Script","HR_PruebaRepartoServidor",svc.ServerScriptService,OWNER);server.Source="old server"
 local camera=make("LocalScript","HR_PruebaRepartoCamara",sps,OWNER);camera.Source="old camera"
 local faces=make("LocalScript","HR_CarasMarcos",sps,OWNER);faces.Source=oldFace
 local cine=make("Script","HR_CineServidor",svc.ServerScriptService,"HR_Cine_V2");cine.Enabled=false
 local cineCam=make("LocalScript","HR_CineCamara",sps,"HR_Cine_V2");cineCam.Enabled=false
 local cast=make("Folder","HR_EstudioReparto",svc.ServerStorage,"HR_ESTUDIO_REPARTO_1")
 local templates=make("Folder","Personajes",cast)
 local roles=make("Folder","Reparto",cast)
 for _,role in ipairs({"Madre","Hija"}) do
  local m=make("Model",role,templates)
  local h=make("Humanoid","Humanoid",m);h.RigType=1
  for _,n in ipairs({"HumanoidRootPart","Head","LeftFoot","RightHand","LeftHand","LowerTorso","UpperTorso","RightUpperArm","RightLowerArm","LeftUpperArm","LeftLowerArm"}) do
   local p=make("Part",n,m);p.CFrame=CFrame.new(0,n=="LeftFoot" and .5 or 3,0)
  end
  for _,j in ipairs({{"Root","HumanoidRootPart","LowerTorso"},{"Waist","LowerTorso","UpperTorso"},{"Neck","UpperTorso","Head"},{"RightShoulder","UpperTorso","RightUpperArm"},{"RightElbow","RightUpperArm","RightLowerArm"},{"RightWrist","RightLowerArm","RightHand"},{"LeftShoulder","UpperTorso","LeftUpperArm"},{"LeftElbow","LeftUpperArm","LeftLowerArm"},{"LeftWrist","LeftLowerArm","LeftHand"}}) do
   local motor=make("Motor6D",j[1],m[j[3]]);motor.Part0=m[j[2]];motor.Part1=m[j[3]]
  end
  local link=make("ObjectValue",role,roles);link.Value=m
 end
 local decor=make("Model","HR_RetoDonuts",workspace,"HR_DONUTS_DECORADO_1")
 decor:SetAttribute("HR_SueloLuzAjustados",true);decor:SetAttribute("HR_Origen",CFrame.new(65,2,0))
 local room=make("Model","Sala",decor);local floor=make("Part","Suelo",room);floor.Position=Vector3.new(65,1.85,0);floor.Size=Vector3.new(28,.3,24)
 local ceiling=make("Part","Techo",room)
 local overhead=make("SurfaceLight","HR_LuzTecho",ceiling);overhead.Brightness=2.2
 local fill=make("Part","HR_RellenoFrontal",room);local frontLight=make("PointLight","HR_LuzFrontal",fill);frontLight.Brightness=1.4
 local mesa=make("Model","Mesa",decor);local board=make("Part","Tablero",mesa);board.Size=Vector3.new(14,.45,7);board.CFrame=CFrame.new(65,5,0)
 make("Folder","Marcas",decor)
 local calls=0
 svc.ScriptEditorService={GetEditorSource=function(_,o) return o.Source end,UpdateSourceAsync=function(_,o,callback)
  calls+=1;if calls==failAt then error("injected write failure") end;o.Source=callback(o.Source)
 end}
 game={GetService=function(_,name) assert(svc[name],name);return svc[name] end}
 return {svc=svc,sps=sps,root=root,decor=decor,server=server,camera=camera,faces=faces,config=config}
end
local function install()
__INSTALLER__
end
local function restore()
__RESTORE__
end
local function patch()
__PATCH__
end
do
 local f=setup();install()
 assert(f.decor.Donuts and #f.decor.Donuts.children==6 and f.decor.RepartoDonuts)
 assert(f.server.Enabled and f.camera.Enabled and f.faces.Enabled)
 assert(f.root.Interpretacion.Source=="preserve poses")
 local backup=f.svc.ServerStorage.HR_DonutsAntesHistoria
 assert(backup.Caras.Value==oldFace)
 assert(not f.faces.Source:find('"Novio"'))
 for _,donut in ipairs(f.decor.Donuts.children) do
  assert(donut.PrimaryPart and #donut.children==61)
  local cf=donut:GetPivot();local q=f.decor.Mesa.Tablero.CFrame:PointToObjectSpace(cf.Position)
  assert(math.abs(q.X)<6.1 and math.abs(q.Z)<3.1 and q.Y>.4)
  for _,part in ipairs(donut.children) do assert(part:IsA("BasePart") and part.Anchored and not part.CanCollide) end
 end
 local food=f.decor.Donuts;local actors=f.decor.RepartoDonuts;local backupFace=backup.Caras.Value
 install();assert(f.decor.Donuts==food and f.decor.RepartoDonuts==actors and backup.Caras.Value==backupFace)
 restore();assert(f.config.Source=="old configuration" and f.server.Source=="old server" and f.camera.Source=="old camera" and f.faces.Source==oldFace)
 install();assert(f.decor.Donuts==food and f.server.Enabled)
end
for n=1,6 do
 local f=setup(n)
 assert(not pcall(install))
 assert(f.config.Source=="old configuration" and f.server.Source=="old server" and f.camera.Source=="old camera" and f.faces.Source==oldFace)
 assert(f.server.Enabled and f.camera.Enabled and f.faces.Enabled)
 assert(not f.root.Donuts and not f.root.BrazoDonut)
 assert(not f.decor.Donuts and not f.decor.RepartoDonuts and not f.svc.ServerStorage.HR_DonutsAntesHistoria)
end
for n=1,6 do
 local f=setup(6+n);install()
 local before={f.config.Source,f.server.Source,f.camera.Source,f.faces.Source}
 local food=f.decor.Donuts;local actors=f.decor.RepartoDonuts
 assert(not pcall(install))
 assert(f.config.Source==before[1] and f.server.Source==before[2] and f.camera.Source==before[3] and f.faces.Source==before[4])
 assert(f.server.Enabled and f.camera.Enabled and f.faces.Enabled and f.decor.Donuts==food and f.decor.RepartoDonuts==actors)
end
for n=1,4 do
 local f=setup(6+n);install()
 local before={f.config.Source,f.server.Source,f.camera.Source,f.faces.Source}
 assert(not pcall(restore))
 assert(f.config.Source==before[1] and f.server.Source==before[2] and f.camera.Source==before[3] and f.faces.Source==before[4])
 assert(f.server.Enabled and f.camera.Enabled and f.faces.Enabled)
end
do
 local f=setup();f.faces.Source="unrecognized facial controller";assert(not pcall(install));assert(not f.decor.Donuts)
end
do
 local f=setup();install()
 for i=7,18 do local m=f.decor.Donuts.Donut_06:Clone();m.Name=string.format("Donut_%02d",i);m.Parent=f.decor.Donuts end
 assert(#f.decor.Donuts.children==18)
 local face=f.faces.Source;local poses=f.root.Interpretacion.Source
 patch()
 assert(#f.decor.Donuts.children==6)
 local archive=f.svc.ServerStorage.HR_DonutsAntesSusurro
 assert(archive and #archive.DonutsAnteriores.children==18)
 assert(f.faces.Source==face and f.root.Interpretacion.Source==poses)
 assert(f.decor.Donuts.Donut_05:GetAttribute("HR_Picante") and not f.decor.Donuts.Donut_06:GetAttribute("HR_Picante"))
 assert(not f.svc.Lighting.Bloom.Enabled and f.svc.Lighting.ExposureCompensation<0)
 assert(not f.decor.Sala.Techo.HR_LuzTecho.Enabled and not f.decor.Sala.HR_RellenoFrontal.HR_LuzFrontal.Enabled)
 assert(f.svc.Lighting.Atmosphere.Density==0)
 local appearance=f.svc.ServerStorage.HR_DonutsAspectoOriginal
 assert(appearance and appearance:GetAttribute("HR_Owner")=="HR_DONUTS_ASPECTO_4")
 local saved=archive.DonutsAnteriores;local height=f.decor.Mesa.Tablero.Position.Y
 patch()
 assert(f.svc.ServerStorage.HR_DonutsAntesSusurro.DonutsAnteriores==saved)
 assert(f.svc.ServerStorage.HR_DonutsAspectoOriginal==appearance)
 assert(#f.decor.Donuts.children==6 and math.abs(f.decor.Mesa.Tablero.Position.Y-height)<.00001)
end
for n=1,5 do
 local f=setup(6+n);install()
 local before={f.config.Source,f.root.Donuts.Source,f.root.BrazoDonut.Source,f.server.Source,f.camera.Source}
 local food=f.decor.Donuts;local height=f.decor.Mesa.Tablero.Position.Y;local face=f.faces.Source
 assert(not pcall(patch))
 assert(f.config.Source==before[1] and f.root.Donuts.Source==before[2] and f.root.BrazoDonut.Source==before[3] and f.server.Source==before[4] and f.camera.Source==before[5])
 assert(f.server.Enabled and f.camera.Enabled and f.decor.Donuts==food and #food.children==6)
 assert(f.faces.Source==face and math.abs(f.decor.Mesa.Tablero.Position.Y-height)<.00001)
 assert(not f.svc.ServerStorage.HR_DonutsAntesSusurro and not f.svc.ServerStorage.HR_DonutsAspectoOriginal)
 assert(f.svc.Lighting.ExposureCompensation==1 and f.svc.Lighting.Bloom.Enabled)
end
do
 local f=setup();install()
 local food=f.decor.Donuts;local face=f.faces.Source;local source=f.server.Source
 f.svc.Lighting.rejectProperty="ExposureCompensation";f.svc.Lighting.rejectOnce=true
 assert(not pcall(patch))
 assert(f.server.Source==source and f.faces.Source==face and f.decor.Donuts==food)
 assert(f.svc.Lighting.Brightness==3 and f.svc.Lighting.ExposureCompensation==1 and f.svc.Lighting.Bloom.Enabled)
 assert(f.decor.Sala.Techo.HR_LuzTecho.Enabled)
 assert(not f.svc.ServerStorage.HR_DonutsAspectoOriginal and not f.svc.ServerStorage.HR_DonutsAntesSusurro)
end
return "PASS: 6 donuts, spicy fifth, face source preserved, repeat/restore; exposure reduced, bloom and both local lights disabled with first-state backup; all 21 source-write failures plus a partial lighting-write failure rolled back."
