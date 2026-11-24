# League Client Simulator

Use the simulator to exercise Remote Rift Desktop and Mobile from lobby creation
through champion select and the end of a match. It serves the League Client API
operations Remote Rift uses over authenticated HTTPS on localhost.

## Connect Remote Rift

1. From the repository root, run `just simulator-run macos` or
   `just simulator-run windows` on the matching host.
2. In the simulator, select **Copy path**. In Remote Rift Desktop on the same
   computer, open **Settings → Lockfile location → Choose custom location** and
   select that file. Wait for Desktop to show **League client connected**.
3. On the same local network, open Remote Rift Mobile and select the Desktop
   instance as usual. Start by creating a **Normal Draft Pick** or **ARAM**
   lobby. Mobile sends commands through Desktop's existing Connector service.

The simulator rewrites the lockfile at the same location on startup. To use the
real client again, select **Reset to default** in Desktop's lockfile settings.

## Reproduce a scenario

| Scenario | How to drive it |
| --- | --- |
| Search and ready check | Start searching from Mobile. A match appears in six seconds, or use **Trigger ready check** in the simulator. Accept, decline, or let the 10-second window expire. |
| Another player declines | Enable **Another player declines** in the simulator, then accept the next ready check. Both apps return to the lobby. |
| Draft champion select | Choose Draft, set role preferences, and accept a match. Hover a champion, ban or choose no ban, lock in a pick, and change spells in Mobile. The simulator advances teammate and opponent turns. |
| ARAM and game completion | Accept an ARAM match to start with an assigned champion. Lock in or let the timer expire, then use **End game** in the simulator or wait for it to return to the lobby. |
| Client launch | Turn off **Client online** in the simulator while leaving its window open. Select **Open Riot Client** in Mobile to bring the simulated client back online. |

Use **Advance phase** to move through champion select without waiting and
**Reset session** to start over from Home. A Draft pick that times out without a
lock-in returns to the lobby. The simulator uses a small, offline champion and
spell catalog and represents the in-game state with a countdown.

## Update UI strings

Edit `lib/i18n/en.i18n.yaml`, then run `dart run slang` from this app's directory.
