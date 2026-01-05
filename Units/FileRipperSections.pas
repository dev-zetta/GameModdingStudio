unit FileRipperSections;

interface

type
  TFormatSection = (
    FORMAT_SECTION_NONE,
    FORMAT_SECTION_AUDIO,
    FORMAT_SECTION_VIDEO,
    FORMAT_SECTION_CONTAINER,
    FORMAT_SECTION_IMAGE,
    FORMAT_SECTION_STREAM,
    FORMAT_SECTION_ARCHIVE,
    FORMAT_SECTION_MODEL,
    FORMAT_SECTION_XBOX,
    FORMAT_SECTION_XBOX360,
    FORMAT_SECTION_PLAYSTATION,
    FORMAT_SECTION_NINTENDO,
    FORMAT_SECTION_GAMESTUDIO,
    FORMAT_SECTION_OTHER
  );

  TSectionEntry = Packed Record
    Section: TFormatSection;
    Name: String[255];
  end;

const
///////////////////////////////////////
/// Section Names
  FORMAT_SECTION_NAME_NONE  ='None';
  FORMAT_SECTION_NAME_AUDIO ='Audio';
  FORMAT_SECTION_NAME_VIDEO = 'Video';
  FORMAT_SECTION_NAME_IMAGE ='Image';
  FORMAT_SECTION_NAME_STREAM  ='Stream';
  FORMAT_SECTION_NAME_ARCHIVE ='Archive';
  FORMAT_SECTION_NAME_MODEL ='Model';
  FORMAT_SECTION_NAME_XBOX  ='XBox';
  FORMAT_SECTION_NAME_XBOX360 ='XBox360';
  FORMAT_SECTION_NAME_PLAYSTATION ='PlayStation';
  FORMAT_SECTION_NAME_NINTENDO  ='Nintendo';
  FORMAT_SECTION_NAME_GAMESTUDIO  ='GameStudio';
  FORMAT_SECTION_NAME_OTHER ='Other';
  FORMAT_SECTION_NAME_CONTAINER = 'Container';

/// Section Names
///////////////////////////////////////

  SectionCount = Ord(High(TFormatSection))+1;
  SectionTable : Array[0..SectionCount-1] of TSectionEntry = (
    (Section:FORMAT_SECTION_NONE; Name:FORMAT_SECTION_NAME_NONE),
    (Section:FORMAT_SECTION_AUDIO; Name:FORMAT_SECTION_NAME_AUDIO),
    (Section:FORMAT_SECTION_VIDEO; Name:FORMAT_SECTION_NAME_VIDEO),
    (Section:FORMAT_SECTION_IMAGE; Name:FORMAT_SECTION_NAME_IMAGE),
    (Section:FORMAT_SECTION_STREAM; Name:FORMAT_SECTION_NAME_STREAM),
    (Section:FORMAT_SECTION_ARCHIVE; Name:FORMAT_SECTION_NAME_ARCHIVE),
    (Section:FORMAT_SECTION_MODEL; Name:FORMAT_SECTION_NAME_MODEL),
    (Section:FORMAT_SECTION_XBOX; Name:FORMAT_SECTION_NAME_XBOX),
    (Section:FORMAT_SECTION_XBOX360; Name:FORMAT_SECTION_NAME_XBOX360),
    (Section:FORMAT_SECTION_PLAYSTATION; Name:FORMAT_SECTION_NAME_PLAYSTATION),
    (Section:FORMAT_SECTION_NINTENDO; Name:FORMAT_SECTION_NAME_NINTENDO),
    (Section:FORMAT_SECTION_GAMESTUDIO; Name:FORMAT_SECTION_NAME_GAMESTUDIO),
    (Section:FORMAT_SECTION_OTHER; Name:FORMAT_SECTION_NAME_OTHER),
    (Section:FORMAT_SECTION_CONTAINER; Name:FORMAT_SECTION_NAME_CONTAINER)
  );

function SectionToString(const FormatSection:TFormatSection):String;
function StringToSection(const FormatSection:String):TFormatSection;

implementation
///////////////////////////////////////
function SectionToString(const FormatSection:TFormatSection):String;
var
  n:Byte;
begin
  for n := 0 to SectionCount - 1 do
  begin
    if SectionTable[n].Section = FormatSection then
    begin
      Result:=SectionTable[n].Name;
      Exit; 
    end; 
  end; 
end; 
///////////////////////////////////////
function StringToSection(const FormatSection:String):TFormatSection;
var
  n:Byte; 
begin
  for n := 0 to SectionCount - 1 do
  begin
    if SectionTable[n].Name = FormatSection then
    begin
      Result:=SectionTable[n].Section;
      Exit; 
    end; 
  end; 
end;

end.
