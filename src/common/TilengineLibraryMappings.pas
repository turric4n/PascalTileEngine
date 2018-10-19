unit TilengineLibraryMappings;

interface

const
 {$IFDEF WINDOWS}
   LIB = 'Tilengine.dll';
 {$ELSE}
   LIB = 'libTilengine.so';
 {$ENDIF}




implementation

// In the compiled library :)

end.
