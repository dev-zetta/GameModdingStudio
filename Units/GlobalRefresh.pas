unit GlobalRefresh;

(*
  This unit is for global usage, it checks if we need to refresh
  application by calling Application.ProcessMessages, so we avoid
  that function Application.ProcessMessages will be called more
  often than its needed.

  Current Refresh time: 500 msec

*)

interface

uses
  Windows;

function IsRefreshTime: Boolean;
function GlobalProcessMessages: Boolean;

implementation

const
  GlobalUpdateRate = 500;

var
  Msg: TMSG;
  GlobalUpdateTick: DWORD;

function InitGlobalProcessMessages: Boolean;
begin
  GlobalUpdateTick:= GetTickCount;
  Result:= True;
end;

function GlobalProcessMessages: Boolean;
var
  Tick: DWORD;
begin
  Result:= False;
  Tick:=GetTickCount;
  if (Tick - GlobalUpdateTick) >= GlobalUpdateRate then
  begin
    GlobalUpdateTick:= Tick;
    PeekMessage(Msg, 0, 0, 0, PM_REMOVE);
    Result:= True;
  end;
end;

function IsRefreshTime: Boolean;
var
  Tick: DWORD;
begin
  Result:= False;
  Tick:=GetTickCount;
  if (Tick - GlobalUpdateTick) >= GlobalUpdateRate then
  begin
    GlobalUpdateTick:= Tick;
    Result:= True;
  end;
end;

initialization

InitGlobalProcessMessages;

end.
