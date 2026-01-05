unit MPEGScanner;

interface

uses
  Windows, SysUtils;

type
  PMPEGFrameHeader = ^TMPEGFrameHeader;
  TMPEGFrameHeader = Record
    RawHeader: DWORD;
    FrameSync: DWORD;
    FrameVersion: DWORD;
    FrameLayer: DWORD;
    FrameProtected: DWORD;
    FrameBitRate: DWORD;
    FrameSampleRate: DWORD;
    FramePadding: DWORD;
    FramePrivateBit: DWORD;
    FrameChannelMode: DWORD;
    FrameChannelModeEx: DWORD;
    FrameCopyrighted: DWORD;
    FrameOriginal: DWORD;
    FrameEmphasis: DWORD;
    FrameLength: DWORD;
    FrameChecksum: DWORD;
  end;

  PFrameCluster = ^TFrameCluster;
  TFrameCluster = Record
    ClusterSize: DWORD;
    FrameHeaderTable: Array of TMPEGFrameHeader;
    //FrameDataTable: Array of Pointer;
    FrameOffsetTable: Array of DWORD;
    FrameCount: DWORD;
    FrameAvailable: DWORD;
  end;

  PMPEGStreamInfo = ^TMPEGStreamInfo;
  TMPEGStreamInfo = Record
    IsLoaded: Boolean;
    FileName: String;
    FileSize: DWORD;
    //MinFrameCount: DWORD;
    TotalFrameCount: DWORD;
    TotalFrameSize: DWORD;
    MinClusterSize: DWORD;
    MaxClusterSize: DWORD;
    FrameClusterTable: Array of TFrameCluster;
    FrameClusterCount: DWORD;
    FrameClusterAvailable: DWORD;
  end;

  TMPEGScannerSettings = Record

  end;

  TMPEGProgressCallback = procedure (const Value, MaxValue: DWORD);

function MPEGProcessFile (const MPEGStreamInfo: PMPEGStreamInfo; const FileName: String; const ProgressCallback:TMPEGProgressCallback; const MinFramesInRow: DWORD = 2): Boolean;

function MPEGDumpInfoToFile(const MPEGStreamInfo: PMPEGStreamInfo; const FileName: String): Boolean;
function MPEGExtractFrameClusters(const MPEGStreamInfo: PMPEGStreamInfo; const TargetFolder: String): Boolean;
function MPEGSaveStreamToFile(const MPEGStreamInfo: PMPEGStreamInfo; const FileName: String): Boolean;

function MPEGGetMaxMessageLength(const MPEGStreamInfo: PMPEGStreamInfo): DWORD;
function MPEGReadMessageFromStream(const MPEGStreamInfo: PMPEGStreamInfo; var InfoMsg: String): Boolean;
function MPEGWriteMessageToStream(const MPEGStreamInfo: PMPEGStreamInfo; var InfoMsg: String): Boolean;

procedure FreeStreamInfo(const MPEGStreamInfo: PMPEGStreamInfo);

implementation


procedure FreeStreamInfo(const MPEGStreamInfo: PMPEGStreamInfo);
begin
  if MPEGStreamInfo^.FrameClusterCount > 0 then
  SetLength(MPEGStreamInfo^.FrameClusterTable, 0);

  MPEGStreamInfo^.IsLoaded:= False;;
  //FillChar(MPEGStreamInfo^
end;

function SwapLong (const Value: DWORD):DWORD;
asm
  bswap eax;
end;

//http://www.mpgedit.org/mpgedit/mpeg_format/mpeghdr.htm
function MPEGDecodeFrameHeader(const Memory: Pointer; var FrameHeader: TMPEGFrameHeader): BOOLEAN;
const
  //MPEG_VERSION_2_5 = 0;
  MPEG_VERSION_1 = 3;
  MPEG_VERSION_2 = 2;

  MPEG_LAYER_1 = 3;
  MPEG_LAYER_2 = 2;
  MPEG_LAYER_3 = 1;
const
// MPEG 2
  MPEG2SampleRateTable : Array [0..3] of DWORD = (
    22050, 24000, 16000, 0
  );

  MPEG2BitrateTable : Array[0..3] of Array [0..15] of DWORD = (
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0), // Reserved
    (0,  8, 16, 24, 32, 40, 48, 56, 64, 80, 96, 112, 128, 144, 160, 0), // Layer III
    (0,  8, 16, 24, 32, 40, 48, 56, 64, 80, 96, 112, 128, 144, 160, 0), // Layer II
    (0, 32, 48, 56, 64, 80, 96, 112, 128, 144, 160, 176, 192, 224, 256, 0)  // Layer I
  );


// MPEG 1
  MPEG1SampleRateTable : Array [0..3] of DWORD = (
    44100, 48000, 32000, 0
  );

  MPEG1BitrateTable : Array[0..3] of Array [0..15] of DWORD = (
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0), // Reserved
    (0, 32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320, 0), // Layer III
    (0, 32, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320, 384, 0), // Layer II
    (0, 32, 64, 96, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448, 0) // Layer I
  );
var
  RawHeader: DWORD;
  FrameSync: DWORD;
  FrameVersion: DWORD;
  FrameLayer: DWORD;
  FrameProtected: DWORD;
  FrameBitrate: DWORD;
  FrameSampleRate: DWORD;
  FramePadding: DWORD;
  FramePrivateBit: DWORD;
  FrameChannelMode: DWORD;
  FrameChannelModeEx: DWORD;
  FrameCopyrighted: DWORD;
  FrameOriginal: DWORD;
  FrameEmphasis: DWORD;
  FrameLength: DWORD;
begin
  Result:= False;

  if Memory = nil then
  Exit;

  RawHeader:=SwapLong(PDWORD(Memory)^);

  FrameSync:= (RawHeader and $FFE00000); // shr ?
  if (FrameSync <> $FFE00000) then  // 00 00 07 ff
  Exit; // invalid frame synchronization bits

  FrameVersion:= (RawHeader and $00180000) shr 19;
  if (FrameVersion < MPEG_VERSION_2) then
  Exit; // Invalid frame version

  FrameLayer:= (RawHeader and $00060000) shr 17;
  if (FrameLayer = 0) then
  Exit; // invalid frame layer version

  FrameProtected:= (RawHeader and $00010000) shr 16;

  FrameBitRate:= (RawHeader and $0000F000) shr 12;

  if FrameBitRate = 0 then
  Exit; // unsupported

  FrameSampleRate:= (RawHeader and $00000C00) shr 10;
  if FrameSampleRate = 3 then
  Exit; // 3 is reserved, cant be used

  FramePadding:= (RawHeader and $00000200) shr 9;

  FramePrivateBit:= (RawHeader and $00000100) shr 8;

  FrameChannelMode:= (RawHeader and $000000C0) shr 6;

  FrameChannelModeEx:= (RawHeader and $00000030) shr 4;

  FrameCopyrighted:= (RawHeader and $00000008) shr 3;
  FrameOriginal:= (RawHeader and $00000004) shr 2;
  FrameEmphasis:= (RawHeader and $00000003) shr 0;

  // We skip frames that has set a private bit, because we dont know for what it stands for
  //if FramePrivateBit <> 0 then
  //Exit;

  // Check if frame is in joint stereo, and if not then check extended mode
  // because it should be set to 0 if frame is not joint stereo
  if (FrameChannelMode <> 1) and (FrameChannelModeEx <> 0) then
  Exit;

  case FrameVersion of
    MPEG_VERSION_1:
    begin
      FrameBitRate:= MPEG1BitrateTable[FrameLayer][FrameBitRate];
      FrameSampleRate:= MPEG1SampleRateTable[FrameSampleRate];

      if FrameBitRate = 0 then
      Exit;

      if FrameSampleRate = 0 then
      Exit;

      // Callculate frame lenght
      if FrameLayer = MPEG_LAYER_1 then
      begin
        FrameLength:= (((12000 * FrameBitRate) div FrameSampleRate) + FramePadding) * 4; // SlotSize = 4
      end
        else
      begin
        FrameLength:= (((144000 * FrameBitRate) div FrameSampleRate) + FramePadding) * 1; // SlotSize = 1
      end;
    end;
    MPEG_VERSION_2:
    begin
      FrameBitRate:= MPEG1BitRateTable[FrameLayer][FrameBitRate];
      FrameSampleRate:= MPEG1SampleRateTable[FrameSampleRate];

      if FrameBitRate = 0 then
      Exit;

      if FrameSampleRate = 0 then
      Exit;

      // Callculate frame lenght
      if FrameLayer = MPEG_LAYER_1 then
      begin
        FrameLength:= (((12000 * FrameBitRate) div FrameSampleRate) + FramePadding) * 4; // SlotSize = 4
      end
        else
      begin
        FrameLength:= (((72000 * FrameBitRate) div FrameSampleRate) + FramePadding) * 1; // SlotSize = 1
      end;
    end;
  end; // case
  
  FrameHeader.RawHeader:= SwapLong(RawHeader);
  FrameHeader.FrameSync:=FrameSync;
  FrameHeader.FrameVersion:=FrameVersion;
  FrameHeader.FrameLayer:=FrameLayer;
  FrameHeader.FrameProtected:=FrameProtected;
  FrameHeader.FrameBitrate:=FrameBitrate;
  FrameHeader.FrameSampleRate:=FrameSampleRate;
  FrameHeader.FramePadding:=FramePadding;
  FrameHeader.FramePrivateBit:=FramePrivateBit;
  FrameHeader.FrameChannelMode:=FrameChannelMode;
  FrameHeader.FrameChannelModeEx:=FrameChannelModeEx;
  FrameHeader.FrameCopyrighted:=FrameCopyrighted;
  FrameHeader.FrameOriginal:=FrameOriginal;
  FrameHeader.FrameEmphasis:=FrameEmphasis;
  FrameHeader.FrameLength:=FrameLength;

  if FrameProtected = 0 then
  FrameHeader.FrameChecksum:= PWORD(DWORD(Memory) + 2)^
  else FrameHeader.FrameChecksum:= 0;

  Result:=True;
end;



function MPEGProcessFile (const MPEGStreamInfo: PMPEGStreamInfo; const FileName: String; const ProgressCallback:TMPEGProgressCallback; const MinFramesInRow: DWORD = 2): Boolean;
const
  MAX_BUFFER_SIZE = 4096;
  BUFFER_CACHE_SIZE = 16;
var
  InFile: File of BYTE;
  InFileSize: DWORD;
  InFilePos: DWORD;

  ReadCount: DWORD;
  Buffer: Pointer;
  BufferMem, BufferMemMax: DWORD;

  BufferSize: DWORD;
  BufferPos: DWORD;
  Header: DWORD;
  FrameHeader: TMPEGFrameHeader;

  //MythFile: TMythFile;

  IsFrameFound: BOOLEAN;
  RangeStart: DWORD;
  FramesInRow: DWORD;
  //MinFramesInRow: DWORD;
  FrameOffset, ExpectedFrameOffset: DWORD;

  IsFrameClusterFound: Boolean;
  FrameClusterIndex: DWORD;

  FrameCluster: PFrameCluster;

  FrameReturnOfsset: DWORD;
  IsSeekNext: Boolean;

  FrameIndex: DWORD;
  //Timer: TProcTimer;
begin
  //StartTimer(Timer);
  Result:= False;
  if (MPEGStreamInfo = nil) or (not FileExists(FileName)) then
  Exit;

  FillChar(MPEGStreamInfo^, SizeOf(TMPEGStreamInfo), 0);
  MPEGStreamInfo^.FileName:= FileName;

  AssignFile(InFile, FileName);
  Reset(InFile);
  InFileSize:=FileSize(InFile);

  MPEGStreamInfo^.FileSize:= InFileSize;
  if InFileSize < 256 then
  begin
    // Not enough data in file, exit here
    CloseFile(InFile);
    Exit;
  end;

  GetMem(Buffer, MAX_BUFFER_SIZE);

  IsFrameFound:=False;

  //MinFramesInRow:= 3;
  FramesInRow:= 0;

  FrameOffset:= 0;
  ExpectedFrameOffset:= 0;

  InFilePos:=0;
  FrameClusterIndex:= 0;
  IsFrameClusterFound:= False;
  while (InFilePos < InFileSize) do
  begin
    ProgressCallback(InFilePos, InFileSize);
    
    Seek(InFile, InFilePos);
    BlockRead(InFile, Buffer^, 4096, BufferSize);

    if BufferSize < 256 then
    Break;

    Dec(BufferSize, BUFFER_CACHE_SIZE);

    BufferPos:= 0;
    BufferMem:= DWORD(Buffer);
    BufferMemMax:= BufferMem + BufferSize;

    IsFrameFound:= False;
    IsSeekNext:= True;
    while BufferMem < BufferMemMax do
    begin
      if MPEGDecodeFrameHeader(PDWORD(BufferMem), FrameHeader) then
      begin
        FrameOffset:= InFilePos + BufferPos;
        if FramesInRow = 0 then
        begin
          FrameReturnOfsset:= FrameOffset + 4; // Where we return in file if we dont find a new cluster
          ExpectedFrameOffset:= FrameOffset;
        end;

        if FrameOffset = ExpectedFrameOffset then
        begin
          ExpectedFrameOffset:= FrameOffset + FrameHeader.FrameLength;
          IsFrameFound:= True;
          Inc(FramesInRow);
          InFilePos:= ExpectedFrameOffset;
          IsSeekNext:= False;

          if MPEGStreamInfo^.FrameClusterAvailable = 0 then
          begin
            SetLength(MPEGStreamInfo^.FrameClusterTable, MPEGStreamInfo^.FrameClusterCount + 128);
            MPEGStreamInfo^.FrameClusterAvailable:=128;
            FillChar(MPEGStreamInfo^.FrameClusterTable[MPEGStreamInfo^.FrameClusterCount], SizeOf(TFrameCluster) * 128, 0);
          end;

          if MinFramesInRow = FramesInRow then
          begin
            IsFrameClusterFound:= True;
            Inc(MPEGStreamInfo^.FrameClusterCount);
            Dec(MPEGStreamInfo^.FrameClusterAvailable);
          end;

          FrameCluster:= @MPEGStreamInfo^.FrameClusterTable[FrameClusterIndex];
          if FrameCluster^.FrameAvailable = 0 then
          begin
            SetLength(FrameCluster^.FrameHeaderTable, FrameCluster^.FrameCount + 32);
            //SetLength(FrameCluster^.FrameDataTable, FrameCluster^.FrameCount + 32);
            SetLength(FrameCluster^.FrameOffsetTable, FrameCluster^.FrameCount + 32);
            FrameCluster^.FrameAvailable:= 32;
            FillChar(FrameCluster^.FrameHeaderTable[FrameCluster^.FrameCount], SizeOf(TMPEGFrameHeader) * 32, 0);
            //FillChar(FrameCluster^.FrameDataTable[FrameCluster^.FrameCount], SizeOf(Pointer) * 32, 0);
            FillChar(FrameCluster^.FrameOffsetTable[FrameCluster^.FrameCount], SizeOf(DWORD) * 32, 0);
          end;

          FrameCluster^.FrameHeaderTable[FrameCluster^.FrameCount]:= FrameHeader;
          FrameCluster^.FrameOffsetTable[FrameCluster^.FrameCount]:= FrameOffset;

          Inc(FrameCluster^.FrameCount);
          Dec(FrameCluster^.FrameAvailable);

          Break;
        end
          else
        begin
          IsFrameFound:= False;

          if (FramesInRow > 0) and (not IsFrameClusterFound) then
          begin
            FrameCluster:= @MPEGStreamInfo^.FrameClusterTable[FrameClusterIndex];
            FillChar(FrameCluster^.FrameHeaderTable[0], SizeOf(TMPEGFrameHeader) * FramesInRow, 0);
            //FillChar(FrameCluster^.FrameDataTable[0], SizeOf(Pointer) * FramesInRow, 0);
            FillChar(FrameCluster^.FrameOffsetTable[0], SizeOf(DWORD) * FramesInRow, 0);
            Inc(FrameCluster^.FrameAvailable, FrameCluster^.FrameCount);
            FrameCluster^.FrameCount:= 0;

            InFilePos:= FrameReturnOfsset; // Return Back
            IsSeekNext:= False;
          end;

          if IsFrameClusterFound then
          begin
            IsFrameClusterFound:= False;
            InFilePos:= FrameOffset;
            Inc(FrameClusterIndex);
            IsSeekNext:= False;
          end;

          FramesInRow:= 0;
          Break;
        end;
      end;

      Inc(BufferMem);
      Inc(BufferPos);
    end;

    if IsSeekNext then
    begin
      Inc(InFilePos, BufferSize);
    end;
  end;

  // Post processing, do some extra work here
  MPEGStreamInfo^.TotalFrameCount:=0;
  MPEGStreamInfo^.TotalFrameSize:=0;
  if MPEGStreamInfo^.FrameClusterCount > 0 then
  begin
    MPEGStreamInfo^.MaxClusterSize:= 0;
    MPEGStreamInfo^.MinClusterSize:= $FFFFFFFF;

    for FrameClusterIndex := 0 to MPEGStreamInfo^.FrameClusterCount - 1 do
    begin
      FrameCluster:= @MPEGStreamInfo^.FrameClusterTable[FrameClusterIndex];

      // Calculate cluster size
      FrameCluster^.ClusterSize:=0;
      for FrameIndex:= 0 to FrameCluster^.FrameCount - 1 do
      begin
        Inc(FrameCluster^.ClusterSize, FrameCluster^.FrameHeaderTable[FrameIndex].FrameLength);
      end;

      Inc(MPEGStreamInfo^.TotalFrameSize, FrameCluster^.ClusterSize);
      Inc(MPEGStreamInfo^.TotalFrameCount, FrameCluster^.FrameCount);

      // Get min and max cluster size
      if MPEGStreamInfo^.MinClusterSize > FrameCluster^.ClusterSize then
      MPEGStreamInfo^.MinClusterSize:= FrameCluster^.ClusterSize;

      if MPEGStreamInfo^.MaxClusterSize < FrameCluster^.ClusterSize then
      MPEGStreamInfo^.MaxClusterSize:= FrameCluster^.ClusterSize;
    end;

    //if MPEGStreamInfo^.TotalFrameCount > 0 then
    //Halt(0);
  end;
  FreeMem(Buffer);
  CloseFile(InFile);
  Result:= True;
end;

function MPEGDumpInfoToFile(const MPEGStreamInfo: PMPEGStreamInfo; const FileName: String): Boolean;
var
  InFile: TextFile;

  FrameClusterIndex, FrameIndex: DWORD;

  FrameCluster: PFrameCluster;

  ClusterBuffer: Pointer;
  ClusterOffset, ClusterSize : DWORD;
  ClusterName: String;

  FrameHeader: PMPEGFrameHeader;
begin
  Result:= False;
  if (MPEGStreamInfo = nil) or (MPEGStreamInfo^.FrameClusterCount = 0) then
  Exit;

  ForceDirectories(ExtractFilePath(FileName));

  AssignFile(InFile, FileName);
  Rewrite(InFile);

  for FrameClusterIndex := 0 to MPEGStreamInfo^.FrameClusterCount - 1 do
  begin
    FrameCluster:= @MPEGStreamInfo^.FrameClusterTable[FrameClusterIndex];

    for FrameIndex := 0 to FrameCluster^.FrameCount - 1 do
    begin
      FrameHeader:= @FrameCluster^.FrameHeaderTable[FrameIndex];

      WriteLn(InFile, '---------------------');
      //WriteLn(InFile, 'Frame header found!');
      WriteLn(InFile, 'File Offset: ' + IntToStr(FrameCluster^.FrameOffsetTable[FrameIndex]));
      WriteLn(InFile, 'Frame Lenght: ' + IntToStr(FrameHeader^.FrameLength));
      WriteLn(InFile, 'Frame Checksum: ' + IntToStr(FrameHeader^.FrameChecksum));

      WriteLn(InFile, ' <Frame Header>');
      WriteLn(InFile, '   Frame Version: ' + IntToStr(FrameHeader^.FrameVersion));
      WriteLn(InFile, '   Frame Layer: ' + IntToStr(FrameHeader^.FrameLayer));
      WriteLn(InFile, '   Frame Protected: ' + IntToStr(FrameHeader^.FrameProtected));
      WriteLn(InFile, '   Frame BitRate: ' + IntToStr(FrameHeader^.FrameBitRate));
      WriteLn(InFile, '   Frame SampleRate: ' + IntToStr(FrameHeader^.FrameSampleRate));
      WriteLn(InFile, '   Frame Padding: ' + IntToStr(FrameHeader^.FramePadding));
      WriteLn(InFile, '   Frame PrivateBit: ' + IntToStr(FrameHeader^.FramePrivateBit));
      WriteLn(InFile, '   Frame ChannelMode: ' + IntToStr(FrameHeader^.FrameChannelMode));
      WriteLn(InFile, '   Frame ChannelModeEx: ' + IntToStr(FrameHeader^.FrameChannelModeEx));
      WriteLn(InFile, '   Frame Copyrighted: ' + IntToStr(FrameHeader^.FrameCopyrighted));
      WriteLn(InFile, '   Frame Original: ' + IntToStr(FrameHeader^.FrameOriginal));
      WriteLn(InFile, '   Frame Emphasis: ' + IntToStr(FrameHeader^.FrameEmphasis));
      WriteLn(InFile, ' </Frame Header>');
    end;
  end;
  CloseFile(InFile);
end;

function MPEGExtractFrameClusters(const MPEGStreamInfo: PMPEGStreamInfo; const TargetFolder: String): Boolean;
var
  InFile, OutFile: File of BYTE;

  FrameClusterIndex: DWORD;

  FrameCluster: PFrameCluster;

  ClusterBuffer: Pointer;
  ClusterOffset, ClusterSize : DWORD;
  ClusterName: String;
begin
  Result:= False;
  if (MPEGStreamInfo = nil) or (MPEGStreamInfo^.FrameClusterCount = 0) then
  Exit;

  ForceDirectories(TargetFolder);

  AssignFile(InFile, MPEGStreamInfo^.FileName);
  Reset(InFile);

  GetMem(ClusterBuffer, MPEGStreamInfo^.MaxClusterSize);

  //MaxBufferSize:=0;
  for FrameClusterIndex := 0 to MPEGStreamInfo^.FrameClusterCount - 1 do
  begin
    FrameCluster:= @MPEGStreamInfo^.FrameClusterTable[FrameClusterIndex];

    ClusterOffset:=FrameCluster^.FrameOffsetTable[0];
    ClusterSize:= FrameCluster^.ClusterSize;

    Seek(InFile, ClusterOffset);
    BlockRead(InFile, ClusterBuffer^, ClusterSize);

    ClusterName:= IntToHex(ClusterOffset, 8) + '_' + IntToHex(ClusterSize, 8) + '.mp3';
    AssignFile(OutFile, TargetFolder + ClusterName);
    Rewrite(OutFile);
    BlockWrite(OutFile, ClusterBuffer^, ClusterSize);
    CloseFile(OutFile);
  end;

  FreeMem(ClusterBuffer);
  CloseFile(InFile);
end;

function MPEGSaveStreamToFile(const MPEGStreamInfo: PMPEGStreamInfo; const FileName: String): Boolean;
var
  InFile, OutFile: File of BYTE;

  FrameClusterIndex, FrameIndex: DWORD;

  FrameCluster: PFrameCluster;

  //ClusterBuffer: Pointer;
  //ClusterOffset, ClusterSize : DWORD;
  FrameBuffer: Pointer;
  FrameOffset, FrameSize: DWORD;
  RawHeader: DWORD;
begin
  Result:= False;
  if (MPEGStreamInfo = nil) or (MPEGStreamInfo^.FrameClusterCount = 0) then
  Exit;

  MPEGStreamInfo^.IsLoaded:= True;
  AssignFile(InFile, MPEGStreamInfo^.FileName);
  Reset(InFile);

  AssignFile(OutFile, FileName);
  Rewrite(OutFile);

  GetMem(FrameBuffer, MPEGStreamInfo^.MaxClusterSize);

  //MaxBufferSize:=0;
  for FrameClusterIndex := 0 to MPEGStreamInfo^.FrameClusterCount - 1 do
  begin
    FrameCluster:= @MPEGStreamInfo^.FrameClusterTable[FrameClusterIndex];

    for FrameIndex := 0 to FrameCluster^.FrameCount - 1 do
    begin
      FrameOffset:= FrameCluster^.FrameOffsetTable[FrameIndex];
      FrameSize:= FrameCluster^.FrameHeaderTable[FrameIndex].FrameLength;
      RawHeader:= FrameCluster^.FrameHeaderTable[FrameIndex].RawHeader;

      //if (FrameOffset + 4) >=  MPEGStreamInfo^.FileSize then
      //Halt(0);

      // We dont read raw header
      Seek(InFile, FrameOffset + 4);
      BlockRead(InFile, FrameBuffer^, FrameSize - 4);

      BlockWrite(OutFile, RawHeader, 4);
      BlockWrite(OutFile, FrameBuffer^, FrameSize - 4);
    end;
  end;

  FreeMem(FrameBuffer);
  CloseFile(OutFile);
  CloseFile(InFile);
end;

function MPEGGetMaxMessageLength(const MPEGStreamInfo: PMPEGStreamInfo): DWORD;
begin
  Result:= 0;
  if (MPEGStreamInfo = nil) or (MPEGStreamInfo^.FrameClusterCount = 0) then
  Exit;

  Result:= (MPEGStreamInfo^.TotalFrameCount div 8);
end;

function MPEGReadMessageFromStream(const MPEGStreamInfo: PMPEGStreamInfo; var InfoMsg: String): Boolean;
var
  FrameClusterIndex, FrameIndex: DWORD;

  FrameCluster: PFrameCluster;

  CharCount: DWORD;
  CharAvailable: DWORD;
  //CharIndex: DWORD;
  PrivateBit: DWORD;
  BitIndex: DWORD;
  CharByte: BYTE;
begin
  Result:= False;
  if (MPEGStreamInfo = nil) or (MPEGStreamInfo^.FrameClusterCount = 0) then
  Exit;

  CharAvailable:= MPEGGetMaxMessageLength(MPEGStreamInfo);
  SetLength(InfoMsg, CharAvailable);

  CharByte:= 0;
  BitIndex:= 0;
  CharCount:= 0;
  //CharIndex:= 0;
  for FrameClusterIndex := 0 to MPEGStreamInfo^.FrameClusterCount - 1 do
  begin
    FrameCluster:= @MPEGStreamInfo^.FrameClusterTable[FrameClusterIndex];
    for FrameIndex := 0 to FrameCluster^.FrameCount - 1 do
    begin
      PrivateBit:=FrameCluster^.FrameHeaderTable[FrameIndex].FramePrivateBit;

      CharByte:= CharByte or (PrivateBit shl BitIndex);
      Inc(BitIndex);

      if (BitIndex = 8) and (CharByte = 0) then
      begin
        SetLength(InfoMsg, CharCount);
        Exit;
      end;

      if BitIndex = 8 then
      begin
        InfoMsg[CharCount + 1]:= Char(CharByte);

        BitIndex:= 0;
        CharByte:= 0;
        Inc(CharCount);
        Dec(CharAvailable);

        if CharAvailable = 0 then
        begin
          SetLength(InfoMsg, CharCount + 256);
          CharAvailable:= 256;
        end;
      end;
    end;
  end;
end;

function MPEGWriteMessageToStream(const MPEGStreamInfo: PMPEGStreamInfo; var InfoMsg: String): Boolean;
var
  FrameClusterIndex, FrameIndex: DWORD;

  FrameCluster: PFrameCluster;

  CharCount: DWORD;
  CharAvailable: DWORD;
  //CharIndex: DWORD;
  PrivateBit: DWORD;
  BitIndex: DWORD;
  CharByte: BYTE;
  FrameHeader: PMPEGFrameHeader;
begin
  Result:= False;
  if (MPEGStreamInfo = nil) or (MPEGStreamInfo^.FrameClusterCount = 0) then
  Exit;

  CharAvailable:= Length(InfoMsg);

  CharByte:= BYTE(InfoMsg[1]);
  BitIndex:= 0;
  CharCount:= 1;
  for FrameClusterIndex := 0 to MPEGStreamInfo^.FrameClusterCount - 1 do
  begin
    FrameCluster:= @MPEGStreamInfo^.FrameClusterTable[FrameClusterIndex];
    for FrameIndex := 0 to FrameCluster^.FrameCount - 1 do
    begin
      FrameHeader:= @FrameCluster^.FrameHeaderTable[FrameIndex];
      PrivateBit:= (CharByte shr BitIndex) and 1;

      FrameHeader^.FramePrivateBit:= PrivateBit;
      FrameHeader^.RawHeader:= SwapLong(FrameHeader^.RawHeader) and $FFFFFEFF;
      FrameHeader^.RawHeader:= FrameHeader^.RawHeader or (PrivateBit shl 8);
      FrameHeader^.RawHeader:= SwapLong(FrameHeader^.RawHeader);

      Inc(BitIndex);
      if BitIndex = 8 then
      begin
        BitIndex:= 0;

        if CharAvailable > 0 then
        begin
          CharByte:= BYTE(InfoMsg[CharCount + 1]);
          Inc(CharCount);
          Dec(CharAvailable);
        end else CharByte:= 0;
      end;
    end;
  end;
end;


(*
function MPEGWriteInfoToStream(const MPEGStreamInfo: PMPEGStreamInfo; const InfoMsg: String): Boolean;
var
  InFile, OutFile: File of BYTE;

  FrameClusterIndex: DWORD;

  FrameCluster: PFrameCluster;

  ClusterBuffer: Pointer;
  ClusterOffset, ClusterSize : DWORD;
begin
  Result:= False;
  if (MPEGStreamInfo = nil) or (MPEGStreamInfo^.FrameClusterCount = 0) then
  Exit;

  MPEGStreamInfo^.IsLoaded:= True;
  AssignFile(InFile, MPEGStreamInfo^.FileName);
  Reset(InFile);

  AssignFile(OutFile, FileName);
  Rewrite(OutFile);

  GetMem(ClusterBuffer, MPEGStreamInfo^.MaxClusterSize);

  //MaxBufferSize:=0;
  for FrameClusterIndex := 0 to MPEGStreamInfo^.FrameClusterCount - 1 do
  begin
    FrameCluster:= @MPEGStreamInfo^.FrameClusterTable[FrameClusterIndex];

    ClusterOffset:=FrameCluster^.FrameOffsetTable[0];
    ClusterSize:= FrameCluster^.ClusterSize;

    Seek(InFile, ClusterOffset);
    BlockRead(InFile, ClusterBuffer^, ClusterSize);
    BlockWrite(OutFile, ClusterBuffer^, ClusterSize);
  end;

  FreeMem(ClusterBuffer);
  CloseFile(OutFile);
  CloseFile(InFile);
end;
*)


end.
