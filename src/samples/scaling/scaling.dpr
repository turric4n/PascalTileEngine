{******************************************************************************
*
* Pascal Tilengine scaling sample
* Copyright (c) 2018 coversion by Enrique Fuentes (aka Turric4n) - thanks to
* Marc Palacios for this great project.
* http://www.tilengine.org
*
* This example show two layers (Background and Foreground) layers that can be
* scrolled and scaled without using linear interpolation technique.
*
******************************************************************************}

program scaling;

uses
  {$IFDEF FPC}
  SysUtils,
  {$ELSE}
  System.SysUtils,
  {$ENDIF }
  TilengineBindings in '..\..\common\bindings\TilengineBindings.pas',
  Tilengine in '..\..\common\Tilengine.pas';

// constants
const
  HRES = 400;
  VRES = 240;
  MIN_SCALE = 50;
  MAX_SCALE = 200;
  NUM_LAYERS = 2;
  NUMBACKGROUNDSTRIPS = 6;

  SKYCOLOR : array [0..1] of TColor =
  (
     (R : $19; G : $54; B : $75),  //top color
     (R : $2C; G : $B0; B : $DC)   //bottom color
  );

  BACKGROUNDCOLOR : TColor = (R : 34; G : 136; B : 170);

var
  // singleton instances
  engine : TEngine;
  window : TWindow;
  // layers
  foreground : TLayer;
  background : TLayer;
  // program variables
  xpos, ypos : Integer;
  fgscale, bgscale : Single;
  bgypos : Integer;
  maxy : Integer;
  scale : Integer;
  speed : Single;
  Callback : TVideocallback;

// helper for loading a related tileset + tilemap and configure the appropiate layer
procedure LoadLayer(layer : TLayer; const filename : PAnsiChar);
var
  tilemap : TTilemap;
begin
  tilemap := TTilemap.FromFile(filename, '');
  layer.SetMap(tilemap);
end;

// integer linear interploation
function Lerp(x, x0, x1, fx0, fx1 : Single) : Single; overload; inline;
begin
  Result := (fx0) + ((fx1) - (fx0))*((x) - (x0))/((x1) - (x0));
end;

function Lerp(x, x0, x1, fx0, fx1 : Integer) : Integer; overload; inline;
begin
  Result := (fx0) + ((fx1) - (fx0))*((x) - (x0))div((x1) - (x0));
end;

// color interpolation
function InterpolateColor(v, v1, v2 : Integer; const color1, color2 : TColor) : TColor; inline;
begin
  Result.R := Byte(Lerp(v, v1, v2, color1.R, color2.R));
  Result.G := Byte(Lerp(v, v1, v2, color1.G, color2.G));
  Result.B := Byte(Lerp(v, v1, v2, color1.B, color2.B));
end;

// raster effects (virtual HBLANK)
procedure MyRasterEffects(line : Integer); cdecl; inline;
var
  color : TColor;
begin
  if line <= 152 then
  begin
    color.R := Lerp(line, 0, 152, SKYCOLOR[0].R, SKYCOLOR[1].R);
    color.G := Lerp(line, 0, 152, SKYCOLOR[0].G, SKYCOLOR[1].G);
    color.B := Lerp(line, 0, 152, SKYCOLOR[0].B, SKYCOLOR[1].B);
    engine.SetBackgroundColor(color);
  end;
end;

procedure ProcessInput;
begin
  if window.GetInput(TInput.Left) then Dec(xpos);
  if window.GetInput(TInput.Right) then Inc(xpos);
  if window.GetInput(TInput.Up) and (ypos > 0) then Dec(ypos);
  if window.GetInput(TInput.Down) then Inc(ypos);
  if window.GetInput(TInput.Button_A) and (scale < MAX_SCALE) then Inc(scale);
  if window.GetInput(TInput.Button_B) and (scale > MIN_SCALE) then Dec(scale);
end;

procedure ProcessScaling;
begin
  fgscale := scale / 100.0;
  bgscale := Lerp(Single(scale), Single(MIN_SCALE), Single(MAX_SCALE), 0.75, 1.5);
  maxy := 640 - (240 *100 div scale);
  if ypos > maxy then ypos := maxy;
end;

procedure ProcessScroll;
begin
  bgypos := Lerp(scale, MIN_SCALE, MAX_SCALE, 0, 80);
  foreground.SetPosition(xpos * 2, ypos);
  background.SetPosition(xpos, bgypos);
  foreground.SetScaling(fgscale, fgscale);
  background.SetScaling(bgscale, bgscale);
end;

procedure Main;
var
  c : Integer;
  frame : Integer;
  sp : TSequencePack;
  waterSequence : TSequence;
  palette : TPalette;
begin
  // Setup engine
  engine := TEngine.Singleton(HRES, VRES, NUM_LAYERS, 0, 0);
  engine.SetBackgroundColor(BACKGROUNDCOLOR);
  callback := @MyRasterEffects;
  engine.SetRasterCallback(Callback);
  foreground := engine.GetLayer(0);
  background := engine.GetLayer(1);

  // Load Resources
  engine.LoadPath := '../../../assets/fox/';
  LoadLayer(foreground, 'psycho.tmx');
  LoadLayer(background, 'rolo.tmx');

  // Initial values
  xpos := 0;
  ypos := 192;
  scale := 100;

  // Main Loop
  window := TWindow.Singleton('', Ord(TWindowsFlag.Vsync));
  frame := 0;
  while window.Process do
  begin
    ProcessInput;
    ProcessScaling;
    ProcessScroll;
    // Render Window
    window.DrawFrame(frame);
    Inc(frame);
  end;
  foreground.Free;
  background.Free;
  window.Free;
  engine.Free;
end;

begin
  Main;
end.

