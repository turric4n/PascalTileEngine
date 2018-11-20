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
  // Is animation end?
  if not fmyactor.Animation.Active then
  begin
    // Release actor
    fmyactor.Release;
    // Free entity
    Free;
  end;
end;

procedure TExplosion.ActorSetup;
var
  explosion_sprite : TSprite;
  explosion_anim : TAnimation;
  explosion_seq : TSequence;
begin
  // Get passed enemy actor sprite
  explosion_sprite := factorhandler.Engine.GetSprite(fmyactor.Idx);
  // Get current enemy animation
  explosion_anim := factorhandler.Engine.GetAnimation(explosion_sprite.Idx);
  // Get explosion sequence
  explosion_seq := fsequencepack.Get(Ord(TActorAnim.aaExpl02));
  // Setup enemy actor to be a explosion
  fmyactor.Setup(explosion_sprite, explosion_anim, TActorType.atExplosion, fmyactor.X, fmyactor.Y, 32, 32);
  // Assign process callback
  fmyactor.OnProcess := ActorProcess;
  // Setup the spriteset
  fmyactor.Sprite.Setup(fspriteset, TTileflags.FNone);
  // Set explosion animation (no loop)
  fmyactor.Animation.SetSpriteAnimation(explosion_sprite.Idx, explosion_seq, 1);
end;

constructor TExplosion.Create(Actor: TActor; ActorHandler: TActorHandler; SpriteSet: TSpriteSet; SequencePack: TSequencePack);
begin
  inherited Create(ActorHandler, Actor, SpriteSet, SequencePack);
  ActorSetup;
end;

end.
