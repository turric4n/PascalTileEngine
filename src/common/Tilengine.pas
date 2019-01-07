{
*****************************************************************************
* Delphi/FreePascal Tilengine wrapper - Up to date to library version 1.20
* http://www.tilengine.org
* https://github.com/turric4n/PascalTileEngine
*****************************************************************************
Copyright (c) 2018 Enrique Fuentes (aka Turric4n) - thanks to Marc Palacios for
this great project.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
}

unit Tilengine;

interface

uses
  TilengineBindings,
  {$IFDEF DELPHI}
  System.SysUtils;
  {$ELSE}
  SysUtils;
  {$ENDIF}

type
  TColorHelper = record helper for TColor
    procedure ByRGB(R,G,B : Byte);
  end;

  /// <summary>
  /// Video callback aka function pointer
  /// </summary>
  TVideocallback = procedure(line : Integer); cdecl;

  /// <summary>
  /// Callback aka function pointer
  /// </summary>
  TBlendFunction = procedure(src, dst : Byte); cdecl;

  /// <summary>
  /// Generic Tilengine exception
  /// </summary>
  TTilengineException = class(Exception)
    public
      constructor Create(const msg : string);
  end;

  /// <summary>
  /// Sequence resource
  /// </summary>
  TSequence = class
    private
      ptr : PInteger;
      /// <summary>
      ///
      /// </summary>
      /// <param name="res"></param>
      constructor Create(res : PInteger); overload;
    public
      /// <summary>
      ///
      /// </summary>
      /// <param name="name"></param>
      /// <param name="target"></param>
      /// <param name="frames"></param>
      constructor Create(name : PAnsiChar; target : Integer; frames : TArray<TSequenceFrame>); overload;
      /// <summary>
      ///
      /// </summary>
      /// <param name="name"></param>
      /// <param name="strips"></param>
      constructor Create(name : PAnsiChar; strips : TArray<TColorStrip>); overload;
      function Clone : TSequence;
      procedure GetInfo(info : PSequenceInfo);
      procedure Delete;
  end;

  /// <summary>
  /// SequencePack resource
  /// </summary>
  TSequencePack = class
    private
      ptr : PInteger;
      function GetSequences : Integer;
      /// <summary>
      ///
      /// </summary>
      /// <param name="res"></param>
      constructor Create(res : PInteger); overload;
    public
      property NumSequences : Integer read GetSequences;
      /// <summary>
      ///
      /// </summary>
      /// <param name="filename"></param>
      /// <returns></returns>
      class function FromFile(filename : PAnsiChar) : TSequencePack;
      /// <summary>
      ///
      /// </summary>
      /// <param name="name"></param>
      /// <returns></returns>
      function Find(name : PAnsiChar) : TSequence;
      /// <summary>
      ///
      /// </summary>
      /// <param name="index"></param>
      /// <returns></returns>
      function Get(index : Integer) : TSequence;
      /// <summary>
      ///
      /// </summary>
      /// <param name="sequence"></param>
      procedure Add(sequence : TSequence);
      procedure Delete;
  end;

  /// <summary>
  /// Palette resource
  /// </summary>
  TPalette = class
    private
      ptr : PInteger;
      /// <summary>
      ///
      /// </summary>
      /// <param name="res"></param>
      constructor Create(res : PInteger); overload;
    public
      constructor Create(entries : Integer); overload;
      class function FromFile(filename : PAnsiChar) : TPalette;
      function Clone : TPalette;
      /// <summary>
      ///
      /// </summary>
      /// <param name="index"></param>
      /// <param name="color"></param>
      procedure SetColor(index : Integer; color : TColor);
      /// <summary>
      ///
      /// </summary>
      /// <param name="src1"></param>
      /// <param name="src2"></param>
      /// <param name="factor"></param>
      procedure Mix(src1, src2 : TPalette; factor : Byte);
      /// <summary>
      ///
      /// </summary>
      /// <param name="color"></param>
      /// <param name="first"></param>
      /// <param name="count"></param>
      procedure AddColor(color : TColor; first, count : Byte);
      /// <summary>
      ///
      /// </summary>
      /// <param name="color"></param>
      /// <param name="first"></param>
      /// <param name="count"></param>
      procedure SubColor(color : TColor; first, count : Byte);
      /// <summary>
      ///
      /// </summary>
      /// <param name="color"></param>
      /// <param name="first"></param>
      /// <param name="count"></param>
      procedure MulColor(color : TColor; first, count : Byte);
      procedure Delete;
  end;

  /// <summary>
  /// Bitmap resource
  /// </summary>
  TBitmap = class
    private
      ptr : PInteger;
      /// <summary>
      ///
      /// </summary>
      /// <param name="res"></param>
      constructor Create(res : PInteger); overload;
      function GetWidth : Integer;
      function GetHeight : Integer;
      function GetDepth : Integer;
      function GetPitch : Integer;
      function GetPixelData : TArray<Byte>;
      function GetPalette : TPalette;
      procedure SetPalette(const Value: TPalette);
      procedure SetPixelData(const Value: TArray<Byte>);
    public
      property PixelData : TArray<Byte> read GetPixelData write SetPixelData;
      property Width : Integer read GetWidth;
      property Height : Integer read GetHeight;
      property Depth : Integer read GetDepth;
      property Pitch : Integer read GetPitch;
      property Palette : TPalette read GetPalette write SetPalette;
      /// <summary>
      ///
      /// </summary>
      /// <param name="width"></param>
      /// <param name="height"></param>
      /// <param name="bpp"></param>
      constructor Create(width, height, bpp : Integer); overload;
      /// <summary>
      ///
      /// </summary>
      /// <param name="filename"></param>
      /// <returns></returns>
      class function FromFile(filename : PAnsiChar) : TBitmap;
      function Clone : TBitmap;
      procedure Delete;
  end;

  /// <summary>
  /// Tileset resource
  /// </summary>
  TTileset = class
    private
      ptr : PInteger;
      /// <summary>
      ///
      /// </summary>
      /// <param name="res"></param>
      constructor Create(res : PInteger); overload;
      function GetHeight: Integer;
      function GetPalette: TPalette;
      function GetSequencePack: TSequencepack;
      function GetWidth: Integer;
    public
      property Width : Integer read GetWidth;
      property Height : Integer read GetHeight;
      property Palette : TPalette read GetPalette;
      property SequencePack : TSequencepack read GetSequencePack;
      /// <summary>
      ///
      /// </summary>
      /// <param name="numTiles"></param>
      /// <param name="width"></param>
      /// <param name="height"></param>
      /// <param name="palette"></param>
      /// <param name="sp"></param>
      /// <param name="attributes"></param>
      constructor Create(numTiles, width, height : Integer; palette : TPalette; sp : TSequencepack; attributes : TArray<TTileAtributes>); overload;
      /// <summary>
      ///
      /// </summary>
      /// <param name="filename"></param>
      /// <returns></returns>
      class function FromFile(filename : PAnsiChar) : TTileset;
      function Clone : TTileset;
      /// <summary>
      ///
      /// </summary>
      /// <param name="entry"></param>
      /// <param name="pixels"></param>
      /// <param name="pitch"></param>
      procedure SetPixels(entry : Integer; pixels : TArray<Byte>; pitch : Integer);
      /// <summary>
      ///
      /// </summary>
      /// <param name="src"></param>
      /// <param name="dst"></param>
      procedure CopyTile(src, dst : Integer);
      procedure Delete;
  end;

  /// <summary>
  /// Tilemap resource
  /// </summary>

  { TTilemap }

  TTilemap = class
    private
      ptr : PInteger;
      /// <summary>
      ///
      /// </summary>
      /// <param name="res"></param>
      ftileset : TTileset;
      constructor Create(res : PInteger); overload;
      function GetCols : Integer;
      function GetRows : Integer;
      function GetTileset : TTileset;
    public
      property Cols : Integer read GetCols;
      property Rows : Integer read GetRows;
      property Tileset : TTileset read GetTileset;
      /// <summary>
      ///
      /// </summary>
      /// <param name="rows"></param>
      /// <param name="cols"></param>
      /// <param name="tiles"></param>
      /// <param name="bgcolor"></param>
      /// <param name="tileset"></param>
      constructor Create(rows, cols : Integer; tiles : TArray<TTile>; bgcolor : TColor; tileset : TTileset); overload;
      /// <summary>
      ///
      /// </summary>
      /// <param name="filename"></param>
      /// <param name="layername"></param>
      /// <returns></returns>
      class function FromFile(filename, layername : PAnsiChar) : TTilemap;
      function Clone : TTilemap;
      /// <summary>
      ///
      /// </summary>
      /// <param name="row"></param>
      /// <param name="col"></param>
      /// <param name="tile"></param>
      procedure SetTile(row, col : Integer; tile : PTile);
      /// <summary>
      ///
      /// </summary>
      /// <param name="row"></param>
      /// <param name="col"></param>
      /// <param name="tile"></param>
      function GetTile(row, col : Integer) : PTile;
      /// <summary>
      ///
      /// </summary>
      /// <param name="srcRow"></param>
      /// <param name="srcCol"></param>
      /// <param name="rows"></param>
      /// <param name="cols"></param>
      /// <param name="dst"></param>
      /// <param name="dstRow"></param>
      /// <param name="dstCol"></param>
      procedure CopyTiles(srcRow, srcCol, rows, cols : Integer; dst : TTilemap; dstRow, dstCol : Integer);
      procedure Delete;
      destructor Destroy; override;
  end;

  /// <summary>
  /// Spriteset resource
  /// </summary>
  TSpriteset = class
    private
      ptr : PInteger;
      /// <summary>
      ///
      /// </summary>
      /// <param name="res"></param>
      function GetPalette : TPalette;
      constructor Create(res : PInteger); overload;
    public
      /// <summary>
      ///
      /// </summary>
      /// <param name="bitmap"></param>
      /// <param name="data"></param>
      property Palette : TPalette read GetPalette;
      constructor Create(bitmap : TBitmap; data : TArray<TSpriteData>); overload;
      /// <summary>
      ///
      /// </summary>
      /// <param name="filename"></param>
      /// <returns></returns>
      class function FromFile(filename : PAnsiChar) : TSpriteSet; overload;
      /// <summary>
      /// Reload same instance from file
      /// </summary>
      /// <param name="filename"></param>
      /// <returns></returns>
      procedure ReloadFromFile(filename : PAnsiChar);
      function Clone : TSpriteset;
      /// <summary>
      ///
      /// </summary>
      /// <param name="index"></param>
      /// <param name="info"></param>
      function GetInfo(index : Integer) : TSpriteInfo;
      /// <summary>
      ///
      /// </summary>
      /// <param name="name"></param>
      /// <returns></returns>
      function FindSprite(name : PAnsiChar) : Integer;
      /// <summary>
      ///
      /// </summary>
      /// <param name="entry"></param>
      /// <param name="data"></param>
      /// <param name="pixels"></param>
      /// <param name="pitch"></param>
      procedure SetSpritesetData(entry : Integer; data : TArray<TSpriteData>; pixels : PInteger; pitch : Integer);
      procedure Delete;
  end;

  /// <summary>
  /// Animation management
  /// </summary>
  TAnimation = class
    private
      findex : Integer;
      function GetActive : Boolean;
      procedure SetDelay(value : Integer);
    public
      constructor Create(index : Integer);
      property Active : Boolean read GetActive;
      property Delay : Integer write SetDelay;
      /// <summary>
      ///
      /// </summary>
      /// <param name="palette"></param>
      /// <param name="sequence"></param>
      /// <param name="blend"></param>
      procedure SetPaletteAnimation(palette : TPalette; sequence : TSequence; blend : Boolean);
      /// <summary>
      ///
      /// </summary>
      /// <param name="palette"></param>
      procedure SetPaletteAnimationSource(palette : TPalette);
      /// <summary>
      ///
      /// </summary>
      /// <param name="layerIndex"></param>
      /// <param name="sequence"></param>
      procedure SetTilesetAnimation(layerIndex : Integer; sequence : TSequence);
      /// <summary>
      ///
      /// </summary>
      /// <param name="layerIndex"></param>
      /// <param name="sequence"></param>
      procedure SetTilemapAnimation(layerIndex : Integer; sequence : TSequence);
      /// <summary>
      ///
      /// </summary>
      /// <param name="spriteIndex"></param>
      /// <param name="sequence"></param>
      /// <param name="loop"></param>
      procedure SetSpriteAnimation(spriteIndex : Integer; sequence : TSequence; loop : Integer);
      procedure Disable;
  end;

  /// <summary>
  /// Sprite management
  /// </summary>
  TSprite = class
    private
      findex : Integer;
      procedure SetSpriteSet(value : TSpriteset);
      procedure SetFlags(value : TTileFlags);
      procedure SetBlendMode(value : TBlend);
      function GetCollision : Boolean;
      procedure SetPalette(const Value: TPalette);
      procedure SetPicture(const Value: Integer);
      function GetPicture: Integer;
    public
      constructor Create(index : Integer);
      property SpriteSet : TSpriteset write SetSpriteSet;
      property Flags : TTileFlags write SetFlags;
      property Picture : Integer read GetPicture write SetPicture;
      property Palette : TPalette write SetPalette;
      property Idx : Integer read findex;
      /// <summary>
      /// Sets blending mode
      /// </summary>
      property BlendMode : TBlend write SetBlendMode;
      property Collision : Boolean read GetCollision;
      /// <summary>
      /// Disables animation if has an assigned animation
      /// </summary>
      procedure DisableAnimation;
      /// <summary>
      /// Disables sprite
      /// </summary>
      procedure Disable;
      /// <summary>
      ///
      /// </summary>
      /// <param name="spriteset"></param>
      /// <param name="flags"></param>
      procedure Setup(spriteset : TSpriteset; flags : TTileFlags);
      /// <summary>
      ///
      /// </summary>
      /// <param name="x"></param>
      /// <param name="y"></param>
      procedure SetPosition(x, y : Integer);
      /// <summary>
      ///
      /// </summary>
      /// <param name="sx"></param>
      /// <param name="sy"></param>
      procedure SetScaling(sx, sy : Single);
      procedure Reset;
      /// <summary>
      ///
      /// </summary>
      /// <param name="mode"></param>
      procedure EnableCollision(mode : Boolean);
  end;
  
  /// <summary>
  /// Layer management
  /// </summary>
  TLayer = class
    private
      findex : Integer;
      FBlendMode: TBlend;
      FTileSet: TTileset;
      FTileMap: TTilemap;
      procedure SetBitmap(const Value: TBitmap);
      procedure SetPalette(const Value: TPalette);
      function GetPalette: TPalette;
      function GetHeight: Integer;
      function GetWidth: Integer;
      procedure SetBlendMode(const Value: TBlend);
      function GetCollision: Boolean;
    public
      constructor Create(index : Integer);
      property BlendMode : TBlend write SetBlendMode;
      property Palette : TPalette read GetPalette write SetPalette;
      property Bitmap : TBitmap write SetBitmap;
      property TileSet : TTileset read FTileSet;
      property TileMap : TTilemap read FTileMap;
      property Width : Integer read GetWidth;
      property Height : Integer read GetHeight;
      property Collision : Boolean read GetCollision;
      /// <summary>
      ///
      /// </summary>
      /// <param name="tileset"></param>
      /// <param name="tilemap"></param>
      procedure Setup(tileset : TTileset; tilemap : TTilemap);
      /// <summary>
      ///
      /// </summary>
      /// <param name="tilemap"></param>
      procedure SetMap(Tilemap : TTilemap);
      /// <summary>
      ///
      /// </summary>
      /// <param name="x"></param>
      /// <param name="y"></param>
      procedure SetPosition(x, y : Integer);
      /// <summary>
      ///
      /// </summary>
      /// <param name="sx"></param>
      /// <param name="sy"></param>
      procedure SetScaling(sx, sy : Single);
      /// <summary>
      ///
      /// </summary>
      /// <param name="angle"></param>
      /// <param name="dx"></param>
      /// <param name="dy"></param>
      /// <param name="sx"></param>
      /// <param name="sy"></param>
      procedure SetTransform(angle, dx, dy, sx, sy : Single);
      /// <summary>
      ///
      /// </summary>
      /// <param name="map"></param>
      procedure SetPixelMapping(map : TArray<TPixelMap>);
      procedure Reset;
      procedure EnableCollision(mode : Boolean);
      procedure SetColumnOffset(offsets : TArray<Integer>);
      procedure SetClip(x1, y1, x2, y2 : Integer);
      procedure DisableClip;
      procedure SetMosaic(width, height : Integer);
      procedure DisableMosaic;
      function GetTileInfo(index, x, y : Integer) : TTileInfo;
      procedure Disable;

  end;

  /// <summary>
  /// Main object for engine creation and rendering
  /// </summary>
  TEngine = class
    protected
      Layers : TArray<TLayer>;
      Sprites : TArray<TSprite>;
      SpriteSets : TArray<TSpriteset>;
      Animations : TArray<TAnimation>;
      FVersion: UInt32;
      FHeight : Integer;
      FWidth : Integer;
    private
      //Singleton
      class var finstance : TEngine;
      class var finit : Boolean;
      //Hidden constructor for Singleton Pattern
      constructor Create(numLayers, numSprites, numAnimations : Integer);
      procedure SetVersion(const Value: UInt32);
      procedure SetWidth(const Value: Integer);
      procedure SetHeight(const Value: Integer);
      function GetTicks : Word;
      function GetWidth : Integer;
      function GetHeight : Integer;
      function GetVersion : UInt32;
      function GetNumObjects: UInt32;
      function GetUsedMemory: UInt32;
      procedure SetBackgroundBitmap(const Value: TBitmap);
      procedure SetBackgroundPalette(const Value: TPalette);
      procedure SetLoadPath(const Value: PAnsiChar);
      /// <summary>
      /// Throws a TilengineException after an unsuccessful operation
      /// </summary>
      /// <param name="success"></param>
      class procedure ThrowException(success : Boolean);
    public
      property Width : Integer read GetWidth write SetWidth;
      property Height : Integer read GetHeight write SetHeight;
      property Version : UInt32 read GetVersion write SetVersion;
      property Ticks : Word read GetTicks;
      /// <summary>
      /// Base path for all data loading .FromFile() static methods
      /// </summary>
      property LoadPath : PAnsiChar write SetLoadPath;
      /// <summary>
      /// Returns the number of objets used by the engine so far
      /// </summary>
      property NumObjects : UInt32 read GetNumObjects;
      /// <summary>
      /// Returns the total amount of memory used by the objects so far
      /// </summary>
      property UsedMemory : UInt32 read GetUsedMemory;
      /// <summary>
      /// Sets an optional, static bitmap as background instead of a solid color
      /// </summary>
      property BackgroundBitmap : TBitmap write SetBackgroundBitmap;
      /// <summary>
      /// Sets the palette for the optional background bitmap
      /// </summary>
      property BackgroundPalette : TPalette write SetBackgroundPalette;
      /// <summary>
      /// Initializes the graphic engine
      /// </summary>
      /// <param name="hres">horizontal resolution in pixels</param>
      /// <param name="vres">vertical resolution in pixels</param>
      /// <param name="numLayers">number of layers</param>
      /// <param name="numSprites">number of sprites</param>
      /// <param name="numAnimations">number of animations</param>
      /// <returns>Engine instance</returns>
      /// <remarks>This is a singleton object: calling Init multiple times will return the same reference</remarks>
      class function Singleton(Hres, Vres, numLayers, numSprites, numAnimations : Integer) : TEngine;
      /// <summary>
      /// Deinits engine and frees associated resources
      /// </summary>
      procedure Deinit;
      /// <summary>
      /// Sets the background color, that is the color of the pixel when there isn't any layer or sprite at that position
      /// </summary>
      procedure SetBackgroundColor(const value : TColor); overload;
      /// <summary>
      /// Sets the background color from a tilemap, that is the color of the pixel when there isn't any layer or sprite at that position
      /// </summary>
      procedure SetBackgroundColor(const tilemap : TTilemap); overload;
      /// <summary>
		  /// Disables background color rendering. If you know that the last background layer will always
      /// cover the entire screen, you can disable it to gain some performance
      /// </summary>
      procedure DisableBackgroundColor;
      /// <summary>
      /// Sets the output surface for rendering
      /// </summary>
      /// <param name="data">Array of bytes that will hold the render target</param>
      /// <param name="pitch">Number of bytes per each scanline of the framebuffer</param>
      /// <remarks>The render target pixel format must be 32 bits RGBA</remarks>
      procedure SetRenderTarget(data : TArray<Byte>; pitch : Integer);
      /// <summary>
      /// Enables raster effects processing, like a virtual HBLANK interrupt where
      /// any render parameter can be modified between scanlines.
      /// </summary>
      /// <param name="callback">name of the user-defined function to call for each scanline. Set Null to disable.</param>
      procedure SetRasterCallback(callback : TVideocallback);
      /// <summary>
      /// Enables user callback for each drawn frame, like a virtual VBLANK interrupt
      /// </summary>
      /// <param name="callback">name of the user-defined function to call for each frame. Set Null to disable.</param>
      procedure SetFrameCallback(callback : TVideocallback);
      /// <summary>
      /// Sets custom blend function to use in sprites or background layers when cref="Blend.Custom" mode
      /// is selected with the cref="Layer.BlendMode" and cref="Sprite.BlendMode" properties.
      /// </summary>
      /// <param name="function">user-defined function to call when blending that takes
      /// two integer arguments: source component intensity, destination component intensity, and returns
      /// the desired intensity.
      /// </param>
      procedure SetCustomBlendFunction(customfunction : TBlendFunction);
      /// <summary>
      /// Starts active rendering of the current frame
      /// </summary>
      /// <param name="frame">Timestamp value</param>
      /// <remarks>This method is used for active rendering combined with DrawNextScanline(), instead of using delegates for raster effects</remarks>
      procedure BeginFrame(frame : Integer);
      /// <summary>
      /// Draws the next scanline of the frame when doing active rendering (without delegates)
      /// </summary>
      /// <returns>true if there are still scanlines to draw or false when the frame is complete</returns>
      function DrawNextScanLine : Boolean;
      /// <summary>
      /// Returns reference to first unused sprite
      /// </summary>
      /// <returns></returns>
      function GetAvailableSprite : TSprite;
      /// <summary>
      /// Init engine sprite array. WARNING! If you call this method you will current sprites
      /// </summary>
      /// <returns></returns>
      procedure InitSprites(count : Integer);
      /// <summary>
      /// Init engine layers array. WARNING! If you call this method you will current layers
      /// </summary>
      /// <returns></returns>
      procedure InitLayers(count : Integer);
      function GetLayer(idx : Integer) : TLayer;
      function GetSprite(idx : Integer) : TSprite;
      function GetAnimation(idx : Integer) : TAnimation;
      procedure UpdateFrame(time : Integer);
      procedure InitAnimations(count : Integer);
      destructor Destroy; override;
  end;

  /// <summary>
  /// Built-in windowing and user input
  /// </summary>
  TWindow = class
    private
      class var finstance : TWindow;
      class var finit : Boolean;
      procedure SetTitle(const Value: PAnsiChar);
      function GetTicks: Word;
      constructor Create;
      function GetActive: Boolean;
    public
      /// <summary>
      /// Sets the title of the window
      /// </summary>
      property Title : PAnsiChar write SetTitle;
      /// <summary>
      /// true if window is active or false if the user has requested to end the application (by pressing Esc key or clicking the close button)
      /// </summary>
      property Active : Boolean read GetActive;
      property Ticks : Word read GetTicks;
      /// <summary>
      /// Singleton
      /// Creates a window for rendering
      /// </summary>
      /// <param name="overlay">Optional path of a bmp file to overlay (for emulating RGB mask, scanlines, etc)</param>
      /// <param name="flags">Combined mask of the possible creation flags</param>
      /// <returns>Window instance</returns>
      /// <remarks>This is a singleton object: calling Init multiple times will return the same reference</remarks>
      class function Singleton(const overlay : PAnsiChar; flags : Integer) : TWindow;
      /// <summary>
      /// Singleton
      /// Creates a multithreaded window for rendering
      /// </summary>
      /// <param name="overlay">Optional path of a bmp file to overlay (for emulating RGB mask, scanlines, etc)</param>
      /// <param name="flags">Combined mask of the possible creation flags</param>
      /// <returns>Window instance</returns>
      /// <remarks>This is a singleton object: calling Init multiple times will return the same reference</remarks>
      class function SingletonThreaded(const overlay : PAnsiChar; flags : Integer) : TWindow;
      /// <summary>
      /// Does basic window housekeeping in signgle-threaded window. Must be called for each frame in game loop
      /// </summary>
      /// <returns>true if window is active or false if the user has requested to end the application (by pressing Esc key or clicking the close button)</returns>
      /// <remarks>This method must be called only for single-threaded windows, created with Create() method.</remarks>
      function Process : Boolean;
      /// <summary>
      /// Returns the state of a given input
      /// </summary>
      /// <param name="id">Input identifier to check state</param>
      /// <returns>true if that input is pressed or false if not</returns>
      function GetInput(ID : TInput) : Boolean;
      /// <summary>
      ///
      /// </summary>
      /// <param name="player">Player number to configure</param>
      /// <param name="enable"></param>
      procedure EnableInput(player : TPlayer; enable : Boolean);
      /// <summary>
      ///
      /// </summary>
      /// <param name="player">Player number to configure</param>
      /// <param name="index"></param>
      procedure AssignInputJoystick(player : TPlayer; index : Integer);
      /// <summary>
      ///
      /// </summary>
      /// <param name="player">Player number to configure</param>
      /// <param name="input"></param>
      /// <param name="keycode"></param>
      procedure DefineInputButton(player : TPlayer; input : TInput; joybutton : Byte);
      /// <summary>
      ///
      /// </summary>
      /// <param name="player">Player number to configure</param>
      /// <param name="input"></param>
      /// <param name="keycode"></param>
      procedure DefineInputKey(player : TPlayer; input : TInput; keycode : Integer);
      /// <summary>
      /// Begins active rendering frame
      /// </summary>
      /// <param name="frame">Timestamp value</param>
      /// <remarks>Use this method instead of Engine::BeginFrame() when using build-in windowing</remarks>
      procedure BeginFrame(frame : Integer);
      /// <summary>
      /// Draws a frame to the window
      /// </summary>
      /// <param name="time">Timestamp value</param>
      /// <remarks>This method does delegate-driven rendering</remarks>
      procedure DrawFrame(time : Integer);
      procedure EndFrame;
      procedure WaitRedraw;
      procedure EnableCRTEffect(overlay : TOverlay; overlay_factor, threshold, v0, v1, v2, v3 : Byte; blur, glow_factor : Byte);
      procedure DisableCRTEffect;
      procedure Delay(msecs : Word);
      procedure Delete;
      destructor Destroy; override;
  end;

implementation

{ TColorHelper }

procedure TColorHelper.ByRGB(R, G, B: Byte);
begin
  Self.R := R;
  Self.G := G;
  Self.B := B;
end;

{ TEngine }

procedure TEngine.BeginFrame(frame: Integer);
begin
  TLN_BeginFrame(frame);
end;

constructor TEngine.Create(numLayers, numSprites, numAnimations: Integer);
var
  c: Integer;
begin
  InitLayers(numLayers);
  InitSprites(numSprites);
  InitAnimations(numAnimations);
  Width := 0;
  Height := 0;
  Version := 0;
end;

procedure TEngine.Deinit;
begin
  TLN_Deinit;
end;

destructor TEngine.Destroy;
begin
  Deinit;
  inherited;
end;

procedure TEngine.DisableBackgroundColor;
begin
  TLN_DisableBGColor;
end;

function TEngine.DrawNextScanLine: Boolean;
begin
  Result := TLN_DrawNextScanline;
end;

function TEngine.GetAnimation(idx: Integer): TAnimation;
begin
  if Animations[idx] = nil then raise Exception.Create('Animation ' + IntToStr(idx) + ' not found.');
  Result := Animations[idx];
end;

function TEngine.GetAvailableSprite: TSprite;
var
  index : Integer;
begin
  index := TLN_GetAvailableSprite;
  ThrowException(index <> -1);
  Result := sprites[index];
end;

function TEngine.GetHeight: Integer;
begin
  Result := fheight;
end;

function TEngine.GetLayer(idx: Integer): TLayer;
begin
  if Layers[idx] = nil then raise Exception.Create('Layer ' + IntToStr(idx) + ' not found.');
  Result := Layers[idx];
end;

function TEngine.GetNumObjects: UInt32;
begin
  Result := TLN_GetNumObjects;
end;

function TEngine.GetSprite(idx: Integer): TSprite;
begin
  if Sprites[idx] = nil then raise Exception.Create('Sprite ' + IntToStr(idx) + ' not found.');
  Result := Sprites[idx];
end;

function TEngine.GetTicks: Word;
begin
  Result := TLN_GetTicks;
end;

function TEngine.GetUsedMemory: UInt32;
begin
  Result := TLN_GetUsedMemory;
end;

function TEngine.GetVersion: UInt32;
begin
  Result := fversion;
end;

function TEngine.GetWidth: Integer;
begin
  Result := fwidth;
end;

procedure TEngine.InitAnimations(count: Integer);
var
  c : Integer;
begin
  SetLength(animations, count);
  for c := 0 to count - 1 do animations[c] := TAnimation.Create(c);
end;

procedure TEngine.InitLayers(count: Integer);
var
  c : Integer;
begin
  SetLength(layers, count);
  for c := 0 to count - 1 do
      layers[c] := TLayer.Create(c);
end;

procedure TEngine.InitSprites(count: Integer);
var
  c : Integer;
begin
  SetLength(sprites, count);
  for c := 0 to count - 1 do sprites[c] := TSprite.Create(c);
end;

procedure TEngine.SetBackgroundBitmap(const Value: TBitmap);
var
  ok : Boolean;
begin
  ok := TLN_SetBGBitmap(value.ptr);
end;

procedure TEngine.SetBackgroundColor(const tilemap: TTilemap);
begin
  TLN_SetBGColorFromTilemap(tilemap.ptr);
end;

procedure TEngine.SetBackgroundColor(const value: TColor);
begin
  TLN_SetBGColor(value.R, value.G, value.B);
end;

procedure TEngine.SetBackgroundPalette(const Value: TPalette);
var
  ok : Boolean;
begin
  ok := TLN_SetBGPalette(value.ptr);
end;

procedure TEngine.SetCustomBlendFunction(customfunction: TBlendFunction);
begin
  TLN_SetCustomBlendFunction(@customfunction);
end;

procedure TEngine.SetFrameCallback(callback: TVideocallback);
begin
  TLN_SetFrameCallback(@callback);
end;

procedure TEngine.SetHeight(const Value: Integer);
begin
  FHeight := Value;
end;

procedure TEngine.SetLoadPath(const Value: PAnsiChar);
begin
  TLN_SetLoadPath(Value);
end;

procedure TEngine.SetRasterCallback(callback: TVideocallback);
begin
  TLN_SetRasterCallback(@callback);
end;

procedure TEngine.SetRenderTarget(data: TArray<Byte>; pitch: Integer);
begin
  TLN_SetRenderTarget(data, pitch);
end;

procedure TEngine.SetVersion(const Value: UInt32);
begin
  FVersion := Value;
end;

procedure TEngine.SetWidth(const Value: Integer);
begin
  FWidth := Value;
end;

class function TEngine.Singleton(Hres, Vres, numLayers, numSprites, numAnimations: Integer): TEngine;
var
  retval : Boolean;
begin
  if not finit then
  begin
    retval := TLN_Init(Hres, Vres, numLayers, numSprites, numAnimations);
    TEngine.ThrowException(retval);
    finit := True;
    finstance := Create(numLayers, numSprites, numAnimations);
    finstance.Width := Hres;
    finstance.Height := Vres;
    finstance.Version := TLN_GetVersion;
  end;
  Result := finstance;
end;

class procedure TEngine.ThrowException(success: Boolean);
var
  error : TError;
  name : PAnsiChar;
begin
  if not success then
  begin
    error := TLN_GetLastError;
    name := TLN_GetErrorString(error);
    if name = nil then name := '';
    raise TTilengineException.Create(name);
  end;
end;

procedure TEngine.UpdateFrame(time: Integer);
begin
  TLN_UpdateFrame(Time);
end;

{ TWindow }

procedure TWindow.AssignInputJoystick(player: TPlayer; index: Integer);
begin
  TLN_AssignInputJoystick(PInteger(player), index);
end;

procedure TWindow.BeginFrame(frame: Integer);
begin
  TLN_BeginWindowFrame(frame);
end;

constructor TWindow.Create;
begin
  inherited;
end;

procedure TWindow.DefineInputButton(player: TPlayer; input: TInput;
  joybutton: Byte);
begin
  TLN_DefineInputButton(PInteger(player), PInteger(input), joybutton);
end;

procedure TWindow.DefineInputKey(player: TPlayer; input: TInput;
  keycode: Integer);
begin
  TLN_DefineInputKey(PInteger(player), PInteger(input), keycode);
end;

procedure TWindow.Delay(msecs: Word);
begin
  TLN_Delay(msecs);
end;

procedure TWindow.Delete;
begin
  TLN_DeleteWindow;
end;

destructor TWindow.Destroy;
begin
  Delete;
  inherited;
end;

procedure TWindow.DisableCRTEffect;
begin
  TLN_DisableCRTEffect;
end;

procedure TWindow.DrawFrame(time: Integer);
begin
  TLN_DrawFrame(time);
end;

procedure TWindow.EnableCRTEffect(overlay: TOverlay; overlay_factor, threshold,
  v0, v1, v2, v3, blur, glow_factor: Byte);
begin
  TLN_EnableCRTEffect(overlay, overlay_factor, threshold, v0, v1, v2, v3, blur, glow_factor);
end;

procedure TWindow.EnableInput(player: TPlayer; enable: Boolean);
begin
  TLN_EnableInput(PInteger(player), enable);
end;

procedure TWindow.EndFrame;
begin
  TLN_EndWindowFrame;
end;

function TWindow.GetActive: Boolean;
begin
  Result := TLN_IsWindowActive;
end;

function TWindow.GetInput(ID: TInput): Boolean;
begin
  Result := TLN_GetInput(Pinteger(ID));
end;

function TWindow.GetTicks: Word;
begin
  Result := TLN_GetTicks;
end;

function TWindow.Process: Boolean;
begin
  Result := TLN_ProcessWindow;
end;

procedure TWindow.SetTitle(const Value: PAnsiChar);
begin
  TLN_SetWindowTitle(Value);
end;

class function TWindow.Singleton(const overlay: PAnsiChar; flags: Integer): TWindow;
var
  retval : Boolean;
begin
  if not finit then
  begin
    retval := TLN_CreateWindow(overlay, flags);
    TEngine.ThrowException(retval);
    finit := True;
    finstance := TWindow.Create;
  end;
  Result := finstance;
end;

class function TWindow.SingletonThreaded(const overlay: PAnsiChar; flags: Integer): TWindow;
var
  retval : Boolean;
begin
  if not finit then
  begin
    retval := TLN_CreateWindowThread(overlay, Byte(flags));
    TEngine.ThrowException(retval);
    finit := True;
    finstance := TWindow.Create;
  end;
  Result := finstance;
end;

procedure TWindow.WaitRedraw;
begin
  TLN_WaitRedraw;
end;

{ TLayer }

constructor TLayer.Create(index: Integer);
begin
  findex := index;
end;

procedure TLayer.Disable;
var
  ok : Boolean;
begin
  ok := TLN_DisableLayer(findex);
  TEngine.ThrowException(ok);
end;

procedure TLayer.DisableClip;
var
  ok : Boolean;
begin
  ok := TLN_DisableLayerClip(findex);
  TEngine.ThrowException(ok);
end;

procedure TLayer.DisableMosaic;
var
  ok : Boolean;
begin
  ok :=  TLN_DisableLayerMosaic(findex);
  TEngine.ThrowException(ok);
end;


procedure TLayer.EnableCollision(mode: Boolean);
var
  ok : Boolean;
begin
  ok := TLN_EnableSpriteCollision(findex, mode);
  TEngine.ThrowException(ok);
end;

function TLayer.GetCollision: Boolean;
begin
  Result := TLN_GetSpriteCollision(findex);
end;

function TLayer.GetHeight: Integer;
begin
  Result := TLN_GetLayerHeight(findex);
end;

function TLayer.GetPalette: TPalette;
var
  value : PInteger;
begin
  value := TLN_GetLayerPalette(findex);
  TEngine.ThrowException(value <> nil);
  Result := TPalette.Create(value);
end;

function TLayer.GetTileInfo(index, x, y: Integer): TTileInfo;
var
  ok : Boolean;
begin
  ok := TLN_GetLayerTile(index, x, y, Result);
  TEngine.ThrowException(ok);
end;

function TLayer.GetWidth: Integer;
begin
  Result := TLN_GetLayerWidth(findex);
end;

procedure TLayer.Reset;
var
  ok : Boolean;
begin
  ok := TLN_ResetLayerMode(findex);
  TEngine.ThrowException(ok);
end;

procedure TLayer.SetBitmap(const Value: TBitmap);
var
  ok : Boolean;
begin
  ok := TLN_SetLayerBitmap(findex, value.ptr);
  TEngine.ThrowException(ok);
end;

procedure TLayer.SetBlendMode(const Value: TBlend);
var
  ok : Boolean;
begin
  ok := TLN_SetLayerBlendMode(findex, PInteger(value), 128);
  TEngine.ThrowException(ok);
end;

procedure TLayer.SetClip(x1, y1, x2, y2: Integer);
var
  ok : Boolean;
begin
  ok := TLN_SetLayerClip(findex, x1, y1, x2, y2);
  TEngine.ThrowException(ok);
end;

procedure TLayer.SetColumnOffset(offsets: TArray<Integer>);
var
  ok : Boolean;
begin
  ok := TLN_SetLayerColumnOffset(findex, offsets);
  TEngine.ThrowException(ok);
end;

procedure TLayer.SetMap(Tilemap: TTIlemap);
var
  ok : Boolean;
begin
  ftilemap := Tilemap;
  ok := TLN_SetLayer(findex, nil, Tilemap.ptr);
  TEngine.ThrowException(ok);
end;

procedure TLayer.SetMosaic(width, height: Integer);
var
  ok : Boolean;
begin
  ok := TLN_SetLayerMosaic(findex, width, height);
  TEngine.ThrowException(ok);
end;

procedure TLayer.SetPalette(const Value: TPalette);
var
  ok : Boolean;
begin
  ok := TLN_SetLayerPalette(findex, value.ptr);
  TEngine.ThrowException(ok);
end;

procedure TLayer.SetPixelMapping(map: TArray<TPixelMap>);
var
  ok : Boolean;
begin
  ok := TLN_SetLayerPixelMapping(findex, map);
  TEngine.ThrowException(ok);
end;

procedure TLayer.SetPosition(x, y: Integer);
var
  ok : Boolean;
begin
  ok := TLN_SetLayerPosition(findex, x, y);
  TEngine.ThrowException(ok);
end;

procedure TLayer.SetScaling(sx, sy: Single);
var
  ok : Boolean;
begin
  ok := TLN_SetLayerScaling(findex, sx, sy);
  TEngine.ThrowException(ok);
end;

procedure TLayer.SetTransform(angle, dx, dy, sx, sy: Single);
var
  ok : Boolean;
begin
  ok := TLN_SetLayerTransform(findex, angle, dx, dy, sx, sy);
  TEngine.ThrowException(ok);
end;

procedure TLayer.Setup(tileset: TTileset; tilemap: TTilemap);
var
  ok : Boolean;
begin
  FTileSet := tileset;
  FTileMap := tilemap;
  ok := TLN_SetLayer(findex, tileset.ptr, tilemap.ptr);
  TEngine.ThrowException(ok);
end;

{ TSprite }

constructor TSprite.Create(index: Integer);
begin
  findex := index;
end;

procedure TSprite.Disable;
var
  ok : Boolean;
begin
  ok := TLN_DisableSprite(findex);
  TEngine.ThrowException(ok);
end;

procedure TSprite.DisableAnimation;
var
  ok : Boolean;
begin
  ok := TLN_DisableAnimation(findex);
  TEngine.ThrowException(ok);
end;

procedure TSprite.EnableCollision(mode: Boolean);
var
  ok : Boolean;
begin
  ok := TLN_EnableSpriteCollision(findex, mode);
  TEngine.ThrowException(ok);
end;

function TSprite.GetCollision: Boolean;
begin
  Result := TLN_GetSpriteCollision(findex);
end;

function TSprite.GetPicture: Integer;
begin
  Result := TLN_GetSpritePicture(findex);
end;

procedure TSprite.Reset;
var
  ok : Boolean;
begin
  ok := TLN_ResetSpriteScaling(findex);
  TEngine.ThrowException(ok);
end;

procedure TSprite.SetBlendMode(value: TBlend);
var
  ok : Boolean;
begin
  ok := TLN_SetSpriteBlendMode(findex, PInteger(value), 0);
  TEngine.ThrowException(ok);
end;

procedure TSprite.SetFlags(value: TTileFlags);
var
  ok : Boolean;
begin
  ok := TLN_SetSpriteFlags(findex, PInteger(value));
  TEngine.ThrowException(ok);
end;

procedure TSprite.SetPalette(const Value: TPalette);
var
  ok : Boolean;
begin
  ok := TLN_SetSpritePalette(findex, Value.ptr);
  TEngine.ThrowException(ok);
end;

procedure TSprite.SetPicture(const Value: Integer);
var
  ok : Boolean;
begin
  ok := TLN_SetSpritePicture(findex, Value);
  TEngine.ThrowException(ok);
end;

procedure TSprite.SetPosition(x, y: Integer);
var
  ok : Boolean;
begin
  ok := TLN_SetSpritePosition(findex, x, y);
  TEngine.ThrowException(ok);
end;

procedure TSprite.SetScaling(sx, sy: Single);
var
  ok : Boolean;
begin
  ok := TLN_SetSpriteScaling(findex, sx, sy);
  TEngine.ThrowException(ok);
end;

procedure TSprite.SetSpriteSet(value: TSpriteset);
var
  ok : Boolean;
begin
  ok := TLN_SetSpriteSet(findex, value.ptr);
  TEngine.ThrowException(ok);
end;

procedure TSprite.Setup(spriteset: TSpriteset; flags: TTileFlags);
var
  ok : Boolean;
begin
  ok := TLN_ConfigSprite(findex, spriteset.ptr, PInteger(flags));
  TEngine.ThrowException(ok);
end;

{ TAnimation }

constructor TAnimation.Create(index: Integer);
begin
  findex := index;
end;

procedure TAnimation.Disable;
var
  ok : Boolean;
begin
  ok := TLN_DisableAnimation(findex);
  TEngine.ThrowException(ok);
end;

function TAnimation.GetActive: Boolean;
begin
  Result := TLN_GetAnimationState(findex);
end;

procedure TAnimation.SetDelay(value: Integer);
var
  ok : Boolean;
begin
  ok := TLN_SetAnimationDelay(findex, value);
  TEngine.ThrowException(ok);
end;

procedure TAnimation.SetPaletteAnimation(palette: TPalette; sequence: TSequence;
  blend: Boolean);
var
  ok : Boolean;
begin
  ok := TLN_SetPaletteAnimation(findex, palette.ptr, sequence.ptr, blend);
  TEngine.ThrowException(ok);
end;

procedure TAnimation.SetPaletteAnimationSource(palette: TPalette);
var
  ok : Boolean;
begin
  ok := TLN_SetPaletteAnimationSource(findex, palette.ptr);
  TEngine.ThrowException(ok);
end;

procedure TAnimation.SetSpriteAnimation(spriteIndex: Integer;
  sequence: TSequence; loop: Integer);
var
  ok : Boolean;
begin
  ok := TLN_SetSpriteAnimation(findex, spriteIndex, sequence.ptr, loop);
  TEngine.ThrowException(ok);
end;

procedure TAnimation.SetTilemapAnimation(layerIndex: Integer;
  sequence: TSequence);
var
  ok : Boolean;
begin
  ok := TLN_SetTilemapAnimation(findex, layerIndex, sequence.ptr);
  TEngine.ThrowException(ok);
end;

procedure TAnimation.SetTilesetAnimation(layerIndex: Integer;
  sequence: TSequence);
var
  ok : Boolean;
begin
  ok := TLN_SetTilesetAnimation(findex, layerIndex, sequence.ptr);
  TEngine.ThrowException(ok);
end;

{ TSpriteset }

function TSpriteset.Clone: TSpriteset;
var
  retval : PInteger;
begin
  retval := TLN_CloneSpriteset(ptr);
  TEngine.ThrowException(retval <> nil);
  result := TSpriteset.Create(retval);
end;

constructor TSpriteset.Create(res: PInteger);
begin
  ptr := res;
end;

constructor TSpriteset.Create(bitmap: TBitmap; data: TArray<TSpriteData>);
var
  retval : PInteger;
begin
  retval := TLN_CreateSpriteset(bitmap.ptr, data, Length(data));
  TEngine.ThrowException(retval <> nil);
end;

procedure TSpriteset.Delete;
var
  ok : Boolean;
begin
  ok := TLN_DeleteSpriteset(ptr);
  TEngine.ThrowException(ok);
  ptr := nil;
end;

function TSpriteset.FindSprite(name: PAnsiChar): Integer;
var
  index : Integer;
begin
  index := TLN_FindSpritesetSprite(ptr, name);
  TEngine.ThrowException(index <> -1);
  Result := index;
end;

class function TSpriteset.FromFile(filename: PAnsiChar): TSpriteSet;
var
  retval : PInteger;
begin
  retval := TLN_LoadSpriteset(filename);
  TEngine.ThrowException(retval <> nil);
  Result := TSpriteset.Create(retval);
end;

function TSpriteset.GetInfo(index: Integer): TSpriteInfo;
var
  ok : Boolean;
  retval : TSpriteInfo;
begin
  ok := TLN_GetSpriteInfo(ptr, index, @retval);
  TEngine.ThrowException(ok);
  Result := retval;
end;

function TSpriteset.GetPalette: TPalette;
begin
  Result := TPalette.Create(TLN_GetSpritesetPalette(ptr));
end;

procedure TSpriteset.ReloadFromFile(filename: PAnsiChar);
var
  retval : PInteger;
begin
  retval := TLN_LoadSpriteset(filename);
  TEngine.ThrowException(retval <> nil);
  ptr := retval;
end;

procedure TSpriteset.SetSpritesetData(entry: Integer; data: TArray<TSpriteData>;
  pixels: PInteger; pitch: Integer);
var
  ok : Boolean;
begin
  ok := TLN_SetSpritesetData(ptr, entry, data, pixels, pitch);
  TEngine.ThrowException(ok);
end;

{ TTileset }

function TTileset.Clone: TTileset;
var
  retval : PInteger;
begin
  retval := TLN_CloneTileset(ptr);
  TEngine.ThrowException(retval <> nil);
  result := TTileset.Create(retval);
end;

procedure TTileset.CopyTile(src, dst: Integer);
var
  ok : Boolean;
begin
  ok := TLN_CopyTile(ptr, src, dst);
  TEngine.ThrowException(ok);
end;

constructor TTileset.Create(numTiles, width, height: Integer; palette: TPalette;
  sp: TSequencepack; attributes: TArray<TTileAtributes>);
var
  retval : PInteger;
begin
  retval := TLN_CreateTileset(numTiles, width, height, palette.ptr, sp.ptr, attributes);
  TEngine.ThrowException(retval <> nil);
end;

constructor TTileset.Create(res: PInteger);
begin
  ptr := res;
end;

procedure TTileset.Delete;
var
  ok : Boolean;
begin
  ok := TLN_DeleteTileset(ptr);
  TEngine.ThrowException(ok);
  ptr := nil;
end;

class function TTileset.FromFile(filename: PAnsiChar): TTileset;
var
  retval : PInteger;
begin
  retval := TLN_LoadTileset(filename);
  TEngine.ThrowException(retval <> nil);
  Result := TTileset.Create(retval);
end;

function TTileset.GetHeight: Integer;
begin
  Result := TLN_GetTileHeight(ptr);
end;

function TTileset.GetPalette: TPalette;
begin
  Result := TPalette.Create(TLN_GetTilesetPalette(ptr));
end;

function TTileset.GetSequencePack: TSequencepack;
begin
  Result := TSequencePack.Create(TLN_GetTilesetSequencePack(ptr));
end;

function TTileset.GetWidth: Integer;
begin
  Result := TLN_GetTileWidth(ptr);
end;

procedure TTileset.SetPixels(entry: Integer; pixels: TArray<Byte>;
  pitch: Integer);
var
  ok : Boolean;
begin
  ok := TLN_SetTilesetPixels(ptr, entry, pixels, pitch);
  TEngine.ThrowException(ok);
end;

{ TTilemap }

function TTilemap.Clone: TTilemap;
var
  retval : PInteger;
begin
  retval := TLN_CloneTilemap(ptr);
  TEngine.ThrowException(retval <> nil);
  Result := TTilemap.Create(retval);
end;

procedure TTilemap.CopyTiles(srcRow, srcCol, rows, cols: Integer; dst: TTilemap;
  dstRow, dstCol: Integer);
var
  ok : Boolean;
begin
  ok := TLN_CopyTiles(ptr, srcRow, srcCol, rows, cols, dst.ptr, dstRow, dstCol);
  TEngine.ThrowException(ok);
end;

constructor TTilemap.Create(res: PInteger);
begin
  ptr := res;
end;

constructor TTilemap.Create(rows, cols : Integer; tiles: TArray<TTile>; bgcolor: TColor;
  tileset: TTileset);
var
  color : Int64;
  retval : PInteger;
begin
  ftileset := tileset;
  color := $FF000000 + (bgcolor.R shl 16) + (bgcolor.G shl 8) + bgcolor.B;
  {$IFNDEF DELPHI}
  retval := TLN_CreateTilemap(rows, cols, tiles, UInt32(color), tileset.ptr);
  {$ELSE}
  retval := TLN_CreateTilemap(rows, cols, tiles, FixedUInt(color), tileset.ptr);
  {$ENDIF}
  TEngine.ThrowException(retval <> nil);
  ptr := retval;
end;

procedure TTilemap.Delete;
var
  ok : Boolean;
begin
  ok := TLN_DeleteTilemap(ptr);
  TEngine.ThrowException(ok);
  ptr := nil;
end;

destructor TTilemap.Destroy;
begin
  Delete;
  inherited;
end;

class function TTilemap.FromFile(filename, layername: PAnsiChar): TTilemap;
var
  retval : PInteger;
begin
  retval := TLN_LoadTilemap(filename, layername);
  TEngine.ThrowException(retval <> nil);
  Result := TTilemap.Create(retval);
end;

function TTilemap.GetCols: Integer;
begin
  Result := TLN_GetTilemapCols(ptr);
end;

function TTilemap.GetRows: Integer;
begin
  Result := TLN_GetTilemapRows(ptr);
end;

function TTilemap.GetTile(row, col: Integer): PTile;
var
  ok : Boolean;
begin
  Result := New(PTile);
  ok := TLN_GetTilemapTile(ptr, row, col, Result);
  TEngine.ThrowException(ok);
end;

function TTilemap.GetTileset: TTileset;
begin
  Result := ftileset;
  if ftileset = nil then ftileset := TTileset.Create(TLN_GetTilemapTileset(ptr))
end;

procedure TTilemap.SetTile(row, col: Integer; tile: PTile);
var
  ok : Boolean;
begin
  ok := TLN_SetTilemapTile(ptr, row, col, tile);
  TEngine.ThrowException(ok);
end;

{ TPalette }

procedure TPalette.AddColor(color: TColor; first, count: Byte);
var
  ok : Boolean;
begin
  ok := TLN_AddPaletteColor(ptr, color.R, color.G, color.B, first, count);
  TEngine.ThrowException(ok);
end;

function TPalette.Clone: TPalette;
var
  retval : PInteger;
begin
  retval := TLN_ClonePalette(ptr);
  TEngine.ThrowException(retval <> nil);
  Result := TPalette.Create(retval);
end;

constructor TPalette.Create(res: PInteger);
begin
  ptr := res;
end;

constructor TPalette.Create(entries: Integer);
var
  retval : PInteger;
begin
  retval := TLN_CreatePalette(entries);
  TEngine.ThrowException(retval <> nil);
  ptr := retval;
end;

procedure TPalette.Delete;
var
  ok : Boolean;
begin
  ok := TLN_DeletePalette(ptr);
  TEngine.ThrowException(ok);
  ptr := nil;
end;

class function TPalette.FromFile(filename: PAnsiChar): TPalette;
var
  retval : PInteger;
begin
  retval := TLN_LoadPalette(filename);
  TEngine.ThrowException(retval <> nil);
  Result := TPalette.Create(retval);
end;

procedure TPalette.Mix(src1, src2: TPalette; factor: Byte);
var
  ok : Boolean;
begin
  ok := TLN_MixPalettes(src1.ptr, src2.ptr, ptr, factor);
  TEngine.ThrowException(ok);
end;

procedure TPalette.MulColor(color: TColor; first, count: Byte);
var
  ok : Boolean;
begin
  ok := TLN_ModPaletteColor(ptr, color.R, color.G, color.B, first, count);
  TEngine.ThrowException(ok);
end;

procedure TPalette.SetColor(index: Integer; color: TColor);
var
  ok : Boolean;
begin
  ok := TLN_SetPaletteColor(ptr, index, color.R, color.G, color.B);
  TEngine.ThrowException(ok);
end;

procedure TPalette.SubColor(color: TColor; first, count: Byte);
var
  ok : Boolean;
begin
  ok := TLN_SubPaletteColor(ptr, color.R, color.G, color.B, first, count);
  TEngine.ThrowException(ok);
end;

{ TBitmap }

function TBitmap.Clone: TBitmap;
var
  retval : PInteger;
begin
  retval := TLN_CloneBitmap(ptr);
  TEngine.ThrowException(retval <> nil);
  Result := TBitmap.Create(retval);
end;

constructor TBitmap.Create(width, height, bpp: Integer);
var
  retval : PInteger;
begin
  retval := TLN_CreateBitmap(width, height, bpp);
  TEngine.ThrowException(retval <> nil);
  ptr := retval;
end;

constructor TBitmap.Create(res: PInteger);
begin
  ptr := res;
end;

procedure TBitmap.Delete;
var
  ok : Boolean;
begin
  ok := TLN_DeleteBitmap(ptr);
  TEngine.ThrowException(ok);
  ptr := nil;
end;

class function TBitmap.FromFile(filename: PAnsiChar): TBitmap;
var
  retval : PInteger;
begin
  retval := TLN_LoadBitmap(filename);
  TEngine.ThrowException(retval <> nil);
  Result := TBitmap.Create(retval);
end;

function TBitmap.GetDepth: Integer;
begin
  Result := TLN_GetBitmapDepth(ptr);
end;

function TBitmap.GetHeight: Integer;
begin
  Result := TLN_GetBitmapHeight(ptr);
end;

function TBitmap.GetPalette: TPalette;
begin
  Result := TPalette.Create(TLN_GetBitmapPalette(ptr));
end;

function TBitmap.GetPitch: Integer;
begin
  Result := TLN_GetBitmapPitch(ptr);
end;

function TBitmap.GetPixelData: TArray<Byte>;
var
  ptrPixelData : PInteger;
begin
  SetLength(Result, Pitch * Height);
  ptrPixelData := TLN_GetBitmapPtr(ptr, 0, 0);
  Move(ptrPixelData^, (@Result)^, Length(Result))
end;

function TBitmap.GetWidth: Integer;
begin
  Result := TLN_GetBitmapWidth(ptr);
end;

procedure TBitmap.SetPalette(const Value: TPalette);
var
  ok : Boolean;
begin
  ok := TLN_SetBitmapPalette(ptr, value.ptr);
  TEngine.ThrowException(ok);
end;

procedure TBitmap.SetPixelData(const Value: TArray<Byte>);
var
  ptrPixelData : PInteger;
begin
  if (Pitch * Height) <> Length(value) then raise EArgumentException.Create('TBitmap.SetPixelData : Invalid pixel data');
  ptrPixelData := TLN_GetBitmapPtr(ptr, 0, 0);
  Move((@Value)^, ptrPixelData^, Length(value));
end;

{ TSequence }

function TSequence.Clone: TSequence;
var
  retval : PInteger;
begin
  retval := TLN_CloneSequence(ptr);
  TEngine.ThrowException(retval <> nil);
  ptr := retval;
end;

constructor TSequence.Create(res: PInteger);
begin
  ptr := res;
end;

constructor TSequence.Create(name: PAnsiChar; target: Integer;
  frames: TArray<TSequenceFrame>);
var
  retval : PInteger;
begin
  retval := TLN_CreateSequence(name, target, Length(frames), frames);
  TEngine.ThrowException(retval <> nil);
  ptr := retval;
end;

constructor TSequence.Create(name: PAnsiChar; strips: TArray<TColorStrip>);
var
  retval : PInteger;
begin
  retval := TLN_CreateCycle(name, Length(strips), strips);
  TEngine.ThrowException(retval <> nil);
  ptr := retval;
end;

procedure TSequence.Delete;
var
  ok : Boolean;
begin
  ok := TLN_DeleteSequence(ptr);
  TEngine.ThrowException(ok);
  ptr := nil;
end;

procedure TSequence.GetInfo(info: PSequenceInfo);
var
  ok : Boolean;
begin
  ok := TLN_GetSequenceInfo(ptr, info);
  TEngine.ThrowException(ok);
end;

{ TSequencePack }

procedure TSequencePack.Add(sequence: TSequence);
var
  ok : Boolean;
begin
  ok := TLN_AddSequenceToPack(ptr, sequence.ptr);
  TEngine.ThrowException(ok);
end;

constructor TSequencePack.Create(res: PInteger);
begin
  ptr := res;
end;

procedure TSequencePack.Delete;
var
  ok : Boolean;
begin
  ok := TLN_DeleteSequencePack(ptr);
  TEngine.ThrowException(ok);
  ptr := nil;
end;

function TSequencePack.Find(name: PAnsiChar): TSequence;
var
  retval : PInteger;
begin
  retval := TLN_FindSequence(ptr, name);
  TEngine.ThrowException(retval <> nil);
  Result := TSequence.Create(retval);
end;

class function TSequencePack.FromFile(filename: PAnsiChar): TSequencePack;
var
  retval : PInteger;
begin
  retval := TLN_LoadSequencePack(filename);
  TEngine.ThrowException(retval <> nil);
  Result := TSequencePack.Create(retval);
end;

function TSequencePack.Get(index: Integer): TSequence;
var
  retval : PInteger;
begin
  retval := TLN_GetSequence(ptr, index);
  TEngine.ThrowException(retval <> nil);
  Result := TSequence.Create(retval);
end;

function TSequencePack.GetSequences: Integer;
begin
  Result := TLN_GetSequencePackCount(ptr);
end;

{ TTilengineException }

constructor TTilengineException.Create(const msg: string);
var
  excpt : string;
begin
  excpt := msg;
  if msg = '' then excpt := 'Unknown error';
  inherited Create(excpt);
end;

end.
