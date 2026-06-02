# CleanPaste

CleanPaste is a small macOS menu bar app that cleans messy text copied from PDFs.

## Download

Download the DMG file from this repository:

[dist/CleanPaste-1.0.dmg](dist/CleanPaste-1.0.dmg)

Open the DMG, then drag `CleanPaste.app` into `Applications`.

After installing, launch CleanPaste from Applications, Spotlight, or Launchpad. It appears in the macOS menu bar.

## How To Use

1. Copy text from a PDF.
2. Click the CleanPaste icon in the menu bar.
3. Click `Clean Clipboard`.
4. Paste the cleaned text anywhere.

CleanPaste replaces your clipboard text with the cleaned version.

## What It Fixes

CleanPaste can:

- Join words split across PDF line breaks
- Join broken lines into normal paragraphs
- Keep real paragraph breaks
- Remove extra spaces
- Fix spaces before punctuation

Example:

```text
We'd be over-
whelmed with an avalanche of thoughts and emotions.
We'd have too
much data.
```

Becomes:

```text
We'd be overwhelmed with an avalanche of thoughts and emotions. We'd have too much data.
```

## For Developers

To build a new DMG:

```bash
./scripts/package_release.sh
```

The output will be:

```text
dist/CleanPaste-1.0.dmg
```

To build a different version name:

```bash
./scripts/package_release.sh 1.1
```

The app icon comes from `Icon.png`.

Note: this app is locally signed. For a fully public macOS release without Gatekeeper warnings, sign it with an Apple Developer ID certificate and notarize it with Apple.
