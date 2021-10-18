var
ArrPredPopulation:array of integer;
ArrPreyPopulation:array of integer;
a,b:array of integer;
f:file;
i,time:integer;
begin
  assign(f,'saved array.bin');
  reset(f);
  i:=0;
  while not EOF(F) do
  begin
    f.ReadInteger().Print;
  end;
  //writeln(a,b);
  closefile(f);
end.