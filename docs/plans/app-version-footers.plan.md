## Goal

Display the installed Mobile and Desktop version as a quiet `v<version>` footer in
the shared app layouts. Mobile keeps it below the scrollable status content. Desktop
shows it in the footer of the fixed 320 × 472 window.

## Approach

Share one `AppVersion` widget. It resolves package information once per widget state
and shows the installed version with the existing secondary text style. Each app
owns the footer placement and spacing in its layout.

## File changes

| File | Responsibility |
| --- | --- |
| `packages/ui/pubspec.yaml` | Declare the shared widget's `package_info_plus` dependency. |
| `packages/ui/lib/src/widgets/app_version.dart` | Cache the package-info future and render centered `v<version>` metadata. |
| `packages/ui/lib/remote_rift_ui.dart` | Export `AppVersion` to both apps. |
| `apps/mobile/lib/ui/widgets/layout.dart` | Place the label below the expanded status scroll view, with 20 px side, 8 px top, and 12 px bottom padding. |
| `apps/desktop/lib/ui/widgets/app_shell.dart` and `app_footer.dart` | Place the centered label beneath the shell body, with connection and MCP indicators aligned to the right. |
| `apps/desktop/lib/ui/app/app_window.dart` | Keep the non-resizable window at 320 × 472 logical pixels. |

## Implementation steps

### Task 1 — Resolve and display the installed version

1. Initialize one `PackageInfo.fromPlatform()` future for each `AppVersion` state.
2. Display the app version with a lowercase `v` prefix and no build suffix. Use
   `labelSmall` with the theme's navy at 72% opacity.
3. Render an empty widget while resolving the version or when package information
   is unavailable.

### Task 2 — Integrate with the app layouts

1. Keep Mobile status content and actions in `FitViewportScrollView`. Put the
   version in its own padded child below the expanded scroll view.
2. Place the Desktop version in `AppFooter` with 12 px side and bottom padding
   and 8 px top padding. Keep it centered as the connection indicators change.
3. Keep window alignment, title bar, and close behavior independent of the footer.

## Acceptance criteria

- Mobile connection, game, and champion-select status layouts display the installed
  version beneath the scroll view. Long content scrolls above it.
- Desktop shell pages show one centered version alongside the footer indicators.
- Both apps use the installed version and display the same non-interactive text style.
- Failed or pending package lookup leaves the label empty. Layout padding belongs to
  the parent footer.
- The Desktop window remains non-resizable at 320 × 472 logical pixels.

## Verification steps

1. Inspect a short Mobile connection state and a long champion-select state. Confirm
   that content and actions scroll, the label remains visible, and the layout fits.
2. Inspect Desktop connection, service, and update pages. Confirm that the status
   indicators leave the label centered and the fixed window does not clip it.
3. Check the version against the installed package version on both apps.

## Risks and mitigations

- Resolve package information outside rebuilds so layout updates reuse the same
  future. Check text contrast and clipping at the parent layout's intended size.
