unit Domain.Abstraction.ICompilerService;

interface

type
  ICompilerService = interface['{926A93F3-FAA1-45BB-912D-241EEBFD4845}']
    procedure CompileProject(const srcfileName, dstfileName : string);
  end;

implementation

end.
