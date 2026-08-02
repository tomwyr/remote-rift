---
name: remote-rift-product-screenshots
description: Capture and maintain Remote Rift's Flutter product walkthrough screenshots. Use for screenshot retakes, README gallery updates, mobile/desktop mock-state captures, or the website showcase image in this repository. Infer the needed walkthrough states from the existing app, docs, and assets instead of requiring the user to enumerate them.
---

# Remote Rift Product Screenshots

Maintain polished, deterministic Remote Rift walkthrough images. Work autonomously from the current product and documentation.

## Defaults

- Inspect `apps/mobile/README.md`, `apps/desktop/README.md`, existing `docs/images/`, and `apps/website/web/images/showcase/` first.
- Preserve the current gallery's intended scope and filenames unless the user asks to add, remove, or reorder states.
- Infer a coherent user journey from the actual UI and localization. Do not ask the user to list screens when the product, README, or existing screenshots establish the narrative.
- For a missing mobile gallery, use: selected lobby → queue selection → ready check → game in progress.
- For a missing desktop gallery, use the non-redundant connection/service states already represented by the desktop UI and README. Prefer the normal connection path; include warnings or errors only when they add useful coverage.
- Ask only when the repository provides no defensible choice or the decision would materially change the product story.

## Capture workflow

1. Identify the production widgets, target files, and native dimensions. Reuse existing image names and README width conventions.
2. Add a temporary local-only Flutter harness that renders real production widgets with deterministic mock data. Bypass live connectors, APIs, and time-dependent state. Disable the debug banner.
3. Capture each state after it is stable. Hot restart after changing a temporary state when practical.
4. Visually inspect every full-resolution image. Retake it if assets have not loaded, chrome is inconsistent, content is clipped, a countdown has changed, a spinner is barely visible, or output is blurry.
5. Update docs and dependent website assets. Use accurate alt text and valid relative paths.
6. Restore the production app entry point and remove the complete temporary harness. Confirm no capture-only identifiers remain and live initialization is unchanged.

## Platform rules

### Mobile

- Capture the full simulator display at the current target viewport; retain the native status bar, Dynamic Island/notch, and system icons consistently across the set.
- Use a fixed countdown for ready-check captures; show 6–7 seconds unless the user specifies otherwise.
- Render queue sheets from representative enabled queues. Use current groups/order and show every requested option legibly.

### Desktop

- Render the real desktop shell at its fixed window size inside a `RepaintBoundary`; export with `toImage(pixelRatio: 3)` for sharp PNGs without OS window chrome.
- Wait before exporting indeterminate spinners so a substantial arc is visible.

### Website showcase

- Refresh `apps/website/web/images/showcase/showcase.png` from the approved mobile ready-check capture when that capture changes.
- Keep the screenshot's native aspect ratio. Do not add a synthetic notch when the capture already includes a real system status area.
- Keep bezel, clipped screen, and caption as separate layout elements; never let the caption constrain or crowd the device frame.

## Verification

- Check dimensions, image paths, README references, and the website source reference.
- Run focused formatting/build checks only when relevant. Report a blocked local daemon rather than terminating unrelated processes.
- Do not commit or publish unless asked.
