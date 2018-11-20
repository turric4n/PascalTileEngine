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

{ TExplosion }

procedure TBullet.ActorProcess(aSender: TObject; Time: Word);
var
  actor : TActor;
  enemytarget : TActor;
  c, last, power : Integer;
begin
  // Actor-Bullet shoot callback
  actor := TActor(aSender);
  if actor.X < 430 then
  begin
    case Actor.ActorType of
      atBladeB : power := 2
      else power := 1;
    end;
    last := Ord(TActorDef.acEnemy1) + MAX_ENEMIES;
    for c := Ord(TActorDef.acEnemy1) to last - 1 do
    begin
      enemytarget := factorhandler.GetActor(c);
      if (enemytarget.State <> 0) and (enemytarget.ActorType = TActorType.atEnemy) and (actor.CheckCollisionWith(enemytarget)) then
      begin
        if Assigned(enemytarget.OnHit) then enemytarget.OnHit(actor, power);
      end;
    end;
  end
  else Actor.Release;
end;

procedure TBullet.ActorSetup;
var
  bullet_spr : TSprite;
  bullet_ani : TAnimation;
  bullet_seq : TActorAnim;
  bullet_size : Integer;
begin
  fmyactor := factorhandler.GetAvailableActor(Ord(TActorDef.acBullet1), MAX_BULLETS);
  if fmyactor <> nil then
  begin
    bullet_spr := factorhandler.Engine.GetSprite(fmyactor.Idx);
    bullet_ani := factorhandler.Engine.GetAnimation(bullet_spr.Idx);
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
    fmyactor.Setup(bullet_spr, bullet_ani, factortype, fx, fy, bullet_size, bullet_size);
    fmyactor.OnProcess := ActorProcess;
    fmyactor.VX := 8;
    fmyactor.VY := 0;
    fmyactor.Sprite.Setup(fspriteset, TTileFlags.FNone);
    fmyactor.Animation.SetSpriteAnimation(bullet_spr.Idx, fsequencepack.Get(Ord(bullet_seq)), 0);
  end;
end;

constructor TBullet.Create(X, Y : Integer; ActorDef : TActorType; ActorHandler : TActorHandler; SpriteSet : TSpriteSet; SequencePack : TSequencePack);
begin
  inherited Create(ActorHandler, SpriteSet, SequencePack);
  fx := x;
  fy := y;
  ActorSetup;
end;

end.
