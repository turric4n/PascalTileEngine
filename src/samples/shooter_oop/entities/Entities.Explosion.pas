unit Entities.Explosion;

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
  TExplosion = class(TEntity)
    private
      procedure ActorSetup; override;
      procedure ActorProcess(aSender : TObject; Time : Word); override;
    public
      constructor Create(Actor : TActor; ActorHandler : TActorHandler; SpriteSet : TSpriteSet; SequencePack : TSequencePack);
  end;

implementation

{ TExplosion }

procedure TExplosion.ActorProcess(aSender: TObject; Time: Word);
begin
  if not fmyactor.Animation.Active then fmyactor.Release;
end;

procedure TExplosion.ActorSetup;
var
  explosion_sprite : TSprite;
  explosion_anim : TAnimation;
  explosion_seq : TSequence;
begin
  explosion_sprite := factorhandler.Engine.GetSprite(Ord(TActortype.atExplosion));
  explosion_anim := factorhandler.Engine.GetAnimation(explosion_sprite.Idx);
  explosion_seq := fsequencepack.Get(Ord(TActorAnim.aaExpl01));
  fmyactor.Setup(explosion_sprite, explosion_anim, TActorType.atExplosion, fmyactor.X, fmyactor.Y, 32, 32);
  fmyactor.OnProcess := ActorProcess;
  fmyactor.Sprite.Setup(fspriteset, TTileflags.FNone);
  fmyactor.Animation.SetSpriteAnimation(explosion_sprite.Idx, explosion_seq, 0);
  fmyactor.OnProcess := ActorProcess;
end;

constructor TExplosion.Create(Actor: TActor; ActorHandler: TActorHandler; SpriteSet: TSpriteSet; SequencePack: TSequencePack);
begin
  inherited Create(ActorHandler, Actor, SpriteSet, SequencePack);
  ActorSetup;
end;

end.
