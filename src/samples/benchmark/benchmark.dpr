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

program benchmark;

uses
  {$IFDEF FPC}
  SysUtils,
  {$ELSE}
  System.SysUtils,
  {$ENDIF }
  Tilengine in '..\..\common\Tilengine.pas';

// constants
const
  HRES = 408;
  VRES = 240;
  NUM_SPRITES = 250;
  NUM_FRAMES = 2000;
  VISIBLEWINDOW = True;

var
  pixels : Integer;
  engine : TEngine;
  window : TWindow;

function Profile : Cardinal;
var
  t0, elapse, frame : Word;
begin
  frame := 0;
  t0 := TLN_GetTicks;
  while frame < NUM_FRAMES do
  begin
    Inc(frame);
    TLN_UpdateFrame(frame);
  end;
  if window <> nil then window.DrawFrame(frame);
  elapse := TLN_GetTicks - t0;
  Result := frame * pixels div elapse;
  Writeln(Format('%3u.%03u Mpixels/s', [result div 1000, result mod 1000]));
end;

procedure Main;
var
  c, y, x : Integer;

  tilemap : TTilemap;
  spriteset : TSpriteset;
  spriteinfo : TSpriteInfo;
  framebuffer : TByteArray;
begin
  // Setup engine
  engine := TEngine.Singleton(HRES, VRES, 1, NUM_SPRITES, 0);
  Writeln('Tilengine pascal benchmark tool');
  Writeln('Written by Turric4n based on Megamarc C version');
  Writeln(Format('Library version %d,%d,%d', [(engine.Version shr 16 and $FF), (engine.Version shr 8 and $FF), (engine.Version and $FF)]));

  // Set stack framebuffer (C uses heap with malloc)
  SetLength(framebuffer, hres * vres * 4);
  engine.SetRenderTarget(framebuffer, HRES * 4);
  //engine.DisableBackgroundColor;
  if VISIBLEWINDOW then window := TWindow.Singleton('', TWindowsFlags.Vsync);

  // Create assets
  engine.LoadPath := '../../../assets/tf4';
  tilemap := TTilemap.FromFile('TF4_bg1.tmx', '');
  spriteset := TSpriteset.FromFile('FireLeo');

  // Setup layer
  engine.Layers[0].SetMap(tilemap);
  pixels := HRES * VRES;

  // Benchmark
  Writeln('Normal layer........');
  Profile;

  Writeln('Scaling Layer.......');
  engine.Layers[0].SetScaling(2.0, 2.0);
  Profile;

  Writeln('Affine Layer........');
  engine.Layers[0].SetTransform(45.0, 0.0, 0.0, 1.0, 1.0);
  Profile;

  Writeln('Blend Layer.........');
  engine.Layers[0].Reset;
  engine.Layers[0].BlendMode := TBlend.Mix50;
  Profile;

  Writeln('Scaling blend.......');
  engine.Layers[0].SetScaling(2.0, 2.0);
  Profile;

  Writeln('Affine blend layer..');
  engine.Layers[0].SetTransform(45.0, 0, 0, 1.0, 1.0);
  Profile;

  engine.Layers[0].Disable;

  for c := 0 to NUM_SPRITES - 1 do
  begin
    y := c div 25;
    x := c mod 25;
    engine.Sprites[c].Setup(spriteset, TTileFlags.FNone);
    engine.Sprites[c].Picture := 0;
    engine.Sprites[c].SetPosition(x * 15, y * 21);
  end;
  spriteinfo := spriteset.GetInfo(0);
  pixels := NUM_SPRITES * spriteinfo.W * spriteinfo.H;
  Writeln('Normal Sprites..........');
  Profile;
  Writeln('Colliding Sprites.......');
  for c := 0 to NUM_SPRITES - 1 do engine.Sprites[c].EnableCollision(True);
  Profile;
  tilemap.Free;
  engine.Free;
end;

begin
  try
    Main;
  except
    on e : Exception do Writeln(e.Message);
  end;
  Readln;
end.

