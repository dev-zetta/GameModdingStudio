unit WAVPlayer;

interface

uses
  Windows,MMSystem;

function PlayWAVFile (const FileName:String):Boolean;
function PlayWAVMemory (const Memory:Pointer):Boolean;
function PlayWAVResource (const Section,Name:String):Boolean;
function StopWAV():Boolean;

implementation

function PlayWAVFile (const FileName:String):Boolean;
begin
  Result:=sndPlaySound(PChar(FileName),SND_NODEFAULT or SND_ASYNC);
end;

function PlayWAVMemory (const Memory:Pointer):Boolean;
begin
  Result:=sndPlaySound(Memory, SND_MEMORY or SND_NODEFAULT or SND_ASYNC);
end;

function PlayWAVResource (const Section,Name:String):Boolean;
var
  Memory:Pointer;
begin
  Memory := Pointer(FindResource(hInstance,PChar(Name),PChar(Section)));
  if Memory <> nil then
  begin
    Memory := Pointer(LoadResource(hInstance, HRSRC(Memory)));
    if Memory <> nil then
    Memory := LockResource(HGLOBAL(Memory));
  end;
  Result:=sndPlaySound(Memory, SND_MEMORY or SND_NODEFAULT or SND_ASYNC);
end;

function StopWAV():Boolean;
begin
  Result:=sndPlaySound(nil, 0);
end;

end.
