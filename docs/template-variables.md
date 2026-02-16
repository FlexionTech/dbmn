---
title: Template Variables
layout: default
nav_order: 7
parent: Documentation
---

# Template Variables

## Overview

Dobermann supports template variables across all API request components: request body, URL path, query parameters, and headers. This guide explains how to use template variables effectively with both single API execution and batch processing.

## Template Variable Syntax

### Basic Syntax
Template variables use double bracket notation: `{{VARIABLE_NAME}}`

### Shorthand Syntax (JSON Body Only)
In JSON request bodies, you can use shorthand `{{}}` syntax where the JSON key becomes the variable name:

```json
{
    "ItemId": "{{}}",           // Variable name inferred as "ItemId"
    "Quantity": "{{:number}}",  // Variable name "Quantity" with number type
    "IsActive": "{{:boolean}}"  // Variable name "IsActive" with boolean type
}
```

This is equivalent to:
```json
{
    "ItemId": "{{ItemId}}",
    "Quantity": "{{Quantity:number}}",
    "IsActive": "{{IsActive:boolean}}"
}
```

**When to use shorthand:**
- When your JSON key names match your CSV column names
- To reduce repetition in templates
- For cleaner, more readable templates

**Limitations:**
- Only works in JSON body templates (not URL, query params, or headers)
- The JSON key must be a valid variable name

### Type-Specific Syntax
For enhanced validation and data processing, you can specify data types:
- `{{VARIABLE_NAME:string}}` - Text values (default)
- `{{VARIABLE_NAME:number}}` - Numeric values (integers or decimals)
- `{{VARIABLE_NAME:boolean}}` - Boolean values (true/false)
- `{{VARIABLE_NAME:date}}` - Date values (outputs YYYYMMDD by default)
- `{{VARIABLE_NAME:datetime}}` - DateTime values (outputs local format by default)

### Date/DateTime Format Modifiers

Template variables with `:date` or `:datetime` types support format modifiers to control the output format. The syntax is `{{VARIABLE_NAME:type:format}}`.

**Date Type Formats:**

| Syntax | Output | Description |
|--------|--------|-------------|
| `{{COL:date}}` | `20240104` | Default - YYYYMMDD (no dashes) |
| `{{COL:date:iso}}` | `2024-01-04` | ISO format with dashes |
| `{{COL:date:DD-MM-YYYY}}` | `04-01-2024` | European format |
| `{{COL:date:MM-DD-YYYY}}` | `01-04-2024` | US format |
| `{{COL:date:YYYY/MM/DD}}` | `2024/01/04` | Custom format |

**DateTime Type Formats:**

| Syntax | Output | Description |
|--------|--------|-------------|
| `{{COL:datetime}}` | `2024-01-04T14:30:00` | Default - Local format (no ms, no Z) |
| `{{COL:datetime:iso}}` | `2024-01-04T14:30:00.000Z` | Full ISO 8601 |
| `{{COL:datetime:date}}` | `2024-01-04` | Date portion only |
| `{{COL:datetime:time}}` | `14:30:00` | Time portion only |
| `{{COL:datetime:HH:mm}}` | `14:30` | Custom time format |

**Example Template:**
```json
{
    "compactDate": "{{ORDER_DATE:date}}",
    "isoDate": "{{ORDER_DATE:date:iso}}",
    "euroDate": "{{ORDER_DATE:date:DD-MM-YYYY}}",
    "timestamp": "{{SHIP_TIME:datetime}}",
    "isoTimestamp": "{{SHIP_TIME:datetime:iso}}",
    "dateOnly": "{{SHIP_TIME:datetime:date}}",
    "timeOnly": "{{SHIP_TIME:datetime:time}}"
}
```

**Format Tokens:**

| Token | Output | Description |
|-------|--------|-------------|
| `YYYY` | 2024 | 4-digit year |
| `YY` | 24 | 2-digit year |
| `MM` | 01 | Month (01-12) |
| `DD` | 04 | Day (01-31) |
| `HH` | 14 | Hour 24h (00-23) |
| `hh` | 02 | Hour 12h (01-12) |
| `mm` | 30 | Minutes (00-59) |
| `ss` | 00 | Seconds (00-59) |

**Important Notes:**
- All datetime processing uses UTC timezone
- CSV dates without timezone info are parsed as local time, then converted to UTC
- Use `:date` modifier if you only need the date portion and want to avoid timezone shifts

### String and Number Modifiers

Template variables with `:string` or `:number` types support validation and transformation modifiers. These modifiers help ensure data quality by validating values against constraints and applying transformations before API execution.

**Syntax:** `{{VARIABLE_NAME:type|modifier1|modifier2|modifier3}}`

**Key Syntax Rule:**
- **Colon (`:`)** = FORMAT (dates only): `{{Date:date:iso}}`
- **Pipe (`|`)** = MODIFIER (all types): `{{Name:string|upper}}`

Modifiers are pipe-delimited (`|`) and can be chained together.

#### Empty Value Modifiers (All Types)

These modifiers control behavior when a value is empty or missing. They work with all data types (string, number, boolean, date, datetime).

| Modifier | Syntax | Example | Description |
|----------|--------|---------|-------------|
| Default | *(none)* | `{{Name:string}}` | Current behavior (string=`""`, number=`0`) |
| Optional | `opt` | `{{Code:string\|opt}}` | **Omit key entirely** if value is empty |
| Null | `null` | `{{Qty:number\|null}}` | **Pass null** if value is empty |

**With `opt` modifier - Omit key entirely:**
```json
// Template
{ "code": "{{Code:string|opt}}", "name": "{{Name:string}}" }

// If Code is empty:  { "name": "Test" }              <- key omitted
// If Code is "ABC":  { "code": "ABC", "name": "Test" }
```

**With `null` modifier - Pass null value:**
```json
// Template
{ "qty": "{{Qty:number|null}}", "name": "{{Name:string}}" }

// If Qty is empty:  { "qty": null, "name": "Test" }  <- null value
// If Qty is "5":    { "qty": 5, "name": "Test" }
```

#### String Modifiers

| Modifier | Syntax | Example | Description |
|----------|--------|---------|-------------|
| Trim | *(default)* | `{{Name:string}}` | Whitespace trimmed automatically |
| No trim | `noTrim` | `{{Code:string\|noTrim}}` | Keep leading/trailing spaces |
| Exact length | `n` | `{{Code:string\|3}}` | **Exactly** 3 characters |
| Min length | `n-` | `{{Name:string\|3-}}` | At least 3 characters |
| Max length | `-n` | `{{Code:string\|-10}}` | At most 10 characters |
| Range | `n-m` | `{{Desc:string\|5-100}}` | Between 5 and 100 characters |
| Uppercase | `upper` | `{{Code:string\|upper}}` | Convert to UPPERCASE |
| Lowercase | `lower` | `{{Email:string\|lower}}` | Convert to lowercase |

#### Number Modifiers

| Modifier | Syntax | Example | Description |
|----------|--------|---------|-------------|
| Greater than | `>n` | `{{Qty:number\|>0}}` | Must be greater than 0 |
| Greater/equal | `>=n` | `{{Stock:number\|>=0}}` | Must be 0 or more |
| Less than | `<n` | `{{Discount:number\|<100}}` | Must be less than 100 |
| Less/equal | `<=n` | `{{Pct:number\|<=100}}` | Must be 100 or less |
| Integer | `int` | `{{Count:number\|int}}` | Whole numbers only |
| Round | `rnd(n)` | `{{Price:number\|rnd(2)}}` | Round to 2 decimals |
| Floor | `floor` | `{{Qty:number\|floor}}` | Round down |
| Ceil | `ceil` | `{{Qty:number\|ceil}}` | Round up |

#### Date Math Modifiers

Works with both CSV date columns and A8 system variables:

| Modifier | Syntax | Example | Description |
|----------|--------|---------|-------------|
| Add days | `+nd` | `{{A8:datetime\|+2d}}` | Add 2 days |
| Subtract days | `-nd` | `{{ShipDate:date\|-1d}}` | Subtract 1 day |
| Add hours | `+nh` | `{{A8:datetime\|+4h}}` | Add 4 hours |
| Add minutes | `+nm` | `{{A8:datetime\|+30m}}` | Add 30 minutes |

#### Modifier Execution Order

When multiple modifiers are specified, they execute in this order:

1. **Pre-transform** - String transforms (trim, upper, lower)
2. **Type conversion** - Convert string to target type
3. **Post-transform** - Type-specific transforms (rnd, floor, ceil, date math)
4. **Validate** - Apply validation modifiers (length, comparisons, int)

#### Validation Behavior

Modifiers validate data **before** API execution:

- In **Run API** mode: Validation errors shown inline before execution
- In **Run Batch** mode: All rows validated after column mapping; execution blocked if any row fails

#### Real-World Template Example

```json
{
    "Data": [
        {
            "ItemId": "{{:string|5-50|upper}}",
            "ItemDescription": "{{Desc:string|-500}}",
            "StandardUOMCode": "{{UOM:string|2-10|upper}}",
            "Quantity": "{{Qty:number|int|>0}}",
            "ItemWeight": "{{Weight:number|>=0|rnd(3)|null}}",
            "ItemCost": "{{Cost:number|>=0|rnd(2)}}",
            "AlternateCode": "{{AltCode:string|10|opt}}",
            "TransactionDate": "{{A8:datetime}}",
            "ShipByDate": "{{A8:datetime:iso|+2d}}"
        }
    ]
}
```

## Using Template Variables in Different Locations

### 1. Request Body Templates (POST/PUT/PATCH)

```json
{
    "Data": [
        {
            "ItemId": "PREFIX-{{SKU:string}}",
            "Quantity": "{{PRICED_QTY:number}}",
            "IsActive": "{{ACTIVE_FLAG:boolean}}",
            "LoadDate": "{{LOAD_DATE:date}}"
        }
    ]
}
```

### 2. URL Path Templates

Template variables can be used directly in the URL path:

- `/api/orders/{{orderId}}/status`
- `/api/users/{{userId:number}}/profile`
- `/api/products/{{category:string}}/{{productId}}/details`

Values are automatically URL-encoded when replaced in paths.

### 3. Query Parameter Templates

Add template variables to query parameter values:

- Parameter: `itemId`, Value: `PREFIX-{{SKU}}`
- Parameter: `limit`, Value: `{{maxResults:number}}`
- Parameter: `includeActive`, Value: `{{isActive:boolean}}`

Query parameter values are automatically URL-encoded.

### 4. Header Templates

Use template variables in HTTP headers:

- Header: `Authorization`, Value: `Bearer {{authToken:string}}`
- Header: `X-User-ID`, Value: `{{userId:number}}`
- Header: `X-Request-ID`, Value: `REQ-{{requestId}}`

Header values are used as-is without URL encoding.

## Automatic Variables (A8)

Automatic variables (prefix `A8:` where A8 = **A**utomatic) are system-generated values computed at execution time.

**Key Behavior:**
- You will **NOT** be prompted for these during "Run API" parameter collection
- They do **NOT** appear in the "Enter Data" grid during "Run Batch"
- They **cannot** be mapped to CSV columns - values are generated automatically
- Use these for timestamps, sequence numbers, and other computed values

### Available Automatic Variables

| Variable | Output | Description |
|----------|--------|-------------|
| `{{A8:sequence}}` | `1001`, `1002`, ... | Sequential numbering |
| `{{A8:date}}` | `20260112` | Current date (YYYYMMDD) |
| `{{A8:datetime}}` | `2026-01-12T22:29:06` | Current timestamp (UTC, no milliseconds) |

### Datetime Format Options

The `A8:datetime` and `A8:date` variables support format specifiers:

**Named Presets:**

| Syntax | Output | Description |
|--------|--------|-------------|
| `{{A8:datetime}}` | `2026-01-12T22:29:06` | Default - UTC without ms/Z |
| `{{A8:datetime:iso}}` | `2026-01-12T22:29:06.729Z` | Full ISO 8601 with milliseconds |
| `{{A8:datetime:date}}` | `2026-01-12` | Date only with dashes |
| `{{A8:datetime:time}}` | `22:29:06` | Time only |
| `{{A8:date}}` | `20260112` | Default - YYYYMMDD |
| `{{A8:date:iso}}` | `2026-01-12` | Date with dashes |

### Sequence Modifiers for Nested Arrays

When working with nested arrays, the `A8:sequence` variable supports modifiers to control sequencing behavior:

| Modifier | Syntax | Behavior |
|----------|--------|----------|
| Default | `{{A8:sequence}}` | Same value per request |
| `:local` | `{{A8:sequence:local}}` | Unique within array, resets each array |
| `:global` | `{{A8:sequence:global}}` | Unique per item, persisted per array path |
| `:parent` | `{{A8:sequence:parent}}` | Reuse parent element's sequence |

**Example - Order Lines:**
```json
{
  "OriginalOrderId": "ORDER-{{A8:sequence}}",
  "OriginalOrderLine": [
    {
      "OriginalOrderLineId": "{{A8:sequence:local}}",
      "ParentOrderRef": "{{A8:sequence:parent}}"
    }
  ]
}
```

## Template Editor Experience

### Syntax Highlighting

Template variables are color-coded based on their type:

| Variable Type | Color | Example |
|--------------|-------|---------|
| Automatic Variables (A8) | Green | `{{A8:sequence}}`, `{{A8:date}}` |
| Environment Variables (ENV) | Green | `{{ENV:host}}`, `{{ENV:org}}` |
| User Variables | Cyan/Blue | `{{orderId}}`, `{{quantity:number}}` |
| Type Modifiers | Purple | `:string`, `:number`, `:date` |
| Format Specifiers | Orange | `:iso`, `:YYYY-MM-DD` |
| Invalid/Errors | Red underline | `{{A8:invalid}}`, `{{var:badtype}}` |

### Autocomplete

The editor provides intelligent autocomplete suggestions:

1. **Type `{{`** - Shows `A8:` suggestion to start an Automatic variable
2. **Type `{{A8:`** - Shows available Automatic variables: `sequence`, `date`, `datetime`
3. **Type `{{varName:`** - Shows type modifiers: `string`, `number`, `boolean`, `date`, `datetime`
4. **Type `{{varName:date:`** - Shows format options: `iso`, `YYYY-MM-DD`, etc.

### Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl+M` / `Cmd+M` | Cycle line variable (Value -> Input -> ENV -> A8 -> restore) |
| `Ctrl+Z` / `Cmd+Z` | Undo last change |
| `Ctrl+/` / `Cmd+/` | Toggle line comment |
| `Ctrl+S` / `Cmd+S` | Save endpoint |

## CSV Batch Processing

### Enhanced Column Mapping

The CSV upload modal shows comprehensive variable information:

- **Variable Name:** The template variable name
- **Type:** Data type (with color-coded pills)
- **Sources:** Where the variable is used (URL, Query Param, Header, Body)
- **CSV Column:** Dropdown to select source column
- **Sample Value:** Preview of how the value will appear

## Data Type Validation

### Supported Data Types

**String (default):** Any text value, used as-is.

**Number:** Integers (`123`, `-45`), decimals (`123.45`), scientific notation (`1.5e-4`).

**Boolean:** True values: `true`, `yes`, `y`, `1`, `on`. False values: `false`, `no`, `n`, `0`, `off` (all case-insensitive).

**Date:** ISO format (`2023-12-25`), US format (`12/25/2023`), European format (`25/12/2023`).

## Encoding Behavior

| Location | Encoding |
|----------|----------|
| URL Path | Automatically URL-encoded |
| Query Parameters | Automatically URL-encoded |
| Headers | Used as-is (no encoding) |
| Body | Used as-is (no encoding) |

## Best Practices

- Use descriptive variable names: `{{orderId}}` instead of `{{id}}`
- Always specify types for validation: `{{qty:number}}`
- Use `string` type explicitly for clarity
- Document your variable usage in endpoint descriptions
- Test with single execution before batch processing

## Related Topics

- [Getting Started](getting-started) - Installation and first steps
- [Endpoints](endpoints) - Endpoint configuration
- [Batch Preparation](batch-preparation) - CSV upload and column mapping
- [Execution](execution) - Running individual and batch requests
- [Shortcuts](shortcuts) - Keyboard shortcuts including template editor shortcuts
