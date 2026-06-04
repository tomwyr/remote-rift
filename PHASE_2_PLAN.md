# Phase 2 Implementation Plan: Static Assets Migration

## Overview
Migrate all static images from the 11ty project to the Jaspr project and organize them into a logical directory structure.

## Prerequisites
- Phase 1 (Tailwind setup) should be completed
- Access to source project at `../remote-rift-website-11ty/`
- `web/images/` directory exists in Jaspr project

## Implementation Steps

### Step 1: Create Directory Structure
**Duration: 5 minutes**

1. Create the following directory structure under `web/images/`:
   ```bash
   mkdir -p web/images/branding
   mkdir -p web/images/showcase
   mkdir -p web/images/features
   mkdir -p web/images/downloads
   ```

**Verification:**
```bash
ls -la web/images/
# Should show: branding/, showcase/, features/, downloads/
```

### Step 2: Copy Branding Assets
**Duration: 2 minutes**

**Assets to copy:**
1. `logo.png` - Main logo used in navbar and hero section
2. `favicon.ico` - Site favicon (if exists in source)

**Commands:**
```bash
# Copy logo
cp ../remote-rift-website-11ty/public/img/logo.png web/images/branding/

# Copy favicon if it exists
cp ../remote-rift-website-11ty/public/favicon.ico web/ 2>/dev/null || echo "No favicon found"
```

**Expected files:**
- `web/images/branding/logo.png`
- `web/favicon.ico` (if exists in source)

### Step 3: Copy Showcase Assets
**Duration: 2 minutes**

**Assets to copy:**
1. `showcase.png` - Hero showcase image showing the app interface

**Commands:**
```bash
cp ../remote-rift-website-11ty/public/img/showcase.png web/images/showcase/
```

**Expected files:**
- `web/images/showcase/showcase.png`

### Step 4: Copy Feature Icons
**Duration: 5 minutes**

**Assets to copy:**
1. `icon_mobile.svg` - Remote queue control feature icon
2. `icon_sync.svg` - Lobby updates feature icon
3. `icon_coffee.svg` - Make wait useful feature icon
4. `icon_rocket.svg` - More coming soon feature icon

**Commands:**
```bash
cp ../remote-rift-website-11ty/public/img/icon_mobile.svg web/images/features/
cp ../remote-rift-website-11ty/public/img/icon_sync.svg web/images/features/
cp ../remote-rift-website-11ty/public/img/icon_coffee.svg web/images/features/
cp ../remote-rift-website-11ty/public/img/icon_rocket.svg web/images/features/
```

**Expected files:**
- `web/images/features/icon_mobile.svg`
- `web/images/features/icon_sync.svg`
- `web/images/features/icon_coffee.svg`
- `web/images/features/icon_rocket.svg`

### Step 5: Copy Download Badges
**Duration: 2 minutes**

**Assets to copy:**
1. `icon_app_store.svg` - App Store download badge
2. `icon_play_store.svg` - Play Store download badge

**Commands:**
```bash
cp ../remote-rift-website-11ty/public/img/icon_app_store.svg web/images/downloads/
cp ../remote-rift-website-11ty/public/img/icon_play_store.svg web/images/downloads/
```

**Expected files:**
- `web/images/downloads/icon_app_store.svg`
- `web/images/downloads/icon_play_store.svg`

### Step 6: Verify All Assets
**Duration: 5 minutes**

**Verification commands:**
```bash
# List all copied images
find web/images -type f

# Verify file sizes (ensure files aren't empty)
find web/images -type f -exec ls -lh {} \;

# Count total assets
echo "Total assets copied: $(find web/images -type f | wc -l)"
```

**Expected output:**
- 10 image files total
- All files should have non-zero size
- No broken symlinks or corrupted files

**Manual verification:**
1. Open a few key images in an image viewer or browser:
   - `web/images/branding/logo.png`
   - `web/images/showcase/showcase.png`
   - `web/images/features/icon_mobile.svg`
2. Ensure they display correctly
3. Check SVG files are valid (can open in a text editor or browser)

### Step 7: Create Asset Reference Document
**Duration: 10 minutes**

Create `ASSETS.md` to document all migrated assets:

```markdown
# Static Assets Reference

## Directory Structure

```
web/images/
├── branding/         # Brand identity assets
├── showcase/         # Hero section images
├── features/         # Feature section icons
└── downloads/        # Download badges and icons
```

## Asset Inventory

### Branding (`web/images/branding/`)
- `logo.png` - Main logo, used in navbar and about section
  - Source: `../remote-rift-website-11ty/public/img/logo.png`

### Showcase (`web/images/showcase/`)
- `showcase.png` - App interface showcase for hero section
  - Source: `../remote-rift-website-11ty/public/img/showcase.png`

### Features (`web/images/features/`)
- `icon_mobile.svg` - Remote queue control feature
  - Source: `../remote-rift-website-11ty/public/img/icon_mobile.svg`
- `icon_sync.svg` - Lobby updates feature
  - Source: `../remote-rift-website-11ty/public/img/icon_sync.svg`
- `icon_coffee.svg` - Make wait useful feature
  - Source: `../remote-rift-website-11ty/public/img/icon_coffee.svg`
- `icon_rocket.svg` - More coming soon feature
  - Source: `../remote-rift-website-11ty/public/img/icon_rocket.svg`

### Downloads (`web/images/downloads/`)
- `icon_app_store.svg` - App Store download badge
  - Source: `../remote-rift-website-11ty/public/img/icon_app_store.svg`
- `icon_play_store.svg` - Play Store download badge
  - Source: `../remote-rift-website-11ty/public/img/icon_play_store.svg`

## Usage in Components

Assets will be referenced in components using Jaspr's image component:
```dart
Image src: '/images/branding/logo.png', src: 'images/showcase/showcase.png'
```

## Total Assets: 10
```

### Step 8: Update Git Tracking
**Duration: 2 minutes**

**Commands:**
```bash
# Add all new assets to git
git add web/images/

# Check status
git status

# Commit (optional, can be done with Phase 2 completion)
git commit -m "Phase 2: Migrate static assets from 11ty to Jaspr

- Copy all images from source 11ty project
- Organize into logical directory structure
- Add branding, showcase, features, downloads directories
- Document assets in ASSETS.md"
```

## Total Estimated Duration: 33 minutes

## Success Criteria

- [ ] All 10 image files copied successfully
- [ ] Directory structure created as specified
- [ ] All files have non-zero size
- [ ] Sample images open and display correctly
- [ ] SVG files are valid
- [ ] `ASSETS.md` documentation created
- [ ] Assets added to git tracking
- [ ] No broken or corrupted files

## Potential Issues & Solutions

### Issue 1: Source path doesn't exist
**Solution:** Verify the 11ty project location:
```bash
ls ../remote-rift-website-11ty/public/img/
```
If path is different, update all copy commands accordingly.

### Issue 2: Permission denied
**Solution:** Check file permissions:
```bash
chmod 644 web/images/**/*
```

### Issue 3: Files are corrupted
**Solution:** Re-copy the specific files from source, verify source files aren't corrupted first.

### Issue 4: Missing assets in source
**Solution:** Document which assets are missing in `ASSETS.md` and create placeholder or note to obtain original.

## Next Steps After Phase 2

Once Phase 2 is complete:
1. Verify all assets are accessible via web server
2. Test image loading in components
3. Proceed to Phase 3: Data & Content Structure
4. Reference assets in component implementations

## Notes

- All source images should remain untouched in the 11ty project
- Maintain original file names for easy traceability
- SVG files are preferred for icons (scalable, smaller size)
- PNG files used for photographs/raster images
- Consider image optimization in future phases (if needed for performance)