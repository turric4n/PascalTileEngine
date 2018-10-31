unit Domain.Abstraction.IProcessService;

interface

type
  IProcessService = interface['{3829A8CC-9A2F-4795-9B1E-CF9C39129288}']
    procedure StartProcess(const processName, parameters : string);
    procedure KillProcess(const processName : string);
  end;

implementation

end.
