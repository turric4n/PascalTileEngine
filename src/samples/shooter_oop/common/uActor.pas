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
  Result := (fhitbox.x1 < actor.Hitbox.x2) and (fhitbox.x2 > Actor.Hitbox.x1) and
            (fhitbox.y1 > Actor.Hitbox.y2) and (fhitbox.y2 > Actor.Hitbox.y1);
end;

constructor TActor.Create(Idx : Integer);
begin
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
  Result := Time >= ftimers[Timer];
end;

procedure TActor.Release;
begin
  fsprite.BlendMode := TBlend.BNone;
  fstate := 0;
end;

procedure TActor.SetTimeout(Time, Timer, Timeout: Integer);
begin
  ftimers[timer] := Time + Timeout;
end;

procedure TActor.Setup(Sprite: TSprite; Animation: TAnimation; ActorType: TActorType; x, y, w, h: Integer);
begin
  fstate := 1;
  fsprite := Sprite;
  fanimation := Animation;
  ftype := ActorType;
  fxpos := x;
  fypos := y;
  fwidth := w;
  fheight := h;
  UpdateHitbox;
end;

procedure TActor.Setup(Sprite: TSprite; ActorType: TActorType; x, y, w, h: Integer);
begin
  Setup(Sprite, nil, ActorType, x, y, w, h);
end;

procedure TActor.Task(Time: Integer);
begin
  // motion
  Inc(fxpos, fvxpos);
  Inc(fypos, fvypos);
  if Assigned(OnProcess) then OnProcess(Self, Time);
  if fstate <> 0 then
  begin
    UpdateHitbox;
    fsprite.SetPosition(fxpos, fypos);
  end
  else
  begin
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
