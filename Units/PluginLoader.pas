unit PluginLoader;

interface

uses
  Windows, SysUtils;

const
  KIT_VERSION = '1.0';

type
  PPluginInfo = ^TPluginInfo;
  TPluginInfo = Record
    Name: PChar;
    KitVersion: PChar;
    Version: PChar;
    Author: PChar;
    Description: PChar;
    ShowInMenu: Boolean;
    MenuCaption: PChar;
  end;

  TPluginGetInfo = function (const PluginInfo: PPluginInfo): Boolean; stdcall;
  TPluginCreateWindow = function (const WindowHandle: PDWORD): Boolean; stdcall;
  TPluginDestroyWindow = function(): Boolean; stdcall;

  PPluginEntry = ^TPluginEntry;
  TPluginEntry = Record
    IsLoaded: Boolean;
    IsEnabled: Boolean;
    ModuleHandle: DWORD;
    WindowHandle: DWORD;
    PluginPath: String;
    PluginInfo: TPluginInfo;
    PluginGetInfo: TPluginGetInfo;
    PluginCreateWindow: TPluginCreateWindow;
    PluginDestroyWindow: TPluginDestroyWindow;
  end;

  PPluginTable = ^TPluginTable;
  TPluginTable = Array of TPluginEntry;

  PPluginCollection = ^TPluginCollection;
  TPluginCollection = Record
    PluginTable: TPluginTable;
    PluginCount: DWORD;
    PluginAvailable: DWORD;
  end;

function LoadPlugin(const FileName: String; const PluginEntry: PPluginEntry): Boolean;
procedure LoadPluginCollection(const SourceFolder: String; const PluginCollection: PPluginCollection);

procedure UnloadPlugin(const PluginEntry: PPluginEntry);
procedure UnloadPluginCollection(const PluginCollection: PPluginCollection);

implementation


function LoadPlugin(const FileName: String; const PluginEntry: PPluginEntry): Boolean;
var
  ModuleHandle: DWORD;
  ProcAddress: Pointer;

  PluginGetInfo: TPluginGetInfo;
  PluginCreateWindow: TPluginCreateWindow;
  PluginDestroyWindow: TPluginDestroyWindow;
begin
  Result:= False;

  ModuleHandle:= LoadLibrary(PChar(FileName));
  if ModuleHandle = 0 then
  Exit;

  ProcAddress:= GetProcAddress(ModuleHandle, 'PluginGetInfo');
  if ProcAddress = nil then
  begin
    FreeLibrary(ModuleHandle);
    Exit;
  end;

  PluginGetInfo:= ProcAddress;

  ProcAddress:= GetProcAddress(ModuleHandle, 'PluginCreateWindow');
  if ProcAddress = nil then
  begin
    FreeLibrary(ModuleHandle);
    Exit;
  end;

  PluginCreateWindow:= ProcAddress;

  ProcAddress:= GetProcAddress(ModuleHandle, 'PluginDestroyWindow');
  if ProcAddress = nil then
  begin
    FreeLibrary(ModuleHandle);
    Exit;
  end;

  PluginDestroyWindow:= ProcAddress;

  PluginEntry^.IsLoaded:= True;
  PluginEntry^.PluginPath:= FileName;
  PluginEntry^.ModuleHandle:= ModuleHandle;
  PluginGetInfo(@PluginEntry^.PluginInfo);
  PluginEntry^.PluginGetInfo:= PluginGetInfo;
  PluginEntry^.PluginCreateWindow:= PluginCreateWindow;
  PluginEntry^.PluginDestroyWindow:= PluginDestroyWindow;
  // Check if kit version is correct, we dont load plugins we dont support
  PluginEntry^.IsEnabled:= PluginEntry^.PluginInfo.KitVersion = KIT_VERSION;
  Result:= True;
end;

procedure UnloadPlugin(const PluginEntry: PPluginEntry);
begin
  if not PluginEntry^.IsLoaded then
  Exit;

  if PluginEntry^.WindowHandle <> 0 then
  PluginEntry^.PluginDestroyWindow;

  FreeLibrary(PluginEntry^.ModuleHandle);
  FillChar(PluginEntry^, SizeOf(TPluginEntry), 0);
end;


procedure LoadPluginCollection(const SourceFolder: String; const PluginCollection: PPluginCollection);
var
  Found: Integer;
  SRec: TSearchRec;
  PluginPath: String;
  PluginEntry: PPluginEntry;
begin
  try
    Found:= FindFirst(SourceFolder + '*.*', faAnyFile, SRec);
    while Found = 0 do
    begin
      if (SRec.Attr and faDirectory = faDirectory) and (not ((SRec.Name = '..') or (SRec.Name = '.'))) then
      LoadPluginCollection (SourceFolder + SRec.Name + '\', PluginCollection)
    else
      begin
        if (LowerCase(ExtractFileExt(SRec.Name)) = '.dll') then
        begin
          PluginPath:= SourceFolder + SRec.Name;

          if PluginCollection^.PluginAvailable = 0 then
          begin
            SetLength(PluginCollection^.PluginTable, PluginCollection^.PluginCount + 16);
            PluginCollection^.PluginAvailable:= 16;
          end;

          PluginEntry:= @PluginCollection^.PluginTable[PluginCollection^.PluginCount];
          FillChar(PluginEntry^, SizeOf(TPluginEntry), 0);

          if LoadPlugin(PluginPath, PluginEntry) then
          begin
            Inc(PluginCollection^.PluginCount);
            Dec(PluginCollection^.PluginAvailable);
          end;
        end;
      end;
      Found:=FindNext(SRec);
    end;
  finally
    FindClose(SRec)
  end;
end;

procedure UnloadPluginCollection(const PluginCollection: PPluginCollection);
var
  PluginIndex: DWORD;
begin
  if (PluginCollection = nil) or (PluginCollection^.PluginCount = 0) then
  Exit;

  for PluginIndex := 0 to PluginCollection^.PluginCount - 1 do
  begin
    UnloadPlugin(@PluginCollection^.PluginTable[PluginIndex]);
  end;

  SetLength(PluginCollection^.PluginTable, 0);
  FillChar(PluginCollection^, SizeOf(TPluginCollection), 0);
end;

end.
