# CleanPaste

CleanPaste is a simple native macOS menu bar app for cleaning messy text copied from PDFs.

It reads the current clipboard text, fixes common PDF copy/paste formatting issues, and writes the cleaned text back to the clipboard.

## Features

- Lives in the macOS menu bar
- Does not open a main window on launch
- Cleans the current clipboard text
- Replaces the clipboard with the cleaned version
- Shows a small confirmation message: `Clipboard cleaned`

## Menu Items

- `Clean Clipboard`
- `Quit`

## Text Cleaning

CleanPaste applies these rules:

- Fixes words broken by PDF line breaks
- Joins broken lines into normal paragraphs
- Keeps paragraph breaks
- Removes extra spaces
- Fixes spaces before punctuation

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

## Project Structure

```text
CleanPaste/
  CleanPasteApp.swift
  MenuBarController.swift
  ClipboardManager.swift
  TextCleaner.swift
  Assets.xcassets/

CleanPaste.xcodeproj/
```

## Requirements

- macOS
- Xcode
- Swift / SwiftUI

## Run Locally

1. Open `CleanPaste.xcodeproj` in Xcode.
2. Select the `CleanPaste` scheme.
3. Press `Cmd + R` to run.
4. Look for the CleanPaste icon in the macOS menu bar.

The app will not open a normal window.

## Install As An App

After building in Xcode:

1. In Xcode, choose `Product` -> `Show Build Folder in Finder`.
2. Open `Products/Release` or `Products/Debug`.
3. Drag `CleanPaste.app` into `/Applications`.

After that, CleanPaste can be launched like a normal macOS app without opening Xcode.

## Create A DMG

To create a downloadable DMG for users who do not have Xcode:

```bash
./scripts/package_release.sh
```

The DMG will be created at:

```text
dist/CleanPaste-1.0.dmg
```

You can pass a different version name:

```bash
./scripts/package_release.sh 1.1
```

That creates:

```text
dist/CleanPaste-1.1.dmg
```

The DMG contains `CleanPaste.app` and an `Applications` shortcut, so users can drag the app into Applications.

Note: this creates a locally signed app. For a public release without macOS Gatekeeper warnings, the app should be signed with an Apple Developer ID certificate and notarized by Apple.

## Usage

1. Copy text from a PDF.
2. Click the CleanPaste icon in the macOS menu bar.
3. Click `Clean Clipboard`.
4. Paste the cleaned text wherever you need it.
