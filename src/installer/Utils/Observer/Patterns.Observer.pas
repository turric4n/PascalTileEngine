unit Patterns.Observer;

interface

uses
  Patterns.IObserver,
  System.Classes,
  System.Generics.Collections;

type
  TNotifyWithMessage = procedure(const msg : string; aSender : TInterfacedObject) of object;

  TSubjectObserver = class(TInterfacedObject, IObserver)
  private
    FEnabled: Boolean;
    FOnChange: TNotifyEvent;
    FOnChangeWithMessage : TNotifyWithMessage;
  protected
    procedure SubjectChanged;
    procedure SubjectChangedWithMessage(const msg : string; aSender : TObject);
  public
    function IsObserving : Boolean;
    procedure EnableObserving;
    procedure DisableObserving;
    constructor Create;
  end;

implementation

{ TSubjectObserver }

procedure TSubjectObserver.SubjectChanged;
begin
  if Assigned(FOnChange) then FOnChange;
end;

procedure TSubjectObserver.SubjectChangedWithMessage(const msg: string; aSender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(msg, aSender);
end;

constructor TSubjectObserver.Create;
begin
  FEnabled := True;
end;

procedure TSubjectObserver.DisableObserving;
begin
  FEnabled := False;
end;

procedure TSubjectObserver.EnableObserving;
begin
  FEnabled := True;
end;

function TSubjectObserver.IsObserving: Boolean;
begin
  Result := FEnabled;
end;

end.
