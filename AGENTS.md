# Dart and Flutter working agreements

## Model boundaries

- Keep transport models faithful to remote protocols: preserve wire names, shapes, and raw domain terminology.
- Put product-facing naming, normalization, and derived state in application models and mappers.
- Use enums for finite protocol values and configure JSON casing with `@JsonEnum(fieldRename:)`; do not add redundant `@JsonValue` annotations or `alwaysCreate`.
- Let generated serializers encode and decode protocol enums; do not manually map JSON strings or serialize enum names.
- Require fields unless absence is meaningful and expected; nullable fields represent genuinely unknown or unavailable data.
- Do not use a nullable successful result for an invalid current state; return a value or throw the feature's typed state error.
- Model mutually exclusive product states with distinct valid data as sealed types; preserve meaningful protocol states rather than mapping them to `null`.
- Prefer full, domain-neutral names over abbreviations, and do not couple reusable value types to their first flow.

## Serialization and time

- Expose elapsed or remaining time as `Duration`, not numeric milliseconds or seconds.
- Define JSON converters in dedicated converter files, keep wire units explicit, and verify both serialization directions when changing a time type.
- Prefer `json_serializable`; use a custom converter only when generated `fromJson` and `toJson` APIs cannot express the boundary.
- Do not suppress generated serialization APIs unless omission is required for correct behavior.
- Decode sealed JSON types by switching directly on the discriminator and delegating to the selected variant's generated `fromJson` factory.
- Use `package:time` for readable duration creation and waiting, such as `1.seconds`, `100.milliseconds`, and `duration.delay`.
- Use a focused extension when package helpers cannot preserve required precision or semantics.
- Prefer `class const Name()` primary constructors for const metadata types when supported by the project toolchain.

## Mapping and data access

- Put transport-to-application conversion in mapper files; prefer descriptive `toXyz()` extensions for self-contained conversions.
- Keep connectors focused on orchestration; put self-contained eligibility and transport-value conversion on the relevant application model or mapper extension.
- Keep gateways limited to remote-service models and transport behavior; put product policy, staging, retries, selection, and application-model mapping in callers or domain layers.
- Gateway operations must express provider-specific capability through inputs or results; move generic-input operations, such as arbitrary-URI handling, to provider-neutral layers.
- Define interfaces from consumers' minimal needs; expose provider names, protocol models, or transport types only when genuinely required.
- Treat malformed gateway inputs as invalid input to that gateway; reserve invalid-response errors for remote-service data.
- Define extensions on non-null receivers; handle nullable values explicitly at call sites.
- Move self-contained parameter logic into a natural extension; inline one-line helpers that provide no useful abstraction.
- Name maps by their key, for example `itemsById`.
- Stores retain resolved values, not completed futures; track only concurrent work in a separate `InFlight`-suffixed member.
- Coalesce concurrent loads through the in-flight future, clear it when settled, and propagate errors so later calls can retry.
- Do not broadly catch errors as missing data; catch only for required cleanup, then rethrow.
- Throw typed feature domain/state errors from orchestration; do not use generic argument errors for invalid external or current-state conditions.
- Keep equivalent client operations consistent in request encoding, headers, and error handling; add HTTP-status translation or protocol metadata only when endpoint-specific.
- Keep feature-specific guards at feature boundaries; do not alter shared action-helper behavior, including concurrency semantics, without a shared requirement.
- Give transport-client methods typed inputs; do not expose raw `Map<String, dynamic>` payloads publicly.
- Match existing feature-action APIs: succeed with `Future<void>`, throw typed feature errors for expected domain/state failures, propagate infrastructure failures, and do not add outcome enums duplicating those semantics.
- Define typed request inputs for action arguments; prefer bodies to query parameters for structured input, and use a finite input discriminator for closely related route variants instead of duplicating routes or input types.

## State management and UI

- A sealed state's base type may expose only values valid for every variant; model differing capabilities in the hierarchy instead of using getters that throw.
- Give states value equality; every `Equatable.props` value, including nested models and collection elements, must have stable value equality.
- When every state needs an initial snapshot, provide it at construction; load asynchronously from the owning lifecycle, not cubit creation.
- Keep displayed feature data in feature state; avoid drilling parallel snapshots through descendants that can select feature state.
- Keep asynchronous action progress and recoverable failure in state; widgets must not catch cubit action failures or duplicate action flags.
- For actions sharing a finite lifecycle, use an action-to-status map with one status per action instead of separate pending and failure collections; omitted entries are neutral.
- A sealed state base may provide a finite status valid for every variant; data-bearing variants override it with resolved status so widgets need not extract subtypes.
- Put capabilities derived from emitted state, such as retryability after failure, on the applicable variant; widgets consume them, while cubits expose commands rather than accepting state solely to answer them.
- When actions can race a state stream, retain the initiating snapshot revision and discard completions after a newer snapshot arrives; never overwrite current state with stale completion.
- Model transient UI effects separately from persistent state with typed events; widgets consume them at their UI boundary rather than deriving effects from transitions.
- For a modal route requiring an existing bloc, re-expose it with `BlocProvider.value`; do not create feature cubits solely for access in a new route context.
- Extract a self-contained sheet or substantial state branch into a meaningful widget that owns local UI state and resolves context dependencies instead of receiving forwarded callbacks or blocs.
- Use modal-route constraints for sheet bounds and `SafeArea` for system insets; do not manually recompute viewport height or safe-area padding unless required interaction behavior cannot use them.
- Use `context.select` for narrow dependencies and `context.watch` for complete state; do not add builders solely to read bloc state.
- Resolve `context.select`, `context.watch`, and `context.read` before constructing widget subtrees; do not nest them in constructor arguments, and extract meaningful state branches when that keeps dependencies with presentation.

## Dart style

- Use dot shorthand when the receiver type is inferred, including `.infinity` and `.all`; spell out unnamed constructors rather than using `.new(...)`.
- When dot shorthand lacks an inferred receiver, restructure to establish context rather than adding an explicit local type solely for shorthand.
- In primary constructors, use `final` field parameters only when values are used after construction; keep values used only for initialization as ordinary parameters.
- When expected error types share handling, catch untyped errors, narrow with `if (error case ...)`, and rethrow unexpected errors.
- Retry only explicitly classified transient failures; immediately preserve invalid-data and unexpected failures, and distinguish final-attempt translation from non-final retry behavior.
- Express construction-time invariants with constructor assertions; reserve typed runtime errors for failures during operations.
- Prefer `if-case` over `switch` when one pattern is handled and all others propagate.
- Keep collections readable: resolve meaningful setup before long collections or loops, but do not extract trivial pure expressions merely to shorten them.
- Separate self-contained phases of long methods with blank lines; extract helpers only for meaningful operations, not parameter forwarding.
- Let scope helpers create and clean up temporary resources before passing them to callbacks; keep resource operations at callers when that clarifies sequence.
- Keep consecutive important asynchronous effects explicit at call sites; do not hide persistence inside a fetching helper.
- Keep serialization models with related package models, prefer generated serializers, and preserve serialized names unless intentionally changing the schema.
- In `build` methods, group resolved locals and separate them from the returned widget tree with a blank line.
- Define const constructors only for widgets; do not require const call sites for ordinary models, but use const where language or framework semantics require it, such as annotation metadata.
- Resolve non-simple constructor arguments before construction; keep final property assignments simple, including asynchronous values and method calls.
- Order model members as declared properties, adjacent `fromJson`/`toJson` APIs, then equality or derived members such as `props`.
- Use `=>` only for simple redirections or one straightforward condition; use blocks for compound logic.
- Use braces for `if` control flows.
- Non-empty Dart `switch` cases end automatically; use `break` only for intentional no-op cases.
- Prefer pattern matching and guards when clearer than chained conditions for nullable, validated values.
- Avoid unsafe `!`; bind and promote nullable values with locals or patterns.
- Avoid `as`; bind and promote narrowed values with locals or patterns.
- Do not create private pass-through methods; extract private methods only for meaningful shared logic, and keep equivalent duplication in that shared method.
- Action helpers may cover only genuinely uniform flows; keep distinct semantics local and require callers to provide every emitted state value rather than hiding transition defaults.
- Do not nest non-trivial transformations in other calls; keep transformations visible while reusing established helpers for shared behavior such as filtering or deduplication.
- Use typedefs for long callback signatures; use positional callback parameters unless the contract requires named parameters.
- Do not create separate types solely for identical shape and behavior; keep distinct domain concepts separate even when their current fields match.
- Order class members with public declarations first, then private members in natural call order, with called members after callers; put private top-level declarations below public ones.
- Remove unused public APIs rather than retaining speculative entry points.
- Put localized enum display values in named shared presentation extensions, not widget-local extensions.
- Keep comments concise, wrap at 100 characters, and separate sentences with periods rather than semicolons.
- Do not add `// ignore` directives; make unambiguous fixes or ask when intent is unclear.
- Name related typed errors as a consistent family with the same concise prefix or suffix.

## Tooling and verification

- Use language features only when compiler, analyzer, and generators support them; do not retain experimental flags as compatibility workarounds.
- In Pub workspaces, treat per-package resolution overrides as exceptional because dependency resolution is shared; verify their effect on root workspace commands.
- Run the relevant formatter and analyzer after changes; never manually format generated Dart.
- Treat generated Dart as read-only: change sources and regenerate through the project-supported generator; never hand-edit generated output for source API changes.
- Do not add or run tests unless requested.
- Hot reload an active Flutter app after code or UI changes when available.
