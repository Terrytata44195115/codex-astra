-- Prueba independiente; no es todavia el guion de 24 segundos.
return {
 Version="PRUEBA_TRES_ACTORES_1",
 Duracion=10,
 Preparacion=3,
 Entrada=2.5,
 Animaciones={Correr="rbxassetid://616140816",Saludar="rbxassetid://507770239"},
 -- IDs encontrados en Base_Historias: su carga real se comprueba durante Play.
 Planos={
  {Inicio=0,Roles={"Madre","Hija","Novio"},Angulo=0,Medio=false},
  {Inicio=2.5,Roles={"Novio"},Angulo=30,Medio=true},
  {Inicio=5,Roles={"Madre","Hija"},Angulo=-30,Medio=true},
  {Inicio=7.5,Roles={"Madre","Hija","Novio"},Angulo=-15,Medio=false},
 },
}
