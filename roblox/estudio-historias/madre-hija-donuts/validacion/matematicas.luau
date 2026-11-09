-- Matematicas de prueba, independientes del motor Roblox. No se instalan en Studio.
local V={};local VM={}
VM.__index=function(a,k)
 if k=="Magnitude" then return math.sqrt(a.X*a.X+a.Y*a.Y+a.Z*a.Z) end
 if k=="Unit" then return a/a.Magnitude end
 return V[k]
end
VM.__add=function(a,b) return Vector3.new(a.X+b.X,a.Y+b.Y,a.Z+b.Z) end
VM.__sub=function(a,b) return Vector3.new(a.X-b.X,a.Y-b.Y,a.Z-b.Z) end
VM.__unm=function(a) return Vector3.new(-a.X,-a.Y,-a.Z) end
VM.__mul=function(a,b)
 if type(a)=="number" then a,b=b,a end
 if type(b)=="number" then return Vector3.new(a.X*b,a.Y*b,a.Z*b) end
 return Vector3.new(a.X*b.X,a.Y*b.Y,a.Z*b.Z)
end
VM.__div=function(a,b) return Vector3.new(a.X/b,a.Y/b,a.Z/b) end
Vector3={new=function(x,y,z) return setmetatable({X=x or 0,Y=y or 0,Z=z or 0},VM) end}
Vector3.zero=Vector3.new();Vector3.xAxis=Vector3.new(1,0,0);Vector3.yAxis=Vector3.new(0,1,0);Vector3.zAxis=Vector3.new(0,0,1)
function V:Dot(b) return self.X*b.X+self.Y*b.Y+self.Z*b.Z end
function V:Cross(b) return Vector3.new(self.Y*b.Z-self.Z*b.Y,self.Z*b.X-self.X*b.Z,self.X*b.Y-self.Y*b.X) end
function V:Lerp(b,t) return self*(1-t)+b*t end
function V:Min(b) return Vector3.new(math.min(self.X,b.X),math.min(self.Y,b.Y),math.min(self.Z,b.Z)) end
function V:Max(b) return Vector3.new(math.max(self.X,b.X),math.max(self.Y,b.Y),math.max(self.Z,b.Z)) end
local F={};local FM={}
local function cf(p,r) return setmetatable({p=p,r=r},FM) end
local function ident() return {1,0,0,0,1,0,0,0,1} end
local function rot(r,v) return Vector3.new(r[1]*v.X+r[2]*v.Y+r[3]*v.Z,r[4]*v.X+r[5]*v.Y+r[6]*v.Z,r[7]*v.X+r[8]*v.Y+r[9]*v.Z) end
FM.__index=function(a,k)
 if k=="Position" then return a.p end
 if k=="Rotation" then return cf(Vector3.zero,a.r) end
 if k=="RightVector" or k=="XVector" then return Vector3.new(a.r[1],a.r[4],a.r[7]) end
 if k=="YVector" or k=="UpVector" then return Vector3.new(a.r[2],a.r[5],a.r[8]) end
 if k=="ZVector" then return Vector3.new(a.r[3],a.r[6],a.r[9]) end
 if k=="LookVector" then return -a.ZVector end
 return F[k]
end
FM.__mul=function(a,b)
 local r={}
 for i=0,2 do for j=0,2 do
  local sum=0
  for k=0,2 do sum+=a.r[i*3+k+1]*b.r[k*3+j+1] end
  r[i*3+j+1]=sum
 end end
 return cf(a.p+rot(a.r,b.p),r)
end
FM.__add=function(a,b) return cf(a.p+b,a.r) end
CFrame={}
function CFrame.new(x,y,z)
 return cf(type(x)=="table" and x or Vector3.new(x,y,z),ident())
end
function CFrame.fromMatrix(p,x,y,z) return cf(p,{x.X,y.X,z.X,x.Y,y.Y,z.Y,x.Z,y.Z,z.Z}) end
function CFrame.Angles(x,y,z)
 local cx,sx,cy,sy,cz,sz=math.cos(x),math.sin(x),math.cos(y),math.sin(y),math.cos(z),math.sin(z)
 return cf(Vector3.zero,{1,0,0,0,cx,-sx,0,sx,cx})*cf(Vector3.zero,{cy,0,sy,0,1,0,-sy,0,cy})*cf(Vector3.zero,{cz,-sz,0,sz,cz,0,0,0,1})
end
function CFrame.lookAt(p,target)
 local f=(target-p).Unit;local x=f:Cross(Vector3.yAxis).Unit;local z=-f
 return CFrame.fromMatrix(p,x,z:Cross(x),z)
end
CFrame.identity=CFrame.new()
function F:Inverse()
 local r=self.r;local t={r[1],r[4],r[7],r[2],r[5],r[8],r[3],r[6],r[9]}
 return cf(-rot(t,self.p),t)
end
function F:ToObjectSpace(b) return self:Inverse()*b end
function F:PointToWorldSpace(p) return self.p+rot(self.r,p) end
function F:PointToObjectSpace(p) return self:Inverse():PointToWorldSpace(p) end
function F:VectorToWorldSpace(p) return rot(self.r,p) end
function F:VectorToObjectSpace(p) return self:Inverse():VectorToWorldSpace(p) end
function F:Lerp(b,t)
 if t==0 then return self end
 if t==1 then return b end
 error("This independent numerical harness only exercises full-weight and zero-weight IK.")
end
