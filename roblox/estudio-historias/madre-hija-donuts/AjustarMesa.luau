-- Ajuste local de proporciones para ver el torso sobre la mesa, como en la referencia.
local M={}
function M.Preparar(decor)
 local mesa=decor:FindFirstChild("Mesa")
 local actors=decor:FindFirstChild("RepartoDonuts")
 local food=decor:FindFirstChild("Donuts")
 local floor=decor:FindFirstChild("Sala") and decor.Sala:FindFirstChild("Suelo")
 local board=mesa and mesa:FindFirstChild("Tablero")
 assert(actors and food and floor and board,"Faltan mesa, reparto, donuts o suelo.")
 local ground=floor.Position.Y+floor.Size.Y/2
 local waist=math.huge
 for _,role in ipairs({"Madre","Hija"}) do
  local model=actors:FindFirstChild(role)
  local hips=model and model:FindFirstChild("LowerTorso")
  assert(hips,"Falta LowerTorso de "..role)
  waist=math.min(waist,hips.Position.Y+hips.Size.Y/2)
 end
 local top=math.max(ground+1.1,waist+.05)
 local delta=top-(board.Position.Y+board.Size.Y/2)
 local height=top-board.Size.Y-ground
 assert(height>.2,"No se puede ajustar la altura de las patas.")
 local parts,donuts={},{}
 for _,p in ipairs(mesa:GetDescendants()) do
  if p:IsA("BasePart") then table.insert(parts,{part=p,cf=p.CFrame,size=p.Size}) end
 end
 for _,m in ipairs(food:GetChildren()) do
  if m:IsA("Model") then
   assert(m.PrimaryPart,"Falta el pivote de "..m.Name)
   table.insert(donuts,{model=m,cf=m:GetPivot(),initial=m:GetAttribute("HR_Inicial")})
  end
 end
 assert(#donuts>=6,"Faltan donuts de la historia anterior.")
 local plan={Delta=delta}
 function plan:Aplicar()
  for _,e in ipairs(parts) do
   local p=e.part
   if p.Name:match("^Pata_") then
    p.Size=Vector3.new(e.size.X,height,e.size.Z)
    p.CFrame=e.cf+Vector3.new(0,ground+height/2-e.cf.Position.Y,0)
   elseif p.Name:match("^Travesano_") then
    p.CFrame=e.cf+Vector3.new(0,ground+math.min(.65,height*.35)-e.cf.Position.Y,0)
   else p.CFrame=e.cf+Vector3.new(0,delta,0) end
  end
  for _,e in ipairs(donuts) do
   local cf=e.cf+Vector3.new(0,delta,0)
   e.model:PivotTo(cf);e.model:SetAttribute("HR_Inicial",cf)
  end
 end
 function plan:Revertir()
  for _,e in ipairs(parts) do e.part.Size=e.size;e.part.CFrame=e.cf end
  for _,e in ipairs(donuts) do e.model:PivotTo(e.cf);e.model:SetAttribute("HR_Inicial",e.initial) end
 end
 return plan
end
return M
