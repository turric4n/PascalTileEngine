unit Patterns.StandardSubject;

interface

uses
  Patterns.ISubject,
  Patterns.IObserver,
  System.Generics.Collections;

type
  TStandardSubject = class(TInterfacedObject, ICustomSubject)
  private
    FObservers: TList<ICustomObserver>;
  protected
    procedure Change;
    procedure ChangeWithMessage(const msg : string; aSender : ICustomObserver);
  public
    constructor Create;
    destructor Destroy; override;
    procedure RegisterObserver(Observer: ICustomObserver);
    procedure UnregisterObserver(Observer: ICustomObserver);
  end;

implementation

{ TSubject }

procedure TStandardSubject.Change;
var
  Obs: ICustomObserver;
  I: Integer;
begin
  for I := 0 to FObservers.Count - 1 do
  begin
    Obs := FObservers[I];
    if Obs.IsObserving then Obs.SubjectChanged;
  end;
end;

procedure TStandardSubject.ChangeWithMessage(const msg : string; aSender : ICustomObserver);
var
  Obs: ICustomObserver;
  I: Integer;
begin
  for I := 0 to FObservers.Count - 1 do
  begin
    Obs := FObservers[I];
    if Obs.IsObserving then Obs.SubjectChangedWithMessage(msg, Self);
  end;
end;

constructor TStandardSubject.Create;
begin
  inherited;
  FObservers := TList<ICustomObserver>.Create;
end;

destructor TStandardSubject.Destroy;
begin
  FObservers.Free;
  inherited;
end;

procedure TStandardSubject.RegisterObserver(Observer: ICustomObserver);
begin
  if FObservers.IndexOf(Observer) = -1 then FObservers.Add(Observer);
end;

procedure TStandardSubject.UnregisterObserver(Observer: ICustomObserver);
begin
  if FObservers.IndexOf(Observer) = 1 then FObservers.Remove(Observer);
end;

end.
