# Remote Rift design and style guidelines

This is the visual, interaction, typography, and editorial baseline for Remote Rift. Use it to keep future product surfaces recognisably part of the same system. It defines how the product should look and behave; it does not describe feature flows, component ownership, source files, or implementation architecture.

## Design character

Remote Rift is a calm, technical, League-inspired control surface. Its style is light and precise rather than flashy or game-like.

- Use a light canvas with navy structure and text contrast.
- Use gold to establish hierarchy, frames, and metadata—not urgency.
- In operational, live-status UI, use cyan and ready green to communicate active or actionable states.
- Ensure every status has a literal label and an icon; colour must not carry the meaning alone.
- Use decoration sparingly: thin rules, a subtle structural grid, and diamond markers may orient the user but must not compete with information or actions.

Avoid dark mode, neon/scanline effects, glassmorphism, generic rounded-SaaS styling, and decoration that obscures the product’s practical purpose.

## Colour

Use named colour tokens consistently. Do not introduce visually similar ad hoc colours when an established token serves the role.

| Token | Value | Purpose |
| --- | --- | --- |
| Canvas | `#FFFFFF` | Default light surface |
| Navy | `#0A1428` | Primary text, structure, primary fills, and borders |
| Panel | `#0E1B2B` | Dark panel surface |
| Panel muted | `#16263A` | Subordinate dark panel surface |
| Rift blue | `#005A82` | Low-contrast structural detail |
| Gold | `#C8AA6E` | Hierarchy, frames, dividers, and neutral accents |
| Gold ink | `#806528` | Gold text on light surfaces |
| Cyan | `#0AC8B9` | Active/interactive emphasis |
| Light blue | `#54C7F3` | Subtle active atmosphere and supporting highlight |
| Ready | `#00726B` | Ready/connected confirmation and focus treatment |
| Success | `#8BC34A` | Explicit success icon treatment |
| Warning | `#F9C732` | Attention that does not indicate failure |
| Error | `#EB6258` | Failure or unavailable state |
| On panel | `#D8E4EE` | Supporting text in emphasized dark-panel notes |
| On panel muted | `#C8D0D9` | Secondary description text in dark panels |
| Footer | `#07101F` | Final-page surface |
| On footer | `#D9D1C2` | Footer body text |
| On footer muted | `#AEB6C0` | Footer secondary text |

Canvas and navy form the default readable pair. On dark panels, use light text for primary content. Maintain adequate readable contrast in both light and dark surface pairings. Gold is generally an accent rather than body copy; cyan and ready green should retain their live-status meaning in operational UI.

The hero phone frame uses `#1B1E24` as a deliberate one-off device-material colour. It is local to that mockup and is not a general product-surface token.

## Typography

Use Inter for interface and body text. Use the serif display style only for large editorial headings on informational pages.

- Display headings are bold, compact, slightly tight in tracking, and use leading near `1.06`.
- Interface titles, body copy, controls, and status details use Inter with a clear weight hierarchy.
- Use compact uppercase Inter labels for eyebrows, metadata, and categories. Apply generous letter spacing (`0.9–1.2px` or `0.12–0.16em`) and keep them short.
- Use sentence case for descriptions and action labels. Do not use all-caps for body text.
- Prefer direct, easily scanned wording over decorative terminology.

## Layout, form, and elevation

Use a 4px spacing rhythm. Common increments are 8, 12, 16, 20, and 24px. Relationships matter most: label-to-title is tight, title-to-description is moderate, and independent groups have clear separation.

- Phone layouts use 20px side gutters; controls remain reachable at the bottom when content scrolls.
- Status panels use 16px internal padding. Rounded panels and embedded status-icon containers use 16px and 10px radii respectively.
- Primary, standard, and compact controls are 48px, 44px, and 40px high.
- Editorial page frames are square and precise: thin gold borders, gold left rules for major headings, and occasional 6px offset shadows on dark framed panels.
- Rounded geometry is reserved for touch surfaces, compact status panels, and device mockups; it is not the default editorial-card treatment.

## Actions and controls

Actions must say exactly what they do.

- Primary operational actions use a navy fill, light label, and navy border.
- Secondary actions use a light/transparent surface with navy text and border.
- Editorial primary calls to action use navy fill, gold border, and light text; their hover state reverses to gold and navy. Secondary calls to action use a navy outline and may use cyan on hover.
- Keep the primary action before the secondary action. When an action is unavailable, show it as disabled rather than pretending it is available or removing meaningful context.
- Do not use cyan or ready green as a general replacement primary-action palette. Destructive choices must be literal in wording, not signalled by colour alone.

## Status, feedback, and informational emphasis

Operational states must have a stable layout, a direct title, an explanation, an icon, an appropriate tone, and the next available action. Use progress indicators for pending work without replacing the surrounding context with an unexplained spinner.

| Tone | Meaning | Treatment |
| --- | --- | --- |
| Neutral | Informational/default | Gold accent |
| Active | Connecting, loading, searching, or in-progress | Cyan accent |
| Ready | Connected or ready for confirmation | Ready-green accent |
| Warning | Attention or compatibility issue | Yellow accent |
| Error | Failure or unavailable connection | Coral accent |

Time-sensitive confirmations receive the strongest hierarchy: a distinct ready-tinted panel, an explicit time label, remaining time, and clear confirm/decline actions.

Static explanatory content is not a live incident. Keep instructional or troubleshooting cards calm, gold-framed, and direct; a small cyan or ready-green marker may provide visual rhythm without claiming a current status or creating alert urgency.

## Responsive and atmospheric treatment

Use responsive layout changes to preserve reading order and reachable controls, not to hide essential information. Multi-column editorial layouts progressively collapse into fewer columns; compact navigation changes to an explicit menu control.

- A subtle rift-blue grid may support a light hero surface.
- A low-opacity cursor-responsive radial atmosphere may support dark editorial surfaces on fine-pointer devices. It must not reduce legibility.
- Keep motion brief and non-essential. Hover, menu, and navigation feedback use short transitions; understanding a state must never depend on animation.

## Editorial voice

Write as a precise operational companion.

- Prefer literal verbs such as `connects`, `shows`, `requires`, `starts`, `cancels`, `accepts`, and `declines`.
- Put relevant requirements and limitations near the action or instruction they affect.
- Describe failure plainly and state the next useful step.
- Avoid pressure, scarcity, vague promises, or unverified claims such as “seamless,” “ultimate,” “never miss,” “unlock,” and “level up.”
- Do not imply official affiliation, endorsement, reliability, or compatibility beyond what can be demonstrated.

## Design review checklist

Before introducing a new surface or state, confirm that it uses the established tokens, typography, hierarchy, and control treatment; communicates status with text and icon; presents honest available/disabled states; remains usable at compact sizes; preserves contrast; and uses motion or decoration only in support of comprehension.
