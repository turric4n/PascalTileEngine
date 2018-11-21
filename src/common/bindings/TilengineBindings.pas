unit TilengineBindings;

interface

{$IFDEF FPC}
  uses
    Sysutils;
{$ENDIF}

const
  //Binary dependancies
 {$IFDEF LINUX}
   LIB = 'libTilengine.so';
 {$ENDIF}
 {$IFDEF ANDROID}
   LIB = 'libTilengine.so';
 {$ENDIF}
 {$IFDEF DARWIN}
   LIB = 'Tilengine.dylib';
 {$ENDIF}
 {$IFDEF MSWINDOWS}
   LIB = 'Tilengine.dll';
 {$ENDIF}

type

{$IFDEF NEXTGEN}
  PAnsiChar = System.MarshaledString;
{$ENDIF}

  /// <summary>
  /// Tile data contained in each cell of a cref="Tilemap" object
  /// </summary>
  TTile = record
    Index : Word;
    Flags : Word;
  end;

  PTile = ^TTile;

  /// <summary>
  /// List of possible exception error codes
  /// </summary>
  TError = (
    Ok,
    OutOfMemory,
    IdxLayer,
    IdxSprite,
    IdxAnimation,
    IdxPicture,
    RefTileset,
    RefTilemap,
    RefSpriteset,
    RefPalette,
    RefSequence,
    RefSequencePack,
    RefBitmap,
    NullPointer,
    FileNotFound,
    WrongFormat,
    WrongSize,
    Unsupported,
    MaxError
  );

  /// <summary>
  /// List of flag values for window creation
  /// </summary>
  TWindowsFlag = (
    Fullscreen = (1 shl 0),
    Vsync = (1 shl 1),
    S1 = (1 shl 2),
    S2 = (2 shl 2),
    S3 = (3 shl 2),
    S4 = (4 shl 2),
    S5 = (5 shl 2),
    Nearest	= (1 shl 6) // unfiltered upscaling
  );

  /// <summary>
  /// Player index for input assignment functions
  /// </summary>
  TPlayer = (
    P1,
    P2,
    P3,
    P4
  );

  /// <summary>
  /// Standard inputs query for cref="Window.GetInput()"
  /// </summary>
  TInput = (
    None,
    Up,
    Down,
    Left,
    Right,
    Button1,
    Button2,
    Button3,
    Button4,
    Button5,
    Button6,
    Start,
    //Pascal limitations here :(
    IP1 = (0 shl 4), // request player 1 input (default)
    IP2 = (1 shl 4), // request player 2 input
    IP3 = (2 shl 4), // request player 3 input
    IP4 = (3 shl 4), // request player 4 input
    // compatibility symbols for pre-1.18 input model
    Button_A = Button1,
    Button_B = Button2,
    Button_C = Button3,
    Button_D = Button4,
    Button_E = Button5,
    Button_F = Button6
  );

  /// <summary>
  /// Available blending modes for cref="Layer" and cref="Sprite"
  /// </summary>
  TBlend = (
    BNone,
    Mix25,
    Mix50,
    Mix75,
    Add,
    Sub,
    Modulus,
    Custom,
    Mix = Mix50
  );

  /// <summary>
  /// List of flags for tiles and sprites
  /// </summary>
  TTileFlags = (
    FNone = (0),
    FlipX = (1 shl 15),
    FlipY = (1 shl 14),
    Rotate = (1 shl 13),
    Priority = (1 shl 12)
  );

  /// <summary>
  /// Data used to create cref="Spriteset" objects
  /// </summary>
  TSpriteData = record
    Name : PAnsiChar;
    X : Integer;
    Y : Integer;
    W : Integer;
    H : Integer;
  end;

  PSpriteData = ^TSpriteData;

  /// <summary>
  /// Data returned by cref="Spriteset.GetSpriteInfo" with dimensions of the requested sprite
  /// </summary>
  TSpriteInfo = record
    W : Integer;
    H : Integer;
  end;

  PSpriteInfo = ^TSpriteInfo;

  /// <summary>
  /// Data returned by cref="Layer.GetTile" about a given tile inside a background layer
  /// </summary>
  TTileInfo = record
    Index : Word;
    Flags : Word;
    Row : Integer;
    Col : Integer;
    Xoffset : Integer;
    Yoffset : Integer;
    Color : Byte;
    Typ : Byte;
    Empty : Boolean;
  end;

  PTileInfo = ^TTileInfo;

  /// <summary>
  /// cref="Tileset" attributes for constructor
  /// </summary>
  TTileAtributes = record
    Typ : Byte;
    Priority : Boolean;
  end;

  PTileAtributes = ^TTileAtributes;

  /// <summary>
  /// Data used to define each frame of an animation for cref="Sequence" objects
  /// </summary>
  TSequenceFrame = record
    Index : Integer;
    Delay : Integer;
  end;

  PSquenceFrame = ^TSequenceFrame;

  TColorStrip = record
    Delay : Integer;
    First : Byte;
    Count : Byte;
    Dir : Byte;
  end;

  PColorStrip = ^TColorStrip;

  /// <summary>
  /// Sequence info returned by cref="Sequence.GetInfo"
  /// </summary>
  TSequenceInfo = record
    Name : PAnsiChar;
    NumFrames : Integer;
  end;

  PSequenceInfo = ^TSequenceInfo;

  /// <summary>
  /// Represents a color value in RGB format
  /// </summary>
  ///
  ///  Delphi haven't structure or record constructor it's a feature I don't like
  TColor = record
    R,G,B : Byte;
  end;

  PColor = ^TColor;

  /// <summary>
  /// overlays for CRT effect
  /// </summary>
	TOverlay = (
		Non,
		ShadowMask,
		Aperture,
		Scanlines,
		Custm
	);

  /// <summary>
  /// pixel mapping for cref="Layer.SetPixelMapping"
  /// </summary>
  TPixelMap = record
    dx, dy : Word;
  end;

  PPixelMap = ^TPixelMap;

  /// <summary>
  // TLN Library Bindings don't use these externals directly
  // ENGINE BINDINGS
  /// </summary>

  function TLN_Init(hres, vres, numlayers, numsprites, numanimations : Integer) : Boolean; cdecl; external LIB name 'TLN_Init';
  procedure TLN_Deinit cdecl; external LIB name 'TLN_Deinit';
  function TLN_GetWidth : Integer; cdecl; external LIB name 'TLN_GetWidth';
  function TLN_GetHeight : Integer; cdecl; external LIB name 'TLN_GetHeight';
  function TLN_GetNumObjects : UInt32; cdecl; external LIB name 'TLN_GetNumObjects';
  function TLN_GetUsedMemory : UInt32; cdecl; external LIB name 'TLN_GetUsedMemory';
  function TLN_GetVersion : UInt32; cdecl; external LIB name 'TLN_GetVersion';
  function TLN_GetNumLayers : Integer; cdecl; external LIB name 'TLN_GetNumLayers';
  function TLN_GetNumSprites : Integer; cdecl; external LIB name 'TLN_GetNumSprites';
  procedure TLN_SetBGColor(r, g, b : Byte) cdecl; external LIB name 'TLN_SetBGColor';
  function TLN_SetBGColorFromTilemap(tilemap : PInteger) : Boolean; cdecl; external LIB name 'TLN_SetBGColorFromTilemap';
  procedure TLN_DisableBGColor cdecl; external LIB name 'TLN_DisableBGColor';
  function TLN_SetBGBitmap(bitmap : PInteger) : Boolean; cdecl; external LIB name 'TLN_SetBGBitmap';
  function TLN_SetBGPalette(palette : PInteger) : Boolean; cdecl; external LIB name 'TLN_SetBGPalette';
  procedure TLN_SetRasterCallback(callback : Pointer) cdecl; external LIB name 'TLN_SetRasterCallback';
  procedure TLN_SetFrameCallback(callback : Pointer) cdecl; external LIB name 'TLN_SetFrameCallback';
  procedure TLN_SetRenderTarget(data : TArray<Byte>; pitch : Integer) cdecl; external LIB name 'TLN_SetRenderTarget';
  procedure TLN_UpdateFrame(time : Integer) cdecl; external LIB name 'TLN_UpdateFrame';
  procedure TLN_BeginFrame(frame : Integer) cdecl; external LIB name 'TLN_BeginFrame';
  function TLN_DrawNextScanline : Boolean; cdecl; external LIB name 'TLN_DrawNextScanline';
  procedure TLN_SetLastError(error : TError) cdecl; external LIB name 'TLN_SetLastError';
  function TLN_GetLastError : TError; cdecl; external LIB name 'TLN_GetLastError';
  function TLN_GetErrorString(error : TError) : PAnsiChar; cdecl; external LIB name 'TLN_GetErrorString';
  function TLN_GetAvailableSprite : Integer; cdecl; external LIB name 'TLN_GetAvailableSprite';
  procedure TLN_SetLoadPath(path : PAnsiChar) cdecl; external LIB name 'TLN_SetLoadPath';
  procedure TLN_SetCustomBlendFunction(customfunction : Pointer) cdecl; external LIB name 'TLN_SetCustomBlendFunction';
  function TLN_CreateWindow(const overlay : PAnsiChar; flags : Integer) : Boolean; cdecl; external LIB name 'TLN_CreateWindow';
  function TLN_CreateWindowThread(const overlay : PAnsiChar; flags : Integer) : Boolean; cdecl; external LIB name 'TLN_CreateWindowThread';
  procedure TLN_SetWindowTitle(const title : PAnsiChar) cdecl; external LIB name 'TLN_SetWindowTitle';
  function TLN_ProcessWindow : Boolean; cdecl; external LIB name 'TLN_ProcessWindow';
  function TLN_IsWindowActive : Boolean; cdecl; external LIB name 'TLN_IsWindowActive';
  function TLN_GetInput(id : PInteger) : Boolean; cdecl; external LIB name 'TLN_GetInput';
  procedure TLN_EnableInput(player : PInteger; enable : Boolean) cdecl; external LIB name 'TLN_EnableInput';
  procedure TLN_AssignInputJoystick(player : PInteger; index : Integer) cdecl; external LIB name 'TLN_AssignInputJoystick';
  procedure TLN_DefineInputKey(player : PInteger; input : PInteger; keycode : Integer) cdecl; external LIB name 'TLN_DefineInputKey';
  procedure TLN_DefineInputButton(player : PInteger; input : PInteger; joybutton : Byte) cdecl; external LIB name 'TLN_DefineInputButton';
  procedure TLN_DrawFrame(time : Integer) cdecl; external LIB name 'TLN_DrawFrame';
  procedure TLN_WaitRedraw cdecl; external LIB name 'TLN_WaitRedraw';
  procedure TLN_DeleteWindow cdecl; external LIB name 'TLN_DeleteWindow';
  procedure TLN_EnableCRTEffect(overlay : TOverlay; overlay_factor, threshold, v0, v1, v2, v3 : Byte;
  blur, glow_factor : Byte) cdecl; external LIB name 'TLN_EnableCRTEffect';
  procedure TLN_DisableCRTEffect cdecl; external LIB name 'TLN_DisableCRTEffect';
  procedure TLN_Delay(msecs : Word) cdecl; external LIB name 'TLN_Delay';
  function TLN_GetTicks : Word cdecl; external LIB name 'TLN_GetTicks';
  procedure TLN_BeginWindowFrame(frame : Integer) cdecl; external LIB name 'TLN_BeginWindowFrame';
  procedure TLN_EndWindowFrame cdecl; external LIB name 'TLN_EndWindowFrame';
  function TLN_SetLayer(nlayer : Integer; tileset, tilemap : PInteger) : Boolean; cdecl; external LIB name 'TLN_SetLayer';
  function TLN_SetLayerPalette(nlayer : Integer; tilemap : PInteger) : Boolean; cdecl; external LIB name 'TLN_SetLayerPalette';
  function TLN_SetLayerBitmap(nlayer : Integer; bitmap : PInteger) : Boolean; cdecl; external LIB name 'TLN_SetLayerBitmap';
  function TLN_SetLayerPosition(nlayer, hstart, vstart : Integer) : Boolean; cdecl; external LIB name 'TLN_SetLayerPosition';
  function TLN_SetLayerScaling(nlayer : Integer; xfactor, yfactor : Single) : Boolean; cdecl; external LIB name 'TLN_SetLayerScaling';
  function TLN_SetLayerTransform(nlayer : Integer; angle, dx, dy, sx, sy : Single) : Boolean; cdecl; external LIB name 'TLN_SetLayerTransform';
  function TLN_SetLayerPixelMapping(nlayer : Integer; table : TArray<TPixelMap>) : Boolean; cdecl; external LIB name 'TLN_SetLayerPixelMapping';
  function TLN_SetLayerBlendMode(nlayer : Integer; mode : PInteger; factor : Byte) : Boolean; cdecl; external LIB name 'TLN_SetLayerBlendMode';
  function TLN_SetLayerColumnOffset(nlayer : Integer; offset : TArray<Integer>) : Boolean; cdecl; external LIB name 'TLN_SetLayerColumnOffset';
  function TLN_SetLayerClip(nlayer, x1, y1, x2, y2 : Integer) : Boolean; cdecl; external LIB name 'TLN_SetLayerClip';
  function TLN_DisableLayerClip(nlayer : Integer) : Boolean; cdecl; external LIB name 'TLN_DisableLayerClip';
  function TLN_SetLayerMosaic(nlayer, width, height : Integer) : Boolean; cdecl; external LIB name 'TLN_SetLayerMosaic';
  function TLN_DisableLayerMosaic(nlayer : Integer) : Boolean; cdecl; external LIB name 'TLN_DisableLayerMosaic';
  function TLN_ResetLayerMode(nlayer : Integer) : Boolean; cdecl; external LIB name 'TLN_ResetLayerMode';
  function TLN_DisableLayer(nlayer : Integer) : Boolean; cdecl; external LIB name 'TLN_DisableLayer';
  function TLN_GetLayerPalette(nlayer : Integer) : PInteger; cdecl; external LIB name 'TLN_GetLayerPalette';
  function TLN_GetLayerTile(nlayer, x, y : Integer; out info : TTileInfo) : Boolean; cdecl; external LIB name 'TLN_GetLayerTile';
  function TLN_GetLayerWidth(nlayer : Integer) : Integer; cdecl; external LIB name 'TLN_GetLayerWidth';
  function TLN_GetLayerHeight(nlayer : Integer) : Integer; cdecl; external LIB name 'TLN_GetLayerHeight';
  function TLN_ConfigSprite(nsprite : Integer; spriteset : PInteger; flags : PInteger) : Boolean; cdecl; external LIB name 'TLN_ConfigSprite';
  function TLN_SetSpriteSet(nsprite : Integer; spriteset : PInteger) : Boolean; cdecl; external LIB name 'TLN_SetSpriteSet';
  function TLN_SetSpriteFlags(nsprite : Integer; flags : PInteger) : Boolean; cdecl; external LIB name 'TLN_SetSpriteFlags';
  function TLN_SetSpritePosition(nsprite, x, y : Integer) : Boolean; cdecl; external LIB name 'TLN_SetSpritePosition';
  function TLN_SetSpritePicture(nsprite, entry : Integer) : Boolean; cdecl; external LIB name 'TLN_SetSpritePicture';
  function TLN_SetSpritePalette(nsprite : Integer; Palette : PInteger) : Boolean; cdecl; external LIB name 'TLN_SetSpritePalette';
  function TLN_SetSpriteBlendMode(nsprite : Integer; mode : PInteger; factor : Byte) : Boolean; cdecl; external LIB name 'TLN_SetSpriteBlendMode';
  function TLN_SetSpriteScaling(nsprite : Integer; sx, sy : Single) : Boolean; cdecl; external LIB name 'TLN_SetSpriteScaling';
  function TLN_ResetSpriteScaling(nsprite : Integer) : Boolean; cdecl; external LIB name 'TLN_ResetSpriteScaling';
  function TLN_GetSpritePicture(nsprite : Integer) : Integer; cdecl; external LIB name 'TLN_GetSpritePicture';
  function TLN_EnableSpriteCollision(nsprite : Integer; enable : Boolean) : Boolean; cdecl; external LIB name 'TLN_EnableSpriteCollision';
  function TLN_GetSpriteCollision(nsprite : Integer) : Boolean; cdecl; external LIB name 'TLN_GetSpriteCollision';
  function TLN_DisableSprite(nsprite : Integer) : Boolean; cdecl; external LIB name 'TLN_DisableSprite';
  function TLN_GetSpritePalette(nsprite : Integer) : PInteger; cdecl; external LIB name 'TLN_GetSpritePalette';
  function TLN_SetPaletteAnimation(index : Integer; palette, sequence : PInteger; blend : Boolean) : Boolean; cdecl; external LIB name 'TLN_SetPaletteAnimation';
  function TLN_SetPaletteAnimationSource(index : Integer; palette : PInteger) : Boolean; cdecl; external LIB name 'TLN_SetPaletteAnimationSource';
  function TLN_SetTilemapAnimation(index, nlayer : Integer; sequence : PInteger) : Boolean; cdecl; external LIB name 'TLN_SetTilemapAnimation';
  function TLN_SetTilesetAnimation(index, nlayer : Integer; sequence : PInteger) : Boolean; cdecl; external LIB name 'TLN_SetTilesetAnimation';
  function TLN_SetSpriteAnimation(index, nlayer : Integer; sequence : PInteger; loop : Integer) : Boolean; cdecl; external LIB name 'TLN_SetSpriteAnimation';
  function TLN_GetAnimationState(index : Integer) : Boolean; cdecl; external LIB name 'TLN_GetAnimationState';
  function TLN_SetAnimationDelay(index, delay : Integer) : Boolean; cdecl; external LIB name 'TLN_SetAnimationDelay';
  function TLN_GetAvailableAnimation : Integer; cdecl; external LIB name 'TLN_GetAvailableAnimation';
  function TLN_DisableAnimation(index : Integer) : Boolean; cdecl; external LIB name 'TLN_DisableAnimation';
  function TLN_CreateSpriteset(bitmap : PInteger; rects : TArray<TSpriteData>; entries : Integer) : PInteger; cdecl; external LIB name 'TLN_CreateSpriteset';
  function TLN_LoadSpriteset(name : PAnsiChar) : PInteger; cdecl; external LIB name 'TLN_LoadSpriteset';
  function TLN_CloneSpriteset(src : PInteger) : PInteger; cdecl; external LIB name 'TLN_CloneSpriteset';
  function TLN_GetSpriteInfo(spriteset : PInteger; entry : Integer; info : PSpriteInfo) : Boolean; cdecl; external LIB name 'TLN_GetSpriteInfo';
  function TLN_GetSpritesetPalette(spriteset : PInteger) : PInteger; cdecl; external LIB name 'TLN_GetSpritesetPalette';
  function TLN_FindSpritesetSprite(spriteset : PInteger; name : PAnsiChar) : Integer; cdecl; external LIB name 'TLN_FindSpritesetSprite';
  function TLN_SetSpritesetData(spriteset : PInteger; entry : Integer; data : TArray<TSpriteData>; pixels : PInteger; pitch : Integer) : Boolean; cdecl; external LIB name 'TLN_SetSpritesetData';
  function TLN_DeleteSpriteset(spriteset : PInteger) : Boolean; cdecl; external LIB name 'TLN_SetSpritesetData';
  function TLN_CreateTileset(numtiles, width, height : Integer; palette, sequencepack : PInteger; attributes : TArray<TTileAtributes>) : PInteger; cdecl; external LIB name 'TLN_CreateTileset';
  function TLN_LoadTileset(filename : PAnsiChar) : PInteger; cdecl; external LIB name 'TLN_LoadTileset';
  function TLN_CloneTileset(src : PInteger) : PInteger; cdecl; external LIB name 'TLN_CloneTileset';
  function TLN_CopyTile(tileset : PInteger; src, dst : Integer) : Boolean; cdecl; external LIB name 'TLN_CopyTile';
  function TLN_SetTilesetPixels(tileset : PInteger; entry : Integer; srcdata : TArray<Byte>; srcpitch : Integer) : Boolean; cdecl; external LIB name 'TLN_SetTilesetPixels';
  function TLN_GetTileWidth(tileset : PInteger) : Integer; cdecl; external LIB name 'TLN_GetTileWidth';
  function TLN_GetTileHeight(tileset : PInteger) : Integer; cdecl; external LIB name 'TLN_GetTileHeight';
  function TLN_GetTilesetPalette(tileset : PInteger) : PInteger; cdecl; external LIB name 'TLN_GetTilesetPalette';
  function TLN_GetTilesetSequencePack(tileset : PInteger) : PInteger; cdecl; external LIB name 'TLN_GetTilesetSequencePack';
  function TLN_DeleteTileset(tileset : PInteger) : Boolean; cdecl; external LIB name 'TLN_DeleteTileset';
  function TLN_CreateTilemap(rows, cols : Integer; tiles : TArray<TTile>; bgcolor : Word; tileset : PInteger) : PInteger; cdecl; external LIB name 'TLN_CreateTilemap';
  function TLN_LoadTilemap(filename, layername : PAnsiChar) : PInteger; cdecl; external LIB name 'TLN_LoadTilemap';
  function TLN_CloneTilemap(src : PInteger) : PInteger; cdecl; external LIB name 'TLN_CloneTilemap';
  function TLN_GetTilemapRows(tilemap : PInteger) : Integer; cdecl; external LIB name 'TLN_GetTilemapRows';
  function TLN_GetTilemapCols(tilemap : PInteger) : Integer; cdecl; external LIB name 'TLN_GetTilemapCols';
  function TLN_GetTilemapTileset(tilemap : PInteger) : PInteger; cdecl; external LIB name 'TLN_GetTilemapTileset';
  function TLN_GetTilemapTile(tilemap : PInteger; row, col : Integer; tile : PTile) : Boolean; cdecl; external LIB name 'TLN_GetTilemapTile';
  function TLN_SetTilemapTile(tilemap : PInteger; row, col : Integer; tile : PTile) : Boolean; cdecl; external LIB name 'TLN_SetTilemapTile';
  function TLN_CopyTiles(src : PInteger; srcrow, srccol, rows, cols : Integer; dst : PInteger; dstrow, dscol : Integer) : Boolean; cdecl; external LIB name 'TLN_CopyTiles';
  function TLN_DeleteTilemap(tilemap : PInteger) : Boolean; cdecl; external LIB name 'TLN_DeleteTilemap';
  function TLN_CreatePalette(entries : Integer) : PInteger; cdecl; external LIB name 'TLN_CreatePalette';
  function TLN_LoadPalette(filename : PAnsiChar) : PInteger; cdecl; external LIB name 'TLN_LoadPalette';
  function TLN_ClonePalette(src : PInteger) : PInteger; cdecl; external LIB name 'TLN_ClonePalette';
  function TLN_SetPaletteColor(palette : PInteger; index : Integer; r, g, b : Byte) : Boolean; cdecl; external LIB name 'TLN_SetPaletteColor';
  function TLN_MixPalettes(src1, src2, dst : PInteger; factor : Byte) : Boolean; cdecl; external LIB name 'TLN_MixPalettes';
  function TLN_AddPaletteColor(palette : PInteger; r, g, b, start, num : Byte) : Boolean; cdecl; external LIB name 'TLN_AddPaletteColor';
  function TLN_SubPaletteColor(palette : PInteger; r, g, b, start, num : Byte) : Boolean; cdecl; external LIB name 'TLN_SubPaletteColor';
  function TLN_ModPaletteColor(palette : PInteger; r, g, b, start, num : Byte) : Boolean; cdecl; external LIB name 'TLN_ModPaletteColor';
  function TLN_GetPaletteData(palette : PInteger; index : Integer) : PInteger; cdecl; external LIB name 'TLN_ModPaletteColor';
  function TLN_DeletePalette(palette : PInteger) : Boolean; cdecl; external LIB name 'TLN_DeletePalette';
  function TLN_CreateBitmap(width, height, bpp : Integer) : PInteger; cdecl; external LIB name 'TLN_CreateBitmap';
  function TLN_LoadBitmap(filename : PAnsiChar) : PInteger; cdecl; external LIB name 'TLN_LoadBitmap';
  function TLN_CloneBitmap(src : PInteger) : PInteger; cdecl; external LIB name 'TLN_CloneBitmap';
  function TLN_GetBitmapWidth(bitmap : PInteger) : Integer; cdecl; external LIB name 'TLN_GetBitmapWidth';
  function TLN_GetBitmapHeight(bitmap : PInteger) : Integer; cdecl; external LIB name 'TLN_GetBitmapHeight';
  function TLN_GetBitmapDepth(bitmap : PInteger) : Integer; cdecl; external LIB name 'TLN_GetBitmapHeight';
  function TLN_GetBitmapPitch(bitmap : PInteger) : Integer; cdecl; external LIB name 'TLN_GetBitmapPitch';
  function TLN_GetBitmapPtr(bitmap : PInteger; x, y : Integer) : PInteger; cdecl; external LIB name 'TLN_GetBitmapPtr';
  function TLN_GetBitmapPalette(bitmap : PInteger) : PInteger; cdecl; external LIB name 'TLN_GetBitmapPalette';
  function TLN_SetBitmapPalette(bitmap, palette : PInteger) : Boolean; cdecl; external LIB name 'TLN_SetBitmapPalette';
  function TLN_DeleteBitmap(bitmap : PInteger) : Boolean; cdecl; external LIB name 'TLN_DeleteBitmap';
  function TLN_CreateSequence(name : PAnsiChar; target, num_frames : Integer; frames : TArray<TSequenceFrame>) : PInteger; cdecl; external LIB name 'TLN_CreateSequence';
  function TLN_CreateCycle(name : PAnsiChar; num_strips : Integer; strips : TArray<TColorStrip>) : PInteger; cdecl; external LIB name 'TLN_CreateCycle';
  function TLN_CloneSequence(sequence : PInteger) : PInteger; cdecl; external LIB name 'TLN_CloneSequence';
  function TLN_GetSequenceInfo(sequence : PInteger; info : PSequenceInfo) : Boolean; cdecl; external LIB name 'TLN_GetSequenceInfo';
  function TLN_DeleteSequence(sequence : PInteger) : Boolean; cdecl; external LIB name 'TLN_DeleteSequence';
  function TLN_CreateSequencePack : PInteger; cdecl; external LIB name 'TLN_CreateSequencePack';
  function TLN_LoadSequencePack(filename : PAnsiChar) : PInteger; cdecl; external LIB name 'TLN_LoadSequencePack';
  function TLN_FindSequence(sp : PInteger; name : PAnsiChar) : PInteger; cdecl; external LIB name 'TLN_FindSequence';
  function TLN_GetSequence(sp : PInteger; index : Integer) : PInteger; cdecl; external LIB name 'TLN_GetSequence';
  function TLN_GetSequencePackCount(sp : PInteger) : Integer; cdecl; external LIB name 'TLN_GetSequencePackCount';
  function TLN_AddSequenceToPack(sp, sequence : PInteger) : Boolean; cdecl; external LIB name 'TLN_AddSequenceToPack';
  function TLN_DeleteSequencePack(sp : PInteger) : Boolean; cdecl; external LIB name 'TLN_AddSequenceToPack';

implementation

end.
