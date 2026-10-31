---
name: runelite-plugin-dev
description: Use when creating, scaffolding, writing, reviewing, or submitting a RuneLite plugin (Plugin Hub / external plugin) or contributing to the RuneLite core client. Covers project scaffolding from the official template, code conventions, API usage, forbidden/restricted APIs, Jagex game-rule constraints, testing, and Plugin Hub submission.
---

# RuneLite Plugin Development

Distilled from the RuneLite wiki (Developer Guide, Code Conventions, Plugin Hub Review, Rejected or Rolled Back
Features, Logging, Dev Tools, Jagex Accounts), the `runelite/plugin-hub` README, `runelite/example-plugin` and
`runelite/plugin-hub-tooling`. Read `references/rules.md` before designing any feature: game-rule violations get a
plugin rejected no matter how good the code is.

## Hub plugin vs core client

- **Plugin Hub** (default): own public GitHub repo, built from the example-plugin template, submitted via a
  one-file PR to `runelite/plugin-hub`. Most development happens here.
- **Core client** (`runelite/runelite`): bug fixes and small features only. For new features, discuss in
  `#development` on Discord first. Branch off master (`lowercase-with-dashes`), PR title like `plugin: fix x`.

## Scaffolding a new hub plugin

Prefer the official generator, it produces exactly the template the hub expects:

```bash
git clone --depth 1 https://github.com/runelite/plugin-hub-tooling.git /tmp/plugin-hub-tooling
python3 /tmp/plugin-hub-tooling/create_new_plugin.py --noninteractive \
  --output_directory <dir> --name "My Plugin" --package com.myplugin \
  --author "<author>" --description "<one line>"
```

Then:
- `chmod +x gradlew`: the generator does not preserve the executable bit.
- Gradle 8.10 (template wrapper) cannot run on very new JDKs. On this machine run builds with
  `mise x java@temurin-11 -- ./gradlew test` (Temurin 11 is what RuneLite recommends).
- Add a `LICENSE` (BSD 2-Clause) at repo root. The hub packager fails without it.
- Fill `runelite-plugin.properties`: `displayName`, `author`, `description`, `tags`, `plugins`, `build=standard`.
  `version` optional. Packager rejects template values (`Example`, `Nobody`, `An example greeter plugin`).
- Never leave `com.example`/`Example*`/`example` config group. Never use `net.runelite` as package.
- Optional `icon.png` at repo root: max 48x72 px, max 256 KiB, real PNG.
- `build=standard` means hub replaces `build.gradle`/`settings.gradle`, so keep them matching the template.
  Only use `build=gradle` if you need third-party deps (avoid: needs hash verification and slows review).
- Do not include `META-INF/services/net.runelite.client.plugins.Plugin`. Do not commit build output.
- Java 11 only (`options.release.set(11)`), Java language only (no Kotlin/Scala).
- `runeLiteVersion = 'latest.release'` in `build.gradle`.

## Project layout

```
build.gradle, settings.gradle, runelite-plugin.properties, LICENSE, README.md, icon.png
src/main/java/<pkg>/<Name>Plugin.java      @PluginDescriptor, @Subscribe handlers, @Provides config
src/main/java/<pkg>/<Name>Config.java      @ConfigGroup("specific-name") interface extends Config
src/main/resources/<pkg>/...               load with getResourceAsStream, never getResource/File
src/test/java/<pkg>/<Name>PluginTest.java  main(): ExternalPluginManager.loadBuiltin(...); RuneLite.main(args)
src/test/resources/logback-test.xml        test-only logging config
```

## Architecture building blocks

- **Plugin class**: extends `Plugin`, `@PluginDescriptor(name, description, tags)`. Register everything in
  `startUp()`, undo all of it in `shutDown()` (overlays, panels/nav buttons, key listeners, scheduled tasks).
- **Event subscribers**: `@Subscribe public void onXxx(XxxEvent e)` in the plugin class (or a class registered on
  the `EventBus`). Events: `net.runelite.api.events.*` and `net.runelite.client.events.*`.
- **Config**: `@ConfigItem(keyName, name, description)` default methods; `@ConfigSection` for grouping. Provide via
  `@Provides MyConfig provideConfig(ConfigManager cm) { return cm.getConfig(MyConfig.class); }`. Programmatic
  persisted data: `configManager.setRSProfileConfiguration(group, key, value)` (per account) or `setConfiguration`.
- **Overlays**: extend `Overlay` / `OverlayPanel` / `WidgetItemOverlay`, add/remove via `OverlayManager`.
  `render()` runs every frame: keep it cheap.
- **Side panels**: extend `PluginPanel` (Swing), add with `ClientToolbar` + `NavigationButton`. Swing work on the
  EDT (`SwingUtilities.invokeLater`); client access on the client thread (`clientThread.invoke`/`invokeLater`).
- Learn API usage from core plugins in `runelite-client/src/main/java/net/runelite/client/plugins/` (agility,
  woodcutting, implings are simple), not from hub plugins. Javadoc: static.runelite.net/runelite-api/apidocs.

## Coding rules

- **Style**: tabs, braces on next line (Allman), BSD copyright header on every new file, imports in one block
  without wildcards, single blank line between logical blocks, extra tab inside multi-line annotations.
- **Gamevals**: use `net.runelite.api.gameval.*` (`ItemID`, `InterfaceID`, `InventoryID`, `VarbitID`, ...).
  No magic numbers. Widgets: `client.getWidget(InterfaceID.Foo.BAR)`, never combine group/child manually.
  `WidgetInfo`/`WidgetID` are disallowed.
- **Threading**: never `Thread.sleep`/`Thread.interrupt`; never block in `startUp`/`shutDown`; no blocking IO on
  the client thread; cancel `ScheduledFuture`s on shutdown.
- **HTTP/JSON**: `@Inject OkHttpClient` and `@Inject Gson` (use `.newBuilder()` to customise). Never construct
  your own; never `HttpURLConnection`/`java.net.http`. Use `enqueue()`, hop back with `clientThread.invoke()`.
  Do not add runelite-client transitive deps (gson, guice, okhttp) to `build.gradle`.
- **Files**: no `java.io` file APIs; use `net.runelite.client.util.Filepath` (requires `internalName` on
  `@PluginDescriptor`), `Filepath.Chooser` instead of `JFileChooser`.
- **Links**: `LinkBrowser.browse` only (not `Desktop.*`, not `LinkBrowser.open`).
- **Performance**: track state via spawn/despawn and change events, never scan the scene each tick.
- **Config**: specific group names (`"shop-hopper"`, not `"shop"`); never rename keys/groups without migration;
  third-party server features opt-in with the standard IP-address `warning`.
- **Deprecated APIs**: the hub packager rejects terminally deprecated APIs. Check with an init script adding
  `-Xlint:deprecation` to `JavaCompile` (e.g. `client.createMenuEntry` is deprecated, use
  `client.getMenu().createMenuEntry`).
- **Menu entries**: only client-side ones (`MenuAction.RUNELITE` with `onClick`), added in `onMenuOpened`
  like core's InventoryTagsPlugin. Never entries that send actions to the server.
- **Logging**: Lombok `@Slf4j`; `log.debug` for diagnostics, `log.info` only for rare events.
- Commits: present-tense imperative ("add x", not "added x"). Do not mix reformatting with feature changes.

## Running and testing

- `./gradlew run` launches the dev client with `--developer-mode --debug` and `-ea` (dev tools in sidebar:
  var inspector, widget inspector, inventory inspector are the main research tools).
- Jagex accounts: run the RuneLite launcher with `--configure`, add client argument
  `--insecure-write-credentials`, launch once via Jagex launcher; the dev client then logs in using
  `~/.runelite/credentials.properties`. Never share that file; delete it when done.
- Unit-test pure logic with JUnit 4 (template ships `junit:4.12`); Mockito/Guice testing via BoundFieldModule
  as core does if needed.
- **Never** drive the game client yourself (screen capture, computer use, input injection). Only the user can test
  in game. After a change: offer `./gradlew run`, tell the user exactly what to test (golden path and edge cases),
  and wait for their confirmation before calling it done.

## Submitting to the Plugin Hub

1. Push the plugin repo (public, HTTPS GitHub URL).
2. Fork `runelite/plugin-hub`, branch, add `plugins/<plugin-name>`:
   ```
   repository=https://github.com/<user>/<repo>.git
   commit=<full 40-char sha>
   ```
   (`warning=` line required if the plugin talks to third-party servers.)
3. Open PR, short description, append `Generated-by: Claude Code` footer if AI-assisted. Fix CI failures and
   "Changes are needed" checks by pushing new commits and updating `commit=` in the same PR.
4. Updates: new PR bumping `commit=` from a branch off `upstream/master`.
5. Review covers security and rule compliance only. Plugins hard to verify as rule-compliant are not merged.
   Restricted APIs (see rules) force manual review.
