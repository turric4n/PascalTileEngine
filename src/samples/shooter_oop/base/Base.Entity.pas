unit Base.Entity;

interface

uses
  Interfaces.Entity,
  uTypes,
  Tilengine,
  TilengineBindings,
  uActor,
  uActorHandler;

type
  /// <summary>
  /// Abstract entity class, don't use this class directly but inherit from.
  /// Entities owns and manage actor actions, entities can the logical manager of zombie actors,
  /// because entities have logic control of the input or animations, actor handler will fire actor task,
  /// you need to override actor task to control actor actions or apareance. Entity is exposed to main game but not actor
  /// </summary>

  TEntity = class(TInterfacedObject, IEntity)
    protected
      fsequencepack : TSequencePack;
      fspriteset : TSpriteset;
      fmyactor : TActor;
      factordef : TActorDef;
      factorhandler : TActorHandler;
      procedure ActorProcess(aSender : TObject; Time : Word); virtual; abstract;
      procedure ActorCollision(aSender : TObject; Power : Integer); virtual; abstract;
      procedure ActorSetup; virtual; abstract;
    public
      property Actor : TActor read fmyactor write fmyactor;
      constructor Create(ActorHandler : TActorHandler; actorDef : TActorDef; SpriteSet : TSpriteSet; SequencePack : TSequencePack); overload;
      constructor Create(ActorHandler : TActorHandler; Actor : TActor; SpriteSet : TSpriteset; SequencePack : TSequencePack); overload;
      constructor Create(ActorHandler : TActorHandler; SpriteSet : TSpriteset; SequencePack : TSequencePack); overload;
  end;

implementation

{ TEntity }

constructor TEntity.Create(ActorHandler : TActorHandler; actorDef : TActorDef; SpriteSet : TSpriteSet; SequencePack : TSequencePack);
begin
  fspriteset := SpriteSet;
  fsequencepack := SequencePack;
  factorhandler := ActorHandler;
  factordef := actorDef;
  fmyactor := factorhandler.GetActor(Ord(actorDef));
end;

constructor TEntity.Create(ActorHandler: TActorHandler; Actor: TActor;
  SpriteSet: TSpriteset; SequencePack: TSequencePack);
begin
  fspriteset := SpriteSet;
  fsequencepack := SequencePack;
  factorhandler := ActorHandler;
  fmyactor := Actor;
end;

constructor TEntity.Create(ActorHandler: TActorHandler; SpriteSet: TSpriteset;
  SequencePack: TSequencePack);
begin
  fspriteset := SpriteSet;
  fsequencepack := SequencePack;
  factorhandler := ActorHandler;
end;

end.
