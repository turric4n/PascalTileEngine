unit Entities.Claw;

interface

uses
  Tilengine,
  TilengineBindings,
  uTypes,
  uActorHandler,
  Base.Entity;

type
  TClaw = class(TEntity)
    private
      factorTypedef : TActorDef;
      FRadius: Integer;
      FAngle: Integer;
      procedure ActorSetup; override;
      procedure SetAngle(const Value: Integer);
      procedure SetRadius(const Value: Integer);
    public
      property Radius : Integer read FRadius write SetRadius;
      property Angle : Integer read FAngle write SetAngle;
      constructor Create(ActorHandler : TActorHandler; actorTypedef : TActorDef; SpriteSet : TSpriteSet; SequencePack : TSequencePack);
  end;

implementation

{ TClaw }

procedure TClaw.ActorSetup;
begin
  fmyactor.Sprite := factorhandler.Engine.GetSprite(Ord(factordef));
  fmyactor.Sprite.Setup(fspriteset, TTileflags.FNone);
  fmyactor.Animation := factorhandler.Engine.GetAnimation(ord(factordef));
  fmyactor.Animation.SetSpriteAnimation(fmyactor.Idx, fsequencepack.Find('seq_claw'), 0);
end;

constructor TClaw.Create(ActorHandler : TActorHandler; actorTypedef : TActorDef; SpriteSet : TSpriteSet; SequencePack : TSequencePack);
var
  clawsprite : TSprite;
begin
  inherited Create(ActorHandler, actorTypedef, SpriteSet, SequencePack);
  ActorSetup;
end;

procedure TClaw.SetAngle(const Value: Integer);
begin
  FAngle := Value;
end;

procedure TClaw.SetRadius(const Value: Integer);
begin
  FRadius := Value;
end;

end.
