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

program colorcycle;

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
  WIDTH = 640;
  HEIGHT = 480;

var
  x : Integer = 0;
  background : Tilengine.TBitmap;
  sequence : TSequence;
  sp : TSequencePack;
  engine : TEngine;
  window : TWindow;
  palette : Tilengine.TPalette;

procedure Main;
var
  frame : Integer;
begin
  //Setup engine
  engine := TEngine.Singleton(WIDTH, HEIGHT, 0, 0, 1);

  engine.LoadPath := '../../../assets/color/';

  //Main Loop
  window := TWindow.Singleton('', Ord(TWindowsFlag.VSync));

  //Init assets
  background := Tilengine.TBitmap.FromFile('beach.png');
  //Get Palette
  palette := background.Palette;
  //Load Animation Sequence Pack
  sp := TSequencePack.FromFile('beach.sqx');
  //Find beach sequence
  sequence := sp.Find('beach');
  //Set background bitmap
  engine.BackgroundBitmap := background;
  //Animate palette
  palette.Animate(sequence, True);

  while window.Process do
  begin
    window.DrawFrame(0);
  end;

  Window.Delete;
  Engine.Deinit;
end;

begin
  Main;
end.

