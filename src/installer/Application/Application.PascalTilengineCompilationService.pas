unit Application.PascalTilengineCompilationService;

interface

uses
  Patterns.StandardSubject, Patterns.IObserver, Domain.Abstraction.ICompilerService, Domain.Abstraction.IFileService;

type
  //Is observer (to Infra layer) and Subject (for UI layer)
  TPascalTilengineCompilationService = class(TStandardSubject, ICustomObserver)
    private
      fcompilerService : ICompilerService;
      ffileService : IFileService;
      fobserving : Boolean;
      procedure Observe;
      procedure UnObserve;
      procedure
    public
      constructor Create(CompilerService : ICompilerService; FileService : IFileService);
      procedure SetupEnvironment;
      procedure SubjectChanged;
      procedure SubjectChangedWithMessage(const msg : string; aSender : TObject);
      function IsObserving : Boolean;
  end;

implementation

{ TPascalTilengineCompilationService }

procedure TPascalTilengineCompilationService.SetupEnvironment;
begin

end;

constructor TPascalTilengineCompilationService.Create(CompilerService: ICompilerService);
begin
  fcompilerService := CompilerService;
end;

procedure TPascalTilengineCompilationService.UnObserve;
begin
  fobserving := False;
end;

procedure TPascalTilengineCompilationService.Observe;
begin

end;

function TPascalTilengineCompilationService.IsObserving: Boolean;
begin

end;

procedure TPascalTilengineCompilationService.SubjectChanged;
begin

end;

procedure TPascalTilengineCompilationService.SubjectChangedWithMessage(const msg: string; aSender: TObject);
begin

end;

end.
