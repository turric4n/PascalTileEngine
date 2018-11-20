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

unit Entities.Bullet;

interface

uses
  Tilengine,
  TilengineBindings,
  uGlobal,
  uTypes,
  uActor,
  uActorHandler,
  Base.Entity;

type
  /// <summary>
  /// Basic bullet entity
  /// </summary>
  TBullet = class(TEntity)
    private
      fx, fy : Integer;
      factortype : TActorType;
      procedure ActorSetup; override;
      procedure ActorProcess(aSender : TObject; Time : Word); override;
    public
      constructor Create(X, Y : Integer; ActorDef : TActorType; ActorHandler : TActorHandler; SpriteSet : TSpriteSet; SequencePack : TSequencePack);
  end;

implementation

procedure TBullet.ActorProcess(aSender: TObject; Time: Word);
var
  enemytarget : TActor;
  c, last, power : Integer;
begin
  { * Actor-Bullet processing * }

  // Is bullet on the screen?
  if fmyactor.X < 430 then
  begin
    // Actor 2 bullet type
    case fmyactor.ActorType of
      atBladeB : power := 2
      else power := 1;
    end;

    { * Bullet Collision check * }
    // Get last enemy actor defined
    last := Ord(TActorDef.acEnemy1) + MAX_ENEMIES;
    // Iterate enemy actors
    for c := Ord(TActorDef.acEnemy1) to last - 1 do
    begin
      // Get target actor instance by idx
      enemytarget := factorhandler.GetActor(c);
       // Is enemy playing, ensures is an enemy and bullet collides ?
      if (enemytarget.State <> 0) and (enemytarget.ActorType = TActorType.atEnemy) and (fmyactor.CheckCollisionWith(enemytarget)) then
      begin
        // Ignite enemty Onhit callback and send this bullet
        if Assigned(enemytarget.OnHit) then enemytarget.OnHit(fmyactor, power);
        // Release bullet actor
        fmyactor.Release;
        // Free bullet entity instance
        Free;
        // Return
        Exit;
      end;
    end;
  end
  else
  begin
    // Bullet is out of bounds (screen), release actor and free entity instance
    Actor.Release;
    Free;
  end;
end;

procedure TBullet.ActorSetup;
var
  bullet_spr : TSprite;
  bullet_ani : TAnimation;
  bullet_seq : TActorAnim;
  bullet_size : Integer;
begin
  // Get the first available actor from the first index to last index
  fmyactor := factorhandler.GetAvailableActor(Ord(TActorDef.acBullet1), MAX_BULLETS);
  if fmyactor <> nil then
  begin
    // Get bullet sprite from the engine with the same index
    bullet_spr := factorhandler.Engine.GetSprite(fmyactor.Idx);
    // Get bullet animation from the sprite index
    bullet_ani := factorhandler.Engine.GetAnimation(bullet_spr.Idx);
    // Bullet type checking and setup
    case factortype of
      atBladeB :
      begin
        bullet_seq := TActorAnim.aaBlade1;
        bullet_size := 32;
      end
    else
      begin
        bullet_seq := TActorAnim.aaBlade2;
        bullet_size := 16;
      end;
    end;
    // Own actor and set inital state
    fmyactor.Setup(bullet_spr, bullet_ani, factortype, fx, fy, bullet_size, bullet_size);
    // Assign bullet actor process callback
    fmyactor.OnProcess := ActorProcess;
    // Move 8 pixels per frame X
    fmyactor.VX := 8;
    // Move 0 pixels per frame Y
    fmyactor.VY := 0;
    // Setup bullet sprite
    fmyactor.Sprite.Setup(fspriteset, TTileFlags.FNone);
    // Set sprite animation (shoot animation) with looping enabled (loop = 0)
    fmyactor.Animation.SetSpriteAnimation(bullet_spr.Idx, fsequencepack.Get(Ord(bullet_seq)), 0);
  end;
end;

constructor TBullet.Create(X, Y : Integer; ActorDef : TActorType; ActorHandler : TActorHandler; SpriteSet : TSpriteSet; SequencePack : TSequencePack);
begin
  inherited Create(ActorHandler, SpriteSet, SequencePack);
  // Inital bullet position
  fx := x;
  fy := y;
  ActorSetup;
end;

end.
