local P={}
function P.Verificar(model)
 assert(model and model:IsA("Model"),"Falta un modelo del reparto.")
 local h=model:FindFirstChildOfClass("Humanoid")
 assert(h and h.RigType==Enum.HumanoidRigType.R15,"Se necesita el rig R15 que ya funcionaba: "..model.Name)
 assert(model:FindFirstChild("HumanoidRootPart") and model:FindFirstChild("Head") and model:FindFirstChild("LeftFoot") and model:FindFirstChild("RightHand") and model:FindFirstChild("LeftHand"),"Rig incompleto: "..model.Name)
 local joints={}
 for _,item in ipairs(model:GetDescendants()) do
  assert(not item:IsA("AnimationConstraint"),"Rig incompatible: "..model.Name)
  if item:IsA("Motor6D") then
   local key=item.Name:gsub("%s+","")
   assert(not joints[key],"Articulacion duplicada: "..key)
   assert(item.Part0 and item.Part1,"Articulacion desconectada: "..key)
   joints[key]=item
  end
 end
 for _,key in ipairs({"Root","Waist","Neck","RightShoulder","RightElbow","RightWrist","LeftShoulder","LeftElbow","LeftWrist"}) do
  assert(joints[key],"Falta "..key.." en "..model.Name)
 end
 local s,e,w=joints.RightShoulder,joints.RightElbow,joints.RightWrist
 assert(s.Part1==e.Part0 and e.Part1==w.Part0 and w.Part1==model.RightHand,"Cadena del brazo incompatible.")
end
function P.Crear(parent,roles,decor,C)
 local origin=decor:GetAttribute("HR_Origen")
 assert(typeof(origin)=="CFrame","Falta HR_Origen en la sala.")
 local floor=decor.Sala.Suelo
 local ground=floor.Position.Y+floor.Size.Y/2
 local preview=Instance.new("Model");preview.Name="RepartoDonuts";preview:SetAttribute("HR_Owner","HR_DONUTS_HISTORIA_1")
 preview.Parent=parent
 for _,role in ipairs({"Madre","Hija"}) do
  local m=roles[role].Value:Clone();m.Name=role;m.Parent=preview
  P.Verificar(m)
  local root=m.HumanoidRootPart;local foot=m.LeftFoot
  local rootHeight=root.Position.Y-(foot.Position.Y-foot.Size.Y/2)
  for _,item in ipairs(m:GetDescendants()) do
   if item:IsA("BaseScript") then item.Enabled=false end
   if item:IsA("BillboardGui") then item.Enabled=false end
   if item:IsA("BasePart") then item.Anchored=item==root;item.CanCollide=false end
  end
  m.PrimaryPart=root;m.ModelStreamingMode=Enum.ModelStreamingMode.Persistent
  local h=m:FindFirstChildOfClass("Humanoid")
  h.AutomaticScalingEnabled=false;h.AutoRotate=false;h.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None
  local localPosition=C.Posiciones[role]
  local p=origin:PointToWorldSpace(localPosition);p=Vector3.new(p.X,ground+rootHeight,p.Z)
  m:PivotTo(CFrame.lookAt(p,p+origin.ZVector))
 end
 return preview
end
return P
