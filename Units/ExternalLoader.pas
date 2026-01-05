unit ExternalLoader;

interface

uses
  Windows, SysUtils, IniFiles;

type
  PExternalInfo = ^TExternalInfo;
  TExternalInfo = Record
    ShellCommand: String;
    Executable: String;
    CommandLine: String;
    Version: String;
    Author: String;
    Description: String;
    MenuCaption: String;
  end;

  PExternalTable = ^TExternalTable;
  TExternalTable = Array of TExternalInfo;

  PExternalCollection = ^TExternalCollection;
  TExternalCollection = Record
    ExternalTable: TExternalTable;
    ExternalCount: DWORD;
    ExternalAvailable: DWORD;
  end;

function LoadExternal(const FileName: String; const ExternalInfo: PExternalInfo): Boolean;
procedure LoadExternalCollection(const SourceFolder: String; const ExternalCollection: PExternalCollection);

procedure UnloadExternal(const ExternalInfo: PExternalInfo);
procedure UnloadExternalCollection(const ExternalCollection: PExternalCollection);

implementation

var
  IsExePath: Boolean = False;
  ExePath: String;

function LoadExternal(const FileName: String; const ExternalInfo: PExternalInfo): Boolean;
var
  IniFile: TIniFile;
begin
  Result:= False;

  if ExternalInfo = nil then
  Exit;

  if not IsExePath then
  begin
    IsExePath:= True;
    ExePath:= ExtractFilePath(ParamStr(0));
  end;

  IniFile:=TIniFile.Create(FileName);
  ExternalInfo^.Executable:= IniFile.ReadString('Main', 'Executable', '');
  ExternalInfo^.Executable:= ExePath + ExternalInfo^.Executable;

  if not FileExists(ExternalInfo^.Executable) then
  begin
    IniFile.Free;
    Exit;
  end;

  ExternalInfo^.CommandLine:= IniFile.ReadString('Main', 'CommandLine', '');
  ExternalInfo^.ShellCommand:= ExternalInfo^.Executable + ' ' + ExternalInfo^.CommandLine;
  ExternalInfo^.Version:= IniFile.ReadString('Main', 'Version', '');
  ExternalInfo^.Author:= IniFile.ReadString('Main', 'Author', '');
  ExternalInfo^.Description:= IniFile.ReadString('Main', 'Description', '');
  ExternalInfo^.MenuCaption:= IniFile.ReadString('Main', 'MenuCaption', '');

  IniFile.Free;
  Result:= True;
end;

procedure UnloadExternal(const ExternalInfo: PExternalInfo);
begin
  if ExternalInfo = nil then
  Exit;

  FillChar(ExternalInfo^, SizeOf(TExternalInfo), 0);
end;


procedure LoadExternalCollection(const SourceFolder: String; const ExternalCollection: PExternalCollection);
var
  Found: Integer;
  SRec: TSearchRec;
  ExternalPath: String;
  ExternalInfo: PExternalInfo;
begin
  try
    Found:= FindFirst(SourceFolder + '*.*', faAnyFile, SRec);
    while Found = 0 do
    begin
      if (SRec.Attr and faDirectory = faDirectory) and (not ((SRec.Name = '..') or (SRec.Name = '.'))) then
      LoadExternalCollection (SourceFolder + SRec.Name + '\', ExternalCollection)
    else
      begin
        if (LowerCase(ExtractFileExt(SRec.Name)) = '.external') then
        begin
          ExternalPath:= SourceFolder + SRec.Name;

          if ExternalCollection^.ExternalAvailable = 0 then
          begin
            SetLength(ExternalCollection^.ExternalTable, ExternalCollection^.ExternalCount + 16);
            ExternalCollection^.ExternalAvailable:= 16;
          end;

          ExternalInfo:= @ExternalCollection^.ExternalTable[ExternalCollection^.ExternalCount];
          FillChar(ExternalInfo^, SizeOf(TExternalInfo), 0);

          if LoadExternal(ExternalPath, ExternalInfo) then
          begin
            Inc(ExternalCollection^.ExternalCount);
            Dec(ExternalCollection^.ExternalAvailable);
          end;
        end;
      end;
      Found:=FindNext(SRec);
    end;
  finally
    FindClose(SRec)
  end;
end;

procedure UnloadExternalCollection(const ExternalCollection: PExternalCollection);
var
  ExternalIndex: DWORD;
begin
  if (ExternalCollection = nil) or (ExternalCollection^.ExternalCount = 0) then
  Exit;

  SetLength(ExternalCollection^.ExternalTable, 0);
  FillChar(ExternalCollection^, SizeOf(TExternalCollection), 0);
end;

end.
