# Phase 6 Implementation Plan: Interactivity

## Context
The Remote Rift website migration from 11ty to Jaspr is nearly complete. All static components, Tailwind CSS configuration, data models, and content structure are in place. Phase 6 focuses on implementing the interactive features that enhance user experience: smooth scrolling, scroll-based back-to-top button visibility, and polished mobile menu animations.

**Current State:**
- ✅ Navbar component with `@client` annotation and basic mobile menu toggle implemented
- ✅ BackToTop component with `@client` annotation but missing scroll listener
- ✅ All section components have proper IDs (`about`, `features`, `download`) for anchor navigation
- ✅ Tailwind CSS fully configured with custom brand colors
- ✅ Single-page layout with all sections integrated

**What's Missing (Phase 6 Scope):**
- Smooth scrolling CSS behavior
- BackToTop button scroll visibility logic (show after 720px scroll, matching original)
- Enhanced hamburger menu animation (polish UX)
- Proper scroll offset handling for fixed navbar

---

## Implementation Approach

### 1. Add Smooth Scrolling CSS

**File:** `web/styles.css`

Add the smooth scrolling behavior that was in the original 11ty implementation:

```css
html {
  scroll-behavior: smooth;
}
```

This should be added after the Tailwind base styles to ensure it takes effect globally.

### 2. Implement BackToTop Scroll Visibility

**File:** `lib/components/back_to_top.dart`

Current state: Component has `_visible` state field and TODO comment for scroll listener.

**Implementation steps:**

1. In `initState()`, add a window scroll event listener
2. In the scroll handler:
   - Check if `window.scrollY >= 720` (matching original threshold)
   - Update `_visible` state via `setState()`
   - Cleanup listener in `dispose()`
3. Update `build()` method to conditionally render:
   - Add `classes: 'hidden'` when `_visible` is false
   - Use normal classes when `_visible` is true

**Reference from original 11ty implementation:**
```javascript
window.addEventListener('scroll', function () {
  let btt = document.getElementById('home-button');
  if (window.scrollY >= 720) {
    btt.classList.remove('hidden');
    btt.classList.add('block');
  } else {
    btt.classList.add('hidden');
    btt.classList.remove('block');
  }
});
```

**Jaspr/Dart adaptation:**
- Use `document.window` to access scroll position
- Use `useState` pattern for `_visible` field
- Add event listener in `initState()` and remove in `dispose()`

### 3. Enhance Hamburger Menu Animation

**File:** `web/styles.css`

Add the hamburger animation styles from the original 11ty implementation to make the menu toggle more polished:

```css
.hamburger {
  cursor: pointer;
  width: 48px;
  height: 48px;
  transition: all 0.25s;
  position: relative;
}

.hamburger__top-bun,
.hamburger__bottom-bun {
  content: '';
  position: absolute;
  width: 24px;
  height: 2px;
  background: #000;
  left: 50%;
  transform: translateX(-50%);
  transition: all 0.5s;
}

.hamburger__top-bun {
  top: 50%;
  margin-top: -6px;
}

.hamburger__bottom-bun {
  top: 50%;
  margin-top: 6px;
}

.hamburger.open {
  transform: rotate(90deg);
}

.hamburger.open .hamburger__top-bun {
  transform: translateX(-50%) rotate(45deg) translateY(0px);
  top: 50%;
  margin-top: 0;
}

.hamburger.open .hamburger__bottom-bun {
  transform: translateX(-50%) rotate(-45deg) translateY(0px);
  top: 50%;
  margin-top: 0;
}
```

**File:** `lib/components/navbar.dart`

Update the hamburger button to add the `open` class conditionally:

```dart
button(
  classes: 'hamburger ${_menuOpen ? 'open' : ''} block sm:hidden focus:outline-none',
  onClick: _toggleMenu,
  [
    span(classes: 'hamburger__top-bun', []),
    span(classes: 'hamburger__bottom-bun', []),
  ],
),
```

### 4. Verify Scroll Offset for Navigation Links

**Files:** `lib/components/navbar.dart`, section components

Current state: Navigation links use `#features` and `#download` hrefs, sections have proper IDs.

**Verification needed:**
- Smooth scrolling should automatically handle scroll offset
- If navbar overlaps content when scrolling to sections, may need to add CSS scroll-padding-top:

```css
html {
  scroll-behavior: smooth;
  scroll-padding-top: 80px; /* Adjust based on navbar height */
}
```

---

## Files to Modify

1. **`lib/components/back_to_top.dart`** - Add scroll listener and visibility logic
2. **`lib/components/navbar.dart`** - Add conditional `open` class to hamburger button
3. **`web/styles.css`** - Add smooth scrolling CSS and hamburger animation styles

---

## Implementation Order

1. **Smooth Scrolling CSS** (5 minutes) - Quick win, enables other features
2. **Hamburger Animation** (10 minutes) - Polish existing menu toggle
3. **BackToTop Scroll Listener** (20 minutes) - Most complex, requires DOM event handling
4. **Scroll Offset Verification** (5 minutes) - Test and adjust if needed

---

## Verification Plan

### Manual Testing Steps

1. **Smooth Scrolling:**
   - Click "Features" link in navbar
   - Verify smooth scroll animation to features section
   - Click "Download Now" link
   - Verify smooth scroll to download section
   - Test on both desktop and mobile

2. **BackToTop Button:**
   - Scroll down the page
   - Verify button appears after scrolling ~720px
   - Scroll back up near top
   - Verify button disappears
   - Click button and verify smooth scroll to top

3. **Mobile Menu:**
   - Open on mobile viewport (< 640px)
   - Click hamburger button
   - Verify menu appears with animation
   - Click hamburger button again
   - Verify menu closes with animation
   - Click navigation links
   - Verify menu closes and smooth scrolls to section

4. **Cross-browser Testing:**
   - Test in Chrome, Firefox, Safari
   - Test on mobile devices (iOS Safari, Chrome Mobile)
   - Verify animations work smoothly

### Success Criteria

- ✅ Smooth scrolling works for all navigation links
- ✅ BackToTop button shows/hides at correct scroll position (720px)
- ✅ Hamburger menu has smooth animation when toggling
- ✅ All interactive features work on mobile and desktop
- ✅ No JavaScript console errors
- ✅ Performance is acceptable (60fps animations)

---

## Technical Notes

**Jaspr DOM Event Handling:**
- Use `document.window` for window object access
- Event listeners use standard Dart patterns
- Remember to cleanup listeners in `dispose()` to prevent memory leaks
- Use `setState()` to trigger re-renders on state changes

**CSS Considerations:**
- Tailwind CSS v4 uses `@layer` directives - custom CSS should be added after Tailwind imports
- Custom animations can coexist with Tailwind utilities
- Use CSS variables where possible for consistency with Tailwind theming

**Browser Compatibility:**
- `scroll-behavior: smooth` is supported in all modern browsers
- CSS transforms for animation have excellent browser support
- Event listeners follow standard DOM API patterns

---

## Testing Checklist

- [ ] Smooth scrolling works on Chrome desktop
- [ ] Smooth scrolling works on Safari desktop
- [ ] Smooth scrolling works on Firefox desktop
- [ ] Smooth scrolling works on mobile Chrome
- [ ] Smooth scrolling works on mobile Safari
- [ ] BackToTop button appears at 720px scroll
- [ ] BackToTop button disappears when near top
- [ ] BackToTop button smooth scrolls to top
- [ ] Hamburger menu animates when opening
- [ ] Hamburger menu animates when closing
- [ ] Mobile menu closes when clicking navigation links
- [ ] No console errors on any page
- [ ] Animations run at 60fps

---

## Estimated Timeline

- Smooth Scrolling CSS: 5 minutes
- Hamburger Animation: 10 minutes
- BackToTop Scroll Listener: 20 minutes
- Testing and Verification: 15 minutes

**Total:** ~50 minutes

---

## Dependencies

- ✅ Requires: Phase 1-5 completion (done)
- ✅ Requires: Tailwind CSS configured (done)
- ✅ Requires: Components with `@client` annotation (done)
- ✅ Requires: Section IDs in place (done)

**No blocking dependencies - ready to implement immediately.**