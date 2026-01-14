# Repository Guidelines

## Project Structure & Module Organization
- `MosaicGrid/Classes/` contains the library source, organized by feature area: `Implementation/`, `Layout/`, `Model/`, `Engine/`, and `Extensions/`.
- `Example/` hosts the sample app and CocoaPods setup, including `Example/MosaicGrid` for app code and `Example/Tests` for unit tests.
- Root files like `Package.swift` and `MosaicGrid.podspec` define SwiftPM and CocoaPods distribution metadata.
- Image assets in the repo root (e.g., `MosaicGridDemo.gif`) are used for documentation.

## Build, Test, and Development Commands
- `cd Example && pod install`: install CocoaPods dependencies for the sample app.
- Open `Example/MosaicGrid.xcworkspace` in Xcode: build and run the example app.
- In Xcode, run tests with the `MosaicGrid-Example` scheme (uses XCTest from `Example/Tests`).

## Coding Style & Naming Conventions
- Swift code uses 4-space indentation and standard Swift formatting conventions.
- Types and protocols: `UpperCamelCase` (e.g., `MosaicGridLayout`).
- Methods, properties, and local variables: `lowerCamelCase` (e.g., `usingGrids`, `gridAspectRatio`).
- Keep files grouped by responsibility under `MosaicGrid/Classes/...` and match type names to filenames.

## Testing Guidelines
- Tests live under `Example/Tests` and are written with XCTest.
- Name test files after the subject under test (e.g., `MosaicSizedGridLayoutTests.swift`).
- Add or update tests when changing layout logic or grid sizing behavior.

## Commit & Pull Request Guidelines
- Commit messages are short, imperative, and scoped (e.g., "Add flow mosaic alignment", "Update README.md").
- If applicable, include issue/PR references in parentheses (e.g., "Release 1.2.0 (#7)").
- PRs should target `main`, include a clear description, and update docs/tests when behavior changes.

## Security & Configuration Tips
- Avoid committing local Xcode user data or derived artifacts.
- Update both `Package.swift` and `MosaicGrid.podspec` when changing public API or versioning.

## Architecture Overview
- `VMosaicGrid` and `HMosaicGrid` are the primary SwiftUI entry points in `MosaicGrid/Classes/Implementation/`.
- Layout strategy lives in `MosaicGrid/Classes/Layout/`, while `MosaicGrid/Classes/Engine/` contains grid/flow calculation utilities.
- Data models in `MosaicGrid/Classes/Model/` define sizing, spacing, coordinates, and alignment used across the layouts.
