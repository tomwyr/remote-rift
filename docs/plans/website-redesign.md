# Remote Rift Website Redesign

## Purpose

Maintain a concise product page for experienced League players. The page shows
what Remote Rift supports during matchmaking, what the companion interface
looks like, and how to install it without explaining familiar League concepts
or making promotional claims.

## Page structure

- Hero: practical phone-based matchmaking control and an existing Remote Rift
  screenshot showing a ready-check countdown.
- How it works: the local connection path between Remote Rift Desktop, the
  League Client, and Remote Rift Mobile.
- Features: supported matchmaking controls and queue groups.
- Troubleshooting: connection, network, and version messages in cause/advice
  form.
- Install: setup order, local-network requirements as information, and
  disabled `Coming soon` download controls for the four app platforms.

## Content decisions

- Keep prerequisites out of the hero. Show them during installation and in
  relevant connection guidance instead.
- Only describe released, supported functionality. Do not retain placeholder
  feature copy.
- Use direct user-facing language and League terminology without explaining
  League mechanics.
- Keep the non-affiliation note in the footer alongside the `Source code` and
  `Built with Jaspr` links.

## Visual and accessibility direction

- Use the existing showcase image; do not construct product-like graphics or
  mock devices in HTML/CSS.
- Keep the light, near-white canvas with structural navy, gold details, and
  restrained League-inspired light blue/cyan connection states.
- Use Tailwind utility classes in components. Restrict stylesheet code to
  shared tokens, base styles, and behavior that cannot be expressed in markup.
- Preserve semantic landmarks, visible focus styles, disabled download
  semantics, text-plus-icon states, and reduced-motion behavior.

## Tooling and verification

- The website declares `build_runner: ^2.15.1`. Its lockfile resolves
  `build_runner` at `2.15.1` and the transitive `build_daemon` at `4.1.5`.
- From `apps/website`, compile Tailwind CSS then build for the GitHub Pages
  base path:

  ```sh
  tailwindcss --input styles.tw.css --output web/styles.css --minify
  jaspr build --dart-define=BASE_PATH=/remote-rift/
  ```

## Assumptions

- Visitors already understand League matchmaking terminology.
- The connection explanation covers Remote Rift only, not League Client
  mechanics.
- Both devices need the same local network, with Remote Rift Desktop and the
  League Client running.

## Outstanding work

- Wire download destinations into the install section when ready for the
  website. The current section renders disabled buttons.
- Update copy and screenshots for the full draft loop as described in
  [Website Phase 5](full-matchmaking-loop-mobile.md#phase-5--website-update-for-the-full-draft-loop).
