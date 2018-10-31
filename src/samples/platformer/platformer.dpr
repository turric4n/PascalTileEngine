 {******************************************************************************
*
* Pascal Tilengine sample
* Copyright (c) 2018 coversion by Enrique Fuentes (aka Turric4n) - thanks to
* Marc Palacios for this great project.
* http://www.tilengine.org
*
* This example show a classic sidescroller. It mimics the actual Sega Genesis
* Sonic game. It uses two layers, where the background one has multiple strips
* and a linescroll effect. It also uses color animation for the water cycle
*
******************************************************************************}

program platformer;

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
  HRES = 408;
  VRES = 240;
  NUMBACKGROUNDSTRIPS = 6;

  SKYCOLOR : array [0..1] of TColor =
  (
     (R : $1B; G : $00; B : $8B),  //top color
     (R : $00; G : $74; B : $D7)   //bottom color
  );

  WATERCOLOR : array [0..1] of TColor =
  (
     (R : $24; G : $92; B : $DB),  //top color
     (R : $1F; G : $7F; B : $BE)   //bottom color
  );

var
  // singleton instances
  engine : TEngine;
  window : TWindow;
  // layers
  foreground : TLayer;
  background : TLayer;
  // program variables
  speed : Single;
  PosForeground : Single = 0;
  Callback : TVideocallback;

  // Postitions
  POSBACKGROUND : array [0..NUMBACKGROUNDSTRIPS - 1] of Single = ( 0.000, 0.000, 0.000, 0.000, 0.000, 0.000 );
  INCBACKGROUND : array [0..NUMBACKGROUNDSTRIPS - 1] of Single = ( 0.562, 0.437, 0.375, 0.625, 1.0, 2.0 );

// helper for loading a related tileset + tilemap and configure the appropiate layer
procedure LoadLayer(layer : TLayer; const filename : PAnsiChar);
var
  tilemap : TTilemap;
begin
  tilemap := TTilemap.FromFile(filename, '');
  layer.SetMap(tilemap);
end;

// integer linear interploation
function Lerp(x, x0, x1, fx0, fx1 : Integer) : Integer;
begin
  Result := fx0 + (fx1 - fx0) * (x - x0) div (x1 - x0);
end;

// color interpolation
function InterpolateColor(v, v1, v2 : Integer; const color1, color2 : TColor) : TColor;
begin
  Result.R := Byte(Lerp(v, v1, v2, color1.R, color2.R));
  Result.G := Byte(Lerp(v, v1, v2, color1.G, color2.G));
  Result.B := Byte(Lerp(v, v1, v2, color1.B, color2.B));
end;

// raster effects (virtual HBLANK)
procedure MyRasterEffects(line : Integer); cdecl;
var
  pos : Single;
begin
  pos := -1;
  if line = 1 then pos := posBackground[0]
  else if line = 32 then pos := posBackground[1]
  else if line = 48 then pos := posBackground[2]
  else if line = 64 then pos := posBackground[3]
  else if line = 112 then pos := posBackground[4]
  else if line >= 152 then pos := Lerp(line, 152, 224, Round(posBackground[4]), Round(posBackground[5]));
  if pos <> -1 then background.SetPosition(Round(pos), 0);

  // background color gradients
  if line < 112 then engine.SetBackgroundColor(InterpolateColor(line, 0, 112, skyColor[0], skyColor[1]))
  else if line >= 144 then engine.SetBackgroundColor(InterpolateColor(line, 144, Vres, waterColor[0], waterColor[1]));
end;

procedure ProcessInput;
begin
  if window.GetInput(TInput.Right) then
  begin
    speed := speed + 0.02;
    if speed > 1.0 then speed := 1.0;
  end
  else if speed > 0.0 then
  begin
    speed := speed - 0.2;
    if speed < 0.0 then speed := 0.0;
  end;
  if window.GetInput(TInput.Left) then
  begin
    speed := speed - 0.02;
    if speed < -1.0 then speed := -1.0;
  end
  else if speed < 0.0 then
  begin
    speed := speed + 0.2;
    if speed > 0.0 then speed := 0.0;
  end;
end;

procedure ProcessScroll;
var
  c : Integer;
begin
  posForeground := posForeground + (3 * speed);
  foreground.SetPosition(Round(PosForeground), 0);
  for c := 0 to NumBackgroundStrips - 1 do
    posBackground[c] := posBackground[c] + (incBackground[c] * speed);
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
  engine := TEngine.Singleton(HRES, VRES, 2, 0, 20);
  foreground := engine.Layers[0];
  background := engine.Layers[1];

  // Load Resources
  engine.LoadPath := '../../../assets/sonic/';
  LoadLayer(foreground, 'Sonic_md_fg1.tmx');
  LoadLayer(background, 'Sonic_md_bg1.tmx');

  // Load sequences for animations
  sp := TSequencePack.FromFile('Sonic_md_seq.sqx');
  waterSequence := sp.find('seq_water');
  palette := background.Palette;
  engine.Animations[0].SetPaletteAnimation(palette, waterSequence, true);
  Callback := @MyRasterEffects;
  engine.SetRasterCallback(Callback);

  // Main Loop
  window := TWindow.Singleton('', Ord(TWindowsFlag.Vsync));
  frame := 0;
  while window.Process do
  begin
    ProcessInput;
    ProcessScroll;
    // Render Window
    window.DrawFrame(frame);
    Inc(frame);
  end;
end;

begin
  Main;
end.

