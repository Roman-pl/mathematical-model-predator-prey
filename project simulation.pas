uses GraphABC;

{const
  fx = 10;
  fy = 10;}

var
  Life: array of array of integer; 
  Next: array of array of integer;
  ArrPredPopulation: array of integer;
  ArrPreyPopulation: array of integer;
  cs: integer := 20;
  x, i: integer;
  y, j: integer;
  flag: boolean;
  fp: integer;// поле зрения хищника который (будет считываться из  текстового файла)
  f: text;
  f2: file of  integer;
  s, g, preyp, predp: string;
  a: array of string;
  f1: text;
  p: integer;
  PosPredator, PosPrey: real;
  time: integer;// время наблюдения за симуляцией
  PredPopulation: integer;
  PreyPopulation: integer;
  fx:integer;
  fy:integer;

procedure drf(fx,fy:integer);// отрисовка поля 
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
  {if  (Life[x][y] = 2) and (c = 0) and (v < 3) then Next[x][y] := 0;
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
  end;}
end;

procedure step(fx,fy:integer);//процедура перехода от одной итерации к другой
var
  x, e: integer;
  y, q: integer;
begin
  for x := 0 to fx do
    for y := 0 to fy do
      nextlife(x, y, fp, PosPredator, PosPrey);
  for e := 0 to fx do
    for q := 0 to fy do 
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
  i:=0;
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
  writeln('справка : пробел - пауза; delete - закрытие программы ');
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
  
  setlength(life,fx+fp);
  for i:= 0 to fx+fp do
  begin
    setlength(life[i],fy+fp);
  end;
     
  setlength(next,fx+fp);   
  for i:= 0 to fx+fp do
  begin
    setlength(next[i],fy+fp); 
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
  if p = 0 then halt(0);
  closefile(f2);
end.
// обЪединить все в одну программу исправить все ошибки в отрисовке 