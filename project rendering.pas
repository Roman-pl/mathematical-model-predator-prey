Uses GraphAbc;

var
  ArrPredPopulation: array of integer;
  ArrPreyPopulation: array of integer;
  a, b: array of integer;
  c:array of string;
  f: file;
  f2:text;
  i, time: integer;
  s:string;
  PosPredator,PosPrey:real;
begin
  assign(f, 'saved array.bin');
  reset(f);
  i := 0;
  setlength(b,1);
  while not EOF(F) do
  begin
    setlength(a, Length(a) + 1);
    if i=0 then read(f,b[i])
    else
      read(f, a[i]);
    i := i + 1;
  end;
  time:=b[0];
  assign(f2, 'Settings.ini');
  reset(f2);
  while not EOF(F2) do
  begin
    readln(f2,s);
    c:=s.Split('=');
    if c[0] = 'the posibility of death of a predator ' then PosPredator := strtofloat(c[1]);
    if c[0] = 'the posibility of reproduce of a prey ' then PosPrey := strtofloat(c[1]);
  end;
  for i:=0 to time-1 do
  begin
    if i mod 2 =0 then ArrPreyPopulation[i]:=a[i]
    else
      ArrPredPopulation[i]:=a[i];
  end;
  
  writeln(a);
  closefile(f);
end.