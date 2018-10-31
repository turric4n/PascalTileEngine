unit Patterns.ISubject;

interface

uses
  Patterns.IObserver;

type
  ICustomSubject = interface['{482F36DF-B109-4AA5-8231-CAC60A5B3065}']
    procedure Change;
    procedure ChangeWithMessage(const msg : string; aSender : ICustomObserver);
    procedure RegisterObserver(Observer: ICustomObserver);
    procedure UnregisterObserver(Observer: ICustomObserver);
  end;

implementation

end.
