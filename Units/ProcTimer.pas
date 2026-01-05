unit ProcTimer;

interface

uses
  Windows,SysUtils;

type
  TProcTimer = Packed Record
    Freq: Int64;
    StartCount: Int64;
    StopCount: Int64;
    TotalTime:LongWord;
  end;

  procedure StartTimer (var Timer:TProcTimer);
  function StopTimer(var Timer:TProcTimer):LongWord;
  procedure ShowTimer (const Timer:TProcTimer);

implementation

procedure StartTimer (var Timer:TProcTimer);
begin
  QueryPerformanceFrequency(Timer.Freq);
  QueryPerformanceCounter(Timer.StartCount);
end;

function StopTimer(var Timer:TProcTimer):LongWord;
begin
  QueryPerformanceCounter(Timer.StopCount);
  Timer.TotalTime:=Round(((Timer.StopCount - Timer.StartCount) / Timer.Freq) *1000);
  Result:=Timer.TotalTime;
end;

procedure ShowTimer (const Timer:TProcTimer);
begin
  MessageBox(0,PChar(IntToStr(Timer.TotalTime)),'Timer',0);
end;

end.
