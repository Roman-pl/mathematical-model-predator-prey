uses GraphABC;
const
  fx = 10;
  fy = 10;

var
  Life: array [0..fx+1] of array [0..fy+1]  of integer; 
  Next: array [0..fx+1] of array [0..fy+1]  of integer;
  cs:integer := 20;
  x: integer;
  y: integer;
  flag: boolean;
  
procedure drf(); // отрисовка поля 
var
  j, i: integer;
begin
  pen.Width:=1;
  pen.Color:=clblack;
  for i := 1 to fx do 
    for j := 1 to fy do 
    begin
      if life[i][j] = 1 then 
        brush.Color:=clgreen
      else
        brush.Color:=clwhite;
      if life[i][j] = 2 then 
        brush.Color:=clred;
        
      Rectangle(i*cs+1,j*cs+1,i*cs+cs-1,j*cs+cs-1); 
      //if life[i][j] = 1 then begin brush.Color:=clgreen ; FillRectangle (i*cs,j*cs,i*cs+cs,j*cs+cs); end;
      //if life[i][j] = 0 then begin pen.Color:=clwhite ; FillRectangle (i*cs,j*cs,i*cs+cs,j*cs+cs); end;
    end;
    Redraw;
end;

function Nextlife(x,y: integer): integer;

var
 n,a,b,c,v,m: integer;
begin
  n:=0;
  a:=0;
  b:=random(0,7);
  n:=random(1,10);
  v := random(1,10);
  m:=random(0,7);
      if (life[x][y]=1) and (n >7) then // если да то где размножится 
        if b=0 then Next[x][y+1]:=1
        else
          if b=2 then Next[x+1][y]:=1
          else
            if b=1 then Next[x+1][y+1]:=1
            else
              if b=3 then Next[x+1][y+1]:=1
              else
                if b=4 then Next[x][y-1]:=1
                else
                  if b=5 then Next[x-1][y-1]:=1
                  else
                    if b=6 then Next[x-1][y]:=1
                    else
                      if b=7 then Next[x-1][y+1]:=1;
                      
      if Life[x][y]=2 then // проверяем есть ли хищник в клетке и если есть и рядом есть жертва то он размножается 
        if Life[x+1][y]=1 then Next[x+1][y]:=2
        else 
          if Life[x][y+1]=1 then Next[x][y+1]:=2
          else
            if Life[x+1][y+1]=1 then Next[x+1][y]:=2
            else
              if Life[x+1][y-1]=1 then Next[x+1][y-1]:=2
              else
                if Life[x][y-1]=1 then Next[x][y-1]:=2
                else
                  if Life[x][y-1]=1 then Next[x][y-1]:=2
                  else
                    if Life[x-1][y]=1 then Next[x-1][y]:=2
                    else
                      if Life[x-1][y-1]=1 then Next[x-1][y-1]:=2;
      
      if Life[x][y]=2 then // проверяем есть ли вокруг хищника хоть одна жертва 
        if Life[x+1][y]=1 then c:=c+1
        else 
          if n+Life[x][y+1]=1 then c:=c+1
          else 
            if Life[x+1][y+1]=1 then c:=c+1
            else 
              if Life[x+1][y-1]=1 then c:=c+1
              else 
                if Life[x][y-1]=1 then c:=c+1
                else
                  if Life[x-1][y+1]=1 then c:=c+1
                  else
                    if Life[x-1][y]=1 then c:=c+1
                    else
                      if Life[x-1][y-1]=1 then c:=c+1;
      if (Life[x][y]=2) and (c=0) then Next[x][y]:=0; // если вокург хищника нет ни одной жертвы то он умирает
      if (Life[x][y]=2) and (v<5) then Next[x][y]:=0;
      if (Life[x][y]=2) and (c>0) and (v>5) then
        if m=0 then Next[x][y+1]:=2
        else
          if m=2 then Next[x+1][y]:=2
          else
            if m=1 then Next[x+1][y+1]:=2
            else
              if m=3 then Next[x+1][y+1]:=2
              else
                if m=4 then Next[x][y-1]:=2
                else
                  if m=5 then Next[x-1][y-1]:=2
                  else
                    if m=6 then Next[x-1][y]:=2
                    else
                      if m=7 then Next[x-1][y+1]:=2;
        
end;

procedure step;//процедура перехода от одной итерации к другой
var
  x,e: integer;
  y,q: integer;
begin
  for x:=1 to fx do
    for y:=1 to fy do
      nextlife(x,y);
  for e:=1 to fx do
    for q:=1 to fy do 
      Life [e][q]:= Next [e][q] ;
end;


procedure MD(x, y, mb: integer);// постановка хищников и жертв краснные - хищники; зеленные - жертвы
begin
  if mb=1 then  
    life[x div cs][y div cs] := 1-life[x div cs][y div cs];;//ставим жертву 
  if mb= 2 then 
  life[x div cs][y div cs] := 2-life[x div cs][y div cs];//ставим хищника
  drf;
end;



procedure KeyDown(Key: integer);
begin
 if key= VK_Space  then flag:=not flag; //постановка паузы
end;


begin
  LockDrawing;
  OnMouseDown := md;
  flag:= true;
  OnKeyDown := KeyDown;
  repeat
    if flag = false then 
      continue ;
    sleep (300);
    step;
    drf;
  until  0=1 ;
end.
// в следущую неделю увидим : у хищника у видим поле зрения запись в файл (желательно в бинарный) хищник умирает с некторой вероятностью и также записывает в текстовый файл парметр "название"="значение в параметра"  