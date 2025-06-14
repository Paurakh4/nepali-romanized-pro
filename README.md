# Nepali Romanized Pro (Unicode) for macOS

**✅ macOS Sequoia 15.0+ Compatible** - Now fully compatible with macOS Sequoia and later versions!

This is a package that installs Unicode Nepali Romanized Keyboard Layout on a macOS machine. Since the Keyboard Layout that comes with macOS is limited, this is intended to be a replacement for a better experience.

This keyboard layout is based on the Nepali Unicode Romanized layout by Madan Puraskar Pustakalaya.

## 🆕 Recent Updates (v4.0) - macOS Sequoia Compatible

### Major Fixes Applied:
- **🔧 Fixed critical XML parsing issues** - Resolved invalid character references that prevented macOS from recognizing the keyboard layout
- **📱 Enhanced macOS Sequoia compatibility** - Added required Info.plist keys and proper bundle configuration
- **🔐 Added code signing support** - Bundle is now properly signed for modern macOS security requirements
- **⚡ Improved installation process** - Comprehensive cache clearing and input service restart procedures
- **🛠️ Added troubleshooting tools** - Complete diagnostic and repair script for installation issues

### Technical Improvements:
- Changed XML version from 1.1 to 1.0 (required for macOS parsers)
- Replaced invalid XML character references with compliant alternatives
- Added required bundle keys: `CFBundlePackageType`, `CFBundleShortVersionString`, `LSMinimumSystemVersion`
- Updated minimum system requirement to macOS 10.15 (Catalina)
- Enhanced postinstall script with proper cache clearing and service restart


## Installation

### Quick Installation
1. Download the latest version [from releases](https://github.com/suvash/nepali-romanized-pro/releases)
2. Right-click on the package and choose 'Open' (required for unsigned packages)
3. Follow the installer instructions
4. **Log out and log back in** (required for macOS to recognize the keyboard layout)
5. Go to System Preferences > Keyboard > Input Sources
6. Click '+' and look for 'Nepali (Romanized) - Pro' under 'Others' or 'Nepali'

**Note for macOS Sequoia 15:**
- If the layout does not appear, ensure you are running version 15.0 or later.
- Try the troubleshooting steps below if it still does not show up.

### Troubleshooting

#### If the keyboard layout doesn't appear in System Preferences (especially on macOS Sequoia 15):

**Option 1: Use the automated troubleshooting script (Recommended)**
```bash
./complete_troubleshooting.sh
```

**Option 2: Manual troubleshooting steps**
1. **Clear input source caches:**
   ```bash
   sudo rm -rf /System/Library/Caches/com.apple.IntlDataCache.le.kbdx
   rm -rf ~/Library/Caches/com.apple.IntlDataCache.le.kbdx
   ```

2. **Restart input services:**
   ```bash
   killall -HUP TextInputMenuAgent
   killall -HUP SystemUIServer
   killall -HUP TextInputSwitcher
   ```

3. **Force refresh keyboard layouts:**
   ```bash
   sudo touch "/Library/Keyboard Layouts"
   ```

4. **Log out and log back in** (REQUIRED - macOS only scans for new layouts during login)

**If you are on Apple Silicon, ensure the bundle is built for arm64.**

#### Verification Commands
Check if the bundle is properly installed and signed:
```bash
# Verify installation
ls -la "/Library/Keyboard Layouts/nepali-romanized.bundle"

# Check code signing
codesign -dv "/Library/Keyboard Layouts/nepali-romanized.bundle"

# Validate bundle configuration
plutil -p "/Library/Keyboard Layouts/nepali-romanized.bundle/Contents/Info.plist"
```

### System Requirements
- **Minimum:** macOS 10.15 (Catalina)
- **Tested:** macOS 15.0+ (Sequoia)
- **Architecture:** Universal (Intel and Apple Silicon)
- **Installation:** Requires administrator privileges

## Building from Source

To build the package from source:

```bash
# Clean previous builds
make clean

# Build the installer package
make build
```

The installer will be created at `build/product/nepali-romanized-4.0.pkg`

### Build Requirements
- macOS development environment
- Xcode command line tools
- `pkgbuild` and `productbuild` utilities (included with Xcode)

## Technical Details (For Developers)

### Key Fixes for macOS Sequoia Compatibility

1. **XML Parsing Issues Fixed:**
   - Changed XML version from 1.1 to 1.0 in keyboard layout file
   - Replaced invalid character references (&#x0000; through &#x001F;) with valid alternatives
   - Fixed truncated character references that caused parsing failures

2. **Bundle Configuration Enhanced:**
   - Added required Info.plist keys: `CFBundlePackageType`, `CFBundleShortVersionString`, `LSMinimumSystemVersion`
   - Updated bundle structure to meet modern macOS requirements
   - Added proper code signing support in build process

3. **Installation Process Improved:**
   - Enhanced cache clearing in postinstall script
   - Added input service restart procedures
   - Force refresh of keyboard layouts directory

### Files Modified:
- `lib/nepali-romanized.bundle/Contents/Info.plist` - Added required keys
- `lib/nepali-romanized.bundle/Contents/Resources/Nepali (Romanized) - Pro.keylayout` - Fixed XML issues
- `productdeps/distribution.xml` - Updated minimum OS version
- `Makefile` - Added code signing support
- `pkgdeps/scripts/postinstall` - Enhanced installation process

## Usage

After installation and logging back in:

1. Open **System Preferences** > **Keyboard** > **Input Sources**
2. Click the **"+"** button to add a new input source
3. Look for **"Nepali (Romanized) - Pro"** under "Others" or "Nepali" category
4. Select it and click **"Add"**
5. Optionally set up keyboard shortcuts for easy switching
6. Use the menu bar input selector to switch between layouts

![System Preferences](https://github.com/suvash/nepali-romanized-pro/raw/master/images/01-system-preferences.png)
![Input Sources](https://github.com/suvash/nepali-romanized-pro/raw/master/images/02-keyboard-input-sources.png)
![Nepali Layout](https://github.com/suvash/nepali-romanized-pro/raw/master/images/03-nepali-romanized-pro.png)

## Keyboard Layouts

### Nepali Mode ( Normal, Shift and Caps Lock Mode )
![Normal](https://github.com/suvash/nepali-romanized-pro/raw/master/images/layout_nepali.png)

### Quick English mode ( Command, Option and Option+Shift Mode)
![Shift Pressed](https://github.com/suvash/nepali-romanized-pro/raw/master/images/layout_english.png)

Download [the pdf here](https://github.com/suvash/nepali-romanized-pro/raw/master/images/layout.pdf) if needed.

## Support and Contributions

- **Issues:** Report problems or request features by [opening an issue](https://github.com/suvash/nepali-romanized-pro/issues)
- **Contributions:** Pull requests are welcome for improvements and bug fixes
- **Compatibility:** If you encounter issues on newer macOS versions, please report them with system details

## Credits

- **Original Layout:** Based on the Nepali Unicode Romanized layout by Madan Puraskar Pustakalaya
- **macOS Sequoia Compatibility:** Enhanced for modern macOS versions with comprehensive fixes
