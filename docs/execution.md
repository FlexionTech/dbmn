---
title: Execution
layout: default
nav_order: 5
parent: Documentation
---

# Execution

Executing API requests is the core functionality of Dobermann. Whether running a single request or batch-processing thousands, Dobermann provides a powerful execution engine with real-time monitoring and detailed results.

## Overview

Dobermann supports two execution modes:
- **Single Execution** - Test individual requests
- **Batch Execution** - Process multiple requests with CSV data

## Single Execution

Execute a single API request to test configuration, verify responses, or perform one-off operations.

### Running a Single Request

**From endpoint webview:**
1. Configure endpoint (method, URL, headers, body)
2. Click **Execute** button
3. Request executes immediately
4. Results open in Report webview

**From sidebar:**
1. Right-click endpoint
2. Select **Execute Endpoint**
3. Results open after completion

**Keyboard shortcut:**
- `Cmd/Ctrl + Enter` (when endpoint webview is focused)

### Execution Process

1. **Validation**
   - Verify endpoint configuration is complete
   - Check environment authentication is valid
   - Validate request body JSON syntax

2. **Variable Substitution**
   - Resolve all `{{variables}}` in URL, headers, body
   - Apply default values where specified
   - Type conversion (string, number, boolean)

3. **Request Execution**
   - Send HTTP request to API
   - Track start time and response time
   - Capture full request/response data

4. **Results Display**
   - Open Report webview automatically
   - Show status code and response time
   - Display formatted response body
   - Highlight errors if any

### Testing with Variables

For single executions with template variables:

**Option 1: Use default values**
```json
{
  "sku": "{{item_id:PRE-TEST-001}}",
  "quantity": "{{qty:10}}"
}
```
Default values are used when no CSV is loaded.

**Option 2: Load single-row CSV**
```csv
item_id,qty
PRE-REAL-001,25
```
CSV values override defaults.

**Option 3: Manual prompt**
- Dobermann prompts for variable values
- Enter values in dialog
- Values are used for this execution only

## Batch Execution

Execute the same endpoint multiple times with different data from a CSV file.

### Prerequisites

Before running a batch:
- Endpoint configured with template variables
- CSV file loaded with data
- Column mapping verified (all green checkmarks)
- Error tolerance configured
- Environment authenticated

### Starting a Batch

**Method 1: From endpoint webview**
1. Load CSV file
2. Map columns to variables
3. Click **Run Batch** button
4. Run Batch webview opens
5. Click **Start** to begin execution

**Method 2: From sidebar**
1. Right-click endpoint
2. Select **Run Batch**
3. Choose CSV file (if not already loaded)
4. Execution begins in Run Batch webview

### Batch Execution Flow

1. **Preparation**
   - Read all CSV rows into memory
   - Validate column mapping
   - Create transaction queue

2. **Sequential Processing**
   - Process one row at a time
   - Substitute variables for each row
   - Execute request
   - Wait for response before next request

3. **Progress Tracking**
   - Update progress bar after each request
   - Increment success/error counters
   - Calculate real-time metrics
   - Display recent results

4. **Error Handling**
   - Apply error tolerance rules
   - Log failure details
   - Continue or stop based on configuration
   - Mark rows as success/failed

5. **Completion**
   - Save results to workspace
   - Open full report
   - Export CSV with results
   - Update execution history

### Monitoring Batch Progress

**Real-time indicators:**
- **Progress bar** - Visual completion percentage
- **Row counter** - "Processing 45 of 100..."
- **Success rate** - Green counter with checkmark
- **Failure count** - Red counter with X
- **Elapsed time** - Timer showing duration
- **Average response time** - Mean across completed requests

**Detailed metrics:**
- Requests per second (throughput)
- Estimated time remaining
- Slowest request (max response time)
- Fastest request (min response time)

### Controlling Execution

**Pause**
- Halts execution after current request completes
- All progress is saved
- Click **Resume** to continue from exact position
- Use cases: Rate limit cooling, reviewing errors

**Stop**
- Terminates execution immediately
- Partial results are saved
- Cannot resume (would need to start over)
- Use cases: Critical error detected, wrong data loaded

**Resume**
- Continues from last completed row
- Only available after pause
- All configuration remains unchanged

## Execution History

All executions (single and batch) are saved in the Executions section of the sidebar.

### Viewing History

**Sidebar tree:**
```
Executions
├── Location Update
│   ├── 2025-01-15 14:30 (✓ 100/100)
│   └── 2025-01-15 12:00 (⚠️ 95/100)
└── Item Create
    └── 2025-01-14 16:45 (✗ 0/10)
```

**Icons:**
- Checkmark - All successful
- Warning - Partial (some failures)
- X - All failed
- Pause icon - Stopped/incomplete

### Opening Past Results

1. Expand **Executions** in sidebar
2. Expand endpoint name
3. Click execution timestamp
4. Report webview opens with full results

**Context menu options:**
- **View Report** - Open results
- **Export Results** - Save to file
- **Re-run** - Execute again with same data
- **Delete** - Remove from history

### Execution Persistence

Results are stored in:
```
.active8/
└── results/
    └── {endpoint-name}/
        └── {timestamp}.json
```

**Contains:**
- Complete request/response data
- Execution metadata
- Success/failure statistics
- Variable values used
- Timing information

## Request Priority Queue (Advanced)

Dobermann uses a priority queue system for batch executions:

### Priority Levels

1. **High** - User-initiated single executions
2. **Normal** - Standard batch requests
3. **Low** - Background/scheduled tasks

### Queue Behavior

**Serial processing:**
- One request at a time (prevents API overload)
- Requests processed in priority order
- Fairness: Round-robin within same priority

**Benefits:**
- No race conditions
- Predictable throughput
- Rate limit friendly
- Easy to monitor and control

## Performance Considerations

### Request Timing

Dobermann enforces sequential execution:
- No concurrent requests (one at a time)
- Small delay between requests (configurable)
- Respects API rate limits
- Avoids overwhelming target servers

**Default delay:** 100ms between requests

### Large Batches

For batches >1000 rows:

**Recommendations:**
- Split into smaller batches (100-500 rows)
- Run during off-peak hours
- Monitor API response times
- Check for rate limit errors

**Memory management:**
- Results streamed to disk
- Completed requests cleared from memory
- Progress auto-saved every 100 requests

### Network Resilience

**Timeout handling:**
- Default timeout: 30 seconds
- Configurable per endpoint
- Timeout counts as failure
- Applies to error tolerance

**Connection issues:**
- Automatic retry (1 attempt)
- Exponential backoff for rate limits
- Clear error messages
- Batch can be resumed after fixing issues

## Error Handling

### Error Categories

**Network errors:**
- Timeout (request took too long)
- Connection refused (server not reachable)
- DNS resolution failed
- SSL certificate issues

**HTTP errors:**
- 4xx - Client errors (bad request, auth failure, not found)
- 5xx - Server errors (internal error, service unavailable)

**Validation errors:**
- JSON syntax error in request body
- Required variable unmapped
- Type conversion failed (e.g., "abc" as number)

### Error Tolerance

Configure how errors affect batch execution:

**Stop on First Error:**
```
Batch: 100 rows
Request 5 fails → Stop immediately
Result: 4 successful, 1 failed, 95 skipped
```

**Maximum Error Count (e.g., 5):**
```
Batch: 100 rows
Request 10, 15, 20, 25, 30 fail → Stop at 30
Result: 94 successful, 5 failed, 1 skipped
```

**Percentage-Based (e.g., 10%):**
```
Batch: 100 rows
Request 11 fails → Stop (11% failure rate)
Result: 89 successful, 11 failed, 0 skipped
```

**Continue on All Errors:**
```
Batch: 100 rows
Requests 5, 20, 35 fail → Continue to end
Result: 97 successful, 3 failed, 0 skipped
```

### Logging

All executions create detailed logs:

**Log location:** `.active8/logs/{endpoint-id}/{timestamp}.log`

**Log contents:**
- Request/response for each row
- Variable substitution results
- Error messages and stack traces
- Performance metrics
- Timestamps for each operation

**Use cases:**
- Debugging failed requests
- Audit trail for compliance
- Performance analysis
- Issue reporting

## Testing Strategies

### Development Testing

**Single execution:**
1. Configure endpoint with test data
2. Execute once
3. Verify response structure
4. Check status code and timing
5. Iterate on configuration

**Small batch:**
1. Create CSV with 5-10 test rows
2. Include edge cases (empty values, special chars)
3. Run batch with "Stop on First Error"
4. Review all responses
5. Fix issues before production

### Pre-Production Validation

**Medium batch:**
1. Use representative sample (50-100 rows)
2. Set error tolerance to 5%
3. Monitor response times
4. Check for rate limiting
5. Validate error handling

**Full dry run:**
1. Use complete dataset (without real IDs)
2. Target staging environment
3. Enable detailed logging
4. Review full report
5. Address any issues found

### Production Execution

**Staged rollout:**
1. Start with small batch (100 rows)
2. Verify success before continuing
3. Increase batch size gradually
4. Monitor API health
5. Keep stakeholders informed

**Monitoring:**
- Watch success rate in real-time
- Check error messages immediately
- Pause if unexpected issues occur
- Export results frequently
- Have rollback plan ready

## Troubleshooting

### Execution Won't Start

**Symptoms:** Execute button is disabled or does nothing

**Check:**
- Endpoint is saved (no unsaved changes)
- Environment has valid authentication
- Required variables are configured
- No validation errors in endpoint

### Execution Hangs

**Symptoms:** Request never completes, spinner runs forever

**Possible causes:**
- API server not responding
- Network connectivity issue
- Firewall blocking request
- Timeout set too high

**Solutions:**
- Check API server status
- Verify network connection
- Test endpoint with curl/Postman
- Reduce timeout value

### Batch Stops Unexpectedly

**Symptoms:** Batch stops before completing all rows

**Check:**
- Error tolerance setting
- Recent error messages in log
- API rate limits hit
- Network interruption

### Wrong Data in Request

**Symptoms:** Variables show incorrect values in request

**Check:**
- Column mapping is correct
- CSV has correct data in columns
- Variable names match exactly
- No extra spaces in CSV headers

### Results Not Saving

**Symptoms:** Execution completes but no results appear

**Check:**
- Write permissions in `.active8/` directory
- Disk space available
- File not locked by another process
- Check VS Code output panel for errors

## Related Topics

- [Endpoints](endpoints) - Configuring API requests
- [Batch Preparation](batch-preparation) - Loading CSV and mapping columns
- [Viewing Results](viewing-results) - Analyzing execution outcomes
- [Environments](environments) - Managing authentication and targets
