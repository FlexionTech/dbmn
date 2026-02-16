---
title: Endpoints
layout: default
nav_order: 3
parent: Documentation
has_children: true
---

# Endpoints

Endpoints are complete API request configurations — everything Dobermann needs to talk to your API. Each endpoint defines the HTTP method, URL path, headers, query parameters, and a request body template. Configure once, then run individually or in batches with thousands of rows.

## Managing Endpoints

### Creating an Endpoint

Click the **+** icon on the Endpoints tree panel. You get a blank configuration with all sections ready to fill in.

### Organising with Folders

Create folders to group endpoints by feature, service, or project. Right-click the tree view or a folder to create sub-folders. Drag and drop endpoints between folders to reorganise.

### Quick Access (Alt+D E)

Skip the tree entirely. Press **Alt+D E** (chord shortcut — press Alt+D, release, then press E) to open fuzzy search across all endpoints. Type a few characters to filter by name, method, path, or folder, then choose your action:

- **Run API** — Execute once with parameter prompts
- **Run Batch** — Open the batch runner
- **Edit Endpoint** — Open the configuration editor

Fully keyboard-driven. No mouse required.

### Deleting Endpoints

Right-click an endpoint and select **Delete Endpoint**. Dobermann shows the number of associated transactions before deletion so you don't accidentally lose history.

---

## Endpoint Configuration

### Basic Settings

| Field | Description |
|-------|-------------|
| **Endpoint Name** | Appears in the tree view — make it descriptive |
| **HTTP Method** | GET, POST, PUT, PATCH, or DELETE |
| **Endpoint Path** | URL path starting with `/` — combined with your environment's base URL at execution time |
| **Description** | Optional context, visible on hover in the tree |

---

## URL Path
{: #url-path }

The URL path is appended to your environment's base URL when running requests. Template variables are fully supported for dynamic paths.

{% raw %}
**Examples:**
- `/api/orders/{{orderId}}/status`
- `/api/users/{{userId:number}}/profile`
- `/api/products/{{category}}/{{productId}}/details`
{% endraw %}

A link icon appears in the URL field when template variables are detected.

For full variable syntax, types, and modifiers, see [Template Variables](template-variables).

---

## Headers
{: #headers }

HTTP headers define metadata for your requests — content type, authentication tokens, custom identifiers.

### Custom Headers

Add headers as key-value pairs. Each header has:
- **Enable/Disable toggle** — disabled headers are greyed out and excluded from requests
- **Template variable support** — use variables in header values
- A link icon appears when a header contains template variables

{% raw %}
**Examples:**
- `Authorization`: `Bearer {{authToken:string}}`
- `X-User-ID`: `{{userId:number}}`
- `X-Request-ID`: `REQ-{{requestId}}`
{% endraw %}

### Environment-Level Headers

Toggle **Include environment-level headers** to inherit headers from your active environment. Inherited headers appear as read-only rows — useful for organisation headers, content-type defaults, or auth tokens that apply across all endpoints.

---

## Query Parameters
{: #query-parameters }

Key-value pairs appended to the URL. Each parameter supports enable/disable toggling and template variables.

{% raw %}
**Examples:**
- `itemId`: `PRE-{{sku}}`
- `limit`: `{{maxResults:number}}`
- `includeActive`: `{{isActive:boolean}}`
{% endraw %}

### Pagination with A8:PAGE

{% raw %}
Use `{{A8:PAGE}}` in a query parameter to enable automatic page iteration during batch execution. Dobermann increments the page number and continues until no more results are returned.
{% endraw %}

**Example:** Parameter `page`, Value: {% raw %}`{{A8:PAGE}}`{% endraw %}

### Query Parameter Repetition

Combine multiple source data values into a single GET request — useful for APIs that accept filter lists.

**Syntax:** `pattern[ separator ]`

{% raw %}
| Pattern | Result |
|---------|--------|
| `ItemId={{ITEM}}[ or ]` | `ItemId=val1 or ItemId=val2 or ItemId=val3` |
| `ItemId={{ITEM}}[&]` | `ItemId=val1&ItemId=val2&ItemId=val3` |
| `status={{STATUS}}[,]` | `status=active,status=pending` |
{% endraw %}

- Pattern comes before the brackets
- Separator goes inside `[]` — spaces are preserved (`[ or ]` vs `[or]`)
- Empty brackets `[]` default to `&`

Dobermann automatically splits into multiple requests if URL length or value count limits are exceeded.

---

## Request Body
{: #request-body }

The JSON payload sent to your API. Dobermann provides a full-featured editor with template variable support, syntax highlighting, and a toolbar to speed up authoring.

- **Always shown** for POST, PUT, PATCH methods
- **Hidden by default** for GET and DELETE (shown if body has content or you explicitly add it)
- An info banner reminds you that request body is not sent for GET/DELETE methods

{% raw %}
**Example template:**
```json
{
    "Data": [
        {
            "ItemId": "PRE-{{sku:string}}",
            "Quantity": "{{quantity:number}}",
            "IsActive": "{{activeFlag:boolean}}",
            "LoadDate": "{{loadDate:date}}"
        }
    ]
}
```
{% endraw %}

For the full template variable reference including types, modifiers, and the editing experience, see [Template Variables](template-variables).

### Editor Toolbar

The toolbar above the editor provides quick access to template authoring features:

| Button | Shortcut | What it does |
|--------|----------|------------|
| **Line Variable** | Ctrl+M | Cycle a JSON line through 4 states: regular value → Input variable → ENV variable → A8 variable → restore original |
| **Insert Var** | Ctrl+Shift+M | {% raw %}Toggle `{{}}` brackets at cursor position{% endraw %} |
| **Modifier** | — | Add type-aware modifiers (shows different options for string, number, date, etc.) |
| **Encode** | — | Toggle BASE64 encoding on a key (`"key"` → `"key:BASE64"`) |
| **Comment** | Ctrl+/ | Toggle line comments (supports multi-line selection) |
| **Delete Line** | Ctrl+D | Delete current line(s) |
| **Undo / Redo** | Ctrl+Z / Ctrl+Shift+Z | Standard undo/redo |
| **Format JSON** | — | Pretty-print the JSON body |

### Autocomplete

{% raw %}
The editor provides intelligent suggestions as you type:
- Type `{{` — suggests `A8:` and `ENV:` prefixes
- Type `{{A8:` — shows available auto-variables: `sequence`, `date`, `datetime`
- Type `{{varName:` — shows data types: `string`, `number`, `boolean`, `date`, `datetime`
- Type `{{varName:type|` — shows applicable modifiers for that type
{% endraw %}

---

## Share, Paste & Duplicate
{: #sharing }

### Share Button — Copy Endpoint to Clipboard

The **Share** button is one of Dobermann's best features. Click it and your entire endpoint configuration is copied to the clipboard in **two formats simultaneously**:

1. **Rich HTML** — renders beautifully in Microsoft Teams, Outlook, Confluence, and any rich-text editor
2. **Plain text (JSONC)** — structured comments with metadata, headers, params, and the full body

**What gets copied (plain text format):**

{% raw %}
```
// Name: Create Order
// Method: POST
// Path: /api/orders
// Description: Create a new order
// Header: Authorization: Bearer {{ENV:API_TOKEN}} [enabled]
// Header: Content-Type: application/json [enabled]
// Header: X-Debug: true [disabled]
// QueryParam: sendEmail: true [enabled]

{
  "customerId": "{{customerId:string}}",
  "items": [
    {
      "sku": "{{sku:string|upper}}",
      "quantity": "{{quantity:number|int}}"
    }
  ],
  "orderDate": "{{createdDate:date|+1d}}"
}
```
{% endraw %}

**How it looks in Teams / Outlook:**

A blue header bar reading **DBMN Endpoint**, followed by a formatted code block with your full endpoint configuration, and a footer link back to dbmn.io.

**How it looks in Confluence:**

The same styled block renders as a clean code section — paste it straight into a wiki page and your team can see exactly what the endpoint does.

### Paste Button — Create from Shared

Got a shared endpoint from a colleague? Click **Paste** on a new endpoint (or create a new endpoint first). Dobermann reads the clipboard, parses the JSONC metadata, and populates:

- Endpoint name, method, path, and description
- All headers (with enabled/disabled state preserved)
- All query parameters
- The complete request body

If the shared endpoint includes headers you don't have yet, Dobermann shows a confirmation modal asking whether to add them.

The Paste button only appears on new, unsaved endpoints.

### Duplicate Endpoint

Click **More Actions** → **Duplicate** to create a copy of any saved endpoint. The duplicate gets a "COPY " prefix and opens as a new unsaved endpoint — modify and save to create your variation.

---

## All Buttons Reference

### Footer Buttons (Always Visible)

| Button | Description |
|--------|-------------|
| **Save Endpoint** (Ctrl+S) | Save current configuration. Validates name, path, and JSON syntax first |
| **Run API** | Execute endpoint once with parameter prompts. Disabled when unsaved changes exist |
| **Run Batch** | Open the batch runner. Disabled when unsaved changes exist |

### Add Section (+) Dropdown

| Option | Description |
|--------|-------------|
| **Request Body** | Show the body editor |
| **Add Header** | Add a new custom header row |
| **Add Query Parameter** | Add a new query parameter row |

### Context-Dependent Buttons

| Button | When Visible | Description |
|--------|-------------|-------------|
| **Paste** | New endpoints only | Parse shared endpoint data from clipboard |
| **Share** | Saved endpoints only | Copy endpoint to clipboard (rich + plain text) |
| **More Actions → Duplicate** | Saved endpoints only | Create a copy with "COPY " prefix |
| **More Actions → Delete** | Saved endpoints only | Delete endpoint (shows transaction count warning) |

---

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| Ctrl+S | Save endpoint |
| Ctrl+M | Cycle line variable (4 states) |
| Ctrl+Shift+M | {% raw %}Insert/remove `{{}}` at cursor{% endraw %} |
| Ctrl+/ | Toggle line comment |
| Ctrl+D | Delete line |
| Ctrl+Z | Undo |
| Ctrl+Shift+Z | Redo |
| Alt+D E | Quick access search |

---

## Related Topics

- [Template Variables](template-variables) — Full variable syntax, types, modifiers, and editing features
- [Environments](environments) — Manage API connections and authentication
- [Batch Preparation](batch-preparation) — Loading data and column mapping
- [Import/Export](import-export) — Share configurations with your team
- [Shortcuts](shortcuts) — All keyboard shortcuts
