unit IOC.ServiceLocator;

interface

uses
  System.Generics.Collections,
  System.SysUtils;

type
  TServiceLocator = class
    private
      class var fServiceContainer : TDictionary<string,Pointer>;
      class var fInit : Boolean;
      class procedure InitContainer;
    public
      class procedure AddService(const InterfaceType : string; instance : Pointer);
      class function LocateService(const InterfaceType : string) : Pointer;
  end;

implementation

{ TServiceLocator }

class procedure TServiceLocator.AddService(const InterfaceType: string; instance: Pointer);
begin
  TServiceLocator.fServiceContainer.Add(InterfaceType, instance);
end;

class procedure TServiceLocator.InitContainer;
begin
  TServiceLocator.fServiceContainer := TDictionary<string,Pointer>.Create;
  TServiceLocator.fInit := True;
end;

class function TServiceLocator.LocateService(const InterfaceType: string): Pointer;
begin
  if not TServiceLocator.finit then TServiceLocator.InitContainer;
  if not TServiceLocator.fServiceContainer.TryGetValue(InterfaceType, Result) then
  raise Exception.Create(Format('IOC : Service for type %s is not registered', [InterfaceType]));
end;

end.
