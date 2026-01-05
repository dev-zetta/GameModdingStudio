unit VastMemory;

interface

uses
  Windows;

function VastHeapAlloc(var Memory:POINTER;const Size:DWORD):Boolean;
function VastHeapRealloc(var Memory:POINTER;const Size:DWORD):Boolean;
function VastHeapFree(var Memory:POINTER):Boolean;

function VastMemAlloc(var Memory:POINTER;const Size:DWORD):Boolean;
function VastMemFree(var Memory:POINTER):Boolean;

implementation

const
  HEAP_GENERATE_EXCEPTIONS = $00000004;
  HEAP_NO_SERIALIZE = $00000001;
  HEAP_REALLOC_IN_PLACE_ONLY = $00000010;
  HEAP_ZERO_MEMORY = $00000008;


//http://msdn.microsoft.com/en-us/library/aa366597(VS.85).aspx
//http://msdn.microsoft.com/en-us/library/aa366711(VS.85).aspx
//http://www.rohitab.com/discuss/index.php?showtopic=30829
var
  HeapHandle:DWORD = 0;

function VastMemoryManagerInit:Boolean;
begin
  HeapHandle:=GetProcessHeap;
  if HeapHandle <> 0 then
  Result:=True else Result:=False;
end;

function VastHeapAlloc(var Memory:POINTER;const Size:DWORD):Boolean;
begin
  Result:=False;
  if HeapHandle = 0 then
  begin
    if not VastMemoryManagerInit then
    begin
      if not VastMemoryManagerInit() then
      Exit;

    end;
  end;

  Memory:=HeapAlloc(HeapHandle,HEAP_NO_SERIALIZE or HEAP_ZERO_MEMORY,Size);
  if Memory <> nil then
  Result:=True else Result:=False;
end;

function VastHeapRealloc(var Memory:POINTER;const Size:DWORD):Boolean;
begin
  Result:=False;
  if (Memory = nil) or (Size = 0) then
  Exit;

  if HeapHandle = 0 then
  begin
    if not VastMemoryManagerInit then
    begin
      if not VastMemoryManagerInit() then
      Exit;

    end;
  end;

  Memory:=HeapRealloc(HeapHandle,HEAP_NO_SERIALIZE or HEAP_ZERO_MEMORY,Memory,Size);
  if Memory <> nil then
  Result:=True else Result:=False;
end;

function VastHeapFree(var Memory:POINTER):Boolean;
begin
  Result:=False;

  if Memory = nil then
  Exit;

  if HeapFree(HeapHandle,HEAP_NO_SERIALIZE,Memory) <> False then
  begin
    Memory:=nil;
    Result:=True;
  end;
end;

function VastMemAlloc(var Memory:POINTER;const Size:DWORD):Boolean;
begin
  Memory:=VirtualAlloc(nil, Size , MEM_COMMIT, PAGE_READWRITE);
  if Memory <> nil then
  Result:=True else Result:=False;
end;

//http://msdn.microsoft.com/en-us/library/aa366892(VS.85).aspx
function VastMemFree(var Memory:POINTER):Boolean;
begin
  Result:=False;
  if Memory = nil then
  Exit;

  //if VirtualFree(Memory,Size,MEM_DECOMMIT) <> False then
  if VirtualFree(Memory, 0, MEM_RELEASE) <> False then
  begin
    Memory:=nil;
    Result:=True;
  end;
end;

end.
