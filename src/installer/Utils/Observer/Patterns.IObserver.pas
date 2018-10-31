unit Patterns.IObserver;

interface

type
  ICustomObserver = interface['{0C2445BF-322B-4277-848D-CC06CD8085BC}']
    procedure SubjectChanged;
    procedure SubjectChangedWithMessage(const msg : string; aSender : TObject);
    function IsObserving : Boolean;
    procedure Observe;
    procedure UnObserve;
  end;

implementation

end.
