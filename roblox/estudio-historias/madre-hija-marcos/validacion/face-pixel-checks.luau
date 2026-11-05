local seen={}
local n=B.ResolucionCara
for _,key in ipairs(B.EstadosCara) do
 local plain=B.PixelesCara(key,false)
 local masked=B.PixelesCara(key,true)
 assert(buffer.len(plain)==n*n*4 and buffer.len(masked)==n*n*4)
 assert(buffer.readu8(plain,3)==0,"Top-left background must be transparent")
 assert(buffer.readu8(masked,3)==0,"Mask must not become a whole-face rectangle")
 local data=buffer.tostring(plain)
 assert(not seen[data],"Different expressions must produce different textures")
 seen[data]=true
 local alpha=0
 for i=3,buffer.len(plain)-1,4 do alpha+=buffer.readu8(plain,i) end
 assert(alpha>0,"Empty expression")
 local chin=(math.floor(n*0.85)*n+math.floor(n*0.5))*4+3
 assert(buffer.readu8(masked,chin)>240,"Mask should cover lower face")
end
return "PASS: 6 distinct nonempty RGBA expressions, transparent backgrounds, mask confined to lower face; images still need Studio rendering review."
