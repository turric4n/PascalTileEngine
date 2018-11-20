unit Entities.Ship;

interface

uses
  Tilengine,
  TilengineBindings,
  uGlobal,
  uTypes,
  uActor,
  uActorHandler,
  Base.Entity,
  Interfaces.Entity,
  Entities.Bullet,
  Entities.Claw;


type
  TShip = class(TEntity)
    private
      fclaws : array[0..1] of TClaw;
      FLives : Integer;
      fhasclaw : Boolean;
      FWeapon : Char;
      procedure ActorSetup; override;
      procedure ProcessMovement(Time : Word);
      procedure ProcessShoot(Time : Word);
      procedure ActorProcess(aSender : TObject; Time : Word); override;
      procedure Shoot(shootType : TActorType; x, y : Integer);
      procedure SetLives(const Value: Integer);
      procedure SetWeapon(const Value: Char);
    public
      property Lives : Integer read FLives write SetLives;
      property Weapon : Char read FWeapon write SetWeapon;
      property isClaw : Boolean read fhasclaw write fhasclaw;
      constructor Create(ActorHandler : TActorHandler; SpriteSet : TSpriteSet; SequencePack : TSequencePack);
  end;

implementation

{ TShip }

procedure TShip.ActorProcess(aSender: TObject; Time : Word);
begin
  ProcessMovement(Time);
  ProcessShoot(Time);
end;

constructor TShip.Create(ActorHandler : TActorHandler; SpriteSet : TSpriteSet; SequencePack : TSequencePack);
begin
  inherited Create(ActorHandler, TActorDef.acShip, SpriteSet, SequencePack);
  //fclaws[0] := TClaw.Create(factorhandler, TActorDef.acClaw1, SpriteSet, SequencePack);
  //fclaws[1] := TClaw.Create(factorhandler, TActorDef.acClaw2, SpriteSet, SequencePack);
  fhasclaw := True;
  ActorSetup;
end;

procedure TShip.ProcessMovement(Time: Word);
var
  window : TWindow;
  spriteidx : Integer;
begin
  { * Logical movement * }

  // Get window singleton instance (We need this to process input basically)
  window := factorhandler.Window;
  // Process X axis motion (Fixed engine hardware resolution) and move 2 pixels each time (VX axis)
  if (window.GetInput(TInput.Left)) and (fmyactor.X > 0) then fmyactor.VX := -2
  else if (window.GetInput(TInput.Right)) and (fmyactor.X < 390) then fmyactor.VX := 2
  else fmyactor.VX := 0;
  // Process Y axis motion (Fixed engine hardware resolution) and move 2 pixels each time (VY axis)
  if (window.GetInput(TInput.Up)) and (fmyactor.Y > 0) then fmyactor.VY := -2
  else if (window.GetInput(TInput.Down)) and (fmyactor.Y < 224) then fmyactor.VY := 2
  else fmyactor.VY := 0;

  { * Visual motion effect * }

  // Ship has 5 movements (sprite frames) (1 - most up, 2 - up, 3 - normal, 4 - down, 5 - most down)

  // Get frame movement timeout to change sprite if momement changed
  if fmyactor.GetTimeout(Time, 0) then
  begin
    // Get actual sprite frame
    spriteidx := fmyactor.Sprite.Picture;
    // Set 0-6 frame time timeout to play with sprite frames and make a fluid motion effect
    fmyactor.SetTimeout(Time, 0, 6);
    // If vertical down movement
    if fmyactor.VY < 0 then
    begin
      // Decrease sprite frame if current sprite frame is greater than 0
      if spriteidx > 0 then
        fmyactor.Sprite.Picture := spriteidx - 1;
    end
    // If vertical UP movement
    else if fmyactor.VY > 0 then
    begin
      // Increase sprite frame if current sprite frame is smaller than 6
      if spriteidx < 6 then
        fmyactor.Sprite.Picture := spriteidx + 1;
    end
    else
    begin
      // Let the ship return to normal sprite
      if spriteidx > 3 then
        fmyactor.Sprite.Picture := spriteidx - 1
      else if spriteidx < 3 then
        fmyactor.Sprite.Picture := spriteidx + 1;
    end;
  end;
end;

procedure TShip.ProcessShoot(Time: Word);
var
  window : TWindow;
  spriteidx : Integer;
begin
  window := factorhandler.Window;
  if fmyactor.GetTimeout(Time, 1) and window.GetInput(TInput.Button_A) then
  begin
    // 10 frames per shoot
    fmyactor.SetTimeout(Time, 1, 10);
    Shoot(TActorType.atBladeB, fmyactor.X + 32, fmyactor.Y + (Random(RANDOMSEED) mod 10) - 5);
  end;
end;

procedure TShip.ActorSetup;
var
  shipsprite : TSprite;
begin
  shipsprite := factorhandler.Engine.GetSprite(Ord(TActorDef.acShip));
  fmyactor.Setup(shipsprite, TActorType.atShip, 100, 100, 32, 16);
  fmyactor.OnProcess := ActorProcess;
  fmyactor.Sprite.Setup(fspriteset, TTileflags.FNone);
  fmyactor.Sprite.Picture := 3;
end;

procedure TShip.SetLives(const Value: Integer);
begin
  FLives := Value;
end;

procedure TShip.SetWeapon(const Value: Char);
begin
  FWeapon := Value;
end;

procedure TShip.Shoot(shootType: TActorType; x, y: Integer);
var
  bullet : IEntity;
begin
  bullet := TBullet.Create(x, y, shootType, factorhandler, fspriteset, fsequencepack);
end;


end.
