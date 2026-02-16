---
title: Getting Started
layout: default
nav_order: 1
parent: Documentation
---

# Getting Started with Dobermann

Welcome to Dobermann, a VS Code extension for mass data loading into Manhattan Active APIs.

## What is Dobermann?

Dobermann is a VS Code extension that enables you to execute API requests individually or in batches using CSV/Excel files. It provides endpoint management, environment configuration, template variables, and comprehensive execution tracking.

## Quick Start

Get started with Dobermann in 5 simple steps:

1. **Create an Environment** - Define your API base URL and authentication
2. **Create an Endpoint** - Configure HTTP method, URL, headers, and body template
3. **Run Single Request** - Test your endpoint with "Run API"
4. **Upload CSV File** - Use "Run Batch" for bulk data processing
5. **View Results** - Check transaction reports for request/response details

## Core Concepts

Understanding these core concepts will help you use Dobermann effectively.

### Environments

Environments define where your APIs run (development, staging, production). Each environment includes a base URL, authentication method (JWT or OAuth), and organization selection for multi-tenant APIs.

### Endpoints

Endpoints are API request configurations including HTTP method, URL path, query parameters, headers, request body template, and optional test scripts. Endpoints can be executed individually or in batches.

### Template Variables

Template variables use `{% raw %}{{variableName}}{% endraw %}` syntax to create dynamic requests. Variables work in URL paths, query parameters, headers, and request bodies. For batch execution, CSV columns map to template variables.

### Transactions

Every API request (individual or batch) creates a transaction record. Transactions include request details, response data, test results, and execution metadata. View transactions in the Transactions tree.

### Batch Execution

Batch execution processes multiple API requests from CSV/Excel files. Upload a file, map columns to template variables, configure options (parallel processing, error tolerance), and execute. Monitor progress in real-time.

## Your First Workflow

Follow this complete workflow to execute your first API request.

### Step 1: Create an Environment

1. Click the "+" icon on the Environments tree
2. Enter environment name (e.g., "Development")
3. Select environment type (development, staging, production)
4. Enter base URL (e.g., `https://api.example.com`)
5. Choose authentication method (JWT or OAuth)
6. Paste JWT token or configure OAuth
7. Click "Save Environment"
8. Right-click environment and select "Set as Active"

### Step 2: Create an Endpoint

1. Click the "+" icon on the Endpoints tree
2. Enter endpoint name (e.g., "Create Order")
3. Enter description
4. Select HTTP method (POST)
5. Enter URL path (e.g., `/api/orders`)
6. Add headers if needed (e.g., `Content-Type: application/json`)
7. Define request body template with variables
8. Click "Save Endpoint"

**Example request body:**
```json
{
    "orderId": "{% raw %}{{orderId:number}}{% endraw %}",
    "customerName": "{% raw %}{{customerName:string}}{% endraw %}",
    "quantity": "{% raw %}{{quantity:number}}{% endraw %}"
}
```

### Step 3: Run a Single API Call

1. Right-click your endpoint
2. Select "Run API"
3. Enter values for template variables:
   - orderId: `12345`
   - customerName: `John Doe`
   - quantity: `10`
4. Click "Execute"
5. Report webview opens showing request/response details

### Step 4: Upload a CSV File

1. Create a CSV file with columns: `ORDER_ID`, `CUSTOMER_NAME`, `QUANTITY`
2. Right-click your endpoint
3. Select "Run Batch"
4. Drag-and-drop your CSV file or click to browse
5. Map CSV columns to template variables:
   - `orderId` → `ORDER_ID`
   - `customerName` → `CUSTOMER_NAME`
   - `quantity` → `QUANTITY`
6. Configure batch options (parallel processing, error tolerance)
7. Click "Run Batch"

### Step 5: View Results

1. Open the Transactions tree
2. Find your batch execution (shows progress)
3. Click the transaction to view detailed report
4. Review request/response for each row
5. Check for errors or failed requests
6. Export results if needed

## What's Next?

Now that you've completed your first workflow, explore these advanced features:

**Template Variables:** Learn about data types, auto-generated variables, and using variables in URLs and headers. See [Endpoints](endpoints).

**Batch Preparation:** Master CSV upload, column mapping, and data transformations. See [Batch Preparation](batch-preparation).

**Execution Options:** Understand individual vs batch execution, parallel processing, and error tolerance. See [Execution](execution).

**OAuth Authentication:** Configure OAuth providers for token-based authentication. See [Environments](environments).

**Import/Export:** Share endpoint and environment configurations with your team. See [Import/Export](import-export).

**Viewing Results:** Analyze transaction reports, test results, and performance metrics. See [Viewing Results](viewing-results).

## Getting Help

If you encounter issues or have questions:

1. Check the [Troubleshooting](troubleshooting) guide
2. Review relevant documentation sections
3. Check execution logs for error details
4. Open GitHub issues for bugs or feature requests

## Related Topics

- [Environments](environments) - Managing API environments
- [Endpoints](endpoints) - Endpoint configuration and template variables
- [Batch Preparation](batch-preparation) - CSV upload and column mapping
- [Execution](execution) - Running requests and monitoring progress
- [Viewing Results](viewing-results) - Analyzing transaction reports
- [Import/Export](import-export) - Sharing configurations
- [Troubleshooting](troubleshooting) - Common issues and solutions
