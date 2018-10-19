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
  Tilengine in '..\common\Tilengine.pas',
  TilengineLibraryMappings in '..\common\TilengineLibraryMappings.pas';

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
