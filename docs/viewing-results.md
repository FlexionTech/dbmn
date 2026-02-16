---
title: Viewing Results
layout: default
nav_order: 6
parent: Documentation
---

# Viewing Results

After executing API requests (single or batch), Dobermann displays comprehensive results in the Report webview. This view provides detailed insights into request/response data, execution metrics, and interactive analysis tools.

## Opening the Report View

Results are displayed automatically after execution:
- **Single execution** - Opens immediately after request completes
- **Batch execution** - Opens after all requests complete or batch is stopped

You can also view previous execution results:
1. Navigate to **Executions** in the sidebar
2. Find the execution by endpoint and timestamp
3. Click to open the report webview

## Execution Summary

The top section displays high-level execution metrics in compact stat cards:

### Status Badge

Visual indicator showing execution outcome:
- **Success** - All requests succeeded (2xx responses)
- **Partial** - Some requests failed
- **Failed** - All requests failed
- **Stopped** - Batch stopped by user

### Summary Statistics

**URL** - Full resolved API endpoint with query parameters

**HTTP Status** - Response status code (single executions only)

**Time** - Execution start timestamp

**Duration** - Total execution time in `HH:MM:SS` format

**ID** - Unique execution identifier for tracking

**Calls** (Batch only) - Actual vs planned transaction count (e.g., `77/77`)
- First number: Completed transactions
- Second number: Planned transactions
- Helps identify if execution completed fully

**Threads** (Batch only) - Maximum concurrent requests
- Shows parallel processing level (e.g., `1` = sequential, `16` = 16 concurrent)
- Higher numbers = faster execution but more server load

**Request/Response Files** (When available) - Direct links to workspace result files
- Click to open JSON request/response files in VS Code editor
- Files saved in `.active8/results/{endpoint}/`

## Tab Navigation

The report uses a tab-based interface to organize different views of execution data:

### Request Tab

Shows the full HTTP request sent to the API:
- HTTP method (GET, POST, PUT, DELETE, etc.)
- Complete URL with resolved variables
- Request headers (including authentication and organization headers)
- Request body (for POST/PUT/PATCH requests)

**Format:**
- Syntax-highlighted JSON for request bodies
- Table format for headers
- Variable substitutions shown resolved

### Logs Tab

Displays execution logs and diagnostic information:
- Request timestamps
- Response timestamps
- Network timing
- Error messages and stack traces
- Retry attempts (if applicable)

**Use case:** Troubleshooting failed requests or performance issues

### Input Tab

Shows original input data used for batch executions:
- CSV row data
- Template variable mappings
- Original data before transformations

**Note:** Only available for batch executions loaded from CSV/Excel files

### Success Tab

Displays only successful requests (2xx responses):
- Filters results to show successes only
- Full response data for each request
- Response times and status codes

**Use case:** Analyze successful patterns, extract data from responses

### Errors Tab

Shows only failed requests:
- 4xx client errors (bad request, unauthorized, not found, etc.)
- 5xx server errors (internal server error, service unavailable, etc.)
- Network errors (timeout, connection refused)
- Error messages from API
- Request context that caused the error

**Use case:** Debug failures, identify data quality issues, spot API problems

## Data Table Features

The main table provides powerful tools for analyzing execution results:

### Root Path Navigation

**Purpose:** Navigate nested JSON response structures

**How it works:**
- Dropdown labeled `Root:` in the toolbar
- Select which JSON path to use as the table root
- Changes which data fields appear as columns

**Example:**
```json
{
  "data": {
    "items": [
      {"id": 1, "name": "Item A"},
      {"id": 2, "name": "Item B"}
    ]
  }
}
```
- Select root path: `data.items`
- Table shows columns: `id`, `name`

**Use case:** Drill into nested API responses without writing code

### Search

**Location:** Search bar with magnifying glass icon

**Features:**
- Search across ALL visible columns simultaneously
- Shows match count (e.g., "Found 5 matches")
- Highlights matching rows
- Case-insensitive matching

**Tips:**
- Search for specific error messages
- Find rows with particular variable values
- Filter by status codes (search "200" or "404")

### Column Management

**Access:** Click "Manage Columns" button in toolbar

**Modal Features:**
- **Search columns** - Filter column list by name
- **Select All** - Show all available columns
- **Deselect All** - Hide all columns (keeps table structure)
- **Reset to Default** - Restore original column selection
- **Toggle checkboxes** - Show/hide individual columns

**Use cases:**
- Hide columns you don't need (declutter view)
- Show only relevant fields for analysis
- Customize view for different analysis tasks

### Sorting

Click any column header to sort:
- **First click:** Sort ascending
- **Second click:** Sort descending
- **Third click:** Remove sort

**Multi-column sort:**
- Hold `Shift` and click additional columns
- Sorts by first column, then second, etc.

**Common sorting patterns:**
- Sort by response time to find slowest requests
- Sort by status code to group errors together
- Sort by row number to see execution order

## Pagination

For large result sets, Dobermann uses pagination to improve performance:

### Pagination Info Display

**Location:** Top of report, below execution summary

Shows current page context:
- **Current page number** (e.g., "Page 2 of 10")
- **Record range** (e.g., "Records 51-100 of 1,000")
- **Navigation:** "Next Page" button to load more

**Note:** Pagination is automatic for responses with `next` links

### Get Multiple Pages

**Access:** Click "Get Multiple Pages" button when pagination is available

**Modal Options:**

**Get All Remaining Pages**
- Fetches all available pages automatically
- Shows progress bar with cancel option
- Use case: Complete data extraction from paginated API

**Get Page Range**
- Specify From/To page numbers
- Fetches only selected range
- Use case: Get specific subset of data

**Progress Tracking:**
- Shows current page being fetched
- Displays success/error count
- Cancel button to stop mid-process
- Results append to existing table data

## Export Options

Save execution results for external analysis or archival:

### Copy CSV

**Quick clipboard export** - Copy data directly to clipboard without saving a file

**What's included:**
- All visible columns
- Current filter/search results
- Sorted order
- CSV format with headers

**How to use:**
1. Click **Export** dropdown in toolbar
2. Select **Copy CSV**
3. CSV data is copied to clipboard
4. Paste directly into Excel, Google Sheets, or any text editor

**Use cases:**
- Quick data sharing (paste into email, Slack, etc.)
- Immediate Excel analysis without file creation
- Ad-hoc data extraction
- Fast iteration during analysis

**Benefits:**
- No file dialog interruption
- Instant clipboard access
- Streamlined workflow (no file cleanup needed)
- Works with filtered/sorted data

**Example workflow:**
```
1. Filter to errors only (click Errors tab)
2. Search for specific error pattern
3. Sort by timestamp
4. Click Export → Copy CSV
5. Paste into email to share with team
```

### Export to CSV (File)

**What's included:**
- All visible columns
- Current filter/search results
- Sorted order

**Use cases:**
- Long-term archival
- Excel analysis with file save
- Reporting to stakeholders
- Performance trending in other tools

### Export to Excel (File)

**What's included:**
- Multiple sheets (Request, Success, Errors tabs become separate sheets)
- Formatted headers
- Preserved data types
- Cell formatting (colors for status codes)

**Use cases:**
- Professional reports
- Complex pivot table analysis
- Sharing with non-technical stakeholders

**Export Process (File-based exports):**
1. Click **Export** dropdown in toolbar
2. Select format (CSV (File) or Excel (File))
3. Choose save location
4. File is created and optionally auto-opened

**File naming:**
```
{executionId}_{tab}.{ext}
```

Example: `batch_abc123_success.csv`

## Workspace File Results

Dobermann automatically creates result files in your workspace after each execution:

### Automatic File Creation

**Location:** `{workspace}/.active8/results/{endpoint}/{timestamp}.json`

**Contents:**
```json
{
  "metadata": {
    "endpointName": "Location Update",
    "endpointId": "uuid",
    "timestamp": "2025-01-15T14:30:00Z",
    "environment": "Production"
  },
  "summary": {
    "totalRequests": 100,
    "successCount": 95,
    "errorCount": 5
  },
  "results": [...]
}
```

### Auto-Opening Files

After execution completes:
- JSON result file opens automatically in VS Code editor
- Files appear in Explorer sidebar under `.active8/results/`
- Can be committed to version control for audit trail

**Benefits:**
- Quick access to raw execution data
- Compare executions using VS Code diff tools
- Share results with team via git

### File Organization

```
.active8/
└── results/
    ├── location-update/
    │   ├── 2025-01-15-14-30-00.json
    │   └── 2025-01-15-15-45-00.json
    └── item-create/
        └── 2025-01-15-16-00-00.json
```

**Cleanup:**
- Old result files can be safely deleted
- Excluded from git by default (`.active8/` in `.gitignore`)

## Performance Analysis

Use the Report webview to analyze API performance patterns:

### Response Time Analysis

**Sort by response time:**
1. Click "Response Time" column header
2. Identify slowest requests (top of descending sort)
3. Look for patterns in slow requests

**Questions to investigate:**
- Do certain variable values cause slower responses?
- Are there outliers (10x slower than average)?
- Does performance degrade over batch position?

### Error Pattern Analysis

**Filter to errors:**
1. Switch to **Errors** tab
2. Use search to find common error messages
3. Sort by status code to group error types

**Common patterns:**
- Specific data values failing validation (search for value in error tab)
- Rate limiting after N requests (errors increase at certain point)
- Timeout issues with certain operations (search "timeout")

### Success Rate Trending

**Compare executions:**
1. Open multiple execution reports
2. Compare success rates across different data sets
3. Identify data quality issues

**Metrics to track:**
- Success rate by endpoint
- Average response time trends
- Error rate by environment

## Troubleshooting

### Report Not Opening

**Symptoms:** Execution completes but report doesn't display

**Solutions:**
- Check VS Code Output panel for errors (View → Output → Dobermann)
- Manually open from Executions sidebar
- Check file permissions in `.active8/results/`
- Reload VS Code window

### Missing Data in Table

**Symptoms:** Report shows but table is empty

**Solutions:**
- Check if correct tab is selected (Success/Errors tabs filter data)
- Verify search box is empty (clear search)
- Check root path selector (try different paths)
- Review error messages in Logs tab

### Export Fails

**Symptoms:** Export button doesn't save file

**Solutions:**
- Check write permissions in target directory
- Verify disk space available
- Try alternative export format
- Check VS Code Output panel for detailed error

### Slow Report Loading

**Symptoms:** Report takes long time to open

**Causes:**
- Large batch (>1,000 requests)
- Large response payloads (>1MB per response)
- Complex nested JSON structures

**Solutions:**
- Use pagination instead of loading all data
- Export to file for external analysis
- Filter to specific tab (Success or Errors only)
- Close other VS Code windows to free memory

## Related Topics

- [Execution](execution) - Running single and batch requests
- [Batch Preparation](batch-preparation) - Configuring batch parameters
- [Endpoints](endpoints) - Configuring API requests
- [Troubleshooting](troubleshooting) - Common issues and solutions
