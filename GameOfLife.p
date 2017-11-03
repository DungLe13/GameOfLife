Program GameOfLife;
uses crt;
const
  size = 25;

type
  cellGenType = array[1..size, 1..size] of char;

procedure initGen0(var currentGen : cellGenType; r, c : integer);
var rand : integer;
begin
  for r := 1 to size do
  begin
    for c := 1 to size do
    begin
      rand := random(2);
      if rand = 0 then
        currentGen[r][c] := '.'     { dead cell }
      else
        currentGen[r][c] := '#';    { alive cell }
    end;
  end;
end;

procedure printCells(currentGen : cellGenType);
var r, c : integer;
begin
  for r := 1 to size do
  begin
    for c := 1 to size do
      write(currentGen[r][c], '  ');
    writeln;
  end;
end;

function countNeighbors(var currentGen : cellGenType; r, c : integer) : integer;
var count : integer;
var above, left, below, right : integer;
begin
  count := 0;
    above := (r+size-1) mod size;  { 1 row above }
    left := (c+size-1) mod size;   { 1 column to the left }
    below := (r+1) mod size;       { 1 row below }
    right := (c+1) mod size;       { 1 column to the right }
    if above = 0 then above := size;
    if left = 0 then left := size;
    if below = 0 then below := size;
    if right = 0 then right := size;

    { Checking for alive neighbor cells }
    if currentGen[above][left] = '#' then count := count + 1;
    if currentGen[above][c] = '#' then count := count + 1;
    if currentGen[r][left] = '#' then count := count + 1;
    if currentGen[r][right] = '#' then count := count + 1;
    if currentGen[below][left] = '#' then count := count + 1;
    if currentGen[below][c] = '#' then count := count + 1;
    if currentGen[above][right] = '#' then count := count + 1;
    if currentGen[below][right] = '#' then count := count + 1;
  countNeighbors := count;
end;

procedure transformGen(var currentGen : cellGenType; r, c : integer);
var nextGen : cellGenType;
var tempGen : cellGenType; { a temporary cell gen so that things don't override }
begin
  tempGen := currentGen;
  for r := 1 to size do
  begin
    for c := 1 to size do
    begin
      if currentGen[r][c] = '#' then { the current cell is alive }
        if (countNeighbors(currentGen, r, c) = 2) or (countNeighbors(currentGen, r, c) = 3) then
        begin
            tempGen[r][c] := '#';
            nextGen[r][c] := tempGen[r][c];
        end
        else
        begin
            tempGen[r][c] := '.';
            nextGen[r][c] := tempGen[r][c];
        end
      else  { the current cell is dead }
        if countNeighbors(currentGen, r, c) = 3 then
        begin
            tempGen[r][c] := '#';
            nextGen[r][c] := tempGen[r][c];
        end
        else
        begin
            tempGen[r][c] := '.';
            nextGen[r][c] := tempGen[r][c];
        end;
    end;
  end;
  currentGen := nextGen;
end;

var iteration : integer;
    gens : integer;
    currentGen : cellGenType;
begin
  randomize;
  writeln('Generation 0:');
  initGen0(currentGen, size, size);
  printCells(currentGen);
  write('How many iterations: ');
  readln(iteration);
  for gens := 1 to iteration do
  begin
      ClrScr;
      gotoxy(1,1);
      writeln('Generation ', gens, ':');
      transformGen(currentGen, size, size);
      printCells(currentGen);
  end;
end.
