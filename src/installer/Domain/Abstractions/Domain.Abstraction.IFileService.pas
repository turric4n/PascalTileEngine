unit Domain.Abstraction.IFileService;

interface

type
  IFileService = interface['{926A93F3-FAA1-45BB-912D-241EEBFD4845}']
    procedure RenameFile(const srcfileName, dstfileName : string);
    procedure CopyFile(const srcFile, dstFile : string);
    procedure DeleteFile(const src : string);
    procedure NewFile(const path : string);
  end;

implementation

end.
