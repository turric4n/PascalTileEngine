program TilengineProject;

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

uses
  {$IFDEF FPC}
  SysUtils,
  {$ELSE}
  System.SysUtils,
  {$ENDIF }
  Tilengine in '..\..\common\Tilengine.pas',
  TilengineBindings in '..\..\common\bindings\TilengineBindings.pas';

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
    Writeln('Tilengine pascal Wrapper is compiled succesfully');
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
