unit Application.PascalTilengineCompilationService;

interface

uses
  Patterns.Subject, Patterns.IObserver, Domain.Abstraction.ICompilerService;

type
  TPascalTilengineCompilationService = class(TSubject, IObserver)
    public
      constructor Create(CompilerService : ICompilerService);
      procedure CompileTilengine;
      procedure SubjectChanged;
      procedure SubjectChangedWithMessage(const msg : string; aSender : TObject);
      function IsEnabled : Boolean;
      procedure Enable;
      procedure Disable;
  end;

implementation

end.
