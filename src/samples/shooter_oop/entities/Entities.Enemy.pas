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

unit Entities.Enemy;

interface

uses
  System.SysUtils,
  Tilengine,
  TilengineBindings,
  uGlobal,
  uTypes,
  uActor,
  uActorHandler,
  Interfaces.Entity,
  Base.Entity,
  Entities.Explosion;

const
  MAX_HEIGHT = 200;

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
  explosion : TEntity;
  bullet : TActor;
begin
  { * Enemy is hit! * }
  bullet := TActor(aSender);
  //Writeln(Format('Hit : Bullet x:%d , y:%d - Enemy : x:%d, y:%d', [bullet.X, bullet.Y, fmyactor.X, fmyactor.y]) );
  // Substract one life
  fmyactor.Life := fmyactor.Life - 1;
  if fmyactor.Life < 1 then
  begin
    // Enemy is blown... Create an explosion, and switch enemy actor sprite to explosion sprite
    explosion := TExplosion.Create(fmyactor, factorhandler, fspriteset, fsequencepack);
    // Free entity
    Free;
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
  // Get the first available actor from the first index to last index
  fmyactor := factorhandler.GetAvailableActor(Ord(TActorDef.acEnemy1), MAX_ENEMIES);
  if fmyactor <> nil then
  begin
    // Get enemy sprite from the engine with the same index
    enemy_sprite := factorhandler.Engine.GetSprite(fmyactor.Idx);
    // Actor setup
    fmyactor.Setup(enemy_sprite, TActorType.atEnemy, WIDTH, Random(RANDOMSEED) mod 200, 32, 16);
    // Assign random enemy x movement
    fmyactor.VX := -(Random(RANDOMSEED) mod 3 + 2);
    // Start life values
    fmyactor.Life := 8;
    // Set first 60 frames timeout among each movement
    fmyactor.SetTimeout(factorhandler.Time, 1, 60);
    // Sprite set spriteset
    fmyactor.Sprite.Setup(fspriteset, TTileflags.FNone);
    // Initial actor sprite frame index
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
  res : Integer;
begin
  { * Visual motion effect * }

  // Get frame movement timeout to change sprite if momement changed
  if fmyactor.GetTimeout(Time, 0) then
  begin
    // Get actual sprite frame
    spriteidx := fmyactor.Sprite.Picture;
    // Set 6 frames between make a fluid motion effect
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
  { * Logical motion dumb AI * }

  // First timer is elapsed
  if fmyactor.GetTimeout(Time, 1) then
  begin
    // Set first timer 60 frames timeout between actions
    fmyactor.SetTimeout(Time, 1, 60);
    // Random vertical motion
    res := Random(RandSeed) mod 3;
    if res = 0 then fmyactor.VY := -1
    else if res = 1 then fmyactor.VY := 1
    else fmyactor.VY := 0;
  end;

  // Border limits
  if fmyactor.Y < 0 then
  begin
    // Set enemy on the edge
    fmyactor.Y := 0;
    fmyactor.VY := 0;
  end
  else if fmyactor.Y > MAX_HEIGHT then
  begin
    // Set enemy on the bounds
    fmyactor.Y := MAX_HEIGHT;
    fmyactor.VY := 0;
  end;
  // Out of bounds (sceen)
  if Actor.X < -32 then
  begin
    // release actor
    fmyactor.Release;
    // free enemy entity instance
    Free;
  end;
end;

procedure TEnemy.SetWeapon(const Value: Char);
begin

end;

end.
