-- Geometria nativa sin assets ni scripts en los alimentos.
local D={Owner="HR_DONUTS_HISTORIA_1",Segmentos=24}
function D.Crear(nombre,parent,cf,seed)
 local m=Instance.new("Model");m.Name=nombre;m:SetAttribute("HR_Owner",D.Owner)
 local pivot=Instance.new("Part");pivot.Name="Centro";pivot.Size=Vector3.new(0.05,0.05,0.05)
 pivot.Transparency=1;pivot.Anchored=true;pivot.CanCollide=false;pivot.CanTouch=false;pivot.CanQuery=false;pivot.CastShadow=false;pivot.Parent=m
 m.PrimaryPart=pivot
 local function piece(name,size,at,color,angle)
  local p=Instance.new("Part");p.Name=name;p.Size=size;p.CFrame=at;p.Color=color;p.Material=Enum.Material.SmoothPlastic
  p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.CastShadow=false
  p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth
  if angle then p:SetAttribute("HR_Angulo",angle) end
  p.Parent=m;return p
 end
 for i=0,D.Segmentos-1 do
  local theta=i*math.pi*2/D.Segmentos
  local x,z=math.cos(theta)*0.505,math.sin(theta)*0.505
  local dough=piece("Masa_"..i,Vector3.new(0.43,0.36,0.43),CFrame.new(x,0,z),Color3.fromRGB(210,145,82),theta)
  dough.Shape=Enum.PartType.Ball
  local icing=piece("Glaseado_"..i,Vector3.new(0.425,0.125,0.425),CFrame.new(x,0.145,z),Color3.fromRGB(255,151,191),theta)
  icing.Shape=Enum.PartType.Ball
 end
 local colors={Color3.fromRGB(255,235,109),Color3.fromRGB(104,211,244),Color3.fromRGB(255,255,246),Color3.fromRGB(182,132,234)}
 for i=1,12 do
  local theta=(i/12+seed*0.073)*math.pi*2
  local radius=0.48+(i%3-1)*0.045
  piece("Viruta_"..i,Vector3.new(0.11,0.025,0.035),CFrame.new(math.cos(theta)*radius,0.211,math.sin(theta)*radius)*CFrame.Angles(0,theta*1.7,0),colors[i%#colors+1],theta)
 end
 m:PivotTo(cf);m:SetAttribute("HR_Inicial",cf);m.Parent=parent
 return m
end
function D.Mesa(parent,board)
 local folder=Instance.new("Folder");folder.Name="Donuts";folder:SetAttribute("HR_Owner",D.Owner)
 local index=0
 for _,z in ipairs({-2.5,-0.1,2.3}) do
  for _,x in ipairs({-5.25,-3.15,-1.05,1.05,3.15,5.25}) do
   index+=1
   D.Crear(string.format("Donut_%02d",index),folder,board.CFrame*CFrame.new(x,board.Size.Y/2+0.185,z),index)
  end
 end
 folder.Parent=parent;return folder
end
function D.Estado(model,visible,mordido)
 for _,p in ipairs(model:GetDescendants()) do
  if p:IsA("BasePart") and p.Name~="Centro" then
   local theta=p:GetAttribute("HR_Angulo")
   local bite=mordido and theta and math.cos(theta)>0.60 and math.sin(theta)<0.35
   p.Transparency=visible and not bite and 0 or 1
  end
 end
end
return D
