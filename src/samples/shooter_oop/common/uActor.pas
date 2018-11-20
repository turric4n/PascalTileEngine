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

unit uActor;

interface

uses
  Tilengine,
  TilengineBindings,
  uTypes;

type
  /// <summary>
  /// Zombie, collideable and manually assisted class but physical don't control an actor directly,
  /// needs to be controlled by an entity. Basically an actor is a way of
  /// communication between game logic and engine input and visuals, if you need an actor call actor handler first
  /// </summary>
  TActor = class
    private
      ftype : TActorType;
      fstate : Integer;
      fwidth : Integer;
      fheight : Integer;
      fxpos : Integer;
      fypos : Integer;
      fvxpos : Integer;
      fvypos : Integer;
      flife : Integer;
      fhitbox : TRect;
      ftimers : array[0..3] of Word;
      fprocessevent : TProcessEvent;
      fhitevent : THitEvent;
      fcollisionevent : TCollisionEvent;
      fusrdata : string;
      findex : Integer;
      fsprite : TSprite;
      fanimation : TAnimation;
    public
      property Hitbox : TRect read fhitbox;
      property Idx : Integer read findex;
      property State : Integer read fstate write fstate;
      property W : Integer read fwidth write fwidth;
      property H : Integer read fheight write fheight;
      property X : Integer read fxpos write fxpos;
      property Y : Integer read fypos write fypos;
      property VX : Integer read fvxpos write fvxpos;
      property VY : Integer read fvypos write fvypos;
      property OnProcess : TProcessEvent read fprocessevent write fprocessevent;
      property OnHit : THitEvent read fhitevent write fhitevent;
      property Sprite : TSprite read fsprite write fsprite;
      property UserData : string read fusrdata write fusrdata;
      property Life : Integer read flife write flife;
      property Animation : TAnimation read fanimation write fanimation;
      property ActorType : TActorType read ftype write ftype;
      constructor Create(Idx : Integer);
      procedure Setup(Sprite : TSprite; ActorType : TActorType; x, y, w, h : Integer); overload;
      procedure Setup(Sprite : TSprite; Animation : TAnimation; ActorType : TActorType; x, y, w, h : Integer); overload;
      procedure UpdateHitbox;
      procedure Release;
      procedure Task(Time : Integer);
      procedure SetTimeout(Time, Timer, Timeout : Integer);
      function GetTimeout(Time, Timer : Integer) : Boolean;
      function CheckCollisionWith(Actor : TActor) : Boolean;
  end;

implementation

{ TActor }

function TActor.CheckCollisionWith(Actor: TActor): Boolean;
begin
  // Collision result based on actors hitbox
  Result := (fhitbox.x1 < actor.Hitbox.x2) and (fhitbox.x2 > Actor.Hitbox.x1) and
            (fhitbox.y1 < actor.Hitbox.y2) and (fhitbox.y2 > Actor.Hitbox.y1);
end;

constructor TActor.Create(Idx : Integer);
begin
  // Actor default values
  fsprite := nil;
  fanimation := nil;
  fxpos := 0;
  fypos := 0;
  fwidth := 0;
  fheight := 0;
  fstate := 0;
  findex := idx;
end;

function TActor.GetTimeout(Time, Timer: Integer): Boolean;
begin
  // Basic timer elapsed time
  Result := Time >= ftimers[Timer];
end;

procedure TActor.Release;
begin
  // We unasign callback
  fprocessevent := nil;
  // Fade sprite
  fsprite.BlendMode := TBlend.BNone;
  // Set actor at available state
  fstate := 0;
end;

procedure TActor.SetTimeout(Time, Timer, Timeout: Integer);
begin
  // Basic timer implementation (Time : Current time; Timer : Target idx timer; Timeout : Seconds to configure)
  ftimers[timer] := Time + Timeout;
end;

procedure TActor.Setup(Sprite: TSprite; Animation: TAnimation; ActorType: TActorType; x, y, w, h: Integer);
begin
  // Set actor active and owned
  fstate := 1;
  // Assign actor current sprite
  fsprite := Sprite;
  // Assign actor animation
  fanimation := Animation;
  // Assign actor type
  ftype := ActorType;
  // Assign initial horizontal position
  fxpos := x;
  // Assign inital vertical position
  fypos := y;
  // Assign initial actor width (Warning! must be same as the sprite)
  fwidth := w;
  // Assign initial actor width (Warning! must be same as the sprite)
  fheight := h;
  // Call initial update hitbox
  UpdateHitbox;
end;

procedure TActor.Setup(Sprite: TSprite; ActorType: TActorType; x, y, w, h: Integer);
begin
  // Call to base constructor
  Setup(Sprite, nil, ActorType, x, y, w, h);
end;

procedure TActor.Task(Time: Integer);
begin
  {* Process basic tasks *}
  // If actor is owned/playing
  if fstate <> 0 then
  begin
    // Increment horizontal position by virtual movement index
    Inc(fxpos, fvxpos);
    // Increment vertical position by virtual movement index
    Inc(fypos, fvypos);
    // Ignite actor process callback
    if Assigned(OnProcess) then OnProcess(Self, Time);
    // Update hitbox
    UpdateHitbox;
    // Set sprite physical position
    fsprite.SetPosition(fxpos, fypos);
  end
  else
  begin
    // If actor is not owned/playing and has an assigned sprite then disable sprite on the screen
    if Assigned(fsprite) then
    begin
      fsprite.Disable;
      fsprite.DisableAnimation;
    end;
  end;
end;

procedure TActor.UpdateHitbox;
begin
  fhitbox.x1 := fxpos;
  fhitbox.y1 := fypos;
  fhitbox.x2 := fxpos + fwidth;
  fhitbox.y2 := fypos + fheight;
end;

end.
