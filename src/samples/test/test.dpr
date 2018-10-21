program test;

uses
  {$IFDEF FPC}
  SysUtils,
  {$ELSE}
  System.SysUtils,
  {$ENDIF }
  Tilengine in '..\..\common\Tilengine.pas';

procedure Main;
var
  engine : TEngine;
  foreground : TTilemap;
  window : TWindow;
  frame : Integer;
begin
  //Setup engine
  engine := TEngine.Singleton(400, 240, 1, 0, 20);
  engine.LoadPath := '../../../../assets/sonic/';
  foreground := TTilemap.FromFile('Sonic_md_fg1.tmx', '');
  engine.Layers[0].SetMap(foreground);
  //Main Loop
  window := TWindow.Singleton('', TWindowsFlags.Vsync);
  frame := 0;
  while window.Process do
  begin
    window.DrawFrame(frame);
    Inc(frame);
  end;
end;

begin
  try
    Main;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

