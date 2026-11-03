-- Ejecutar mediante el comando de activacion con el juego detenido.
-- Usa los Motor6D de las referencias existentes y ropa/pelo reales del catalogo.
return function()
 assert(not game:GetService("RunService"):IsRunning(),"Primero pulsa Stop.")
 local Players=game:GetService("Players")
 local Catalog=game:GetService("AvatarEditorService")
 local Content=game:GetService("ContentProvider")
 local storage=game:GetService("ServerStorage")
 local expected={
  Waist={"LowerTorso","UpperTorso"},Neck={"UpperTorso","Head"},
  RightShoulder={"UpperTorso","RightUpperArm"},LeftShoulder={"UpperTorso","LeftUpperArm"},
  RightElbow={"RightUpperArm","RightLowerArm"},LeftElbow={"LeftUpperArm","LeftLowerArm"},
  RightWrist={"RightLowerArm","RightHand"},LeftWrist={"LeftLowerArm","LeftHand"},
  RightHip={"LowerTorso","RightUpperLeg"},LeftHip={"LowerTorso","LeftUpperLeg"},
  RightKnee={"RightUpperLeg","RightLowerLeg"},LeftKnee={"LeftUpperLeg","LeftLowerLeg"},
  RightAnkle={"RightLowerLeg","RightFoot"},LeftAnkle={"LeftLowerLeg","LeftFoot"},
 }
 local function validate(model)
  local humanoid=model:FindFirstChildOfClass("Humanoid")
  assert(humanoid and humanoid.RigType==Enum.HumanoidRigType.R15,"Referencia no R15: "..model.Name)
  local motors={}
  for _,item in ipairs(model:GetDescendants()) do
   if item:IsA("Motor6D") then
    local key=item.Name:gsub("%s+","")
    assert(not motors[key],"Motor duplicado: "..key)
    motors[key]=item
   elseif item:IsA("AnimationConstraint") then
    error("La referencia "..model.Name.." tiene AnimationConstraint. Necesitamos las chicas originales con Motor6D.")
   end
  end
  for name,ends in pairs(expected) do
   local m=motors[name]
   assert(m and m.Part0 and m.Part1 and m.Part0.Name==ends[1] and m.Part1.Name==ends[2],"Motor incompatible: "..model.Name.."."..name)
  end
  return humanoid
 end
 local girlX=workspace:FindFirstChild("chicaX")
 local girlB=workspace:FindFirstChild("chicaB")
 assert(girlX and girlB,"Con Stop deben estar las chicas originales en Workspace.")
 validate(girlX);validate(girlB)
 local previous=storage:FindFirstChild("HR_AvataresRopa")
 assert(not previous or previous:GetAttribute("HR_Avatares")=="ROPA_CHICOS_1","El contenedor anterior no es nuestro.")
 local function canonical(uri)
  assert(type(uri)=="string" and uri~="","Textura vacia")
  local id=uri:match("^rbxassetid://(%d+)$")
   or uri:match("^https?://www%.roblox%.com/asset/%??id=(%d+)")
   or uri:match("^https?://www%.roblox%.com/asset%?id=(%d+)")
  return id and "rbxassetid://"..id or uri
 end
 local function preload(uri)
  local success=false
  local ok,err=pcall(function()
   Content:PreloadAsync({uri},function(_,status)
    if status==Enum.AssetFetchStatus.Success then success=true end
   end)
  end)
  assert(ok and success,"No se pudo cargar "..uri..(ok and "" or " ("..tostring(err)..")"))
 end
 local function firstLoadable(candidates,loader,label)
  local failures={}
  for _,candidate in ipairs(candidates) do
   local ok,result=pcall(loader,candidate)
   if ok and result then return result,candidate end
   local reason=tostring(result)
   warn("[HR SKINS] Se descarta "..label.." "..candidate.id..": "..reason)
   table.insert(failures,tostring(candidate.id)..": "..reason)
  end
  error("No hay "..label.." cargable entre los candidatos. "..table.concat(failures,"; "))
 end
 local function search(assetType,keywords)
  local failures={}
  local found={}
  local seen={}
  for _,keyword in ipairs(keywords) do
   print("[HR SKINS] Buscando en catalogo: "..keyword)
   local params=CatalogSearchParams.new()
   params.SearchKeyword=keyword
   params.AssetTypes={assetType}
   params.SortType=Enum.CatalogSortType.Relevance
   params.IncludeOffSale=false
   params.Limit=10
   local ok,pages=pcall(function() return Catalog:SearchCatalogAsync(params) end)
   if ok then
    local count=0
    for _,row in ipairs(pages:GetCurrentPage()) do
     local id=tonumber(row.Id)
     if id and id>0 and row.ItemType=="Asset" and not seen[id] then
      seen[id]=true
      table.insert(found,{id=id,name=tostring(row.Name)})
      count+=1
      if count>=3 then break end
     end
    end
   else table.insert(failures,keyword..": "..tostring(pages)) end
  end
  assert(#found>0,"Sin candidatos de "..assetType.Name..". "..table.concat(failures,"; "))
  return found
 end
 local function garment(candidates,class,property)
  local result,candidate=firstLoadable(candidates,function(item)
   local description=Instance.new("HumanoidDescription")
   description[class]=item.id
   local temp
   local copy
   local ok,err=pcall(function()
    temp=Players:CreateHumanoidModelFromDescriptionAsync(description,Enum.HumanoidRigType.R15)
    local instance=temp:FindFirstChildOfClass(class)
    assert(instance and instance[property]~="","Roblox no devolvio la prenda")
    local uri=canonical(instance[property])
    preload(uri)
    copy=instance:Clone()
    copy[property]=uri
   end)
   description:Destroy()
   if temp then temp:Destroy() end
   if not ok then if copy then copy:Destroy() end;error(err) end
   return copy
  end,class)
  print("[HR SKINS] "..class.." verificada: "..candidate.name.." ("..candidate.id..")")
  return {id=candidate.id,name=candidate.name,instance=result}
 end
 local selected={
  shirt=garment(search(Enum.AvatarAssetType.Shirt,{"blue purple anime hoodie","rainbow hoodie"}),"Shirt","ShirtTemplate"),
  pants=garment(search(Enum.AvatarAssetType.Pants,{"blue purple streetwear pants","black blue anime pants"}),"Pants","PantsTemplate"),
 }
 local function hair(candidates)
  local result,candidate=firstLoadable(candidates,function(item)
   local description=Instance.new("HumanoidDescription")
   description.HairAccessory=tostring(item.id)
   local temp
   local copies={}
   local ok,err=pcall(function()
    temp=Players:CreateHumanoidModelFromDescriptionAsync(description,Enum.HumanoidRigType.R15)
    for _,accessory in ipairs(temp:GetChildren()) do
     if accessory:IsA("Accessory") then
      local loaded=true
      Content:PreloadAsync({accessory},function(_,status)
       if status~=Enum.AssetFetchStatus.Success then loaded=false end
      end)
      assert(loaded,"No se pudo precargar el accesorio de pelo")
      table.insert(copies,accessory:Clone())
     end
    end
    assert(#copies>0,"Roblox no devolvio el pelo")
   end)
   description:Destroy()
   if temp then temp:Destroy() end
   if not ok then for _,copy in ipairs(copies) do copy:Destroy() end;error(err) end
   return copies
  end,"pelo")
  print("[HR SKINS] Pelo verificado: "..candidate.name.." ("..candidate.id..")")
  return {id=candidate.id,name=candidate.name,instances=result}
 end
 selected.hairX=hair(search(Enum.AvatarAssetType.HairAccessory,{"blue messy anime hair","blue boy hair"}))
 selected.hairB=hair(search(Enum.AvatarAssetType.HairAccessory,{"purple anime boy hair","red anime boy hair"}))
 local staging=Instance.new("Folder")
 staging.Name="HR_AvataresRopa"
 staging:SetAttribute("HR_Avatares","ROPA_CHICOS_1")
 staging:SetAttribute("HR_Rig","Motor6D original")
 staging:SetAttribute("HR_RopaReal",true)
 staging:SetAttribute("HR_CatalogRevision",2)
 local function build(reference,name,hair)
  local shirt=selected.shirt.instance
  local pants=selected.pants.instance
  local accessories=hair.instances
  local clone=reference:Clone()
  clone.Name=name
  clone.Parent=staging
  local humanoid=validate(clone)
  humanoid.AutomaticScalingEnabled=false
  for _,item in ipairs(clone:GetChildren()) do
   if item:IsA("Accessory") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") then
    item:Destroy() -- Solo elementos de la copia nueva, nunca de la chica original.
   end
  end
  for _,item in ipairs(clone:GetDescendants()) do
   if item:IsA("BaseScript") then
    print("[HR SKINS] Script heredado desactivado SOLO en copia: "..item:GetFullName())
    item.Enabled=false
   end
  end
  shirt:Clone().Parent=clone
  pants:Clone().Parent=clone
  for _,accessory in ipairs(accessories) do
   local copy=accessory:Clone()
   for _,joint in ipairs(copy:GetDescendants()) do
    if joint:IsA("JointInstance") or joint:IsA("WeldConstraint") then
     local external=(joint.Part0 and not joint.Part0:IsDescendantOf(copy))
      or (joint.Part1 and not joint.Part1:IsDescendantOf(copy))
     if joint.Name=="AccessoryWeld" or external then joint:Destroy() end
    elseif joint:IsA("BaseScript") then joint.Enabled=false end
   end
   humanoid:AddAccessory(copy)
   local handle=copy:FindFirstChild("Handle")
   assert(handle and handle:FindFirstChild("AccessoryWeld"),"No se pudo unir el pelo al Head de "..name)
  end
  clone:SetAttribute("HR_CatalogShirt",selected.shirt.id)
  clone:SetAttribute("HR_CatalogPants",selected.pants.id)
  clone:SetAttribute("HR_CatalogHair",hair.id)
  clone:SetAttribute("HR_CatalogShirtName",selected.shirt.name)
  clone:SetAttribute("HR_CatalogHairName",hair.name)
  validate(clone)
  print("[HR SKINS] "..name..": ropa real cargada y Motor6D comprobados.")
 end
 local ok,err=pcall(function()
  build(girlX,"chicoX",selected.hairX)
  build(girlB,"chicoB",selected.hairB)
 end)
 selected.shirt.instance:Destroy()
 selected.pants.instance:Destroy()
 for _,item in ipairs({selected.hairX,selected.hairB}) do
  for _,accessory in ipairs(item.instances) do accessory:Destroy() end
 end
 if not ok then staging:Destroy();error("[HR SKINS] No se sustituyen las bases anteriores. "..tostring(err)) end
 if previous then previous.Name="HR_BasesAnteriores_"..tostring(os.time()) end
 staging.Parent=storage
 print("[HR SKINS V2] INSTALADO: ropa verificada y Motor6D conservados.")
 print("[HR SKINS] Guarda y pulsa F5. La camara y el guion no se han cambiado.")
end
