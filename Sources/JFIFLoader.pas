unit JFIFLoader;

interface

implementation

  TJPEGMarker = (
  M_SOF0  = $FFC0, // Baseline DCT
  M_SOF1  = $FFC1, // Extended Sequential DCT
  M_SOF2  = $FFC2, // Progressive DCT
  M_SOF3  = $FFC3, // Lossless (sequential)
  M_DHT   = $FFC4, // Define Huffman Table
  M_SOF5  = $FFC5, // Differential sequential DCT
  M_SOF6  = $FFC6, // Differential progressive DCT
  M_SOF7  = $FFC7, // Differential lossless (sequential)

  M_JPG   = $FFC8, // JPEG Extensions
  M_SOF9  = $FFC9, // Extended sequential DCT, Arithmetic coding
  M_SOF10 = $FFCA, // Progressive DCT, Arithmetic coding
  M_SOF11 = $FFCB, // Lossless (sequential), Arithmetic coding
  M_DAC   = $FFCC, // Define Arithmetic Coding
  M_SOF13 = $FFCD, // Differential sequential DCT, Arithmetic coding
  M_SOF14 = $FFCE, // Differential progressive DCT, Arithmetic coding
  M_SOF15 = $FFCF, // Differential lossless (sequential), Arithmetic coding

  M_RST0  = $FFD0, // Restart Marker 0
  M_RST1  = $FFD1,
  M_RST2  = $FFD2,
  M_RST3  = $FFD3,
  M_RST4  = $FFD4,
  M_RST5  = $FFD5,
  M_RST6  = $FFD6,
  M_RST7  = $FFD7, // Restart Marker 7

  M_SOI   = $FFD8, // Start of Image
  M_EOI   = $FFD9, // End of Image
  M_SOS   = $FFDA, // Start of Scan
  M_DQT   = $FFDB, // Define Quantization Table
  M_DNL   = $FFDC, // Define Number of Lines
  M_DRI   = $FFDD, // Define Restart Interval
  M_DHP   = $FFDE, // Define Hierarchical Progression
  M_EXP   = $FFDF, // Expand Reference Component

  M_APP0  = $FFE0,
  M_APP1  = $FFE1, // Exif
  M_APP2  = $FFE2, // ICC color profile
  M_APP3  = $FFE3, // JPS Tag for Stereoscopic JPEG images
  M_APP4  = $FFE4,
  M_APP5  = $FFE5,
  M_APP6  = $FFE6, // NITF Lossles profile
  M_APP7  = $FFE7,
  M_APP8  = $FFE8,
  M_APP9  = $FFE9,
  M_APP10 = $FFEA, // ActiveObject (multimedia messages / captions)
  M_APP11 = $FFEB, // HELIOS JPEG Resources (OPI Postscript)
  M_APP12 = $FFEC, // Picture Info (older digicams),Photoshop Save for Web: Ducky
  M_APP13 = $FFED, // Photoshop Save As: IRB, 8BIM, IPTC
  M_APP14 = $FFEE, // Photoshop
  M_APP15 = $FFEF,

  M_JPG0  = $FFF0,
  M_JPG1  = $FFF1,
  M_JPG2  = $FFF2,
  M_JPG3  = $FFF3,
  M_JPG4  = $FFF4,
  M_JPG5  = $FFF5,
  M_JPG6  = $FFF6,
  M_JPG7  = $FFF7, // Lossless JPEG
  M_JPG8  = $FFF8, // Lossless JPEG Extension Parameters
  M_JPG9  = $FFF9,
  M_JPG10 = $FFFA,
  M_JPG11 = $FFFB,
  M_JPG12 = $FFFC,
  M_JPG13 = $FFFD,
  M_COM   = $FFFE, // Comment

  M_TEM   = $FF01);

  TAPP0Marker = Packed Record
    //WORD marker;// = 0xFFE0
    Size:Word; // = 16 for usual JPEG, no thumbnail
		ID:Array[0..4] of Char; // = "JFIF",'\0'
		//VersionHI:Byte; // 1
		//VersionLO:Byte; // 1
    Version:Word;
		XYUnits:Byte;   // 0 = no units, normal density
		XDensity:Word;  // 1
		YDensity:Word;  // 1
		ThumbWidth:Byte; // 0
		ThumbHeight:Byte; // 0
  end;

  TSOF0Marker = Packed Record
    //WORD marker; // = 0xFFC0
    Size:Word; // = 17 for a truecolor YCbCr JPG
		Precision:Byte ;// Should be 8: 8 bits/sample
		Height:Word;
		Width:Word;
		Channels:Byte;//Should be 3: We encode a truecolor JPG
		IdY:Byte;  // = 1
		HVY:Byte; // sampling factors for Y (bit 0-3 vert., 4-7 hor.)
		QTY:Byte;  // Quantization Table number for Y = 0
		IdCb:Byte; // = 2
		HVCb:Byte;
		QTCb:Byte; // 1
		IdCr:Byte; // = 3
		HVCr:Byte;
  end;

  TDQTMarker = Packed Record
    //WORD marker;  // = 0xFFDB
    Size:Word;  // = 132
    QTYinfo:Byte;// = 0:  bit 0..3: number of QT = 0 (table for Y)
				  //       bit 4..7: precision of QT, 0 = 8 bit
    Ytable:Array[0..63] of Byte;
    QTCbinfo:Byte; // = 1 (quantization table for Cb,Cr}
    Cbtable:Array[0..63] of Byte;
  end;

  TDHTMarker = Packed Record
		 //WORD marker;  // = 0xFFC4
    Size:Word;  //0x01A2
    HTYDCinfo:Byte; // bit 0..3: number of HT (0..3), for Y =0
			  //bit 4  :type of HT, 0 = DC table,1 = AC table
				//bit 5..7: not used, must be 0
    YDC_nrcodes:Array[0..15] of Byte; //at index i = nr of codes with length i
    YDC_values:Array[0..11] of Byte;
    HTYACinfo:Byte; // = 0x10
    YAC_nrcodes:Array[0..15] of Byte;
    YAC_values:Array[0..161] of Byte;//we'll use the standard Huffman tables
    HTCbDCinfo:Byte; // = 1
    CbDC_nrcodes:Array[0..15] of Byte;
    CbDC_values:Array[0..11] of Byte;
    HTCbACinfo:Byte; //  = 0x11
    CbAC_nrcodes:Array[0..15] of Byte;
    CbAC_values:Array[0..161] of Byte;
  end;

  TSOSMarker = Packed Record
    //WORD marker;  // = 0xFFDA
    Size:Word; // = 12
    Channels:Byte; // Should be 3: truecolor JPG
    IdY:Byte; //1
    HTY:Byte; //0 // bits 0..3: AC table (0..3)
				   // bits 4..7: DC table (0..3)
    IdCb:Byte; //2
    HTCb:Byte; //0x11
    IdCr:Byte; //3
    HTCr:Byte; //0x11
     // not interesting, they should be 0,63,0
    SS:Byte;
    SE:Byte;
    BF:Byte;
  end;
  /////////////////////////////////////////////


end.
