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

unit uActorHandler;

interface

uses
  {$IFDEF FPC}
  SysUtils,
  {$ELSE}
  System.SysUtils,
  {$ENDIF }
  uActor,
  Tilengine;

type
  /// <summary>
  /// Will manage zombie actor in the game, actors can be owned and controlled by entities
  /// avoid to have more than an instance per game.
  /// </summary>
  TActorHandler = class
    private
      fsequencepack : TSequencePack;
      fengine : TEngine;
      factors : TArray<TActor>;
      fcount : Integer;
      ftime : Integer;
      fwindow : TWindow;
    public
      property Engine : TEngine read fengine;
      property Window : TWindow read fwindow;
      property Time : Integer read ftime;
      function GetAvailableActor(First, Len : Integer) : TActor;
      function GetActor(idx : Integer) : TActor;
      procedure CreateActors(num : Integer);
      procedure DeleteActors;
      procedure TaskActors(time : Integer);
      constructor Create(engine : TEngine; Window : TWindow);
  end;

implementation

{ TActorHandler }

constructor TActorHandler.Create(engine : TEngine; Window : TWindow);
begin
  fengine := engine;
  fwindow := Window;
end;

procedure TActorHandler.CreateActors(num : Integer);
var
  x : Integer;
begin
  // Create available actors
  if Length(factors) > 0 then raise Exception.Create('Actors already initialized');
  SetLength(factors, num);
  for x := 0 to num - 1 do factors[x] := TActor.Create(x);
end;

procedure TActorHandler.DeleteActors;
var
  actor : TActor;
begin
  // Unused
  for actor in factors do actor.Free;
end;

function TActorHandler.GetActor(idx: Integer): TActor;
begin
  if (Length(factors) < 1) and (factors[idx] <> nil) then raise Exception.Create('Actor not found');
  Result := factors[idx];
end;

function TActorHandler.GetAvailableActor(First, Len: Integer) : TActor;
var
  c, last : Integer;
begin
  { Normally actors are sorted by index, imagine we have a main actor that will be nº (1) - 1) and imagine we have bullets, bullets
    are in consecutive order ex. nº 32 then if you want a bullet actor you will need to find from 32 to the max bullet actors
                                                   (32, max_bullets + 32)
  }
  Result := nil;
  if (Length(factors) > 0) then
  begin
    last := First + Len;
    Result := nil;
    for c := first to last - 1 do
      if factors[c].State = 0 then
      begin
        Result := factors[c];
        Break;
      end;
  end;
end;

procedure TActorHandler.TaskActors(time: Integer);
var
  actor : TActor;
begin
  // Simple zombie actor task, will call the assigned entity-actor callback
  if Length(factors) > 0 then
  begin;
    ftime := time;
    for actor in factors do actor.Task(ftime);
  end;
end;

end.
