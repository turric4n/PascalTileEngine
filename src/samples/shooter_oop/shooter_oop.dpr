{******************************************************************************
*
* Pascal Tilengine horizontal shooter sample (OOP aproach)
* Copyright (c) 2018 coversion by Enrique Fuentes (aka Turric4n) - thanks to
* Marc Palacios for this great project.
* http://www.tilengine.org
*
* Complete game example, horizontal scrolling, actors, collisions... OOP
*
******************************************************************************}

program shooter_oop;

uses
  {$IFDEF FPC}
  SysUtils,
  {$ELSE}
  System.SysUtils,
  {$ENDIF }
  TilengineBindings,
  Tilengine,
  uGlobal in 'common\uGlobal.pas',
  uActor in 'common\uActor.pas',
  uTypes in 'common\uTypes.pas',
  uActorHandler in 'common\uActorHandler.pas',
  Entities.Ship in 'entities\Entities.Ship.pas',
  Base.Entity in 'base\Base.Entity.pas',
  Entities.Claw in 'entities\Entities.Claw.pas',
  TilengineUtils in '..\..\common\utils\TilengineUtils.pas',
  RasterEffects in '..\..\common\utils\RasterEffects.pas',
  Entities.Enemy in 'entities\Entities.Enemy.pas',
  Entities.Explosion in 'entities\Entities.Explosion.pas',
  Interfaces.Entity in 'interfaces\Interfaces.Entity.pas',
  Entities.Bullet in 'entities\Entities.Bullet.pas';

var
  gametime : Integer = 0;
  frame : Integer = 0;

// raster effects (virtual HBLANK)
procedure rasterEffects(line : Integer); cdecl;
var
  pos : Integer;
  y : Integer;
  backgroundlayer, foregroundlayer : TLayer;
begin
  backgroundlayer := engine.GetLayer(Ord(TLayerType.ltBackground));
  foregroundlayer := engine.GetLayer(Ord(TLayerType.ltForeground));
  if line < 64 then
  begin
    // Apply sky color gradient
    engine.SetBackgroundColor(InterpolateColor(line, 0, 63, sky_hi, sky_lo));
  end;
  // Foreground
  if line = 32 then backgroundlayer.SetPosition(Round(gametime / 4), 160);
  if line = 64 then
  begin
    // Switch layer again (because clouds are on foreground and mountains on background)
    backgroundlayer.Setup(background_tileset, background_tilemap);
    foregroundlayer.Setup(foreground_tileset, foreground_tilemap);
    backgroundlayer.SetPosition(pos_background[0], 64);
    // Switch palettes again
    foregroundlayer.Palette := palettes[Ord(TLayerType.ltForeground)];
    backgroundlayer.Palette := palettes[Ord(TLayerType.ltBackground)];
    // Move Cloud layer
    foregroundlayer.SetPosition((frame shl 2) div 3, 192 - line);
    foregroundlayer.BlendMode := TBlend.Mix50;
  end;
  // We don't want to draw foreground layer anymore
  if line = 112 then foregroundlayer.Disable;
  if line = 192 then
  begin
    foregroundlayer.BlendMode := TBlend.BNone;
    // Move middle foreground layer clouds and foreground mountains
    foregroundlayer.SetPosition(frame * 10, 448 - line);
  end;
  if line >= 112 then
  begin
    // Water pixel effect
    pos := Lerp(line, 112, 240, pos_background[1], pos_background[2]);
    y := 224 - 112;
    backgroundlayer.SetPosition(pos + TTilengineUtils.CalcSin(line * 5 + frame, 5), y);
  end;
end;

procedure updateSkycolor;
var
  c : Integer;
begin
  // Calculate sky time gradient effect
  if (gametime >= PAL_T0) and (gametime <= PAL_T1) and ((gametime and $07) = 0)  then
  begin
    sky_hi := InterpolateColor(gametime, PAL_T0, PAL_T1, SKYES[0], SKYES[2]);
    sky_lo := InterpolateColor(gametime, PAL_T0, PAL_T1, SKYES[1], SKYES[3]);
  end;
end;

procedure updateScroll;
var
  c : Integer;
  backgroundlayer, foregroundlayer : TLayer;
begin
  // Increment position x of our fixed array
  for c := 0 to 2 do
    Inc(pos_background[c], inc_background[c]);
  // Get engine layers
  foregroundlayer := engine.GetLayer(Ord(TLayerType.ltForeground));
  backgroundlayer := engine.GetLayer(Ord(TLayerType.ltBackground));
  // Switch tilemaps for background and foreground
  backgroundlayer.Setup(foreground_tileset, foreground_tilemap);
  foregroundlayer.Setup(background_tileset, background_tilemap);
  // Update delta position for each layer
  backgroundlayer.SetPosition(Round(time / 3), 160);
  foregroundlayer.SetPosition(pos_background[0], 64);
  // Assign defined palettes for switched layers
  foregroundlayer.Palette := palettes[Ord(TLayerType.ltBackground)];
  backgroundlayer.Palette := palettes[Ord(TLayerType.ltForeground)];
end;

procedure spawnEnemies;
var
  Enemy, Boss : TEntity;
begin
  // Fixed gametime
  if gametime > 100 then
  begin
    // Max random number div 30 remainder result will be in an enemy spawn
    if (Random(RadomSeed) mod 30) = 1 then Enemy := TEnemy.Create(actorhandler, spritesets[Ord(TSpritesetType.ssMain)], sequencepack);
  end
  // boss creation at 600
  else if gametime = 600 then //TODO create boss;
end;

procedure Main;
var
  c : Integer;
  ship : IEntity;
begin
  // Setup engine
  engine := TEngine.Singleton(WIDTH, HEIGHT, Ord(TLayerType.ltMax), Ord(TActorDef.acMAX), Ord(TActorDef.acMAX));
  engine.SetBackgroundColor(BACKGROUNDCOLOR);

  // Assign raster operations callback for each frame scanline (must be fast pixel operations)
  callback := @rasterEffects;
  engine.SetRasterCallback(Callback);

  // Base resource path
  engine.LoadPath := '../../../assets/tf4/';

  // Load Layers
  TTilengineUtils.LoadLayer(engine.GetLayer(Ord(TLayerType.ltBackground)), 'TF4_bg1');
  TTilengineUtils.LoadLayer(engine.GetLayer(Ord(TLayerType.ltForeground)), 'TF4_fg1');

  // Setup background layer
  background_tileset := engine.GetLayer(Ord(TLayerType.ltBackground)).TileSet;
  background_tilemap := engine.GetLayer(Ord(TLayerType.ltBackground)).TileMap;

  // Setup foreground layer
  foreground_tileset :=  engine.GetLayer(Ord(TLayerType.ltForeground)).TileSet;
  foreground_tilemap :=  engine.GetLayer(Ord(TLayerType.ltForeground)).TileMap;


  // Load Spritesets
  spritesets[Ord(TSpritesetType.ssMain)] := TSpriteset.FromFile('FireLeo');
  spritesets[Ord(TSpritesetType.ssHellArm)] := TSpriteset.FromFile('HellArm');

  // Load sequences
  sequencepack := TSequencePack.FromFile('TF4_seq.sqx');

  // Create engine renderer and input logic (AKA SDL)
  window := TWindow.Singleton('', Ord(TWindowsFlag.Vsync) or Ord(TWindowsFlag.Fullscreen));
  window.Title := 'Pascal horizontal shooter demo';

  // Create actor handler
  actorhandler := TActorHandler.Create(engine, window);
  actorhandler.CreateActors(Ord(TActorDef.acMAX));

  // Create entities, entities are logical actor managers
  ship := TShip.Create(actorhandler, spritesets[Ord(TSpritesetType.ssMain)], sequencepack);

  // Inital sky color palette
  sky_hi := skyes[0];
  sky_lo := skyes[1];

  // compute increments for water scroll effect
  inc_background[0] := 1;
  inc_background[1] := 2;
  inc_background[2] := 8;


  // Get layer palettes into global array
  for c := 0 to Ord(TLayerType.ltMax) - 1 do
  begin
    palettes[c] := engine.GetLayer(c).Palette.Clone;
  end;

  Randomize;

  // Main Loop
  while window.Process do
  begin
    // Time keeper
    gametime := frame;
    // Sky palette update by time
    updateSkycolor;
    // Update layer base scroll
    updateScroll;
    // spawn enemies
    spawnEnemies;
    // Update actor tasks
    actorhandler.TaskActors(gametime);
    // Render Window
    window.DrawFrame(gametime);
    // Increment drawn frame
    inc(frame);
  end;
  window.Free;
  engine.Free;
end;

begin
  Main;
end.

