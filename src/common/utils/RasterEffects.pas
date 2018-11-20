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

unit RasterEffects;

interface

uses
  TilengineBindings;

function InterpolateColor(v, v1, v2 : Integer; const color1, color2 : TColor) : TColor; inline;
function Lerp(x, x0, x1, fx0, fx1 : Single) : Single; overload; inline;
function Lerp(x, x0, x1, fx0, fx1 : Integer) : Integer; overload; inline;

implementation

// color interpolation
function InterpolateColor(v, v1, v2 : Integer; const color1, color2 : TColor) : TColor;
begin
  Result.R := Byte(Lerp(v, v1, v2, color1.R, color2.R));
  Result.G := Byte(Lerp(v, v1, v2, color1.G, color2.G));
  Result.B := Byte(Lerp(v, v1, v2, color1.B, color2.B));
end;


function Lerp(x, x0, x1, fx0, fx1 : Single) : Single; overload; inline;
begin
  Result := (fx0) + ((fx1) - (fx0))*((x) - (x0))/((x1) - (x0));
end;

function Lerp(x, x0, x1, fx0, fx1 : Integer) : Integer; overload; inline;
begin
  Result := (fx0) + ((fx1) - (fx0))*((x) - (x0))div((x1) - (x0));
end;

end.
