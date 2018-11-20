unit uGlobal;

interface

uses
  uTypes,
  uActorHandler,
  TilengineBindings,
  Tilengine;

// constants
const

  WIDTH  = 400;
  HEIGHT = 240;

  MAX_BULLETS	=	20;
  MAX_ENEMIES	=	10;

  PAL_T0 = 120;
  PAL_T1 = 1000;


  SKYES: array [0..3] of TColor =
  (
     (R : 107; G : 205; B : 255),  //First sky color
     (R : 255; G : 242; B : 167),  //Second sky color
     (R : 131; G :  72; B : 148),  //Third sky color
     (R : 237; G : 219; B : 149)   //Fourth sky color
  );

  BACKGROUNDCOLOR : TColor = (R : 34; G : 136; B : 170);

  RANDOMSEED = 32767;

var
  // singleton instances
  engine : TEngine;
  window : TWindow;
  // raster operations procedure pointer
  callback : TVideocallback;
  sky_hi : TColor;
  sky_lo : TColor;
  pos_foreground : array[0..2] of Integer = (0, 0, 0);
  pos_background : array[0..2] of Integer = (0, 0, 0);
  inc_background : array[0..2] of Integer = (0, 0, 0);
  spritesets : array[0..Ord(TSpritesetType.ssMAX)] of TSpriteset;
  sequencepack : TSequencePack;
  palettes : array[0..Ord(TLayerType.ltMax)] of TPalette;
  layers : array[0..Ord(TLayerType.ltMax)] of TLayer;
  actorhandler : TActorHandler;
  foreground_tileset : TTileset;
  background_tileset : TTileset;
  foreground_tilemap : TTilemap;
  background_tilemap : TTilemap;


implementation

end.
