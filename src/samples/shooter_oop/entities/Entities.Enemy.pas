unit Entities.Enemy;

interface

uses
  Tilengine,
  TilengineBindings,
  uGlobal,
  uTypes,
  uActor,
  uActorHandler,
  Interfaces.Entity,
  Base.Entity,
  Entities.Explosion;

type
  TEnemy = class(TEntity)
    private
      FLives : Integer;
      FWeapon : Char;
      procedure ActorSetup; override;
      procedure ProcessMovement(Time : Word);
      procedure ActorProcess(aSender : TObject; Time : Word); override;
      procedure ActorHit(aSender : TObject; Power : Integer);
      procedure SetWeapon(const Value: Char);
    public
      property Weapon : Char read FWeapon write SetWeapon;
      constructor Create(ActorHandler : TActorHandler; SpriteSet : TSpriteSet; SequencePack : TSequencePack);
  end;

implementation

{ TEnemy }

procedure TEnemy.ActorHit(aSender: TObject; Power: Integer);
var
  explosion : IEntity;
begin
  fmyactor.Life := fmyactor.Life - 1;
  if fmyactor.Life < 1 then
  begin
    explosion := TExplosion.Create(fmyactor, factorhandler, fspriteset, fsequencepack);
  end;
end;

procedure TEnemy.ActorProcess(aSender: TObject; Time: Word);
begin
  ProcessMovement(Time);
end;

procedure TEnemy.ActorSetup;
var
  enemy_sprite : TSprite;
begin
  fmyactor := factorhandler.GetAvailableActor(Ord(TActorDef.acEnemy1), MAX_ENEMIES);
  if fmyactor <> nil then
  begin
    enemy_sprite := factorhandler.Engine.GetSprite(fmyactor.Idx);
    fmyactor.Setup(enemy_sprite, TActorType.atEnemy, WIDTH, Random(RANDOMSEED) mod 200, 32, 16);
    // Start values
    fmyactor.VX := -(Random(RANDOMSEED) mod 3 + 2);
    fmyactor.Life := 8;
    fmyactor.SetTimeout(factorhandler.Time, 1, 60);
    fmyactor.Sprite.Setup(fspriteset, TTileflags.FNone);
    fmyactor.Sprite.Picture := 25;
    // Assign Callbacks
    fmyactor.OnProcess := ActorProcess;
    fmyactor.OnHit := ActorHit;
  end;
end;

constructor TEnemy.Create(ActorHandler: TActorHandler; SpriteSet: TSpriteSet;
  SequencePack: TSequencePack);
begin
  inherited Create(ActorHandler, SpriteSet, SequencePack);
  ActorSetup;
end;

procedure TEnemy.ProcessMovement(Time: Word);
var
  spriteidx : Integer;
begin
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
      // Decrease sprite frame if current sprite frame is greater than 23
      if spriteidx > 23 then
        fmyactor.Sprite.Picture := spriteidx - 1;
    end
    // If vertical UP movement
    else if fmyactor.VY > 0 then
    begin
      // Increase sprite frame if current sprite frame is smaller than 27
      if spriteidx < 27 then
        fmyactor.Sprite.Picture := spriteidx + 1;
    end
    else
    begin
      // Let the enemy return to normal sprite
      if spriteidx > 25 then
        fmyactor.Sprite.Picture := spriteidx - 1
      else if spriteidx < 25 then
        fmyactor.Sprite.Picture := spriteidx + 1;
    end;
  end;
  if fmyactor.GetTimeout(Time, 1) then
  begin

  end;

end;

procedure TEnemy.SetWeapon(const Value: Char);
begin

end;

end.
