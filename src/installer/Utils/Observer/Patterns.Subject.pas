unit Patterns.Subject;

interface

uses
  Patterns.ISubject,
  Patterns.IObserver,
  System.Generics.Collections;

type
  TSubject = class(TInterfacedObject, ISubject)
  private
    FObservers: TList<IObserver>;
  protected
    procedure Change;
    procedure ChangeWithMessage(const msg : string);
  public
    constructor Create;
    destructor Destroy; override;
    procedure RegisterObserver(Observer: IObserver);
    procedure UnregisterObserver(Observer: IObserver);
  end;

implementation

{ TSubject }

procedure TSubject.Change;
var
  Obs: IObserver;
  I: Integer;
begin
  for I := 0 to FObservers.Count - 1 do
  begin
    Obs := FObservers[I];
    if Obs.IsObserving then Obs.SubjectChanged;
  end;
end;

procedure TSubject.ChangeWithMessage(const msg: string);
var
  Obs: IObserver;
  I: Integer;
begin
  for I := 0 to FObservers.Count - 1 do
  begin
    Obs := FObservers[I];
    if Obs.IsObserving then Obs.SubjectChangedWithMessage(msg, Self);
  end;
end;

constructor TSubject.Create;
begin
  inherited;
  FObservers := TList<IObserver>.Create;
end;

destructor TSubject.Destroy;
begin
  FObservers.Free;
  inherited;
end;

procedure TSubject.RegisterObserver(Observer: IObserver);
begin
  if FObservers.IndexOf(Observer) = -1 then FObservers.Add(Observer);
end;

procedure TSubject.UnregisterObserver(Observer: IObserver);
begin
  if FObservers.IndexOf(Observer) = 1 then FObservers.Remove(Observer);
end;

end.
