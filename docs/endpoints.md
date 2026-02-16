---
title: Endpoints
layout: default
nav_order: 3
parent: Documentation
---

# Managing API Endpoints

API endpoints are the core of Dobermann - they define your API requests including HTTP method, URL, headers, body template, and test scripts.

## Overview

An endpoint is a complete API request configuration that can be executed individually or in batches using CSV data. Each endpoint includes HTTP method, URL path, query parameters, headers, request body template, and optional test scripts.

**Quick Start:**
1. Click the "+" icon on the Endpoints tree
2. Enter endpoint name and description
3. Select HTTP method (GET, POST, PUT, DELETE)
4. Configure URL path (e.g., `/api/orders`)
5. Add query parameters and headers if needed
6. Define request body template with variables
7. Click "Save Endpoint"
8. Test by clicking "Run API" button

## Managing Endpoints

The Endpoints tree view displays all your API configurations organized by folders.

### Adding Endpoints

Create new endpoints by clicking the "+" icon in the tree view. You can create endpoints directly at the root level or within folders for better organization.

### Editing Endpoints

Click any endpoint in the tree to open the endpoint configuration webview. The webview shows all endpoint settings and allows you to modify any aspect of the configuration.

### Organizing with Folders

Create folders to organize endpoints by feature, service, or environment. Right-click the tree view or a folder to create new folders. Drag and drop endpoints between folders to reorganize your structure.

### Quick Access

The Quick Access feature provides fast, keyboard-driven endpoint search and execution without navigating the tree structure. This is particularly useful when working with deeply nested folders or large endpoint collections.

**Opening Quick Access:**
- **Keyboard:** Press `Alt+D E` (chord shortcut - press Alt+D, release, then E)
- **Mouse:** Click the search icon in the Endpoints tree toolbar
- **Command Palette:** "Dobermann: Search Endpoints"

**Two-Step Workflow:**

*Step 1 - Search Endpoints:*
A fuzzy search interface appears showing all endpoints with icons, methods, and paths. Type to filter the list by name, method, path, or folder. Use arrow keys to navigate and Enter to select.

*Step 2 - Choose Action:*
After selecting an endpoint, choose what to do:
- **Run API** - Execute endpoint once with parameter collection
- **Run Batch** - Open batch execution with CSV upload
- **Edit Endpoint** - Open endpoint configuration editor

The interface is fully keyboard accessible - no mouse required. Use arrow keys to navigate options and Enter to select.

**Example Workflow:**
1. Press `Alt+D E`
2. Type "order" to filter endpoints
3. Press Enter on "Get Orders"
4. Arrow down to "Run Batch"
5. Press Enter to open batch creator

This workflow is significantly faster than navigating nested folders in the tree view, especially when you know the endpoint name but not its exact location.

### Deleting Endpoints

Right-click an endpoint and select "Delete Endpoint" to remove it. The system will show the number of associated transactions before deletion to prevent accidental data loss.

## Request Configuration

The endpoint configuration webview provides comprehensive settings for API requests. Every endpoint requires basic configuration including name, description, HTTP method selection, and folder assignment.

### Basic Settings

The endpoint name appears in the tree view and helps identify the endpoint's purpose. Descriptions provide additional context visible when hovering over endpoints. Folder assignment helps organize endpoints logically by feature or service area.

### HTTP Method Selection

Choose from GET, POST, PUT, or DELETE methods. The selected method determines whether a request body is available and affects how query parameters are sent.

## URL Path

The URL path defines the endpoint location on your API server. Enter the full URL path starting with `/`. Paths are combined with the environment's base URL when executing requests.

### Using Variables in URLs

URL paths support template variables for dynamic paths using double bracket notation `{% raw %}{{variableName}}{% endraw %}`. Variables are replaced with actual values during execution and automatically URL-encoded.

**Examples:**
- `/api/orders/{% raw %}{{orderId}}{% endraw %}/status`
- `/api/users/{% raw %}{{userId:number}}{% endraw %}/profile`
- `/api/products/{% raw %}{{category}}{% endraw %}/{% raw %}{{productId}}{% endraw %}/details`

The URL field displays a link icon when template variables are detected.

## Headers

HTTP headers define metadata for your API requests including content-type, authorization, and custom headers. Headers are configured as key-value pairs in the headers section.

### Using Variables in Headers

Header values support template variables for dynamic authentication tokens or user-specific values. Values are not URL-encoded, preserving header format requirements.

**Examples:**
- Header: `Authorization`, Value: `Bearer {% raw %}{{authToken:string}}{% endraw %}`
- Header: `X-User-ID`, Value: `{% raw %}{{userId:number}}{% endraw %}`
- Header: `X-Request-ID`, Value: `REQ-{% raw %}{{requestId}}{% endraw %}`

### Auto Organization Headers

When using organization-based authentication, Dobermann automatically adds organization headers to requests. These auto-generated headers are managed by the authentication system and cannot be edited manually.

## Query Parameters

Query parameters are key-value pairs appended to the URL. Click "Add Parameter" to create new parameters. Parameter values support template variables for dynamic values.

### Using Variables in Query Parameters

Add template variables to query parameter values for dynamic URL construction. Values are automatically URL-encoded when replaced.

**Examples:**
- Parameter: `itemId`, Value: `PRE-{% raw %}{{sku}}{% endraw %}`
- Parameter: `limit`, Value: `{% raw %}{{maxResults:number}}{% endraw %}`
- Parameter: `includeActive`, Value: `{% raw %}{{isActive:boolean}}{% endraw %}`

### A8:PAGE Variable for Pagination

Dobermann provides a special `{% raw %}{{A8:PAGE}}{% endraw %}` variable for pagination support. Use this in query parameters to enable automatic page iteration during batch execution.

**Example:**
- Parameter: `page`, Value: `{% raw %}{{A8:PAGE}}{% endraw %}`

When pagination is enabled, Dobermann automatically increments the page number and continues fetching until no more results are returned.

### Query Parameter Repetition

Query parameter repetition allows you to combine multiple CSV values into a single GET request. This is useful for APIs that support filtering by multiple values (e.g., fetching multiple items by ID in one request).

**Syntax:** `pattern[ separator ]`

Add a separator inside square brackets `[]` after your query parameter pattern.

**Examples:**

| Pattern | Result |
|---------|--------|
| `ItemId={% raw %}{{ITEM}}{% endraw %}[ or ]` | `ItemId=val1 or ItemId=val2 or ItemId=val3` |
| `ItemId={% raw %}{{ITEM}}{% endraw %}[&]` | `ItemId=val1&ItemId=val2&ItemId=val3` |
| `status={% raw %}{{STATUS}}{% endraw %}[,]` | `status=active,status=pending` |
| `ItemId=ACAU-{% raw %}{{ITEM}}{% endraw %}[ or ]` | `ItemId=ACAU-val1 or ItemId=ACAU-val2` |

**Key Points:**
- Pattern comes before the brackets (e.g., `ItemId={% raw %}{{ITEM}}{% endraw %}`)
- Separator goes inside `[]` (e.g., `[ or ]`)
- Empty brackets `[]` default to `&`
- Spaces inside brackets are preserved: `[ or ]` vs `[or]`

**Configuration (CSV Modal Step 4):**
- **Enable/Disable**: Toggle to enable repeating parameter
- **Max URL Length**: Maximum URL length before splitting (default: 2048)
- **Max Values Per Request**: Optional limit on values per request

**Automatic Batching:**
Dobermann automatically splits rows into multiple requests if URL length or value count limits are exceeded.

## Request Body

The request body contains the JSON payload sent to the API. Define your JSON template using the Monaco editor with syntax highlighting and validation. Template variables enable dynamic data replacement for both single and batch execution.

### Using Variables in Request Body

Place template variables anywhere in your JSON body template using `{% raw %}{{variableName}}{% endraw %}` syntax. Variables are replaced with actual values during execution.

**Example:**
```json
{
    "Data": [
        {
            "ItemId": "PRE-{% raw %}{{sku:string}}{% endraw %}",
            "Quantity": "{% raw %}{{quantity:number}}{% endraw %}",
            "IsActive": "{% raw %}{{activeFlag:boolean}}{% endraw %}",
            "LoadDate": "{% raw %}{{loadDate:date}}{% endraw %}"
        }
    ]
}
```

### Variable Types

Template variables support four data types with automatic validation during CSV processing:

**String (default):** Any text value. Use `{% raw %}{{name:string}}{% endraw %}` or `{% raw %}{{name}}{% endraw %}`.

**Number:** Integers (`123`, `-45`) or decimals (`123.45`, `-0.5`). Use `{% raw %}{{quantity:number}}{% endraw %}`.

**Boolean:** Accepts `true`, `yes`, `y`, `1`, `on` or `false`, `no`, `n`, `0`, `off` (case-insensitive). Use `{% raw %}{{isActive:boolean}}{% endraw %}`.

**Date:** Supports ISO (`2023-12-25`), US (`12/25/2023`), European (`25/12/2023`) formats. Use `{% raw %}{{orderDate:date}}{% endraw %}`.

### Automatic Variables (A8)

Automatic variables (A8 = **A**utomatic) are system-generated values that don't require parameter collection or CSV columns. You will NOT be prompted for these - they are computed automatically at execution time:

- `{% raw %}{{A8:sequence}}{% endraw %}` - Sequential numbering (increments with each request)
- `{% raw %}{{A8:datetime}}{% endraw %}` - Current timestamp (ISO 8601 format)
- `{% raw %}{{A8:endpoint}}{% endraw %}` - Endpoint name
- `{% raw %}{{A8:PAGE}}{% endraw %}` - Page number for pagination

**Example:**
```json
{
    "requestId": "{% raw %}{{A8:sequence}}{% endraw %}",
    "timestamp": "{% raw %}{{A8:datetime}}{% endraw %}",
    "endpointName": "{% raw %}{{A8:endpoint}}{% endraw %}",
    "orderId": "{% raw %}{{orderId:number}}{% endraw %}"
}
```

### Environment Variables

Use environment-level variables in templates with the `{% raw %}{{ENV:variableName}}{% endraw %}` syntax. These variables are automatically resolved from your active environment's variables, not from CSV data or parameter prompts.

**Use Cases:**
- Organization codes that vary between environments
- Host identifiers for different deployments
- Tenant IDs or region codes
- Any value that differs per environment but stays constant within a batch

**Example:**
```json
{
    "organization": "{% raw %}{{ENV:org}}{% endraw %}",
    "host": "{% raw %}{{ENV:host}}{% endraw %}",
    "orderId": "{% raw %}{{orderId:number}}{% endraw %}",
    "items": [
        {
            "sku": "{% raw %}{{SKU}}{% endraw %}",
            "warehouse": "{% raw %}{{ENV:warehouse}}{% endraw %}"
        }
    ]
}
```

**Setting Environment Variables:**
Environment variables are configured in your Environment settings. Go to the Environments tree, select your environment, and add variables in the Variables section.

**Key Behaviors:**
- ENV variables are NOT prompted during Run API parameter collection
- ENV variables are NOT shown in the Enter Data grid during Run Batch
- If an ENV variable is missing from the active environment, execution will fail with a clear error message
- ENV variables work at any level: root, outer array, inner array

### Visual Indicators

Dobermann provides real-time visual feedback when template variables are detected:
- Link icon in URL field when path contains variables
- Link icon for query parameters with template values
- Link icon for headers with template values
- Count badges showing number of templated items

## Test Scripts

Define JavaScript test scripts that run after each API request to validate responses. Tests use JavaScript with access to `response` and `request` objects.

**Example test:**
```javascript
expect(response.status).to.equal(200);
expect(response.json().success).to.be.true;
expect(response.json().orderId).to.exist;
```

**Note:** Test functionality is currently in development and may have limitations.

The test configuration panel validates JavaScript syntax before saving. Syntax errors are highlighted with line numbers and error messages.

## Executing Endpoints

Endpoints can be executed individually for testing or in batches for bulk data processing.

### Single Execution

Click the "Run API" button to execute the endpoint once. Dobermann scans all request components (body, URL, query params, headers) and prompts for all template variable values. Duplicate variables are deduplicated and only asked once.

**Workflow:**
1. Click "Run API" button
2. Enter values for each unique template variable
3. Request executes immediately
4. Report opens showing results
5. Transaction saved to history

### Batch Execution

Click the "Run Batch" button to process multiple requests from a CSV file. The Run Batch webview handles file upload, column mapping, and batch execution configuration.

**Workflow:**
1. Click "Run Batch" button
2. Upload CSV/Excel file
3. Map CSV columns to template variables
4. Configure batch options (parallel processing, error tolerance)
5. Click "Run Batch" to start processing
6. Monitor progress in Transactions tree

For detailed batch execution guidance, see [Batch Preparation](batch-preparation) and [Execution](execution).

### CSV Column Mapping

During batch execution, the mapping interface shows comprehensive variable information:
- Variable Name - The template variable identifier
- Type - Data type with color-coded pill
- Sources - Where variable is used (URL, Query Param, Header, Body)
- CSV Column - Dropdown to select source column
- Sample Value - Preview of mapped value

## Troubleshooting

Common issues when working with endpoints and how to resolve them.

### Template Variables Not Replaced

Check variable spelling and bracket syntax (`{% raw %}{{variableName}}{% endraw %}`). Ensure CSV has matching column names during batch execution. Verify template variable indicators (link icons) are showing in the UI.

### URL Encoding Issues

URL and query parameter values are automatically encoded. Header values are not encoded. If special characters cause problems, verify the correct encoding is applied for the variable's location.

### Type Validation Errors

Review data type specifications in your template (`{% raw %}{{variable:type}}{% endraw %}`). Check that CSV data format matches expected types. Use the validation preview before full batch execution to catch errors early.

### Request Body Syntax Errors

Validate JSON syntax in the request body editor. Ensure template variables don't break JSON structure. Use the Monaco editor's syntax highlighting to identify issues.

### Endpoint Won't Save

Check that all required fields are completed (name, HTTP method, URL). Verify folder assignment is valid. Look for validation error messages in the UI.

## Related Topics

- [Batch Preparation](batch-preparation) - CSV upload and column mapping
- [Execution](execution) - Running individual and batch requests
- [Viewing Results](viewing-results) - Analyzing transaction reports
- [Environments](environments) - Managing API environments
- [Troubleshooting](troubleshooting) - General troubleshooting guide
