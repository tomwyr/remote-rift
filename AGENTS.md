# Dart and Flutter working agreements

## Model boundaries

- Keep transport models faithful to the remote protocol. Preserve wire names, shapes, and raw
  domain terminology at that boundary.
- Put product-facing naming, normalization, and derived state in application models and mappers.
- Use enums for finite protocol values. Configure JSON enum casing with `@JsonEnum(fieldRename:)`.
  Do not add redundant `@JsonValue` annotations or `alwaysCreate` options.
- Let generated serializers decode and encode protocol enums. Do not hand-map JSON strings to enum
  values or serialize enum names manually.
- Make fields required unless their absence is meaningful and expected. Nullable fields should model
  genuinely unknown or unavailable data.
- Do not use a nullable successful result to represent an invalid current state. Return a value or
  throw the feature's typed state error.
- Model mutually exclusive product states as sealed types when each variant carries different valid
  data. Preserve meaningful protocol states during mapping instead of collapsing them into `null`.
- Prefer full, domain-neutral names over abbreviations. Do not couple reusable value types to a
  particular flow merely because that is their first use.

## Serialization and time

- Expose elapsed or remaining time as `Duration`, not numeric milliseconds or seconds.
- Define JSON converters in dedicated converter files. Keep wire units explicit and verify both
  serialization directions before changing a time type.
- Prefer `json_serializable` for model serialization. Use a custom converter only when the model's
  generated `fromJson` and `toJson` APIs cannot express the required boundary.
- Do not suppress generated serialization APIs unless omission is required for correct behavior.
- When decoding a sealed JSON type, switch directly on its discriminator string and delegate the
  selected variant to its generated `fromJson` factory.
- Use `package:time` for readable duration creation and waiting, such as `1.seconds`,
  `100.milliseconds`, and `duration.delay`.
- Use a focused extension when package helpers do not preserve the required precision or semantics.
- Prefer `class const Name()` primary constructors when a const metadata type needs one and the
  project toolchain supports primary constructors.

## Mapping and data access

- Put transport-to-application conversion in mapper files. Prefer extensions with descriptive
  `toXyz()` names for self-contained conversions.
- Keep connectors focused on orchestration. Put self-contained eligibility rules and transport value
  conversion on the relevant application model or mapper extension.
- Keep transport gateways limited to the remote service's models and transport behavior. Put product
  policy, staging, retries, selection, and mapping to application models in the caller or a
  domain-specific layer.
- A gateway operation must express a provider-specific capability through its inputs or results. Move
  operations that accept only generic inputs, such as an arbitrary URI, to a provider-neutral layer.
- Define interfaces from the consumer's minimal need. Do not expose a provider name, protocol model,
  or transport type unless the consumer genuinely needs that information.
- Treat a malformed value supplied to a gateway as invalid input to that gateway; reserve invalid
  response errors for data received from the remote service.
- Define extensions on non-null receiver types. Make nullable handling explicit at call sites.
- Move self-contained parameter logic into an extension when it reads naturally there. Inline
  one-line helpers that do not create a useful abstraction.
- Name maps by their key, for example `itemsById`.
- Stores should retain resolved values, not completed futures. Track only concurrent work in a
  separate member suffixed `InFlight`.
- Coalesce concurrent loads through the in-flight future. Clear it when the work settles, and let
  errors propagate so later calls can retry.
- Do not broadly catch errors and turn them into missing data. Catch only to perform necessary
  cleanup, then rethrow.
- Throw the feature's typed domain/state errors from orchestration layers. Do not use generic
  argument errors to represent invalid external or current-state conditions.
- Keep equivalent client operations consistent in request encoding, headers, and error handling.
  Do not add per-method HTTP-status translation or protocol metadata unless the endpoint needs it.
- Keep feature-specific guards at the feature boundary. Do not silently change shared action-helper
  behavior, including concurrency semantics, without a shared requirement.
- Give transport client methods typed inputs. Do not expose raw `Map<String, dynamic>` payloads in
  their public APIs.
- Keep action APIs consistent with existing feature actions: complete a `Future<void>` on success,
  throw typed feature errors for expected domain or state failures, and let infrastructure failures
  propagate. Do not introduce outcome enums that duplicate completion and error semantics.
- Define typed request inputs for action arguments. Prefer request bodies over query parameters for
  structured action input. When one route supports closely related variants, model the variant with
  a finite discriminator in its input rather than duplicating routes or input types.

## State management and UI

- A sealed state's base type may expose only values valid for every variant. Do not hide an invalid
  variant behind a getter that throws; model the differing capability in the state hierarchy instead.
- Give state types value equality. Every value included in `Equatable.props` must also have stable
  value equality, including nested models and collection elements.
- When every state requires an initial snapshot, provide it when constructing the state object. Run
  asynchronous loading from the owning component's lifecycle, not as a cubit-creation side effect.
- Keep a feature's displayed data in its feature state. Avoid property-drilling a parallel snapshot
  through descendants that can instead select it from the feature's state object.
- Keep asynchronous action progress and recoverable failure in state. Do not make widgets catch
  cubit action failures or maintain duplicate action flags.
- When several actions share the same finite lifecycle, model their state as an action-to-status map
  with one status per action, rather than coordinating separate pending and failure collections.
  Let omitted entries represent the neutral status.
- A sealed state base may provide a finite default status when that status is valid for every variant;
  data-bearing variants override it with their resolved status so widgets do not extract a subtype.
- Put a capability derived from an emitted state, such as whether a failed action remains retryable,
  on the applicable state variant. Widgets consume that state capability; cubits expose commands and
  do not take a state value solely to answer a question about it.
- When an asynchronous action can race a state stream, retain the initiating snapshot revision and
  discard its completion if a newer snapshot has arrived. Do not let stale completions overwrite
  current state.
- Model transient UI effects separately from persistent state with typed events. Widgets consume
  those events at their UI boundary rather than deriving effects from state transitions.
- When a modal route needs an existing bloc, re-expose that instance with `BlocProvider.value`.
  Child widgets must not create feature cubits solely to access them from a new route context.
- Extract a self-contained sheet or substantial state branch into a meaningful widget. Let that
  widget own its local UI state and resolve context-available dependencies rather than forwarding
  callbacks or blocs through constructor parameters.
- Prefer modal-route constraints for a sheet's intended bounds and `SafeArea` for system insets.
  Do not manually recompute available viewport height or safe-area padding in the sheet body unless
  the interaction needs behavior that those primitives cannot express.
- Prefer `context.select` for a narrow state dependency and `context.watch` when the complete
  state is needed. Do not add a builder wrapper solely to read bloc state.
- Resolve `context.select`, `context.watch`, and `context.read` calls before constructing a widget
  subtree. Do not nest them in widget constructor arguments; extract a meaningful state branch when
  that keeps its dependencies and presentation together.

## Dart style

- Use dot shorthand when the receiver type is inferred, including typed arguments such as
  `.infinity` and named constructors such as `.all`. For an unnamed constructor, spell out the
  type rather than using `.new(...)`.
- When dot shorthand lacks an inferred receiver type, restructure the expression to establish that
  context instead of introducing an explicit local type solely to enable shorthand.
- In a primary constructor, declare a `final` field parameter only when the value is used after
  construction. Keep values used solely to initialize other fields as ordinary constructor
  parameters.
- Catch untyped errors when several expected error types have the same handling, then narrow them
  with an `if (error case ...)`; rethrow unexpected errors.
- Retry only explicitly classified transient failures. Preserve invalid-data and unexpected failures
  immediately, and make final-attempt translation distinct from non-final retry behavior.
- Express construction-time programming invariants with constructor assertions. Reserve typed runtime
  errors for failures that can occur during the operation itself.
- Prefer `if-case` over a `switch` when error handling has one handled pattern and propagation is
  the only alternative.
- Keep collection declarations readable: resolve meaningful setup before a long collection or loop,
  but do not extract trivial pure expressions merely to shorten it.
- Add blank lines between self-contained phases of long methods. Extract a helper only when it owns
  a meaningful operation rather than forwarding parameters to another helper.
- Let a scope helper own temporary-resource creation and cleanup, then pass the prepared resource to
  its callback. Keep the operation using that resource at the caller when that makes its sequence
  easier to follow.
- Keep consecutive asynchronous effects explicit at the call site when both steps matter, such as
  fetching a value and then persisting it; do not hide the second operation inside the first helper.
- Keep serialization models with their related package models. Prefer generated serializers and
  preserve existing serialized names unless a schema change is intentional.
- In `build` methods, keep resolved local values together and separate them from the returned widget
  tree with a blank line.
- Define const constructors only for widgets. Do not require const call sites for ordinary models.
  Use const where the language or framework semantics require it, such as annotation metadata.
- Resolve non-simple constructor argument values before object construction. Keep the final property
  assignment simple. This includes asynchronous values and method calls.
- Keep a model's declared properties first, followed by adjacent `fromJson` and `toJson` APIs, then
  equality or derived-property members such as `props`.
- Use `=>` only for simple redirections or a single straightforward condition. Use a block body for
  compound logic.
- Use braces for `if` control flows.
- Dart switch statements end non-empty cases automatically. Use `break` only for an intentional
  no-op case; do not add it after a non-empty case.
- Prefer pattern matching and guards when they make nullable, validated values clearer than chained
  conditions.
- Avoid unsafe `!` unwraps. Bind and promote nullable values through a local variable or pattern
  before use.
- Avoid `as` casts. Bind and promote a narrowed value through a local variable or pattern instead.
- Do not create private pass-through methods. Extract a private method only when it owns meaningful
  shared logic; keep equivalent duplicated logic in that shared method.
- Action helpers may cover only genuinely uniform flows. Keep distinct action semantics local, and
  require callers to provide every emitted state value instead of hiding transition defaults in the
  helper.
- Do not nest non-trivial transformations inside other calls. Keep the meaningful transformation
  visible, while continuing to reuse established helpers for shared behavior such as filtering or
  deduplication.
- Use a typedef for a long callback signature. Callback types use positional parameters unless named
  parameters are required by the callback contract.
- Do not create separate types solely for identical shape and behavior. Conversely, keep distinct
  domain concepts separate even when their current fields coincide.
- Order class members with public declarations first. Put private members underneath in their
  natural call order, with a called member following the member that uses it. Put private top-level
  declarations below public ones.
- Remove unused public APIs instead of retaining speculative entry points.
- Put localized enum display values in named shared presentation extensions, rather than defining
  widget-local extensions.
- Keep comments concise, wrap them at 100 characters, and separate sentences with periods rather
  than semicolons.
- Do not add `// ignore` directives. Apply unambiguous fixes or ask when intent is unclear.
- Name related typed errors as a consistent family with the same concise prefix or suffix.

## Tooling and verification

- Use language features only when the compiler, analyzer, and code generators all support them.
  Do not add experimental flags as a permanent compatibility workaround.
- In Pub workspaces, remember that dependency resolution is shared. Treat per-package resolution
  overrides as exceptional and verify their effect on root workspace commands.
- Run the relevant formatter and analyzer after a change. Do not manually format generated Dart.
- Treat generated Dart as read-only: update its source and regenerate it through the project-supported
  generator. Do not hand-edit generated output to satisfy a source API change.
- Do not add or run tests unless requested.
- Hot reload an active Flutter app after code or UI changes when one is available.
