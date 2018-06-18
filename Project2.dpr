program Project2;

{$APPTYPE CONSOLE}

uses
  SysUtils, Windows;

type
  Ptree = ^Ttree;

  Ttree = record
    Key: integer;
    Left,Right: Ptree;
    frec: integer;
    end;
var
  tree: Ptree;
  F: TextFile;
  x,key,i: integer;

//Добавление элементов в дерево
Procedure addToTree(var tree: Ptree; x: Integer);
begin
  if tree = nil then
  begin
    New(tree);
    tree.Key:= x;
    tree.Left:= nil;
    tree.Right:= nil;
    tree.frec:= 0;
  end
  else
    begin
      if x < tree.Key then
        addToTree(tree^.Left, x)
      else
        addToTree(tree^.Right, x);
    end;
end;

//Чтение данных из файла
Procedure DownloadFile;
begin
  AssignFile(F, 'TreeFile.txt');
  reset(f);
  while not Eof(F) do
  begin
    Readln(F, x);
    addToTree(tree, x);
  end;
end;

//Вывод дерева
Procedure PrintTree(Var Curr: Ptree);
begin
  if Curr <> nil then
  begin
    write(Curr^.Key,'   ');
    PrintTree(Curr^.Left);
    PrintTree(Curr^.Right);
  end;
end;

//процедура удаления поддерева из дерева
procedure DeleteTree(adr: PTree);
begin
  if adr <> nil then
  begin
    if adr^.left <> nil then
    DeleteTree(adr^.left);
    if adr^.right <> nil then
    DeleteTree(adr^.right);
  dispose(adr);
  end;
end;

//Поиск заданного ключа
function poiskKlucha(var adr: PTree; num: integer): PTree;
  var
    temp: PTree;
    bool: Boolean;
  begin
    result:= nil;
    temp:= adr;
    if temp^.Key = num then
    begin
      Result:= temp;
      adr:= nil;
    end
    else
    begin
      bool:= True;
      while  (temp <> nil) and (temp^.Key <> num) and (bool = True) do
      begin
        if (temp^.left <> nil) and (temp^.Left^.Key = num) then
        begin
          Result:= temp;
          deleteTree(temp^.Left);
          temp^.left:= nil;
          bool:= False;
        end;
        if (temp^.right <> nil) and (temp^.Right^.Key = num) then
        begin
          deleteTree(temp^.Right);
          temp^.right:= nil;
          Result:= temp;
          bool:= False;
        end;
        if temp^.Key < num then
          temp:= temp^.right
        else
          temp:= temp^.left;
      end;
    end;
  end;

begin
SetConsoleCP(1251);
SetConsoleOutputCP(1251);
DownloadFile;
writeln('Дерево:');
PrintTree(tree);
writeln;
repeat
  writeln;
  write('Удалить - 1, выход - 0: ');
  readln(i);
  if i=1 then
  begin
    writeln;
    PrintTree(tree);
    writeln;
    write('Введите корень удаляемого поддерева: ');
    readln(Key);
    poiskKlucha(tree,Key);
    writeln;
    PrintTree(tree);
  end
  else i:=0;
  if tree = nil then
    writeln('Все элементы дерева удалены!!!');
until (i=0) or (tree=nil);
readln;
end.
