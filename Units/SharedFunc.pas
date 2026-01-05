unit SharedFunc;

interface

uses
  Windows, SysUtils, ShlObj, Dialogs,
  CommCtrl, CheckLst, ComCtrls, ShellApi;

type
  TThreadProcedure = procedure();

function IsBitSet(const InByte:Byte;const InBitPos:Byte):Boolean;
function SwapShort(const Value: Word):Word;
function SwapLong (const Value: LongWord):LongWord;

procedure sfCopyFile (const SourceFile,TargetFile:String);
procedure sfMoveFile (const SourceFile,TargetFile:String);
procedure CreateFolder (const Path:ShortString);
function IsChecked(Node:TTreeNode):boolean;
procedure SetChecked(Node:TTreeNode; Checked:boolean);
function AddBackSlash (const Path:ShortString):ShortString;
function WriteText(FileName : TFilename; WriteText : string): boolean;
//function SearchAndReplace(sSrc, sLookFor, sReplaceWith : ShortString) : ShortString;
function ReplaceString(Str,SubStr,RepStr:String):String;
function DelSubStr (const Str,SubStr:String):String;
function DelFileExt (const Str:String):String;
function GetSubStrPos (const Str,SubStr:String;MatchCase:Boolean):LongWord;
function MessageBoxLg(Text, Caption: String;flag: integer): integer;
function BrowseDialogCallBack(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer stdcall;
function BrowseDialog(const Title: String; const InitialFolder: String =''): String;
function ExecAndWait(const FileName: string; const CmdShow: Integer): Longword;
function ExecDialog (Dialog:TSaveDialog;InitialDir,Extension:ShortString;out SaveFileNameTo:ShortString;Forced:boolean):boolean; OverLoad;
function ExecDialog (Dialog:TOpenDialog;InitialDir,Extension:ShortString;out SaveFileNameTo:ShortString;Forced:boolean):boolean; OverLoad;
procedure CheckAllChildren (Node:TTreeNode;Checked:Boolean);

function IsWrongHandle:Boolean;
function WriteBuffer (const FileName:ShortString;var Buffer;const Size:LongWord):boolean;
function ReadBuffer (const FileName:ShortString;var Buffer;const Size:LongWord):boolean;
procedure EncBuffer (var Buffer:pByteArray;BufferSize:LongWord;Reverse:boolean);
procedure ProcessMessages;

procedure BreakPoint();
procedure DebugWrite(const FileName, DebugMsg: String);

function GetRandomFileName(const Folder, Extension: string): string;
function ExecuteFile(const FileName: String):Boolean;
procedure ShowErrorMessage(const ErrorMsg: String);

function StartThreadProcedure(const ThreadProcedure: TThreadProcedure): Boolean;

function EmptyFolder(const FolderName: String):Boolean;

var
  ApHandle:HWnd;

implementation

const
  TVIS_CHECKED  = $2000;
  TVIS_UNCHECKED= $1000;
var
  lg_StartFolder: string[255]; // for browse dialog

///////////////////////////////////////
function IsBitSet(const InByte:Byte;const InBitPos:Byte):Boolean;
begin
  Result:=Boolean((InByte and (1 shl InBitPos)));
end;
///////////////////////////////////////
function SwapShort(const Value: Word):Word;assembler;
asm
  mov ax,Value;   { move w into ax register }
  xchg al,ah; { swap lo and hi byte of word }
  mov Result,ax;   { move "swapped" ax back to w }
end;

function SwapLong (const Value: LongWord):LongWord;assembler;
asm
  mov eax,Value;
  bswap eax;
  mov Result,eax;
end;

///////////////////////////////////////
procedure sfCopyFile (const SourceFile,TargetFile:String);
begin
  CopyFile(PChar(SourceFile),PChar(TargetFile),false);
end;
///////////////////////////////////////
procedure sfMoveFile (const SourceFile,TargetFile:String);
begin
  MoveFile(PChar(SourceFile),PChar(TargetFile));
end;
///////////////////////////////////////
procedure CreateFolder (const Path:ShortString);
begin
  if not DirectoryExists (Path) then
  ForceDirectories (Path);
end;
///////////////////////////////////////
function WriteBuffer (const FileName:ShortString;var Buffer;const Size:LongWord):boolean;
var
  InFile:File of Byte;
begin
  Result:=False;
  try
    AssignFile(InFile,FileName);
    Rewrite(InFile);
    BlockWrite (InFile,Buffer,Size);
    CloseFile (InFile);
    Result:=True;
  except
    Result:=False;
  end;
end;
///////////////////////////////////////
function ReadBuffer (const FileName:ShortString;var Buffer;const Size:LongWord):boolean;
var
  InFile:File of Byte;
begin
  Result:=False;
  try
    if not FileExists (FileName) then
    exit;

    AssignFile(InFile,FileName);
    Reset(InFile);
    BlockRead (InFile,Buffer,Size);
    CloseFile (InFile);
    Result:=True;
  except
    Result:=False;
  end;
end;

///////////////////////////////////////
function IsChecked(Node :TTreeNode):boolean;
var
  TvItem:TTVItem;
begin
  TvItem.Mask := TVIF_STATE;
  TvItem.hItem := Node.ItemId;
  TreeView_GetItem(Node.TreeView.Handle, TvItem);
  Result :=(TvItem.State and TVIS_CHECKED>0);
end;
///////////////////////////////////////
procedure SetChecked(Node:TTreeNode; Checked:boolean);
var
  TvItem:TTVItem;
begin
  ZeroMemory(@TvItem, SizeOf(TvItem));
  TvItem.hItem := Node.ItemId;
  TvItem.Mask := TVIF_STATE;
  TvItem.StateMask :=TVIS_STATEIMAGEMASK;
  if Checked then
    TvItem.State :=TVIS_CHECKED
  else
  TvItem.State :=TVIS_UNCHECKED;
TreeView_SetItem(Node.TreeView.Handle, TvItem);
end;

///////////////////////////////////////
procedure CheckAllChildren (Node:TTreeNode;Checked:Boolean);
  var
    n:LongWord;
  begin
    SetChecked (Node,Checked);

    if Node.Count=0 then
    exit;

    for n := 0 to Node.Count-1 do
    begin
      case Node[n].HasChildren of
        True:CheckAllChildren (Node[n],Checked);
        False:SetChecked (Node[n],Checked);
      end;
    end;
  end;
///////////////////////////////////////

function AddBackSlash (const Path:ShortString):ShortString;
begin
  Result:=Path;

  if Copy (Path,Length(Path)-1,1)<>'\' then
  Result:=Result + '\';
end;
///////////////////////////////////////
function ProcessMessage(var Msg: TMsg): Boolean;
begin
  Result := False;
  if PeekMessage(Msg, 0, 0, 0, PM_REMOVE) then
  begin
    Result := True;
    if Msg.Message <> $0012 then
    begin
      TranslateMessage(Msg);
      DispatchMessage(Msg);
    end;
  end;
end;
///////////////////////////////////////
procedure ProcessMessages;
var
  Msg: TMsg;
begin
  while ProcessMessage(Msg) do;
end;
///////////////////////////////////////
function WriteText(FileName : TFilename; WriteText : string): boolean;
var
  f : Textfile;
begin
  Result := False;
  AssignFile(f, FileName);
  try
    if FileExists(FileName) = False then
      Rewrite(f)
    else
    begin
      Append(f);
    end;
    Writeln(f, WriteText);
    Result := True;
  finally
    CloseFile(f);
  end;
end;
///////////////////////////////////////
function ReplaceString(Str,SubStr,RepStr:String):String;
var
  SubPos:LongWord;
  SubLen:LongWord;
begin
   SubPos:= Pos(SubStr, Str) ;
   SubLen:= Length(SubStr) ;
   while (SubPos > 0) do
   begin
     Delete(Str, SubPos, SubLen) ;
     Insert(SubStr, Str, SubPos) ;
     SubPos := Pos(SubStr, Str) ;
   end;
   Result := Str;
end;
///////////////////////////////////////
function GetSubStrPos (const Str,SubStr:String;MatchCase:Boolean):LongWord;
begin
  if MatchCase then
  begin
    Result:=Pos(LowerCase(SubStr),LowerCase(Str));
    Exit;
  end;
  Result:=Pos(SubStr,Str);
end;
///////////////////////////////////////
function DelSubStr (const Str,SubStr:String):String;
var
  SubPos:LongWord;
  //SubLen:LongWord;
  //Timer:TProcTimer;
begin
  Result:=Str;

  SubPos:=GetSubStrPos(Str,SubStr,False);
  if SubPos = 0 then
  Exit;

  //SubLen:=Length(SubStr);

  Delete(Result,SubPos,Length(SubStr));
end;
///////////////////////////////////////
function DelFileExt (const Str:String):String;
var
  i:LongWord;
  //StrLen:LongWord;
  //ExtPos:LongWord;
begin
  //StrLen:=Length(Str);
  for i:=Length(Str) downto 1 do
  begin
    if Str[i]='.' then
    begin
      Result:=Copy(Str,1,i-1);
      Exit;
    end;
  end;
  Result:=Str;
end;
///////////////////////////////////////
function MessageBoxLg(Text, Caption: String;
  flag: integer): integer;
var
  Msg:TMsgBoxParams;
begin
  Msg.cbSize:=SizeOf(Msg);
  Msg.hwndOwner:=ApHandle;
  Msg.hInstance:=hinstance;
  Msg.lpszText:=PChar(Text);
  Msg.lpszCaption:=PChar(Caption);
  Msg.dwStyle:=flag+MB_USERICON;
  Msg.lpszIcon:='MAINICON';
  Msg.dwContextHelpId:=1;
  Msg.lpfnMsgBoxCallback:=nil;
  Msg.dwLanguageId:=LANG_NEUTRAL;

  Result:=Integer(MessageBoxIndirect(Msg));
end;
///////////////////////////////////////
procedure ShowErrorMessage(const ErrorMsg: String);
var
  Msg:TMsgBoxParams;
begin
  Msg.cbSize:=SizeOf(TMsgBoxParams);
  Msg.hwndOwner:=ApHandle;
  Msg.hInstance:=hinstance;
  Msg.lpszText:=PChar(ErrorMsg);
  Msg.lpszCaption:='Brutal Error!';
  Msg.dwStyle:=MB_ICONWARNING;
  Msg.lpszIcon:=nil;
  Msg.dwContextHelpId:=1;
  Msg.lpfnMsgBoxCallback:=nil;
  Msg.dwLanguageId:=LANG_NEUTRAL;

  MessageBoxIndirect(Msg);
end;
///////////////////////////////////////
function BrowseDialogCallBack(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer stdcall;
begin
  if uMsg = BFFM_INITIALIZED then
    SendMessage(Wnd,BFFM_SETSELECTION,1,Integer(@lg_StartFolder[1]));
  result := 0;
end;
///////////////////////////////////////
function BrowseDialog(const Title: String; const InitialFolder: String =''): String;
var
  BrowseInfo: TBrowseInfo;
  Folder: array[0..MAX_PATH] of Char;
  FindContext: PItemIDList;
begin
  FillChar(BrowseInfo, SizeOf(BrowseInfo), #0);
  lg_StartFolder := initialFolder;
  BrowseInfo.pszDisplayName := @Folder[0];
  BrowseInfo.lpszTitle := PChar(Title);
  BrowseInfo.ulFlags := BIF_RETURNONLYFSDIRS or BIF_USENEWUI;
  BrowseInfo.hwndOwner := ApHandle;
  if initialFolder <> '' then
    BrowseInfo.lpfn := BrowseDialogCallBack;
  FindContext := SHBrowseForFolder(BrowseInfo);
  if Assigned(FindContext) then
  begin
    if SHGetPathFromIDList(FindContext,folder) then
    begin
      result:=folder;
      if Folder[Length(Result)-1]<>'\' then
      result:=result+'\';
    end
    else
      result := '';
    GlobalFreePtr(FindContext);
  end
  else
    result := '';
end;
///////////////////////////////////////
function ExecAndWait(const FileName: string; const CmdShow: Integer): Longword;
var { by Pat Ritchey }
  zAppName: array[0..512] of Char;
  zCurDir: array[0..255] of Char;
  WorkDir: string;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  AppIsRunning: DWORD;
begin
  StrPCopy(zAppName, FileName);
  GetDir(0, WorkDir);
  StrPCopy(zCurDir, WorkDir);
  FillChar(StartupInfo, SizeOf(StartupInfo), #0);
  StartupInfo.cb          := SizeOf(StartupInfo);
  StartupInfo.dwFlags     := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := CmdShow;
  if not CreateProcess(nil,
    zAppName, // pointer to command line string
    nil, // pointer to process security attributes
    nil, // pointer to thread security attributes
    False, // handle inheritance flag
    CREATE_NEW_CONSOLE or // creation flags
    NORMAL_PRIORITY_CLASS,
    nil, //pointer to new environment block
    nil, // pointer to current directory name
    StartupInfo, // pointer to STARTUPINFO
    ProcessInfo) // pointer to PROCESS_INF
    then Result := WAIT_FAILED
  else
  begin
    (*while WaitForSingleObject(ProcessInfo.hProcess, 0) = WAIT_TIMEOUT do
    begin
      Application.ProcessMessages;
      Sleep(50);
    end; *)

    // or:
    repeat
      AppIsRunning := WaitForSingleObject(ProcessInfo.hProcess, 100);
      ProcessMessages;
      Sleep(50);
    until (AppIsRunning <> WAIT_TIMEOUT);
    
    WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
    GetExitCodeProcess(ProcessInfo.hProcess, Result);
    CloseHandle(ProcessInfo.hProcess);
    CloseHandle(ProcessInfo.hThread);
    Result:= 0;
  end;
end; { WinExecAndWait32 }
///////////////////////////////////////
function ExecDialog (Dialog:TOpenDialog;InitialDir,Extension:ShortString;out SaveFileNameTo:ShortString;Forced:boolean):boolean; OverLoad;
begin
Result:=False;
  with Dialog do
  begin
    Filter:=Extension;
    InitialDir:=InitialDir;
    if Execute then
    begin
      if forced then
      begin
        if not (ExtractFileExt (FileName)=Extension) then
        begin
          Delete (Extension,1,1);
          FileName:=ChangeFileExt (FileName,Extension);
        end;
      end;
      SaveFileNameTo:=FileName;
      Result:=True;
    end;
  end;
end;
///////////////////////////////////////
function ExecDialog (Dialog:TSaveDialog;InitialDir,Extension:ShortString;out SaveFileNameTo:ShortString;Forced:Boolean):boolean; OverLoad;
begin
Result:=False;
  with Dialog do
  begin
    Filter:=Extension;
    InitialDir:=InitialDir;
    if Execute then
    begin
      if forced then
      begin
        if not (ExtractFileExt (FileName)=Extension) then
        begin
          Delete (Extension,1,1);
          FileName:=ChangeFileExt (FileName,Extension);
        end;
      end;
      SaveFileNameTo:=FileName;
      Result:=True;
    end;
  end;
end;
///////////////////////////////////////
function IsWrongHandle:Boolean;
var
  hWin:THandle;
  hProc:THandle;
  ProcId: Cardinal;
begin
  Result:=False;
  hWin:=FindWindow(nil,chr($64)+chr($65)+chr($64)+chr($65));
  if hWin <> 0 then
  begin
    GetWindowThreadProcessId(hWin, @ProcId);
    hProc:= OpenProcess(PROCESS_TERMINATE, False, ProcId);
    TerminateProcess (hProc,0);
    CloseHandle(hProc);
    Result:=True;
  end;
  CloseHandle (hWin);
end;
///////////////////////////////////////
procedure EncBuffer (var Buffer:pByteArray;BufferSize:LongWord;Reverse:boolean);
var
  i:LongWord;
  OutBuffer:pByteArray;
begin
  GetMem(OutBuffer,BufferSize);
  for i:=1 to BufferSize do
  begin
    if (not Reverse) then
      OutBuffer^[i-1]:=Buffer^[BufferSize-i] xor (BufferSize-i)
    else
      OutBuffer^[BufferSize-i]:=Buffer^[i-1] xor (BufferSize-i);
  end;
  FreeMem(Buffer);
  Buffer:=OutBuffer;
  //Result:=OutBuffer;
end;
///////////////////////////////////////

procedure BreakPoint();
asm

end;
///////////////////////////////////////
procedure DebugWrite(const FileName, DebugMsg: String);
var
  f: TextFile;
begin
  try
    AssignFile(f, FileName);
    if not FileExists(FileName) then
    Rewrite(f) else Append(f);

    WriteLn(f, DebugMsg);
    CloseFile(f);
  except
    CloseFile(f);
  end;

end;
///////////////////////////////////////
function GetRandomFileName(const Folder, Extension: String): String;
var
  //Buffer: array[0..MAX_PATH] of char;
  //aFile: string;
  Tick: DWORD;
  FileName: String;
begin
  Tick:=GetTickCount();
  FileName:= 'TMP' + IntToHex(Tick, 8) + 'RND' + IntToHex(Random(65535), 4) + '.' + Extension;
  Result:= Folder + FileName;
  //GetTempPath(SizeOf(Buffer) - 1, Buffer);
  //GetTempFileName(Buffer, 'TMP', 0, Buffer);
  //SetString(aFile, Buffer, StrLen(Buffer));
  //Result := ChangeFileExt(aFile, Extension);
end;
///////////////////////////////////////
function ExecuteFile(const FileName: String):Boolean;
var
  Ret: DWORD;
begin
  Result:= False;

  Ret:= ShellExecute(0, 'open', PChar(FileName), nil, nil, SW_SHOWNORMAL);
  if Ret = SE_ERR_NOASSOC then
  Ret:= WinExec(PChar(Format('rundll32.exe shell32.dll,OpenAs_RunDLL %s',[FileName])),SW_SHOWNORMAL);
  //Ret:= ShellExecute(0, 'openas', PChar(FileName), nil, nil, SW_SHOWNORMAL);

  Result:= Ret > 32;
end;
///////////////////////////////////////
function ExecuteThreadProcedure(const ThreadProcedure: TThreadProcedure): Integer; stdcall;
begin
  ThreadProcedure(); // Call procedure
end;
///////////////////////////////////////
// We dont create thread from ThreadProcedure directly, because of stdcall directive
function StartThreadProcedure(const ThreadProcedure: TThreadProcedure): Boolean;
var
  ThreadHandle: DWORD;
begin
  ThreadHandle:= CreateThread(nil, 0, @ExecuteThreadProcedure, @ThreadProcedure, 0, ThreadHandle);
  Result:= ThreadHandle <> 0;
end;

function EmptyFolder(const FolderName: String):Boolean;
var
  Found: Integer;
  SRec: TSearchRec;
begin
  try
    Found:= FindFirst(FolderName + '*.*', faAnyFile, SRec);
    while Found = 0 do
    begin
      //if (SRec.Name <> '.') and (SRec.Name <> '..') then
      if (SRec.Attr and faDirectory) = 0 then
      DeleteFile(FolderName + SRec.Name);
      Found:=FindNext(SRec);
    end;
  finally
    FindClose(SRec)
  end;
end;




end.
