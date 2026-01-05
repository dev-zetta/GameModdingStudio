unit SystemInfo;

interface

uses
  Windows;

type
  PSystemInfo = ^TSystemInfo;
  TSystemInfo = Record
    ProcessorUsage: DWORD;
    MemoryLoad: DWORD;
  End;
  TSystemInfoCallback = procedure (const SystemInfo: PSystemInfo);

function StartReportingSystemInfo(const SystemInfoCallback:TSystemInfoCallback): Integer; stdcall;

implementation

type
  PGetSystemTimes = ^TGetSystemTimes;
  TGetSystemTimes = function (var IdleTime, KernelTime, UserTime:INT64):BOOLEAN; stdcall;

  TMEMORYSTATUSEX = Packed Record
    Length:DWORD;
    MemoryLoad:DWORD;
    TotalPhys:INT64;
    AvailPhys:INT64;
    TotalPageFile:INT64;
    AvailPageFile:INT64;
    TotalVirtual:INT64;
    AvailVirtual:INT64;
    AvailExtendedVirtual:INT64;
  end;
  PMEMORYSTATUSEX = ^TMEMORYSTATUSEX;

// Not defined in Windows.h
  PGlobalMemoryStatusEx = ^TGlobalMemoryStatusEx;
  TGlobalMemoryStatusEx = function (const MemStatus:PMEMORYSTATUSEX):DWORD;stdcall;

//http://www.codeproject.com/KB/threads/Get_CPU_Usage.aspx
function StartReportingSystemInfo(const SystemInfoCallback:TSystemInfoCallback): Integer; stdcall;
var
  SystemInfo: TSystemInfo;

  KernelLib: DWORD;
  GetSystemTimes: TGetSystemTimes;
  GlobalMemoryStatusEx: TGlobalMemoryStatusEx;

  IdleTime, KernelTime, UserTime:INT64;
  IdleTimeNow, KernelTimeNow, UserTimeNow:INT64;
  usr, ker, idl, sys: INT64;
  cpu: DWORD;

  MemStatus:TMEMORYSTATUSEX;

begin
  Result:=0;
  KernelLib:=LoadLibrary('Kernel32.dll');
  if KernelLib = 0 then
  Exit;

  GetSystemTimes:= GetProcAddress(KernelLib, 'GetSystemTimes');
  if @GetSystemTimes = nil then
  Exit;

  GlobalMemoryStatusEx:= GetProcAddress(KernelLib, 'GlobalMemoryStatusEx');
  if @GlobalMemoryStatusEx = nil then
  Exit;

  MemStatus.Length:=SizeOf(TMEMORYSTATUSEX);

  IdleTime:=0;
  KernelTime:=0;
  UserTime:=0;
  while True do
  begin
    if GlobalMemoryStatusEx(@MemStatus) = 0 then
    Break;

    SystemInfo.MemoryLoad:=MemStatus.MemoryLoad;

    if not GetSystemTimes(IdleTimeNow, KernelTimeNow, UserTimeNow) then
    Break;

    usr:= UserTimeNow - UserTime;
    ker:= KernelTimeNow - KernelTime;
    idl:= IdleTimeNow - IdleTime;

    sys:= ker + usr;

    SystemInfo.ProcessorUsage:= ((sys - idl) * 100) div sys;

    UserTime:= UserTimeNow;
    KernelTime:= KernelTimeNow;
    IdleTime:= IdleTimeNow;

    if (@SystemInfoCallback) <> nil then
    SystemInfoCallback(@SystemInfo);

    Sleep(2000);
  end;
  result:=1;
end;

end.
