---
title: Changelog
layout: default
nav_order: 99
parent: Documentation
---

# Changelog

All notable changes to Dobermann are documented here.

## v0.0.50 — 2026-02-15

### Added
- **Template variable modifiers** — Validate and transform data with pipe syntax: `{{Name:string|3-50|upper}}`, `{{Qty:number|int|>0}}`, `{{Code:string|opt}}` for omitting empty keys, `{{Val:number|null}}` for null values
- **Modifier toolbar** — Visual toolbar for adding modifiers to template variables without memorizing syntax
- **`|asString` modifier** — Force any value to be treated as a string in JSON output
- **HTML response viewer** — Three view modes (Raw/Render/Text) for HTML responses in the RAW tab
- **Paste header confirmation modal** — Review and confirm pasted headers before they're applied
- **Rich copy from reports** — Copy transaction data as TSV, HTML, Markdown, or CSV
- **RAW tab improvements** — Enhanced JSON viewing with Monaco Editor integration

### Fixed
- Import compatibility for older export formats
- Nested array template processing edge cases
- File upload column mapping accuracy
- Marketplace presentation and metadata

## v0.0.49 — 2026-01-31

### Added
- **New template editor** — Monaco-based editor with syntax highlighting, autocomplete, and real-time error detection for template variables
- **ENV variables** — Reference environment-specific values with `{{ENV:varName}}` syntax
- **Sequence modifiers** — `:local`, `:global`, `:parent` modifiers for `A8:sequence` in nested arrays
- **Batch reprocessing** — Reprocess only failed transactions from a previous batch run
- **CSV auto-sort** — Automatic sorting for nested array templates
- **Run Batch tabs** — New tabbed interface: Enter Data, Upload File, Paste Text
- **Tab delimiter support** — Paste directly from Excel with tab-delimited data
- **Date math modifiers** — `+2d`, `-1d`, `+4h`, `+30m` for date/datetime variables

### Changed
- Rebranded from "Active8" to "Dobermann" across all UI

### Fixed
- Status-based classification for report tabs

## v0.0.48 — 2026-01-14

### Fixed
- Nested array batch execution transaction counts
- Run API not processing A8 system variables correctly
- Unified JSON generation refactor for consistency

## v0.0.47 — 2026-01-13

### Fixed
- Nested array grouping correction for complex templates

## v0.0.46 — 2026-01-12

### Added
- **A8 datetime format specifiers** — Custom format strings for `A8:datetime` and `A8:date` variables
- **Date/DateTime format modifiers** — Control output format of date columns: `{{COL:date:iso}}`, `{{COL:datetime:YYYY-MM-DD}}`

### Fixed
- Date variable UTC timezone handling
- JSON escaping for special characters in substituted values
