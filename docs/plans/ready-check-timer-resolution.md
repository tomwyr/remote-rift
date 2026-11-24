# Ready-check timer resolution

## Goal

Improve the ready-check countdown by refining the connector's elapsed-time
estimate while preserving the Mobile UI and wire fields.

## Approach

1. Keep the one-second session poll. When it first sees an in-progress ready
   check, seed the countdown from the reported elapsed time and start a
   separate background sampler for the ready-check endpoint.
2. Adapt the LCU response through `ReadyCheckTimer`. Its generic
   `TimerTickResolver` waits 50 milliseconds between initial samples and
   250 milliseconds once a one-second advancement resolves the boundary.
3. Estimate that transition at the midpoint between the two observations,
   then advance the estimate with the local stopwatch. A gap of more than
   one tick returns the sampler to 50-millisecond intervals until it resolves
   another boundary.
4. Derive a nonnegative remaining duration from the ten-second maximum.
   Publish it in subsequent `Found` states through the existing session
   stream, which encodes durations as fractional seconds. Mobile retains
   its local countdown behavior.
5. Stop the sampler when the ready check becomes inactive or the session poll
   leaves that gameflow phase. A temporary LCU read failure leaves the
   sampler able to resume on a later sample.

## Verification

- Inspect live session updates through one ready check. The initial estimate
  uses the reported elapsed time. Subsequent updates carry a refined
  fractional duration using the same `Found` fields.
- Verify that a new ready check starts fresh after the previous one ends and
  Mobile continues displaying its countdown from the stream.
