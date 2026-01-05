unit DupeChecker;

interface

uses
  Windows,SysUtils,SharedTypes,SharedFunc,CRCFunc;

type
  TFileEntry = Packed Record
    IsInitial:Boolean;
    IsFound:Boolean;
    FullName:String;
    Name:String;
    Path:String;
    Ext:String;
    Size:LongWord;
    //IsCRC32:Boolean;
    CRC32:LongWord;
    DupeList:Array of LongWord;
    DupeListLen:LongWord;
  end;
  TFileArray = Array of TFileEntry;

  TDupeMethod = (dmName,dmSize,dmExt,dmPath,dmData);
  TDupeMethods = Set of TDupeMethod;
  //TDupeOption = (doMove,doCopy,doDelete,doErase);
  //TDupeOptions = Set of TDupeOption;

  TDupeChecker = Class (TObject)
   private
    FFileList:TFileArray;
    FFileListLen:LongWord;
    FSourceExt:String;
    FSourceFolder:String;
    //FTargetFolder:String;
    FDupeMethods:TDupeMethods;
    //FDupeOptions:TDupeOptions;
    FDupeFound:LongWord;
    FDupeCount:LongWord;
    FMsgSender:TMsgSender;
    FExtSet:Boolean;
    procedure SearchFilesInt(const sDir: String);
    procedure SendMsg (const Msg:ShortString);
   public
    constructor Create;
    destructor Destroy;
    procedure ResetChecker;
    property FilesCount:LongWord read FFileListLen;
    property DupesCount:LongWord read FDupeCount;

    procedure SearchFiles(const Folder,Ext: String);
    procedure CreateCRC32 ();
    procedure SearchDupes ();
    function IsMethodSet(const Method:TDupeMethod):Boolean;
    procedure SetMethod(const Method:TDupeMethod);
    procedure SetMsgSender(const MsgSender:TMsgSender);
    //function IsOptionSet(Option:TDupeOption):Boolean;
    //procedure SetOption(Option:TDupeOption);

    function IsInitial(const FileIndex:LongWord):Boolean;
    function GetFileName(const FileIndex:LongWord):String;
    function GetRelFileName(const FileIndex:LongWord):String;

    function GetDupeCount(const FileIndex:LongWord):LongWord;
    function GetDupeName(const FileIndex,DupeIndex:LongWord):String;
    function GetDupeIndex(const FileIndex,DupeIndex:LongWord):LongWord;
    function GetRelDupeName(const FileIndex,DupeIndex:LongWord):String;

    //function GetDupeCount(const FileIndex:LongWord):LongWord;

    //procedure SetTargetFolder(const Folder:String);
    procedure MoveDupe (const FileIndex:LongWord;const TargetFolder:String);
    procedure CopyDupe (const FileIndex:LongWord;const TargetFolder:String);
    procedure DeleteDupe (const FileIndex:LongWord);
    procedure EraseDupe (const FileIndex:LongWord);
  end;

implementation

const
  DefArrayInc = 1000;

constructor TDupeChecker.Create();
begin
  inherited Create;
  ResetChecker;
end;

destructor TDupeChecker.Destroy();
begin
  ResetChecker;
  inherited Destroy;
end;

procedure TDupeChecker.ResetChecker();
begin
  SetLength(FFileList,0);
  FFileListLen:=0;
  FSourceExt:='';
  FSourceFolder:='';
  //FTargetFolder:='';
  FDupeFound:=0;
  FDupeCount:=0;
  //FDupeOptions:=[];
  FDupeMethods:=[];
  FExtSet:=False;
end;
procedure TDupeChecker.SetMsgSender(const MsgSender:TMsgSender);
begin
  FMsgSender:=MsgSender;
end;

function TDupeChecker.IsInitial(const FileIndex:LongWord):Boolean;
begin
  Result:=FFileList[FileIndex].IsInitial;
end;

procedure TDupeChecker.SendMsg (const Msg:ShortString);
begin
  FMsgSender(Msg);
end;

function TDupeChecker.IsMethodSet(const Method:TDupeMethod):Boolean;
begin
  Result:=Method in FDupeMethods;
end;
(*
function TDupeChecker.IsOptionSet(Option:TDupeOption):Boolean;
begin
  Result:=Option in FDupeOptions;
end;
*)
procedure TDupeChecker.SetMethod(const Method: TDupeMethod);
begin
  include(FDupeMethods,Method);
end;
(*
procedure TDupeChecker.SetOption(Option: TDupeOption);
begin
  include(FDupeOptions,Option);
end;
*)
function TDupeChecker.GetFileName(const FileIndex:LongWord):String;
begin
  Result:=FFileList[FileIndex].FullName;
end;

function TDupeChecker.GetRelFileName(const FileIndex:LongWord):String;
begin
  with FFileList[FileIndex] do
  Result:=Path+Name+Ext;
end;

function TDupeChecker.GetDupeCount(const FileIndex:LongWord):LongWord;
begin
  Result:=FFileList[FileIndex].DupeListLen;
end;

function TDupeChecker.GetDupeName(const FileIndex,DupeIndex:LongWord):String;
var
  Index:LongWord;
begin
  Index:=FFileList[FileIndex].DupeList[DupeIndex];
  Result:=FFileList[Index].FullName;
end;

function TDupeChecker.GetRelDupeName(const FileIndex,DupeIndex:LongWord):String;
var
  Index:LongWord;
begin
  Index:=FFileList[FileIndex].DupeList[DupeIndex];
  with FFileList[Index] do
  Result:=Path+Name+Ext;
end;

function TDupeChecker.GetDupeIndex(const FileIndex,DupeIndex:LongWord):LongWord;
begin
  Result:=FFileList[FileIndex].DupeList[DupeIndex];
end;
(*
procedure TDupeChecker.SetTargetFolder(const Folder:String);
begin
  FTargetFolder:=Folder;
end;
*)
procedure TDupeChecker.MoveDupe (const FileIndex:LongWord;const TargetFolder:String);
var
  //InName:String;
  //OutFile:String;
  OutPath:String;
begin
  with FFileList[FileIndex] do
  begin
    //InName:=FullName;
    OutPath:=TargetFolder+Path;//+Name+Ext;
    if not DirectoryExists(OutPath) then
    ForceDirectories(OutPath);

    MoveFile(PChar(FullName),PChar(OutPath+Name+Ext));
  end;
end;

procedure TDupeChecker.CopyDupe (const FileIndex:LongWord;const TargetFolder:String);
begin
  with FFileList[FileIndex] do
  begin
    CopyFile(PChar(FullName),PChar(TargetFolder+Path+Name+Ext),false);
  end;
end;

procedure TDupeChecker.DeleteDupe (const FileIndex:LongWord);
begin
  DeleteFile(FFileList[FileIndex].FullName);
end;

procedure TDupeChecker.EraseDupe (const FileIndex:LongWord);
var
  FFile:File of Byte;
  //FSize:LongWord;
  Buffer:pByteArray;
begin

  with FFileList[FileIndex] do
  begin
    AssignFile(FFile,FullName);
    Reset(FFile);
    GetMem(Buffer,Size);
    FillChar(Buffer^,Size,$00);
    BlockWrite(FFile,Buffer^,Size);
    CloseFile(FFile);
    FreeMem(Buffer);
  end;
end;

procedure TDupeChecker.SearchFilesInt(const sDir: String);
var
  Found: Integer;
  SRec: TSearchRec;
  FileExt:ShortString;
begin
  try
    Found:=FindFirst(sDir+'*.*',faAnyFile,SRec);
    while Found=0 do
    begin
      if (SRec.Attr and faDirectory = faDirectory) and (not ((SRec.Name = '..') or (SRec.Name = '.'))) then
      SearchFilesInt (sDir+SRec.Name+'\')
    else
      begin
        //ProcessMessages;
        FileExt:=LowerCase(ExtractFileExt(SRec.Name));
        if (FExtSet and (FileExt=FSourceExt)) or
        ((not FExtSet) and (FileExt<>'.') and (FileExt<>'..')) then
        begin
          inc(FFileListLen);
          if FFileListLen > Length(FFileList) then
          SetLength(FFileList,FFileListLen+DefArrayInc);

          FillChar(FFileList[FFileListLen-1],SizeOf(TFileEntry),$00);
          with FFileList[FFileListLen-1] do
          begin
            //Found:=False;
            FullName:=sDir+SRec.Name;
            Name:=DelFileExt(SRec.Name);
            Path:=DelSubStr(sDir,FSourceFolder);
            Ext:=FileExt;
            Size:=SRec.Size;
            //CRC32:=0;
          end;
        end;
      end;
      Found:=FindNext(SRec);
    end;
  finally
    FindClose(SRec)
  end;
end;

procedure TDupeChecker.SearchFiles(const Folder,Ext: String);
begin
  FSourceFolder:=Folder;

  if (Ext<>'.*') and (Ext<>'*.*') then
  FExtSet:=True;

  FSourceExt:=Ext;
  SearchFilesInt(Folder);
end;

procedure TDupeChecker.CreateCRC32 ();
var
  i:LongWord;
begin
  if FFileListLen=0 then
  Exit;

  for i := 0 to FFileListLen - 1 do
  FFileList[i].CRC32:=GenerateCRC32(FFileList[i].FullName);
end;


procedure TDupeChecker.SearchDupes ();
var
  i,j:LongWord;
  //IsProper:Boolean;
  Method:TDupeMethod;
  MethodSet:LongWord;
  MethodCount:LongWord;
  //Option:TDupeOption;
begin
  //if IsMethodSet(dmData)then
  //CreateCRC32;

  MethodCount:=0;
  for Method in FDupeMethods do
  inc(MethodCount);

  //cmName,cmSize,cmExt,cmPath,cmData
  for i := 0 to FFileListLen - 1 do
  begin
    if not FFileList[i].IsFound then
    begin
      for j := i+1 to FFileListLen - 1 do
      begin
        //if i=j then
        //continue;

        //IsProper:=False;
        MethodSet:=0;
        for Method in FDupeMethods do
        begin
          case Method of
            dmName:
            begin
              if FFileList[i].Name<>FFileList[j].Name then
              Break;

              inc(MethodSet);
            end;
            dmSize:
            begin
              if FFileList[i].Size<>FFileList[j].Size then
              Break;

              inc(MethodSet);
            end;
            dmExt:
            begin
              if FFileList[i].Ext<>FFileList[j].Ext then
              Break;

              inc(MethodSet);
            end;
            dmPath:
            begin
              if FFileList[i].Path<>FFileList[j].Path then
              Break;

              inc(MethodSet);
            end;
            dmData:
            begin
              if not (FFileList[i].CRC32 <> 0)  then
              FFileList[i].CRC32:=GenerateCRC32(FFileList[i].FullName);

              if not (FFileList[j].CRC32 <> 0)  then
              FFileList[j].CRC32:=GenerateCRC32(FFileList[j].FullName);

              if FFileList[i].CRC32<>FFileList[j].CRC32 then
              Break;

              inc(MethodSet);
            end;
          end;
        end;

        if MethodSet=MethodCount then
        begin
          inc(FDupeCount);
          FFileList[i].IsInitial:=True;
          FFileList[j].IsFound:=True;
          with FFileList[i] do
          begin
            inc(DupeListLen);
            SetLength(DupeList,DupeListLen);
            DupeList[DupeListLen-1]:=j;
          end;
(*
          for Option in FDupeOptions do
          begin
            case Option of
              doMove: ;
              doCopy: ;
              doDelete: ;
              doErase: ;
            end;
          end;
*)
        end;
        

      end;
    end;
  end;
end;


end.
