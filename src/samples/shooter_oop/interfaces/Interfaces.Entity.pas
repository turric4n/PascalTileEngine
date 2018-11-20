unit Interfaces.Entity;

interface

type
  IEntity = interface['{8E0E423A-F390-4594-A418-528AD7EBB85C}']
    procedure ActorProcess(aSender : TObject; Time : Word);
    procedure ActorCollision(aSender : TObject; Power : Integer);
    procedure ActorSetup;
  end;

implementation

end.
