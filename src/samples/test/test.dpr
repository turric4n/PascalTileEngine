{******************************************************************************
*
* Pascal Tilengine sample
* Copyright (c) 2018 Enrique Fuentes (aka Turric4n) - thanks to Marc Palacios for
*  this great project.
* http://www.tilengine.org
*
* This example show a basic initialization example. Engine, Window and
* foreground tilemap layer with animation.
*
******************************************************************************}

program test;

{$APPTYPE GUI}

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
  window := TWindow.Singleton('', TWindowsFlags.VSync);
  frame := 0;
  while window.Process do
  begin
    window.DrawFrame(frame);
    Inc(frame);
  end;
end;

begin
  Main;
end.

