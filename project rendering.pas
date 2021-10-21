Uses GraphAbc;
type 
  point= record
  x:integer;
  y:integer;
  end;


var
  ArrPredPopulation: array of integer;
  ArrPreyPopulation: array of integer;
  a, b: array of integer;
  c: array of string;
  ArrPredGraphics : array of point;
  ArrPreyGraphics : array of point;
  f: file;
  f2: text;
  i, time, n,j,x: integer;
  x1,y1:integer;
  x2,y2:integer;
  p:integer; // вероятность того что жертву съест хищник
  s: string;
  PosPredator:real; // вероятность смерти хщника
  PosPrey: real;// вероятность размножения жертвы

begin
  assign(f, 'saved array.bin');
  reset(f);
  i := 0;
  setlength(b, 1);
  j:=0;
  while not EOF(F) do
  begin
    if i = 0 then
       begin 
       read(f, b[i]); 
       i:=0;
       end
    else
    begin
      setlength(a, Length(a) + 1);
      read(f, a[j]);
      j:=j+1;
    end;
    i := i + 1;
  end;
  time := b[0];
  
  assign(f2, 'Settings.ini');
  reset(f2);
  while not EOF(F2) do
  begin
    readln(f2, s);
    c := s.Split('=');
    if c[0] = 'the posibility of death of a predator ' then PosPredator := strtofloat(c[1]);
    if c[0] = 'the posibility of reproduce of a prey ' then PosPrey := strtofloat(c[1]);
  end;
  n := length(a) div 2;
  setlength(ArrPreyPopulation,time);
  setlength(ArrPredPopulation, time);
  
  j:=0;
  x:=0;
  for i :=0 to length(a)-1 do
  begin
    if i mod 2 = 0 then
      begin 
      ArrPreyPopulation[j]:=a[i];
      j:=j+1; 
      end
      else
      begin
        ArrPredPopulation[x]:=a[i];
        x:=x+1;
      end;
  end;
  
  begin
  window.Maximize;
  Setlength(ArrPreyGraphics,time);
  MoveTo(0,window.Height);
    for i:=0 to time-1 do
    begin
      pen.Color := Clgreen;
      pen.Width:=3;
      ArrPreyGraphics[i].x:=i;
      if ArrPreyPopulation[i]=0 then p:=(abs((ArrPreyPopulation[i]-ArrPreyPopulation[i+1]))) div 1
      else
        if i = time -1 then p:=(abs((ArrPreyPopulation[i]-ArrPreyPopulation[i+0]))) div ArrPreyPopulation[i]
        else
          p:=(abs((ArrPreyPopulation[i]-ArrPreyPopulation[i+1]))) div ArrPreyPopulation[i]; //вероятность сЪедения жертвы;  
       ArrPreyGraphics[i].y:=round((PosPrey-p*ArrPredPopulation[i])*ArrPreyPopulation[i]);
       LineTo(ArrPreyGraphics[i].x*10+500,ArrPreyGraphics[i].y*10+500)
    end;
  end;
  
  Setlength(ArrPredGraphics,time);
  MoveTo(0,window.Height);
    for i:=0 to time-1 do
    begin
      pen.Color := Clred;
      pen.Width:=3;
      ArrPredGraphics[i].x:=i; 
      ArrPredGraphics[i].y:=round((PosPredator-1*ArrPreyPopulation[i])*ArrPredPopulation[i]);
      LineTo(ArrPredGraphics[i].x*10+500,ArrPredGraphics[i].y*10+500)
    end;  
  closefile(f);
end.