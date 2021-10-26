uses GraphABC;

var
  Life: array of array of integer; 
  Next: array of array of integer;
  ArrPredPopulation: array of integer;
  ArrPreyPopulation: array of integer;
  cs: integer := 20;
  i,j,u,n: integer;
  flag: boolean;
  fp: integer;// поле зрения хищника который (будет считываться из  текстового файла)
  f: text;
  f2: file of  integer;
  s, g, preyp, predp,m: string;
  a,c: array of string;
  f1: text;
  p: integer;
  PosPredator, PosPrey: real;
  time: integer;// время наблюдения за симуляцией
  PredPopulation: integer;
  PreyPopulation: integer;
  fx:integer;
  fy:integer;
  x:integer ;
  y:integer ;
  b,a1:array of integer ;
  f3:file;
  
  
  
procedure InitMathGraph;
begin
  Coordinate.SetMathematic;
  Coordinate.SetOrigin(20,Window.Height-20);
end;

procedure drf(fx,fy:integer);// отрисовка поля 
var
  j, i: integer;
begin
  pen.Width := 1;
  pen.Color := clblack;
  for i := fp to fx+fp-1 do 
    for j := fp to fy+fp-1 do 
    begin
      if life[i][j] = 1 then 
        brush.Color := clgreen
      else
        brush.Color := clwhite;
      if life[i][j] = 2 then 
        brush.Color := clred;
      Rectangle(i * cs + 1, j * cs + 1, i * cs + cs - 1, j * cs + cs - 1); 
    end;
  Redraw;
end;

function Nextlife(x, y, fp: integer; PosPredator, PosPrey: real): integer;

var
  n, a, b, c, v, m, i, k: integer;
begin
  n := 0;
  a := 0;
  b := 0;
  c := 0;
  v := 0;
  m := 0;
  k := 0;
  i := 0;
  n := random(1, 10);
  v := random(1, 10);
  b := random(0, 7);
  m := random(0, 7);
  k := random(1, fp);
  
  if (life[x][y] = 1)  and (random() <= PosPrey) then
    if b = 0 then Next[x][y + 1] := 1
    else
    if b = 1 then Next[x + 1][y] := 1
      else
    if b = 2 then Next[x + 1][y + 1] := 1
        else
    if b = 3 then Next[x][y - 1] := 1
          else
    if b = 4 then Next[x + 1][y - 1] := 1
            else  
    if b = 5 then Next[x - 1][y - 1] := 1
              else
    if b = 6 then Next[x - 1][y + 1] := 1
                else
    if b = 7 then Next[x - 1][y] := 1;
  
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
    
  if (life[x][y] = 2) and (c = 0) and (random() > PosPredator) then Next[x][y] := 0;
  if (life[x][y] = 2) and (c = 0) and (random() <= PosPredator) then
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

procedure step(fx,fy:integer);//процедура перехода от одной итерации к другой
var
  x, e: integer;
  y, q: integer;
begin
  for x := fp to fx+fp-1 do
    for y := fp to fy+fp-1 do
      nextlife(x, y, fp, PosPredator, PosPrey);
  for e := fp to fx+fp-1 do
    for q := fp to fy+fp-1 do 
      Life[e][q] := Next[e][q];
end;

procedure MD(x, y, mb: integer);// постановка хищников и жертв краснные - хищники; зеленные - жертвы
begin
  if mb = 1 then  
    life[x div cs][y div cs] := 1 - life[x div cs][y div cs];;//ставим жертву 
  if mb = 2 then 
    life[x div cs][y div cs] := 2 - life[x div cs][y div cs];//ставим хищника
  drf(fx,fy);
end;

procedure KeyDown(Key: integer);
begin
  if key = VK_Space  then flag := not flag; //постановка паузы
  if key = VK_delete then p := 0;
end;

begin
  p := 1;
  time := 0;
  u:=0;
  LockDrawing;
  OnMouseDown := md;
  flag := true;
  OnKeyDown := KeyDown;
  
  g := 'Settings.ini';
  Assign(F, g);
  Reset(F);
  g := 'saved array.txt';
  DeleteFile(g);
  Assign(f1, g);
  f1.Rewrite();
  
  
  while not EOF(F) do
  begin
    Readln(F, s);
    a := s.split('=');
    if a[0] = 'predator"s field of view ' then fp := strtoint(a[1]);
    if a[0] = 'the posibility of death of a predator ' then PosPredator := strtofloat(a[1]);
    if a[0] = 'the posibility of reproduce of a prey ' then PosPrey := strtofloat(a[1]);
    if a[0] = 'field length by x ' then fx:= strtoint(a[1]);
    if a[0] = 'field length by y ' then fy:= strtoint(a[1]); 
  end;
  CloseFile(f);
  
  setlength(life,fx+fp+fp+1);
  for u:= 0 to fx+fp+fp do
  begin
    setlength(life[u],fy+fp+fp+1);
  end;
  
  setlength(next,fx+fp+fp+1);   
  for u:= 0 to fx+fp+fp do
  begin
    setlength(next[u],fy+fp+fp+1); 
  end;
     
  repeat
    if flag = false then 
      continue;
    sleep(300);
    step(fx,fy);
    drf(fx,fy);
    time := time + 1;
    PredPopulation := 0;
    PreyPopulation := 0;
    
    for i := 0 to fx do
      for j := 0 to fy do
      begin
        if life[i][j] = 2 then PredPopulation := PredPopulation + 1;
        if life[i][j] = 1 then PreyPopulation := PreyPopulation + 1;
      end;  
    
    preyp := preyp + ',' +  PreyPopulation;
    predp := predp + ',' +  PredPopulation;
    
    setlength(ArrPredPopulation, Length(ArrPredPopulation) + 1);
    ArrPredPopulation[length(ArrPredPopulation)-1] := PredPopulation;
    
    setlength(ArrPreyPopulation, Length(ArrPreyPopulation) + 1);
    ArrPreyPopulation[length(ArrPreyPopulation)-1] := PreyPopulation;
  until  0 = p;
  writeln(f1, 'количество хищников на протяжении разного количество времени :', predp);
  
  writeln(f1, 'количество жертв на протяжении разного количество времени :', preyp);
  
  writeln(f1, 'время наблюдения за симуляцией: ', time);
  CloseFile(f1);
  g := 'saved array.bin';
  DeleteFile(g);
  Assign(f2, g);
  f2.rewrite();
  write(f2, time);
  for i := 0 to time - 1 do
  begin
    write(f2,ArrPreyPopulation[i],ArrPredPopulation[i]); 
  end;
  closefile(f2);
  
  Read(m);
  if m = 'y' then
  begin
  //pen.Color:=clWhite;
  //FillRect(0,0,Window.Width,Window.Height);
  ClearWindow();
  assign(f3, 'saved array.bin');
  reset(f3);
  i := 0;
  setlength(b, 1);
  j:=0;
  while not EOF(F3) do
  begin
    if i = 0 then
       begin 
       read(f3, b[i]); 
       i:=0;
       end
    else
    begin
      setlength(a1, Length(a1) + 1);
      read(f3, a1[j]);
      j:=j+1;
    end;
    i := i + 1;
  end;
  time := b[0];
  

  n := length(a1) div 2;
  setlength(ArrPreyPopulation,time);
  setlength(ArrPredPopulation, time);
 
  j:=0;
  x:=0;
  for i :=0 to length(a1)-1 do
  begin
    if i mod 2 = 0 then
      begin 
      ArrPreyPopulation[j]:=a1[i];
      j:=j+1; 
      end
      else
      begin
        ArrPredPopulation[x]:=a1[i];
        x:=x+1;
      end;
  end;
  
  begin
  window.Normalize;
  InitMathGraph;
  moveto(0,0);
    for i:=0 to time-1 do
    begin
      pen.Color := Clgreen;
      pen.Width:=3;
       LineTo(i*5,ArrPreyPopulation[i]);
    end;
  moveto(0,0);
    for i:=0 to time-1 do
    begin
      pen.Color := Clred;
      pen.Width:=3;
      LineTo(i*5, ArrPredPopulation[i]);
    end;
   end;
  closefile(f3);
  end;
  
end.
// обЪединить все в одну программу исправить все ошибки в отрисовке 