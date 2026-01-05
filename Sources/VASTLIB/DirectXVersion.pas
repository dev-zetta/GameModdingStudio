unit DirectXVersion;

interface

uses
  Windows;
(*
const
  DIRECTX_UNKNOWN     = $00000000;
  DIRECTX_VERSION700  = $00000001;
  DIRECTX_VERSION70A  = $00000002;
  DIRECTX_VERSION800  = $00000003;
  DIRECTX_VERSION810  = $00000004;
  DIRECTX_VERSION900  = $00000005;
  DIRECTX_VERSION90A  = $00000006;
  DIRECTX_VERSION90B  = $00000006;
  DIRECTX_VERSION90C  = $00000006;
*)
(*
const
  DIRECTX_VERSION70 = WORD(Byte('7') or (Byte('0') shl 8));
  DIRECTX_VERSION80 = WORD(Byte('8') or (Byte('0') shl 8));
  DIRECTX_VERSION90 = WORD(Byte('9') or (Byte('0') shl 8));
*)

// Gets version of installed Direct X from registry entries... ActiveX may be more effective probably
function GetDirectXVersion (var dwMajorVersion:DWORD;var dwMinorVersion:DWORD):BOOLEAN;

implementation

function GetDirectXVersion (var dwMajorVersion:DWORD;var dwMinorVersion:DWORD):BOOLEAN;
var
  Version:Array[0..31] of BYTE;
  dwVersionSize:DWORD;
  dwHandle:HKEY;
begin
  Result:=False;

  //dwHandle:=0;
  if RegOpenKeyEx(HKEY_LOCAL_MACHINE,PCHAR('Software\Microsoft\DirectX'),0,KEY_READ,dwHandle) <> ERROR_SUCCESS then
  Exit;
  //FillChar(
  if RegQueryValueEx(dwHandle,'Version',nil,nil,@Version[0],@dwVersionSize) <> ERROR_SUCCESS then
  Exit;

  if (dwVersionSize <> 13) or (Version[8] <> BYTE('.')) then // 4.09.00.0904
  Exit;

  // Convert string to integer
  dwMajorVersion:= ((Version[$08] - $30) * $0A) + (Version[$09] - $30);
  dwMinorVersion:= ((Version[$0A] - $30) * $0A) + (Version[$0B] - $30);

  RegCloseKey(dwHandle);
  Result:=True;
end;


end.
