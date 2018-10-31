unit Patterns.StandardSubjectObserver;

interface

uses
  Patterns.IObserver,
  System.Classes,
  System.Generics.Collections;

type
  TNotifyWithMessage = procedure(const msg : string; aSender : TObject) of object;

  TStandardSubjectObserver = class(TInterfacedObject, ICustomObserver)
  private
    FEnabled: Boolean;
    FOnChange: TNotifyEvent;
    FOnChangeWithMessage : TNotifyWithMessage;
  protected
    procedure SubjectChanged;
    procedure SubjectChangedWithMessage(const msg : string; aSender : TObject);
  public
    function IsObserving : Boolean;
    procedure Observe;
    procedure UnObserve;
    constructor Create;
  end;

implementation

{ TSubjectObserver }

procedure TStandardSubjectObserver.SubjectChanged;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TStandardSubjectObserver.SubjectChangedWithMessage(const msg: string; aSender: TObject);
begin
  if Assigned(FOnChange) then FOnChangeWithMessage(msg, aSender);
end;

constructor TStandardSubjectObserver.Create;
begin
  FEnabled := True;
end;

procedure TStandardSubjectObserver.UnObserve;
begin
  FEnabled := False;
end;

procedure TStandardSubjectObserver.Observe;
begin
  FEnabled := True;
end;

function TStandardSubjectObserver.IsObserving: Boolean;
begin
  Result := FEnabled;
end;

end.
