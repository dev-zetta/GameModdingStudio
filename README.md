# Game Modding Studio 🎮🛠️

**Version:** 0.1.4  •  **Author:** Gabriel Max

**A utility suite for ripping, inspecting and converting game assets — released after 14 years in private development.**

---

## About

Game Modding Studio (originally a long-term personal project) provides a collection of tools to rip, view and convert game files, textures and audio. It was developed for Windows using Delphi and is now being published for the first time after ~14 years dormant on a hard drive.

## Features

- File ripping and format scanning
- Texture conversion and imaging utilities (DDS, TGA, PSD, etc.)
- Audio tools and WAV playback support
- Plugin architecture for extendable file handlers
- Small utilities and batch tools in `Tools/`

### Included tools

- **FileRipper** — format scanner and ripper with many supported formats
- **Texture Converter** — advanced imaging/texture conversion tools
- **AsciiEditor** — draw ASCII art and export to images
- **DupeChecker** — duplicate file detection and reporting
- **MPEGTool** — audio scanner/extractor (MP3/MPEG support)

---

## Supported formats

Below is a concise table of commonly supported formats and notable caveats. This project evolved over many years and the list below highlights the main formats supported by the bundled tools; consult the original `ReadMe.txt` for a fuller historical list of added/rare formats.

| Format examples | Type | Notes |
|---|---|---|
| PSD, TGA, PNG, JPEG (JFIF), BMP, GIF | Image | Texture conversion and loaders; TGA: only the uncompressed non-palette variation is considered safe for automatic detection |
| MP3, WAV, AIFF, APE, M4A, FLAC, OGG | Audio | MP3 fully supported (including ID3); other formats supported to varying degrees depending on container and metadata |
| MP4, MOV, AVI, FLV, 3GP, 3G2, NSV, PVA | Video / containers | Archive/stream scanning and extraction; MP4/MOV marker support may be partial in some cases |
| ZIP, 7z, CAB, XNB, WAD, 4XM, PSMF | Archives / containers | Archive scanning and file extraction supported for many common container formats |
| 3DS, MDL7, GR2, other 3D models | 3D models | Read-only support for several model formats; behaviour may vary by format version |
| Zlib / compressed data | Compression | Zlib support included for compressed streams and file blocks |
| SWF, EXE, DLL, TTF, XMV, and many others | Misc | Many additional formats were added across versions; see historical changelog or `ReadMe.txt` for exhaustive lists and notes |


## Legacy notes (imported from original ReadMe.txt)

These notes were taken from the original project ReadMe (author: Crypton) and preserved here for context.

### Overview
The Game Modding Studio (GMS) is a collection of modding utilities designed to provide a universal modding toolkit.

### Other features
- Plugin support (SDK included)
- Third-party integration to allow external tools to be integrated with GMS

### License & tips
- License: Freeware under the zlib license (see `LICENSE` for full text).
- Tips: Always make backups of files you modify — and make more backups.

### FileRipper notes
- Known bugs: not all MP4/MOV markers are supported; only one TGA variation (uncompressed, non-palette) is recognized.
- A non-exhaustive list of unsupported or rare formats is documented in the original ReadMe; contributions welcome.

## Requirements

- Windows (desktop)
- Delphi / Embarcadero (project was authored around Delphi era Version 7; see `GameModdingStudio.dproj`)
- Basic VCL libraries (included or available with your Delphi install)

> **Note:** You may need to adjust Unit search paths or install additional design-time packages to build cleanly.

## Building

1. Open `GameModdingStudio.dproj` (or `GameModdingStudio.dpr`) in your Delphi IDE and build the project.
2. Alternatively, use the command-line compiler (if available):

```ps1
DCC32.exe GameModdingStudio.dpr
```

If you run into missing units or package errors, ensure your Delphi installation's library paths are set or copy the required sources from `Sources/` and `Units/` into the project search path.

## Release & License

This is the first public release of the project after many years of private development. See the bundled `LICENSE` file for licensing terms.

### Release files

- `gamodstudio_v0.1.4.zip` — packaged release archive (located in repository root)

### Screenshot

[![Game Modding Studio screenshot](./screenshot.PNG)](./screenshot.PNG)

## Release notes (v0.1.4)

- **Initial public release (first public release after ~14 years).**
- Packaged release: `#Release/gamodstudio_v0.1.4.zip` contains `GameModdingStudio.exe` and supporting files.
- Included a screenshot and minimal documentation; basic functionality: file ripping, texture conversion, audio tools, and plugin support.
- Known issues: building from source may require Delphi unit path adjustments and additional design-time packages; plugins may need updates for modern Delphi versions.

## Usage (packaged release)

1. Download and extract `gamodstudio_v0.1.4.zip` (located in repository root).
2. Run `GameModdingStudio.exe` from the extracted folder (Windows desktop).
3. To use plugins, place plugin files in the `Plugin/` folder or load them via the program's plugin menu.

---

## Changelog

See `CHANGELOG.md` for a succinct history of releases.


## Contributing

If you'd like to contribute, please open issues or pull requests. For big changes, create an issue first so we can discuss the direction.

## Contact / History

Originally authored by an independent developer; revived and cleaned for public release in 2026. If you'd like to collaborate or discuss features, open an issue or leave a comment on the repo.

Note: Historical changelog entries and legacy notes were imported from the original `ReadMe.txt` (author: Crypton) and consolidated into `CHANGELOG.md` and the "Legacy notes" section above.

---

**Enjoy!** ✅

