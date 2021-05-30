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

program test2;

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

uses
  {$IFDEF FPC}
  SysUtils,
  {$ELSE}
  System.SysUtils,
  {$ENDIF }
  Tilengine,
  TilengineBindings;

const
  WIDTH = 400;
  HEIGHT = 240;

var
  x : Integer = 0;
  engine : TEngine;
  window : TWindow;

procedure Rasters(Line : Integer);
var
  factor : Single;
begin
  factor := line / 120.0;
  engine.GetLayer(3).SetParallaxFactor(-factor, 1);
end;

procedure Main;
var
  frame : Integer;
begin
  //Setup engine
  engine := TEngine.Singleton(WIDTH, HEIGHT, 8, 80, 0);

  engine.LoadPath := '../../../assets/forest/';

  engine.LoadWorld('map.tmx');

  engine.SetRasterCallback(@Rasters);

  //Main Loop
  window := TWindow.Singleton('', Ord(TWindowsFlag.VSync));
  frame := 0;
  while window.Process do
  begin
    engine.SetWorldPosition(x, 0);
    window.DrawFrame(frame);
    Inc(frame);
    Inc(x, 2);
  end;

  Window.Delete;
  Engine.Deinit;
end;

begin
  Main;
end.

