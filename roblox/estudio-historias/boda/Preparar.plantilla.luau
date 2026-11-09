-- PASO 1. Ejecutar en una copia del proyecto, con Stop.
assert(not game:GetService("RunService"):IsRunning(),"Primero pulsa Stop. Este comando se ejecuta fuera de Play.")
local Storage=game:GetService("ServerStorage")
local owner="HR_BODA_1"
local exists=workspace:FindFirstChild("HR_Boda") or Storage:FindFirstChild("HR_Boda")
if exists then
 assert(exists:GetAttribute("HR_Owner")==owner,"Ya existe otro objeto HR_Boda. Se conserva.")
 exists.Parent=workspace;game:GetService("Selection"):Set({exists.Ceremonia.ArcoFloral,exists.Reparto.Madre,exists.Reparto.Hija,exists.Reparto.Novio})
 print("[HR BODA] El decorado ya existe; no se han creado copias. Pulsa F con el raton sobre la vista 3D.")
 return
end
local cast=Storage:FindFirstChild("HR_EstudioReparto")
assert(cast and cast:GetAttribute("HR_Owner")=="HR_ESTUDIO_REPARTO_1" and cast:FindFirstChild("Reparto"),"Abre una copia del proyecto que ya tiene madre, hija y novio. Faltan las plantillas compatibles.")
local C=(function()
__CONFIG_CODE__
end)()
local P=(function()
__PREVIEW_CODE__
end)()
local V=(function()
__CLOTHES_CODE__
end)()
local E=(function()
__SCENE_CODE__
end)()
for _,role in ipairs({"Madre","Hija","Novio"}) do
 local link=cast.Reparto:FindFirstChild(role)
 assert(link and link:IsA("ObjectValue") and link.Value and link.Value:IsDescendantOf(cast),"Falta la plantilla: "..role)
 P.Verificar(link.Value)
end
local gallery=workspace:FindFirstChild("HR_RevisionReparto")
local oldStage=workspace:FindFirstChild("HR_RetoDonuts")
local center=oldStage and oldStage:GetAttribute("HR_Origen")
if typeof(center)~="CFrame" then center=gallery and gallery:GetPivot() or CFrame.new(0,0,0) end
local point=center.Position+center.XVector*115
local exclude={}
for _,m in ipairs(workspace:GetChildren()) do if m:IsA("Model") and (m:FindFirstChildOfClass("Humanoid") or m==gallery or m==oldStage) then table.insert(exclude,m) end end
local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances=exclude
local hit=workspace:Raycast(Vector3.new(point.X,point.Y+300,point.Z),Vector3.new(0,-1000,0),params)
local y=hit and hit.Position.Y+.03 or center.Position.Y
local front=Vector3.new(center.ZVector.X,0,center.ZVector.Z).Unit
local origin=CFrame.lookAt(Vector3.new(point.X,y,point.Z),Vector3.new(point.X,y,point.Z)-front)
local lighting=game:GetService("Lighting")
local settings={Brightness=1.4,ExposureCompensation=-.20,ClockTime=14,Ambient=Color3.fromRGB(100,105,112),OutdoorAmbient=Color3.fromRGB(105,109,116),EnvironmentDiffuseScale=.35,EnvironmentSpecularScale=.15,GlobalShadows=true,ColorShift_Top=Color3.new(0,0,0),ColorShift_Bottom=Color3.new(0,0,0),FogStart=0,FogEnd=100000}
local edits={}
local function edit(object,values)
 local before={};for k in pairs(values) do before[k]=object[k] end
 table.insert(edits,{object=object,before=before,after=values})
end
edit(lighting,settings)
for _,d in ipairs(lighting:GetChildren()) do
 if d:IsA("PostEffect") then edit(d,{Enabled=false})
 elseif d:IsA("Atmosphere") then edit(d,{Density=0,Haze=0,Glare=0}) end
end
local staging=Instance.new("Folder");local root
local ok,err=pcall(function()
 root=E.Crear(staging,origin,cast.Reparto,C,P,V)
 local backup=Instance.new("Folder");backup.Name="AspectoAnterior";backup.Parent=root
 for i,e in ipairs(edits) do
  local ref=Instance.new("ObjectValue");ref.Name="Ajuste_"..i;ref.Value=e.object
  for k,v in pairs(e.before) do ref:SetAttribute(k,v) end
  ref.Parent=backup
 end
 for _,e in ipairs(edits) do for k,v in pairs(e.after) do e.object[k]=v end end
 root.Parent=workspace
end)
if not ok then
 for _,e in ipairs(edits) do for k,v in pairs(e.before) do pcall(function() e.object[k]=v end) end end
 staging:Destroy();if root then root:Destroy() end
 error("[HR BODA] Preparacion detenida y cambios revertidos: "..tostring(err))
end
staging:Destroy();game:GetService("Selection"):Set({root.Ceremonia.ArcoFloral,root.Reparto.Madre,root.Reparto.Hija,root.Reparto.Novio})
print("[HR BODA] DECORADO LISTO: arco floral, pasillo, 12 asientos y dormitorio para el giro final.")
print("[HR BODA] Cuatro actores con vestuario de celebracion; las plantillas originales no se han cambiado.")
print("[HR BODA] Pulsa F con el raton en la vista 3D y guarda con Ctrl+S. El paso 2 activa la historia.")
