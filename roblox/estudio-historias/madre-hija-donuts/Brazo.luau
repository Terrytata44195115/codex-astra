-- IK analitica sobre los Motor6D existentes. No reconstruye el rig.
local A={}
function A.SoporteMano(hand)
 local grip=hand:FindFirstChild("RightGripAttachment")
 return CFrame.new(grip and grip.Position or Vector3.new(0,-hand.Size.Y*.25,hand.Size.Z*.45))
end
-- Mismo soporte y UV de boca que el cliente facial que ya se ve correctamente.
function A.PuntoBoca(head,cf)
 local front=head:FindFirstChild("FaceFrontAttachment")
 local hat=head:FindFirstChild("HatAttachment")
 local mesh=head:FindFirstChildOfClass("SpecialMesh")
 local radius=front and math.abs(front.Position.Z) or head.Size.Z*.6
 local top=hat and math.abs(hat.Position.Y) or radius
 local width=math.max(.5,math.min(head.Size.X,2*radius))
 local height=math.max(.5,2*top)
 local depth=math.max(radius,head.Size.Z/2*(mesh and math.max(1,mesh.Scale.Z) or 1))
 local x=front and front.Position.X or 0
 local y=(front and front.Position.Y or 0)-height*.20
 return (cf or head.CFrame)*CFrame.new(x,y,-depth-width*.04-.035)
end
function A.Bocado(head,cf)
 -- El borde posterior elevado de la rosca toca la boca, no su centro ni un lado.
 return A.PuntoBoca(head,cf)*CFrame.Angles(math.rad(-68),0,0)*CFrame.new(0,0,-.72)
end
local function rotationFor(localAxis,worldAxis,reference)
 local function basis(y,x)
  y=y.Unit;x=x-y*x:Dot(y)
  if x.Magnitude<0.001 then x=Vector3.zAxis-y*Vector3.zAxis:Dot(y) end
  if x.Magnitude<0.001 then x=Vector3.xAxis-y*Vector3.xAxis:Dot(y) end
  x=x.Unit
  return CFrame.fromMatrix(Vector3.zero,x,y,x:Cross(y).Unit)
 end
 return basis(-worldAxis,reference)*basis(-localAxis,Vector3.xAxis):Inverse()
end
function A.Cadena(actor)
 local s,e,w=actor.joints.RightShoulder,actor.joints.RightElbow,actor.joints.RightWrist
 assert(s and e and w,"Falta la cadena del brazo derecho de "..actor.model.Name)
 local v1=e.base.Position-s.motor.C1.Position
 local v2=w.base.Position-e.motor.C1.Position
 assert(v1.Magnitude>0.05 and v2.Magnitude>0.05,"Longitudes de brazo no validas.")
 return {s=s,e=e,w=w,v1=v1,v2=v2,l1=v1.Magnitude,l2=v2.Magnitude}
end
function A.Marcos(actor)
 local frames={[actor.root]=actor.root.CFrame}
 local pending=true
 while pending do
  pending=false
  for _,j in pairs(actor.joints) do
   local m=j.motor
   if m.Part0 and m.Part1 and frames[m.Part0] and not frames[m.Part1] then
    frames[m.Part1]=frames[m.Part0]*m.C0*m.C1:Inverse();pending=true
   end
  end
 end
 return frames
end
function A.Resolver(actor,handTarget,weight)
 local chain=actor.arm
 local s,e,w=chain.s,chain.e,chain.w
 local frames=A.Marcos(actor)
 local parent=frames[s.motor.Part0]
 assert(parent,"No se pudo calcular el torso del actor.")
 local shoulder=(parent*s.base).Position
 local wrist=(handTarget*w.motor.C1).Position
 local diff=wrist-shoulder
 if diff.Magnitude<0.001 then diff=actor.root.CFrame.LookVector*0.001 end
 local u=diff.Unit
 local d=math.clamp(diff.Magnitude,math.abs(chain.l1-chain.l2)+0.002,chain.l1+chain.l2-0.002)
 local pole=actor.root.CFrame.RightVector*0.8-Vector3.yAxis*0.4-actor.root.CFrame.LookVector*0.1
 local bend=pole-u*pole:Dot(u)
 if bend.Magnitude<0.001 then bend=u:Cross(Vector3.yAxis) end
 if bend.Magnitude<0.001 then bend=u:Cross(Vector3.xAxis) end
 bend=bend.Unit
 local cosine=math.clamp((chain.l1^2+d^2-chain.l2^2)/(2*chain.l1*d),-1,1)
 local elbow=shoulder+u*(cosine*chain.l1)+bend*(math.sqrt(math.max(0,1-cosine^2))*chain.l1)
 local endPoint=shoulder+u*d
 local upper=CFrame.new(shoulder)*rotationFor(chain.v1,elbow-shoulder,actor.root.CFrame.RightVector)*CFrame.new(-s.motor.C1.Position)
 local lower=CFrame.new(elbow)*rotationFor(chain.v2,endPoint-elbow,actor.root.CFrame.RightVector)*CFrame.new(-e.motor.C1.Position)
 local hand=CFrame.new(endPoint)*handTarget.Rotation*CFrame.new(-w.motor.C1.Position)
 local goals={parent:ToObjectSpace(upper*s.motor.C1),upper:ToObjectSpace(lower*e.motor.C1),lower:ToObjectSpace(hand*w.motor.C1)}
 for i,j in ipairs({s,e,w}) do j.motor.C0=j.motor.C0:Lerp(goals[i],weight) end
 local final=A.Marcos(actor)[w.motor.Part1]
 return final,math.max(0,diff.Magnitude-d)
end
return A
