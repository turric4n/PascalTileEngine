unit Domain.Abstraction.IRepository;

interface

type
  IRepository = interface['{8811F70D-BDDA-433F-9E84-9011EADACD55}']
    procedure Rename(const srcName, dstName : string);
    procedure Copy(const src, dst : string);
    procedure Delete(const src : string);
    procedure New(const name : string);
  end;

implementation

end.
