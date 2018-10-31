program Setup;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Domain.Abstraction.IRepository in 'Domain\Abstractions\Domain.Abstraction.IRepository.pas',
  Domain.Abstraction.IProcessService in 'Domain\Abstractions\Domain.Abstraction.IProcessService.pas',
  Domain.Abstraction.ICompilerService in 'Domain\Abstractions\Domain.Abstraction.ICompilerService.pas',
  Domain.Abstraction.IFileService in 'Domain\Abstractions\Domain.Abstraction.IFileService.pas',
  Infrastructure.LinuxFileRepository in 'Infrastructure\Repositories\Infrastructure.LinuxFileRepository.pas',
  Infrastructure.WindowsFileRepository in 'Infrastructure\Repositories\Infrastructure.WindowsFileRepository.pas',
  IOC.ServiceLocator in 'Utils\IOC\IOC.ServiceLocator.pas',
  Application.PascalTilengineCompilationService in 'Application\Application.PascalTilengineCompilationService.pas',
  Infrastructure.FPCCompilerService in 'Infrastructure\Services\Infrastructure.FPCCompilerService.pas',
  Infrastructure.DelphiCompilerService in 'Infrastructure\Services\Infrastructure.DelphiCompilerService.pas',
  Patterns.StandardSubjectObserver in 'Utils\Observer\Patterns.StandardSubjectObserver.pas',
  Patterns.ISubject in 'Utils\Observer\Patterns.ISubject.pas',
  Patterns.StandardSubject in 'Utils\Observer\Patterns.StandardSubject.pas',
  Patterns.IObserver in 'Utils\Observer\Patterns.IObserver.pas';

begin
  try

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
