uses GraphABC;

const
  fx = 10;
  fy = 10;

var
  Life: array [0..fx + 1] of array [0..fy + 1]  of integer; 
  Next: array [0..fx + 1] of array [0..fy + 1]  of integer;
  cs: integer := 20;
  x: integer;
  y: integer;
  flag: boolean;
  fp: integer;// поле зрения хищника который (будет считываться из  текстового файла)
  f: text;
  s, g: string;
  a: array of string;
  f1: text ;
  p:integer;
  pos:real;

procedure drf();// отрисовка поля 
var
  j, i: integer;
begin
  pen.Width := 1;
  pen.Color := clblack;
  for i := 1 to fx do 
    for j := 1 to fy do 
    begin
      if life[i][j] = 1 then 
        brush.Color := clgreen
      else
        brush.Color := clwhite;
      if life[i][j] = 2 then 
        brush.Color := clred;
      Rectangle(i * cs + 1, j * cs + 1, i * cs + cs - 1, j * cs + cs - 1); 
      //if life[i][j] = 1 then begin brush.Color:=clgreen ; FillRectangle (i*cs,j*cs,i*cs+cs,j*cs+cs); end;
      //if life[i][j] = 0 then begin pen.Color:=clwhite ; FillRectangle (i*cs,j*cs,i*cs+cs,j*cs+cs); end;
    end;
  Redraw;
end;

function Nextlife(x, y, fp: integer;PosPredator,PosPrey:real): integer;

var
  n, a, b, c, v, m, i, k,PosPredator2,PosPrey2: integer;
begin
  n := 0;
  a := 0;
  b := 0;
  c := 0;
  v := 0;
  m := 0;
  k := 0;
  i := 0;
  PosPredator2:=0;
  if PosPredator = 0.0 then PosPredator2:=0;
  else 
  if PosPredator = 0.1 then PosPredator2:=1
  else 
    if PosPredator = 0.2 then PosPredator2:=2
    else 
      if PosPredator =0.3 then PosPredator2:=3
      else 
        if PosPredator = 0.4 then PosPredator2 :=4
        else
          if PosPredator = 0.5 then PosPredator2:=5
          else 
            if PosPredator = 0.6 then PosPredator2:=6
            else 
              if PosPredator = 0.7 then PosPredator2:=7 
              else 
                if PosPredator = 0.8 then PosPredator2:=8
                else 
                  if PosPredator =0.9 then PosPredator2:=9
                  else 
                    if PosPredator = 1.0 then PosPredator2:=10;
  
  case PosPrey of 
    0.0: PosPrey2:= 0;
    0.1: PosPrey2:= 1;
    0.2: PosPrey2:= 2;
    0.3: PosPrey2:= 3;
    0.4: PosPrey2:= 4;
    0.6: PosPrey2:= 5;
    0.6: PosPrey2:= 6;
    0.7: PosPrey2:= 7;
    0.8: PosPrey2:= 8;
    0.9: PosPrey2:= 9;
    1.0: PosPrey2:= 10;
  end;
  b := random(0, 10);
  n := random(PosPrey2, 10); // шанс размножения prey
  if PosPredator2=0 then v:=0
  else
    v := random(PosPredator2, 10);// шанс выживания хищника если вокруг нет еды 
  m := random(0, 7);
  k := random(1, fp);
  
  if (life[x][y] = 1) and (n > 5) then // если да то где размножится 
    if b = 0 then Next[x][y + 1] := 1
        else
    if b = 2 then Next[x + 1][y] := 1
          else
    if b = 1 then Next[x + 1][y + 1] := 1
            else
    if b = 3 then Next[x + 1][y + 1] := 1
              else
    if b = 4 then Next[x][y - 1] := 1
                else
    if b = 5 then Next[x - 1][y - 1] := 1
                  else
    if b = 6 then Next[x - 1][y] := 1
                    else
    if b = 7 then Next[x - 1][y + 1] := 1;
  
  if Life[x][y] = 2 then // проверяем есть ли хищник в клетке и если есть и рядом есть жертва то он размножается
    for i := 1 to fp do
    begin
      if Life[x + i][y] = 1 then
      begin
        Next[x + i][y] := 2;
      end
          else 
      if Life[x][y + i] = 1 then
      begin
        Next[x][y + i] := 2;
      end
            else
      if Life[x + i][y + i] = 1 then 
      begin
        Next[x + i][y + i] := 2;
      end
                else
      if Life[x + i][y - i] = 1 then 
      begin
        Next[x + i][y - i] := 2;
      end
                  else
      if Life[x - i][y + i] = 1 then 
      begin
        Next[x - i][y + i] := 2;
      end
                    else
      if Life[x][y - i] = 1 then 
      begin
        Next[x][y - i] := 2;
      end
                      else
      if Life[x - i][y] = 1 then
      begin
        Next[x - i][y] := 2;
      end
                        else
      if Life[x - i][y - i] = 1 then 
      begin
        Next[x - i][y - i] := 2;
      end;
    end;
  
  if Life[x][y] = 2 then // проверяем есть ли вокруг хищника хоть одна жертва 
    for i := 1 to fp do
    begin
      if Life[x + i][y] = 1 then c := c + 1
        else 
      if n + Life[x][y + i] = 1 then c := c + 1
          else 
      if Life[x + i][y + i] = 1 then c := c + 1
            else 
      if Life[x + i][y - i] = 1 then c := c + 1
              else 
      if Life[x][y - i] = 1 then c := c + 1
                else
      if Life[x - i][y + i] = 1 then c := c + 1
                  else
      if Life[x - i][y] = 1 then c := c + 1
                    else
      if Life[x - i][y - i] = 1 then c := c + 1;
    end;
  
  if  (Life[x][y] = 2) and (c = 0) and (v < 3) then Next[x][y] := 0;
  if (Life[x][y] = 2) and (c = 0) and (v > 3) then
    if m = 0 then 
    begin
      Next[x][y + k] := 2;
      Next[x][y] := 0;
    end
    else
    if m = 1 then
    begin
      Next[x + k][y + k] := 2;
      Next[x][y] := 0;
    end
          else
    if m = 2 then 
    begin
      Next[x + k][y] := 2;
      Next[x][y] := 0;
    end
            else
    if m = 3 then
    begin
      Next[x + k][y + k] := 2;
      Next[x][y] := 0;
    end
              else
    if m = 4 then
    begin
      Next[x][y - k] := 2;
      Next[x][y] := 0;
    end
                else
    if m = 5 then
    begin
      Next[x - k][y - k] := 2;
      Next[x][y] := 0;
    end
                  else
    if m = 6 then
    begin
      Next[x - k][y] := 2;
      Next[x][y] := 0;
    end
                    else
    if m = 7 then
    begin
      Next[x - k][y + k] := 2;
      Next[x][y] := 0;
    end;
end;

procedure step;//процедура перехода от одной итерации к другой
var
  x, e: integer;
  y, q: integer;
begin
  for x := 1 to fx do
    for y := 1 to fy do
      nextlife(x, y, fp,pos);
  for e := 1 to fx do
    for q := 1 to fy do 
      Life[e][q] := Next[e][q];
end;


procedure MD(x, y, mb: integer);// постановка хищников и жертв краснные - хищники; зеленные - жертвы
begin
  if mb = 1 then  
    life[x div cs][y div cs] := 1 - life[x div cs][y div cs];;//ставим жертву 
  if mb = 2 then 
    life[x div cs][y div cs] := 2 - life[x div cs][y div cs];//ставим хищника
  drf;
end;



procedure KeyDown(Key: integer);
begin
  if key = VK_Space  then flag := not flag; //постановка паузы
  if key = VK_delete then p:=0;
end;

begin
  p:=1;
  LockDrawing;
  OnMouseDown := md;
  flag := true;
  OnKeyDown := KeyDown;
  g := 'Settings.ini';
  Assign(F, g);
  Reset(F);
  g := 'saved array.txt';
  DeleteFile(g);
  Assign(f1,g);
  f1.Rewrite();
  writeln('справка : пробел - пауза; delete - закрытие программы ');
  while not EOF(F) do
  begin
    Readln(F, s);
    a := s.split('=');
    if a[0] = 'predator"s field of view ' then fp := strtoint(a[1]);
    if a[0] = 'the prabability of deth of a predator ' then pos:=strtofloat(a[1]) 
  end;
  CloseFile(f);
  repeat
    if flag = false then 
      continue;
    sleep(300);
    step;
    drf;
    writeln(f1,life);
    if p = 0 then  halt(0)
  until  0 = p;
  //CloseFile(f1);
end.
// в следущую неделю увидим : у хищника у видим поле зрения запись в файл (желательно в бинарный) считывание из бин файла и построение графикоф 