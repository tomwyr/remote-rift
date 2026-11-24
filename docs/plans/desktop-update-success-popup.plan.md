## 1. Goal

Notify desktop users exactly once after relaunch when an update either completed or rolled back, with each occurrence delivered to the UI as a typed transient event from the locally owned update cubit.

## 2. Approach

The updater keeps durable cross-process records and `UpdateCubit` maps startup results into desktop presentation events. The root-level `UpdateComponent` provides the cubit and subscribes to its broadcast event stream with the shared `EventsListener` before initialization. It presents non-blocking toast notifications at the UI boundary.

The success toast uses the explicit success icon treatment. The rollback toast uses the coral error treatment, tells the user that the previous version is still running, and directs them to the header Update action. The Update page handles pre-exit download and helper-start errors in the current process.

## 3. File Changes

- **Modify** `packages/updater/lib/src/models.dart` — define startup results for acknowledged and recovered updates, pending acknowledgement, invalid journal or recovery records, and no update; keep them focused on updater facts rather than UI semantics.
- **Modify (generated)** `packages/updater/lib/src/models.g.dart` — generate JSON support for the journal and recovery record.
- **Modify** `packages/updater/lib/src/update_journal_store.dart` — acknowledge matching journals, persist and consume a separate recovery record, and preserve pending or invalid records.
- **Modify** `packages/updater/lib/src/update_runner.dart` — record the recovery cause before attempting to relaunch the original or restored app. Resolve the startup result during healthy startup.
- **Modify** `packages/updater/lib/src/updater.dart` — make `ApplicationUpdater.acknowledgeHealthyStart` and `DesktopUpdater` return the startup outcome.
- **Modify** `apps/desktop/lib/services/noop_updater.dart` — return the updater’s absent-result value in debug/no-op mode.
- **Modify** `apps/desktop/lib/dependencies.dart` — retain the existing update-cubit factory as the provider entry point for the new update feature component.
- **Modify** `apps/desktop/lib/main.dart` — stop acknowledging the outcome directly; initialize window/tray as today, then run the app so the cubit can communicate the occurrence through its event stream.
- **Modify** `apps/desktop/lib/ui/app/app.dart` — mount `AppNotifications` in `MaterialApp.builder` with the navigator key, then wrap the navigator with the update feature component so both persist across home-route changes.
- **Create** `apps/desktop/lib/ui/app/app_notifications.dart` — wrap the app in a Toastification scope and use the app-provided navigator key to display notifications.
- **Modify** `apps/desktop/lib/ui/update/update_state.dart` — define payload-free update events as an enum beside the feature state types.
- **Modify** `apps/desktop/lib/ui/update/update_cubit.dart` — add a broadcast event controller, translate the updater’s startup outcome into a typed event during initialization, expose `events`, and close the event controller and cubit together.
- **Create** `apps/desktop/lib/ui/update/update_component.dart` — provide the cubit, consume its events with `EventsListener` before initialization, and render outcome toasts at the UI boundary.
- **Modify** `packages/ui/lib/remote_rift_ui.dart` and **Create** `packages/ui/lib/src/widgets/events_listener.dart` — move the shared event-stream listener from the mobile app into the shared UI package.
- **Modify** `apps/mobile/lib/ui/champion_select/widgets/picker_sheet.dart` and **Delete** `apps/mobile/lib/ui/widgets/events_listener.dart` — use the shared event listener instead of retaining a duplicate mobile-only widget.
- **Modify** `apps/desktop/pubspec.yaml` — add `toastification` for queued, non-blocking desktop notifications.
- **Modify** `apps/desktop/lib/ui/update/update_button.dart` — consume the ancestor update cubit instead of creating a separate provider or triggering initialization, so header actions and startup events share one feature owner.
- **Modify** `apps/desktop/lib/ui/widgets/app_shell.dart` — replace `UpdateButton.builder()` with the inherited-cubit `UpdateButton`.
- **Modify** `apps/desktop/lib/i18n/en.i18n.yaml` — add localized success and rollback toast copy.
- **Modify (generated)** `apps/desktop/lib/i18n/strings.g.dart` and `apps/desktop/lib/i18n/strings_en.g.dart` — regenerate Slang APIs from the localization source.

## 4. Implementation Steps

### Task 1: Persist only trustworthy cross-process update outcomes

1. In `packages/updater/lib/src/models.dart`, define finite `UpdateStartupResult` variants for acknowledged, recovery, pending acknowledgement, invalid records, and no record. Keep them free of UI wording and product presentation policy.
2. In `packages/updater/lib/src/update_journal_store.dart`, acknowledge a matching journal after removing any existing backup and deleting the journal. Return pending acknowledgement for a version mismatch and invalid results for malformed records. Use a separate sibling file for recovery results.
3. In `packages/updater/lib/src/update_runner.dart`, keep the current rollback behavior. On helper failure after the original app has exited, restore the backup if the replacement was installed, record the failure and recovery cause, then attempt to relaunch the existing or restored executable. The recovery record is written before relaunch is confirmed.
4. In `packages/updater/lib/src/update_runner.dart`, read the journal first. Consume a recovery record only if the journal result is `NoUpdate`. An awaiting or invalid journal takes precedence.
5. In `packages/updater/lib/src/updater.dart` and `apps/desktop/lib/services/noop_updater.dart`, expose those facts through `ApplicationUpdater`; the no-op implementation returns the absent-result value.

### Task 2: Emit update outcomes as typed cubit events

1. Add payload-free `UpdateEvent.installed` and `UpdateEvent.installationFailed` enum values to `apps/desktop/lib/ui/update/update_state.dart`. Keep them transient presentation events, separate from persistent `UpdateState` variants.
2. In `apps/desktop/lib/ui/update/update_cubit.dart`, add a broadcast `StreamController<UpdateEvent>`, expose a read-only `Stream<UpdateEvent>`, and await event-controller and cubit closure together.
3. Extend `UpdateCubit.initialize` to first await `_updater.acknowledgeHealthyStart()`, map `Acknowledged` to `.installed`, `Recovered` to `.installationFailed`, and intentionally ignore unrelated updater results before continuing the existing update-availability check and state transitions. The event must not be encoded in `UpdateState`, because it is a one-time UI effect.
4. Preserve `installUpdate` and `UpdateError` behavior in `apps/desktop/lib/ui/update/update_cubit.dart`. `UpdatePage` renders download and helper-start failures in the current process.

### Task 3: Scope the update feature and listen at the UI boundary

1. Use `apps/desktop/lib/ui/update/update_component.dart` as the update feature boundary. Its builder creates `UpdateCubit` through `Dependencies.updateCubit`. Its shared `EventsListener` subscribes to `cubit.events` in `initState`. The nested `Lifecycle` calls `cubit.initialize()`. `EventsListener` cancels the subscription on disposal.
2. Use the shared `EventsListener` around the lifecycle that initializes the cubit, so subscription occurs before the startup event can be emitted. Map each event to a toast through the navigator context. `AppNotifications.show` returns early when the navigator is unavailable.
3. In `apps/desktop/lib/ui/app/app.dart`, mount `AppNotifications` with the app-owned navigator key around `UpdateComponent.builder` in `MaterialApp.builder`. `UpdateComponent` resolves notifications from context rather than receiving navigation infrastructure directly, while its local cubit remains available to every header update control.
4. In `apps/desktop/lib/ui/update/update_button.dart`, remove its inner provider and `Lifecycle(onInit: cubit.initialize)`; read/watch the inherited cubit instead. In `apps/desktop/lib/ui/widgets/app_shell.dart`, instantiate the inherited `UpdateButton` directly.
5. Preserve `UpdatePage.show`'s `BlocProvider.value` usage in `apps/desktop/lib/ui/update/update_page.dart`, so the pushed route continues to use the same update cubit rather than creating one.

### Task 4: Render concise outcome toasts and localize them

1. In `apps/desktop/lib/ui/app/app_notifications.dart`, centralize `toastification` calls in `AppNotifications.show`, with an `AppNotificationType` enum selecting the success or error treatment. Configure each bottom-right, non-blocking toast with a five-second duration, canvas/navy surface, themed title and body text, 12 px padding, 8 px margin, 16 px corner radius, low-opacity navy border, and soft shadow.
2. Render `UpdateEvent.installed` with `colors.success` on a check icon and concise completion title/body.
3. Render `UpdateEvent.installationFailed` with `Icons.error_outline_rounded` and `colors.error`, copy confirming the previous version is still running, and an instruction to use the header Update action to try again. Do not add a retry that competes with the cubit’s update-check lifecycle.
4. Use Toastification’s 200 ms animation and the existing Material icons. The toast supports click and drag dismissal.
5. Add all new strings in `apps/desktop/lib/i18n/en.i18n.yaml`, regenerate generated Slang output with `dart run slang` from `apps/desktop`, and use the resulting typed translation accessors.

## 5. Acceptance Criteria

- On every launch, `UpdateCubit.initialize` awaits updater acknowledgement and maps each relevant updater fact to exactly one typed `UpdateEvent` on its public broadcast stream.
- The update component subscribes before initialization. With the navigator ready, each startup event received by `EventsListener` shows one toast.
- No updater outcome is supplied directly to `App`, `HomePage`, or a toast constructor from `main`.
- A normal launch emits no event and displays no popup. `UpdateCubit` intentionally ignores updater-pending and invalid-record facts until the desktop product has a use for them.
- A matching completed-update journal produces one `UpdateEvent.installed` event for the green confirmation toast.
- A helper-side failure that relaunches the original or restored app produces one `UpdateEvent.installationFailed` event for the coral error toast. The copy says the previous version remains active and how to retry.
- Existing pre-exit update errors continue to render in `UpdatePage` without a startup event or duplicate toast.
- `UpdateButton` and `UpdatePage` operate on the same inherited `UpdateCubit`; no separate update cubit is created per app shell.
- The cubit closes its event controller and the shared listener cancels its stream subscription on disposal.
- All outcome-toast strings are localized through `apps/desktop/lib/i18n/en.i18n.yaml` and regenerated Slang accessors.

## 6. Verification Steps

Use a release-mode Desktop build for update-path verification. Debug mode uses
`NoopUpdater` and returns no startup outcome.

1. Regenerate Slang output from `apps/desktop`, format the non-generated changed Dart files, and run the relevant Dart analyzer. Do not add or run automated tests under the repository agreement.
2. Launch normally without update artifacts; verify the update feature initializes once, emits no outcome event, displays no toast, and still checks for updates.
3. Complete a normal update and confirm the relaunched app emits the installed event, displays the green toast once, and does not display it after a second restart.
4. Trigger a helper-side archive, extraction, or replacement failure that recovers to the old executable. Confirm the relaunched app emits the failure event and shows the coral recovery toast once. Check that the header Update action appears if the release check finds an available update.
5. Trigger an in-app download/helper-start failure and confirm the existing Update page error remains the only feedback.
6. Inspect debug logs/breakpoints or a temporary development observer to confirm the toast is shown from `UpdateCubit.events`, not from a state transition or main-startup constructor argument.
7. With the Flutter desktop app active, hot reload after UI changes and visually verify toast spacing, contrast, icon alignment, and dismissal on supported macOS and Windows targets.

## 7. Risks & Mitigations

- **Missed startup event:** emitting before the UI subscribes would silently drop a broadcast event. Mitigation: the outer `EventsListener` subscribes before the nested `Lifecycle` calls `UpdateCubit.initialize()`.
- **Duplicate update cubits:** per-shell providers would split the event stream from the header’s update state. Mitigation: scope exactly one provider in `UpdateComponent` and remove `UpdateButton.builder`.
- **Persistent transient effect:** adding startup outcome to `UpdateState` could reopen toasts after rebuilds. Mitigation: use enum `UpdateEvent` values and consume each stored outcome once.
- **Misleading failure warning:** a helper may be unable to restore or relaunch anything. Mitigation: the helper records recovery before attempting to relaunch the existing or restored app. The user-facing event requires a subsequent startup that consumes the recovery record.
- **Retry lifecycle race:** a toast retry could race the existing availability check. Mitigation: make the failure toast actionable through explicit guidance to the already-owned header Update flow.
