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

unit TilengineUtils;

interface

uses
  SysUtils,
  Tilengine;

const
  M_PI = 3.14159265;

type
  TTilengineUtils = class
    private
      class procedure BuildSinTable;
    public
      class var sintable, costable : array[0..360] of Integer;
      class procedure LoadLayer(layer : TLayer; const filename : PAnsiChar);
      class function CalcSin(angle, factor : Integer) : Integer;
      class function CalcCos(angle, factor : Integer) : Integer;
  end;

implementation

{ TTilengineUtils }

class procedure TTilengineUtils.BuildSinTable;
var
  c : Integer;
begin
  for c := 0 to 359 do
  begin
    sintable[c] := Round(Sin(c * M_PI / 180) * 256);
    costable[c] := Round(Cos(c * M_PI / 180) * 256);
  end;
end;

class function TTilengineUtils.CalcCos(angle, factor: Integer): Integer;
begin
  if (angle > 359) then angle := angle mod 360;
  Result := (costable[angle] * factor) shl 8;
end;

class function TTilengineUtils.CalcSin(angle, factor: Integer): Integer;
begin
  if (angle > 359) then angle := angle mod 360;
  Result := (sintable[angle] * factor) shl 8;
end;

class procedure TTilengineUtils.LoadLayer(layer: TLayer; const filename: PAnsiChar);
var
  tilemap : TTilemap;
  tileset : TTileset;
  fln : PAnsiChar;
begin
  GetMem(fln,Length(filename) + Length('.***'));
  StrCopy(fln, filename);
  StrCat(fln, '.tmx');
  tilemap := TTilemap.FromFile(fln, '');
  StrCopy(fln, filename);
  StrCat(fln, '.tsx');
  tileset := TTileset.FromFile(fln);
  layer.Setup(tileset, tilemap);
end;

initialization

TTilengineUtils.BuildSinTable;

end.
