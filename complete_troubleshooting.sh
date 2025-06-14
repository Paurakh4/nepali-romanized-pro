#!/bin/bash

# Complete troubleshooting script for Nepali Romanized Pro keyboard layout
# This script performs all necessary steps to ensure the keyboard layout appears in System Preferences

echo "=== Nepali Romanized Pro Complete Troubleshooting ==="
echo "macOS Version: $(sw_vers -productVersion)"
echo "Build Version: $(sw_vers -buildVersion)"
echo

BUNDLE_PATH="/Library/Keyboard Layouts/nepali-romanized.bundle"

# Step 1: Verify installation
echo "Step 1: Verifying Installation"
echo "==============================="
if [ -d "$BUNDLE_PATH" ]; then
    echo "✅ Bundle found at: $BUNDLE_PATH"
else
    echo "❌ Bundle NOT found. Please install the keyboard layout first."
    echo "   Run: sudo installer -pkg build/product/nepali-romanized-4.0.pkg -target /"
    exit 1
fi

# Step 2: Validate XML structure
echo
echo "Step 2: Validating XML Structure"
echo "================================="
KEYLAYOUT_FILE="$BUNDLE_PATH/Contents/Resources/Nepali (Romanized) - Pro.keylayout"
if xmllint --noout "$KEYLAYOUT_FILE" 2>/dev/null; then
    echo "✅ Keyboard layout XML is valid"
else
    echo "❌ Keyboard layout XML is invalid. This is likely the main issue."
    echo "   The XML file contains invalid character references that prevent macOS from parsing it."
    echo "   Please use the fixed version from this repository."
    exit 1
fi

# Step 3: Check Info.plist
echo
echo "Step 3: Checking Info.plist"
echo "============================"
INFO_PLIST="$BUNDLE_PATH/Contents/Info.plist"
if plutil -lint "$INFO_PLIST" >/dev/null 2>&1; then
    echo "✅ Info.plist is valid"
    
    # Check required keys
    if plutil -extract CFBundlePackageType raw "$INFO_PLIST" 2>/dev/null | grep -q "BNDL"; then
        echo "✅ CFBundlePackageType: BNDL"
    else
        echo "❌ CFBundlePackageType missing or incorrect"
    fi
    
    if plutil -extract CFBundleShortVersionString raw "$INFO_PLIST" 2>/dev/null >/dev/null; then
        echo "✅ CFBundleShortVersionString present"
    else
        echo "❌ CFBundleShortVersionString missing"
    fi
else
    echo "❌ Info.plist is invalid"
fi

# Step 4: Clear all caches
echo
echo "Step 4: Clearing Input Source Caches"
echo "====================================="
echo "Clearing system caches..."
sudo rm -rf /System/Library/Caches/com.apple.IntlDataCache.le.kbdx 2>/dev/null && echo "✅ System cache cleared" || echo "ℹ️  System cache not found"

echo "Clearing user caches..."
rm -rf ~/Library/Caches/com.apple.IntlDataCache.le.kbdx 2>/dev/null && echo "✅ User cache cleared" || echo "ℹ️  User cache not found"

# Clear additional caches
for cache_dir in "/Library/Caches/com.apple.IntlDataCache.le.kbdx" "/var/folders/*/*/C/com.apple.IntlDataCache.le.kbdx"; do
    if [ -d "$cache_dir" ]; then
        sudo rm -rf "$cache_dir" 2>/dev/null && echo "✅ Additional cache cleared: $cache_dir"
    fi
done

# Step 5: Restart input services
echo
echo "Step 5: Restarting Input Services"
echo "=================================="
echo "Restarting TextInputMenuAgent..."
killall -HUP TextInputMenuAgent 2>/dev/null && echo "✅ TextInputMenuAgent restarted" || echo "ℹ️  TextInputMenuAgent not running"

echo "Restarting SystemUIServer..."
killall -HUP SystemUIServer 2>/dev/null && echo "✅ SystemUIServer restarted" || echo "ℹ️  SystemUIServer not running"

echo "Restarting TextInputSwitcher..."
killall -HUP TextInputSwitcher 2>/dev/null && echo "✅ TextInputSwitcher restarted" || echo "ℹ️  TextInputSwitcher not running"

# Step 6: Force refresh
echo
echo "Step 6: Force Refresh Keyboard Layouts"
echo "======================================="
sudo touch "/Library/Keyboard Layouts" && echo "✅ Keyboard layouts directory refreshed"

# Step 7: Additional macOS Sequoia specific steps
echo
echo "Step 7: macOS Sequoia Specific Steps"
echo "====================================="
if [[ "$(sw_vers -productVersion)" == 15.* ]]; then
    echo "Detected macOS Sequoia 15.x - applying additional fixes..."
    
    # Force reload of input source list
    defaults write com.apple.HIToolbox AppleEnabledInputSources -array-add '{
        "Bundle ID" = "com.thapaliya.ukelele.keyboardlayout.nepali-romanized";
        "Input Mode" = "com.thapaliya.ukelele.keyboardlayout.nepali-romanized.nepali(romanized)-pro";
        "InputSourceKind" = "Keyboard Layout";
        "KeyboardLayout Name" = "Nepali (Romanized) - Pro";
    }' 2>/dev/null && echo "✅ Added to input sources registry" || echo "ℹ️  Registry update attempted"
    
    # Restart additional services for Sequoia
    killall -HUP "Input Method Kit" 2>/dev/null || true
    killall -HUP "TextInputMenuAgent" 2>/dev/null || true
else
    echo "ℹ️  Not macOS Sequoia - skipping Sequoia-specific steps"
fi

# Step 8: Final verification
echo
echo "Step 8: Final Verification"
echo "=========================="
if codesign -dv "$BUNDLE_PATH" 2>&1 | grep -q "Signature="; then
    echo "✅ Bundle is properly code signed"
else
    echo "⚠️  Bundle is not code signed (may cause issues on some systems)"
fi

echo
echo "=== IMPORTANT NEXT STEPS ==="
echo "1. 🔄 LOG OUT AND LOG BACK IN (This is REQUIRED for macOS to recognize the keyboard layout)"
echo "2. 🖥️  Go to System Preferences > Keyboard > Input Sources"
echo "3. ➕ Click the '+' button to add a new input source"
echo "4. 🔍 Look for 'Nepali (Romanized) - Pro' under:"
echo "   - 'Others' category, OR"
echo "   - 'Nepali' language category"
echo "5. ✅ Select it and click 'Add'"
echo
echo "If the keyboard layout still doesn't appear after logging out/in:"
echo "- Run this script again"
echo "- Check System Preferences > Security & Privacy > Privacy > Input Monitoring"
echo "- Try restarting your Mac completely"
echo
echo "=== Troubleshooting Complete ==="
