---
title: Batch Preparation
layout: default
nav_order: 4
parent: Documentation
---

# Batch Preparation

Batch execution allows you to run the same API endpoint multiple times with different data from a CSV file. This is essential for bulk operations like creating multiple items, updating locations, or processing large datasets.

## Overview

Batch preparation involves:
- **CSV file selection** - Choose data source
- **Column mapping** - Map CSV columns to template variables
- **Configuration** - Set batch parameters and error tolerance
- **Validation** - Verify mapping and data before execution

## Loading CSV Data

### Selecting a CSV File

**Method 1: File Browser**
1. Click **Load CSV File** button in endpoint webview
2. Navigate to your CSV file
3. Click **Open**

**Method 2: Drag & Drop**
1. Drag CSV file from file explorer
2. Drop onto the CSV upload area
3. File loads automatically

**Supported formats:**
- `.csv` - Comma-separated values
- `.txt` - Tab or comma-separated
- Character encoding: UTF-8 (recommended), ASCII

### Manual Data Entry (Grid)

For quick data entry without creating a CSV file, use the built-in data entry grid:

1. Click **Run Batch** on an endpoint with template variables
2. Select the **Manual Entry** tab
3. Enter data directly into the grid
4. Use keyboard shortcuts for fast entry (see below)

**Grid Keyboard Shortcuts:**

| Shortcut | Action |
|----------|--------|
| `Tab` | Move to next cell. From last cell, adds a new row |
| `Shift+Tab` | Move to previous cell |
| `Enter` | Move down to same column in next row |
| `Ctrl+D` | Copy value from cell above (fill-down) |
| `Escape` | Clear current cell |

**Progressive Tab Copy (Nested Templates):**

For templates with nested structures, the grid supports progressive copy:
1. Fill first row completely
2. Tab from last cell - adds new row
3. Tab again (without typing) - copies root-level values
4. Tab again - copies next level values
5. Type to cancel and enter unique values

A hint appears to guide you through the progressive copy levels.

See [Keyboard Shortcuts](shortcuts#grid-data-entry-shortcuts) for detailed information.

### CSV Requirements

**Header row:**
- First row must contain column names
- Column names should match template variables (or be mapped manually)
- Avoid special characters in column names

**Data formatting:**
- Consistent delimiter (comma, tab, semicolon)
- Quote text fields containing delimiters
- One record per row
- Empty cells are treated as empty strings

**Example CSV:**
```csv
sku,description,quantity,warehouse
PRE-ITEM-001,Widget Alpha,100,DC01
PRE-ITEM-002,Widget Beta,250,DC02
PRE-ITEM-003,Widget Gamma,75,DC01
```

### File Preview

After loading, Dobermann displays:
- **Row count** - Total data rows (excludes header)
- **Column list** - All column names detected
- **Preview table** - First 5 rows of data

**Review checklist:**
- Correct number of columns
- Data appears in correct columns
- No missing delimiters
- Special characters display properly

## Column Mapping

Map CSV columns to template variables in your endpoint configuration.

### Automatic Mapping

Dobermann automatically maps columns when:
- Column name exactly matches a template variable
- Example: CSV column `sku` maps to template variable `{{sku}}`

**Case sensitivity:**
- Mapping is case-insensitive
- `SKU`, `sku`, `Sku` all map to `{{sku}}`

### Manual Mapping

For columns that don't auto-map:

1. Find unmapped variable in the mapping interface
2. Click the dropdown next to the variable name
3. Select the corresponding CSV column
4. Mapping is saved automatically

**Example:**
```
Template Variable    | CSV Column
---------------------|-------------
{{item_id}}         | sku
{{item_desc}}       | description
{{qty}}             | quantity
{{location}}        | warehouse
```

### Mapping Validation

Dobermann validates your mapping:

**Valid:**
- All required variables are mapped
- No duplicate mappings
- Column names exist in CSV

**Invalid:**
- Required variable unmapped (red indicator)
- Multiple variables map to same column (warning)
- Mapped column doesn't exist in CSV (error)

### Source Format Configuration

The **Source Format** column in the mapping table lets you specify how CSV values should be interpreted before conversion.

**Number Formats:**

| Format | Example Input | Description |
|--------|---------------|-------------|
| Standard | `1234.56` | Regular decimal numbers |
| COBOL | `+000000099.9900` | COBOL packed decimal with sign |
| Scientific | `1.23E+04` | Scientific notation |
| Currency | `$1,234.56` | Currency with symbols and separators |

**Date Formats:**

| Format | Example Input | Description |
|--------|---------------|-------------|
| Auto-detect | Various | Attempts to parse common formats |
| YYYY-MM-DD | `2024-01-04` | ISO date format |
| MM/DD/YYYY | `01/04/2024` | US date format |
| DD/MM/YYYY | `04/01/2024` | European date format |
| Unix Timestamp | `1704326400` | Seconds since epoch |
| ISO 8601 | `2024-01-04T14:30:00Z` | Full ISO datetime |
| Excel Serial Date | `45295` | Excel serial number (days since 1900) |

**Excel Serial Date:**

Excel stores dates as numbers representing days since January 1, 1900. When exporting from Excel, dates may appear as numbers like `45295` instead of `2024-01-04`.

To handle Excel serial dates:
1. Map your date column normally
2. Change **Source Format** to "Excel Serial Date"
3. The number will be converted to a proper date

**Example:**
- Excel serial `45295` becomes `2024-01-04`
- Excel serial `45458` becomes `2024-06-15`

### Handling Missing Data

Configure how to handle empty/null values:

**Skip row:**
- Row is not processed if required variable is empty
- Useful for optional batch processing

**Use default value:**
- Specify fallback value in template
- Example: `{{quantity:100}}` defaults to 100

**Send empty string:**
- Empty CSV cell becomes empty string in request
- May cause API validation errors

## Batch Configuration

### Error Tolerance

Control how errors affect batch execution:

**Stop on First Error** (default)
- Batch stops immediately when any request fails
- No further requests are processed
- Use for critical operations where any failure is unacceptable

**Maximum Error Count**
- Specify number of failures allowed (e.g., 5)
- Batch stops after reaching limit
- Use when a few failures are acceptable but many indicate a problem

**Percentage-Based Tolerance**
- Specify maximum error rate (e.g., 10%)
- Batch stops if error rate exceeds threshold
- Use for large batches where some failures are expected

**Continue on All Errors**
- Batch runs to completion regardless of failures
- All rows are attempted
- Use for exploratory runs or when failures are expected

**Example scenarios:**

| Scenario | Recommended Setting |
|----------|-------------------|
| Critical data migration | Stop on First Error |
| Bulk update with validation | Max 5 errors |
| Large import (10,000 rows) | 5% error tolerance |
| Data quality testing | Continue on all errors |

### Maximum Repetitions (Advanced)

Limit how many times array values repeat in requests.

**Default behavior:**
If CSV has fewer rows than array size in template, Dobermann repeats CSV rows:
```
CSV: 3 rows
Template array: 10 items
Result: [row1, row2, row3, row1, row2, row3, row1, row2, row3, row1]
```

**With maxRepetitions=2:**
```
CSV: 3 rows
Max repetitions: 2
Result: [row1, row2, row3, row1, row2, row3] (stops after 2 cycles)
```

**Use cases:**
- Prevent runaway repetition with small CSV files
- Control exactly how many cycles to process
- Testing without processing all possible combinations

## Batch Execution

### Running the Batch

1. Ensure endpoint is saved with all template variables
2. Load CSV file
3. Verify column mapping (all green checkmarks)
4. Configure error tolerance if needed
5. Click **Run Batch**

Dobermann processes requests sequentially:
- One request at a time (avoids rate limiting)
- Progress indicator shows current row
- Real-time success/failure count
- Pause/Stop buttons available

### Monitoring Progress

**Progress indicators:**
- **Progress bar** - Visual completion percentage
- **Status text** - "Processing 45 of 100..."
- **Success counter** - Green checkmark with count
- **Error counter** - Red X with count
- **Elapsed time** - Running timer

**Real-time updates:**
- Response times for recent requests
- Current row being processed
- Average requests per second

### Pausing and Stopping

**Pause**
- Temporarily halt execution
- Resume from current position
- Useful for rate limit cooling

**Stop**
- Terminate batch immediately
- Partial results are saved
- Cannot resume (must start over)

## The Run Batch Webview

After configuring a batch in the endpoint webview, the **Run Batch** webview provides a dedicated interface for execution and monitoring.

### Opening Run Batch

**From endpoint:**
1. Configure endpoint with template variables
2. Load CSV and map columns
3. Click **Run Batch** button
4. Run Batch webview opens

**From context menu:**
1. Right-click endpoint in sidebar
2. Select **Run Batch**
3. Choose CSV file (if not already loaded)

### Run Batch Interface

**Configuration summary:**
- Endpoint name and method
- Environment target
- Row count from CSV
- Mapped variables preview

**Execution controls:**
- **Start** - Begin batch execution
- **Pause** - Temporarily halt
- **Resume** - Continue from pause
- **Stop** - Terminate batch
- **Export** - Save results

**Real-time metrics:**
- Progress percentage and bar
- Requests completed / Total rows
- Success and error counts
- Average response time
- Estimated time remaining

**Results preview:**
- Recent requests (last 10)
- Status codes and response times
- Error messages for failures
- Success indicators

### Batch Results

When batch completes:
- Full report opens automatically
- Results saved to workspace (`.active8/results/`)
- CSV with results available
- Execution remains in history

**Report includes:**
- Summary statistics
- Complete request/response data
- Error analysis
- Performance metrics

See [Viewing Results](viewing-results) documentation for detailed report features.

## Advanced Features

### Variable Types

Specify data types in template variables for validation:

**String (default):**
```json
{
  "sku": "{{sku}}"
}
```

**Number:**
```json
{
  "quantity": "{{quantity:number}}"
}
```
- CSV value converted to number
- Validation fails if not numeric

**Boolean:**
```json
{
  "active": "{{is_active:boolean}}"
}
```
- `true`, `1`, `yes` become true
- `false`, `0`, `no` become false
- Case-insensitive

**Array:**
```json
{
  "items": [
    {
      "id": "{{sku}}"
    }
  ]
}
```
- Multiple CSV rows create array entries
- See Template Arrays section in Endpoints documentation

### Pagination Support (A8:PAGE)

For APIs supporting pagination, use the special `{{A8:PAGE}}` variable:

**In endpoint URL or query parameters:**
```
/api/items?page={{A8:PAGE}}&limit=100
```

**Behavior:**
- First request: `page=1`
- Second request: `page=2`
- Continues incrementing automatically

**Use cases:**
- Fetching all pages of results
- Batch processing paginated data
- API endpoints with page-based access

**Combined with CSV:**
- CSV provides other parameters
- `A8:PAGE` auto-increments independent of CSV rows

### Batch File Organization

**Directory structure:**
```
.active8/
├── batches/
│   └── {endpoint-id}/
│       ├── latest.csv
│       └── {timestamp}.csv
└── results/
    └── {endpoint-id}/
        └── {timestamp}.json
```

**File retention:**
- Latest CSV is always saved
- Historical CSVs retained for 30 days
- Results retained indefinitely (manual cleanup)

## Troubleshooting

### CSV Not Loading

**Symptoms:** File browser appears but file doesn't load

**Check:**
- File extension is `.csv` or `.txt`
- File encoding is UTF-8
- File is not locked by another application
- File size is reasonable (<10MB recommended)

### Column Mapping Fails

**Symptoms:** Columns don't auto-map or mapping shows errors

**Solutions:**
- Check CSV header row has column names
- Verify column names don't have special characters
- Manually map columns using dropdowns
- Check for extra spaces in column names

### Batch Stops Immediately

**Symptoms:** Batch stops after first request

**Check:**
- Error tolerance setting (may be "Stop on First Error")
- First request succeeded (check status code)
- Template variables are correctly mapped
- API endpoint is correct and accessible

### Variables Not Substituting

**Symptoms:** Template variables appear literally in request (e.g., `{{sku}}` in JSON)

**Causes:**
- Variable not mapped to CSV column
- Column name mismatch
- Variable misspelled in template

**Solutions:**
- Review column mapping interface
- Ensure all variables have green checkmarks
- Check variable names match exactly (including case)

### Performance Issues

**Symptoms:** Batch runs very slowly

**Optimization:**
- Reduce CSV file size (batch in smaller chunks)
- Check API response times (may be server-side)
- Ensure network connection is stable
- Close unnecessary VS Code extensions

### Memory Issues

**Symptoms:** VS Code becomes slow or crashes during large batch

**Solutions:**
- Process in smaller batches (<1000 rows at a time)
- Close other VS Code windows
- Increase VS Code memory limit
- Export results immediately after completion

## Best Practices

**CSV preparation:**
- Clean data before importing (remove duplicates, fix formatting)
- Include meaningful column headers
- Test with small sample (10-20 rows) first
- Keep backups of original CSV files

**Error handling:**
- Start with "Stop on First Error" for testing
- Use percentage tolerance for production runs
- Review first few errors before continuing large batches
- Export results frequently for large batches

**Performance:**
- Optimal batch size: 100-500 rows
- Split large files into multiple batches
- Run batches during off-peak hours (avoid API rate limits)
- Monitor API response times for degradation

**Data validation:**
- Validate CSV data externally before importing
- Test endpoint with single execution first
- Review column mapping carefully
- Check variable types match API expectations

## Related Topics

- [Endpoints](endpoints) - Template variables and configuration
- [Execution](execution) - Running and monitoring requests
- [Viewing Results](viewing-results) - Analyzing batch results
- [Import/Export](import-export) - Sharing endpoint configurations
