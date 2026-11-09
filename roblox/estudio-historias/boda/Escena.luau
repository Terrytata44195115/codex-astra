local E={Owner="HR_BODA_1"}
local cream=Color3.fromRGB(220,213,199)
local gold=Color3.fromRGB(179,145,85)
local white=Color3.fromRGB(232,228,219)
local pink=Color3.fromRGB(209,153,163)
local green=Color3.fromRGB(62,100,65)
local function part(parent,name,size,cf,color,shape)
 local p=Instance.new("Part");p.Name=name;p.Size=size;p.CFrame=cf;p.Color=color
 p.Material=Enum.Material.SmoothPlastic;p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.CastShadow=false
 p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth
 if shape then p.Shape=shape end
 p.Parent=parent;return p
end
local function rod(parent,name,a,b,radius,color)
 local d=b-a;local p=part(parent,name,Vector3.new(d.Magnitude,radius*2,radius*2),CFrame.lookAt((a+b)/2,b)*CFrame.Angles(0,math.pi/2,0),color,Enum.PartType.Cylinder)
 return p
end
local function flower(parent,cf,radius,color)
 local m=Instance.new("Model");m.Name="Rosa";m.Parent=parent
 for i=0,6 do
  local a=i*math.pi*2/7
  part(m,"Petalo",Vector3.new(radius*.9,radius*.27,radius*.65),cf*CFrame.new(math.sin(a)*radius*.44,.02,math.cos(a)*radius*.44)*CFrame.Angles(math.rad(-18),a,0),color,Enum.PartType.Ball)
 end
 for i=0,3 do
  local a=i*math.pi/2+.3
  part(m,"PetaloInterior",Vector3.new(radius*.63,radius*.34,radius*.43),cf*CFrame.new(math.sin(a)*radius*.21,.075,math.cos(a)*radius*.21)*CFrame.Angles(math.rad(-28),a,0),color:Lerp(white,.18),Enum.PartType.Ball)
 end
 part(m,"Centro",Vector3.new(radius*.3,radius*.24,radius*.3),cf*CFrame.new(0,.12,0),Color3.fromRGB(199,172,108),Enum.PartType.Ball)
end
local function foliage(parent,cf,scale)
 for i=-1,1 do
  local p=part(parent,"Hoja",Vector3.new(scale*.22,scale*.055,scale*.73),cf*CFrame.new(i*scale*.19,0,i*scale*.11)*CFrame.Angles(0,i*.85,math.rad(i*15)),green:Lerp(Color3.fromRGB(116,139,94),(i+1)*.16),Enum.PartType.Ball)
  p.Material=Enum.Material.SmoothPlastic
 end
end
function E.Crear(parent,origin,roles,C,P,V)
 local root=Instance.new("Model");root.Name="HR_Boda";root:SetAttribute("HR_Owner",E.Owner);root:SetAttribute("HR_Origen",origin)
 root.ModelStreamingMode=Enum.ModelStreamingMode.Persistent;root.Parent=parent
 local decor=Instance.new("Model");decor.Name="Ceremonia";decor.Parent=root
 local function at(x,y,z) return origin*CFrame.new(x,y,z) end
 local ground=part(decor,"Cesped",Vector3.new(1024,.3,1024),at(0,-.15,16),Color3.fromRGB(102,143,80));ground.Material=Enum.Material.Grass;ground.CanCollide=true;ground.CanQuery=true
 part(decor,"Tarima",Vector3.new(14,.22,8),at(0,.11,-.8),cream)
 part(decor,"BordeTarima",Vector3.new(14.2,.10,8.2),at(0,.04,-.8),gold)
 part(decor,"Pasillo",Vector3.new(3.8,.055,22),at(0,.03,13),white)
 for _,side in ipairs({-1,1}) do
  part(decor,"RibetePasillo",Vector3.new(.055,.06,22),at(side*1.84,.04,13),gold)
 end
 local arch=Instance.new("Model");arch.Name="ArcoFloral";arch.Parent=decor
 for _,side in ipairs({-1,1}) do
  part(arch,"Pedestal",Vector3.new(1.5,.3,1.35),at(side*4.7,.38,-3.1),cream)
  part(arch,"MolduraBase",Vector3.new(1.25,.18,1.12),at(side*4.7,.62,-3.1),gold)
  rod(arch,"Columna",at(side*4.7,.7,-3.1).Position,at(side*4.7,4.7,-3.1).Position,.23,cream)
  for j=0,1 do part(arch,"Capitel",Vector3.new(.9,.12,.9),at(side*4.7,4.6+j*.18,-3.1),j==0 and gold or cream) end
 end
 -- Arco de dos perfiles curvos y montantes: abertura limpia, sin una pared tras las caras.
 for _,depth in ipairs({-.24,.24}) do
  for i=0,31 do
   local a=i/32*math.pi;local b=(i+1)/32*math.pi
   local p=at(math.cos(a)*4.7,4.7+math.sin(a)*3.5,-3.1+depth).Position
   local q=at(math.cos(b)*4.7,4.7+math.sin(b)*3.5,-3.1+depth).Position
   rod(arch,"PerfilArco",p,q,.11,depth<0 and cream or gold)
  end
 end
 -- Guirnalda asimetrica: hojas de fondo y rosas orientadas hacia la camara.
 for i=0,27 do
  local a=i/27*math.pi
  local x,y=math.cos(a)*4.7,4.7+math.sin(a)*3.5
  foliage(arch,at(x,y,-2.85)*CFrame.Angles(math.pi/2,0,a),1.15)
  if i<12 or i>22 then
   flower(arch,at(x,y,-2.69)*CFrame.Angles(math.pi/2,a,0),.43,i%3==0 and pink or white)
  end
 end
 for _,side in ipairs({-1,1}) do
  for i=0,7 do
   local y=.9+i*.46;local x=side*4.7+math.sin(i*1.7)*.20
   foliage(arch,at(x,y,-2.82)*CFrame.Angles(math.pi/2,0,i*.5),1.0)
   if i%2==0 or side==-1 then flower(arch,at(x,y,-2.65)*CFrame.Angles(math.pi/2,i,0),.4,i%3==0 and pink or white) end
  end
  -- Cintas colgantes junto al arco, fuera de los ojos de la oficiante.
  for i=1,3 do part(arch,"Cinta",Vector3.new(.11,1.3+i*.25,.025),at(side*(3.2+i*.25),6.6,-2.95),white) end
 end
 for _,side in ipairs({-1,1}) do
  for row=0,2 do
   local x,z=side*4.4,5.4+row*3.2
   for seat=0,1 do
    local sx=x+side*seat*2.1
    part(decor,"Asiento",Vector3.new(1.6,.18,1.55),at(sx,1.05,z),white)
    part(decor,"Respaldo",Vector3.new(1.6,1.6,.16),at(sx,1.8,z+.68),white)
    for _,leg in ipairs({-.6,.6}) do for _,dz in ipairs({-.55,.55}) do part(decor,"PataSilla",Vector3.new(.11,1,.11),at(sx+leg,.52,z+dz),gold) end end
   end
   part(decor,"MacetaPasillo",Vector3.new(.75,.50,.75),at(side*2.5,.25,z),cream)
   for k=0,2 do
    local a=k*math.pi*2/3
    local cf=at(side*2.5+math.cos(a)*.25,.75,z+math.sin(a)*.25)
    foliage(decor,cf,1);flower(decor,cf,.32,k==1 and pink or white)
   end
  end
 end
 local room=Instance.new("Model");room.Name="Dormitorio";room.Parent=root
 local function bedroom(x,y,z) local p=C.Dormitorio;return at(p.X+x,y,p.Z+z) end
 part(room,"Suelo",Vector3.new(11,.2,11),bedroom(0,.1,0),Color3.fromRGB(156,124,91))
 part(room,"ParedFondo",Vector3.new(11,7,.2),bedroom(0,3.7,-4.8),Color3.fromRGB(159,177,185))
 part(room,"Cabecero",Vector3.new(3.8,2.2,.3),bedroom(0,1.7,-3.4),Color3.fromRGB(97,59,51))
 part(room,"BaseCama",Vector3.new(3.6,.45,5.3),bedroom(0,.55,-1),Color3.fromRGB(97,59,51))
 part(room,"Colchon",Vector3.new(3.5,.4,5.1),bedroom(0,.98,-1),white)
 part(room,"Edredon",Vector3.new(3.55,.24,3.9),bedroom(0,1.24,-.4),Color3.fromRGB(173,49,63))
 part(room,"Almohada",Vector3.new(2.7,.34,1),bedroom(0,1.32,-2.85),white,Enum.PartType.Ball)
 part(room,"Mesilla",Vector3.new(1.1,1.2,1.1),bedroom(2.8,.6,-2.8),cream)
 rod(room,"PieLampara",bedroom(2.8,1.2,-2.8).Position,bedroom(2.8,1.9,-2.8).Position,.055,gold)
 part(room,"PantallaLampara",Vector3.new(.85,.65,.85),bedroom(2.8,2.05,-2.8),white)
 local cast=Instance.new("Model");cast.Name="Reparto";cast.Parent=root
 for _,role in ipairs(C.Roles) do
  local template=roles:FindFirstChild(role=="Invitada" and "Hija" or role).Value
  local m=template:Clone();m.Name=role;m.Parent=cast;P.Verificar(m)
  local humanoid=m:FindFirstChildOfClass("Humanoid");local hrp=m.HumanoidRootPart;local foot=m.LeftFoot
  local height=hrp.Position.Y-foot.Position.Y+foot.Size.Y/2
  for _,d in ipairs(m:GetDescendants()) do
   if d:IsA("BaseScript") or d:IsA("BillboardGui") then d.Enabled=false end
   if d:IsA("BasePart") then d.Anchored=d==hrp;d.CanCollide=false;d.CanTouch=false end
   if d:IsA("Motor6D") then d.Transform=CFrame.identity end
  end
  humanoid.AutomaticScalingEnabled=false;humanoid.AutoRotate=false;humanoid.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None
  m.PrimaryPart=hrp;m.ModelStreamingMode=Enum.ModelStreamingMode.Persistent
  V.Aplicar(m,role)
  local position=C.Posiciones[role]
  local point=origin:PointToWorldSpace(Vector3.new(position.X,height+.22,position.Z))
  m:PivotTo(CFrame.lookAt(point,point+origin.ZVector)*CFrame.Angles(0,math.rad(C.Giros[role]),0))
  m:SetAttribute("HR_AlturaRaiz",height)
 end
 return root
end
return E
