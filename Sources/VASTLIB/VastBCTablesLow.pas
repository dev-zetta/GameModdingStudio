unit VastBCTablesLow;

interface

var
  BCRIndexTable:Array[0..65535] of BYTE;
  BCGIndexTable:Array[0..65535] of BYTE;
  BCBIndexTable:Array[0..65535] of BYTE;

  BCRColorTable:Array[0..31] of Array[0..31] of Array[0..3] of BYTE; // 32*32*4
  BCGColorTable:Array[0..63] of Array[0..63] of Array[0..3] of BYTE; // 64*64*4
  BCBColorTable:Array[0..31] of Array[0..31] of Array[0..3] of BYTE; // 32*32*4

  // Converts 4x 2bit to 4x 8bit
  BCIndex2Table:Array[0..255] of Array[0..3] of BYTE;
  // Converts 4x 3bit to 4x 8bit
  BCIndex3Table:Array[0..4095] of Array[0..3] of BYTE;

  // Converts 2x 4bit to 2x 8bit
  BC2Alpha4Table:Array[0..255] of Array[0..1] of BYTE; // 256*2
  // Decode Mix and Max Alpha values
  BC3Alpha6Table:Array[0..255] of Array[0..255] of Array[0..5] of BYTE; // 256*256*6
  BC3Alpha4Table:Array[0..255] of Array[0..255] of Array[0..3] of BYTE; // 256*256*4

procedure BCInitDecodeTables();

implementation

procedure BCInitDecodeTables();
var
  i,j:BYTE;
  n:WORD;
begin
  for n:=0 to 65535 do
  begin
    BCRIndexTable[n]:= (n and $001F) shr 0;
    BCGIndexTable[n]:= (n and $07E0) shr 5;
    BCBIndexTable[n]:= (n and $F800) shr 11;
  end;

  for i:=0 to 31 do
  begin
    for j:=0 to 31 do
    begin
      BCRColorTable[i][j][0]:= i shl 3;
      BCRColorTable[i][j][1]:= j shl 3;
      BCRColorTable[i][j][2]:=( ( ((i shl 3) *2) + (j shl 3) ) div 3);
      BCRColorTable[i][j][3]:=( ( ((j shl 3) *2) + (i shl 3) ) div 3);
    end;
  end;

  for i:=0 to 63 do
  begin
    for j:=0 to 63 do
    begin
      BCGColorTable[i][j][0]:= i shl 2;
      BCGColorTable[i][j][1]:= j shl 2;
      BCGColorTable[i][j][2]:=( ( ((i shl 2) *2) + (j shl 2) ) div 3);
      BCGColorTable[i][j][3]:=( ( ((j shl 2) *2) + (i shl 2) ) div 3);
    end;
  end;

  for i:=0 to 31 do
  begin
    for j:=0 to 31 do
    begin
      BCBColorTable[i][j][0]:= i shl 3;
      BCBColorTable[i][j][1]:= j shl 3;
      BCBColorTable[i][j][2]:=( ( ((i shl 3) *2) + (j shl 3) ) div 3);
      BCBColorTable[i][j][3]:=( ( ((j shl 3) *2) + (i shl 3) ) div 3);
    end;
  end;

  for i:=0 to 255 do
  begin
    BCIndex2Table[i][0]:=(i and $03) shr 0;
    BCIndex2Table[i][1]:=(i and $0C) shr 2;
    BCIndex2Table[i][2]:=(i and $30) shr 4;
    BCIndex2Table[i][3]:=(i and $C0) shr 6;
  end;

  for i:=0 to 255 do
  begin
    BC2Alpha4Table[i][0]:=(i and $0F) or ((i and $0F) shl 4);
    BC2Alpha4Table[i][1]:=(i and $F0) or ((i and $F0) shr 4);
  end;

  for i:=0 to 255 do
  begin
    for j:=0 to 255 do
    begin
      BC3Alpha6Table[i][j][0]:=(6 * i + 1 * j + 3) div 7;
      BC3Alpha6Table[i][j][1]:=(5 * i + 2 * j + 3) div 7;
      BC3Alpha6Table[i][j][2]:=(4 * i + 3 * j + 3) div 7;
      BC3Alpha6Table[i][j][3]:=(3 * i + 4 * j + 3) div 7;
      BC3Alpha6Table[i][j][4]:=(2 * i + 5 * j + 3) div 7;
      BC3Alpha6Table[i][j][5]:=(1 * i + 6 * j + 3) div 7;

      BC3Alpha4Table[i][j][0]:=(4 * i + 1 * j + 2) div 5;
      BC3Alpha4Table[i][j][1]:=(3 * i + 2 * j + 2) div 5;
      BC3Alpha4Table[i][j][2]:=(2 * i + 3 * j + 2) div 5;
      BC3Alpha4Table[i][j][3]:=(1 * i + 4 * j + 2) div 5;
    end;
  end;

  for n:=0 to 4095 do
  begin
    BCIndex3Table[n][0]:= (n and $0007) shr 0;
    BCIndex3Table[n][1]:= (n and $0038) shr 3;
    BCIndex3Table[n][2]:= (n and $01C0) shr 6;
    BCIndex3Table[n][3]:= (n and $0E00) shr 9;
  end;
end;

end.
