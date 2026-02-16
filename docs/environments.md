---
title: Environments
layout: default
nav_order: 2
parent: Documentation
---

# Environments

Environments in Dobermann represent different API targets (Production, Staging, Development, etc.) with their own authentication and configuration. Managing environments allows you to easily switch between different servers and maintain separate configurations for each.

## Overview

Each environment contains:
- **Connection details** - Base URL and environment metadata
- **Authentication** - JWT tokens or OAuth configuration
- **Organization selection** - For Manhattan Active APIs
- **Mock mode** - Option to use mock responses for testing

## Managing Environments

### Adding Environments

1. Click the **+ icon** next to "Environments" in the sidebar
2. Fill in environment details
3. Configure authentication method
4. Click **Save Environment**

The environment will appear in the sidebar tree view, grouped by type.

### Editing Environments

1. Click an environment name in the sidebar
2. Modify any details in the webview
3. Changes are saved automatically

### Deleting Environments

1. Right-click an environment in the sidebar
2. Select **Delete Environment**
3. Confirm the deletion

**Note:** Deleting an environment does not delete associated endpoints - they will remain but show as disconnected until assigned to another environment.

### Setting Active Environment

1. Right-click an environment in the sidebar
2. Select **Set as Active**
3. The active environment is used for all endpoint executions

The currently active environment is shown with a checkmark in the tree view.

## Environment Details

### Environment Name

A descriptive name for the environment (e.g., "Production US", "Staging Europe", "Dev Sandbox").

**Best practices:**
- Use clear, descriptive names
- Include region or tenant if managing multiple instances
- Avoid special characters that might cause issues

### Environment Type

Categorizes the environment for visual organization in the tree view:

- **Production** - Live production systems
- **Staging** - Pre-production testing
- **UAT** - User acceptance testing
- **QA/Testing** - Quality assurance
- **Development** - Active development (default)
- **Sandbox** - Experimental/demo
- **Training** - Training environment
- **Integration** - Integration testing
- **Performance** - Performance testing
- **Local** - Local development

Environments are grouped and sorted by type in the sidebar.

### Base URL

The primary API endpoint for this environment.

**Examples:**
- `https://tenant.sce.manh.com` - Manhattan Active
- `https://api.github.com` - GitHub API
- `https://api.staging.example.com` - Staging server
- `http://localhost:8080` - Local development

**Important:**
- Must include protocol (`https://` or `http://`)
- Do not include trailing slash
- This URL is prepended to all endpoint paths
- **URL is immutable after creation** - Once an environment is saved, the Base URL cannot be changed. This ensures batch executions always target the correct server. If you need a different URL, create a new environment.

### Description

Optional field for notes about the environment:
- Purpose and use cases
- Access restrictions
- Tenant or customer information
- Maintenance windows

### Mock Requests

When enabled, API requests use mock responses instead of calling real endpoints.

**Use cases:**
- Testing endpoint configuration without hitting real APIs
- Demonstrating functionality without credentials
- Development when backend is unavailable

**Limitations:**
- Mock responses are simplified and may not reflect actual API behavior
- Only basic success scenarios are mocked
- Not suitable for integration testing

## Authentication

Dobermann supports two authentication methods:

### Manual JWT Token

Direct authentication using a JWT (JSON Web Token).

**How to use:**
1. Select "Manual JWT Token" as authentication method
2. Obtain a JWT token from your API provider
3. Paste the token in the text area
4. Click **Save Environment**

**Token format:**
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
```

**Token expiration:**
- Dobermann displays token expiration time if available
- Visual warnings appear when token is about to expire
- Refresh the token manually when needed

**Best practices:**
- Store tokens securely
- Rotate tokens regularly
- Use environment-specific tokens
- Never commit tokens to source control

### OAuth

OAuth 2.0 authentication flow for secure, delegated access.

**Required fields:**
- **Client ID** - Your OAuth application identifier
- **Authorization URL** - OAuth provider's authorization endpoint
- **Token URL** - OAuth provider's token endpoint
- **Redirect URI** - Callback URL (usually provided by Dobermann)

**Optional fields:**
- **Client Secret** - Required for confidential clients (toggle visibility with eye button)
- **Scopes** - Space-separated list of requested permissions

**OAuth flow:**
1. Configure OAuth settings
2. Click **Authenticate with OAuth**
3. Browser opens to authorization URL
4. Log in and grant permissions
5. Dobermann receives token automatically

**Token management:**
- Access tokens are stored securely
- Refresh tokens are used automatically when access token expires
- Visual indicators show authentication status
- Click **Re-authenticate** if token becomes invalid

**Relative URLs:**
Dobermann supports relative URLs for OAuth endpoints. If authorization URL or token URL starts with `/`, it will be automatically prepended with the environment's base URL.

**Example:**
```
Base URL: https://tenant.sce.manh.com
Authorization URL: /oauth/authorize
Token URL: /oauth/token

Resolves to:
Authorization URL: https://tenant.sce.manh.com/oauth/authorize
Token URL: https://tenant.sce.manh.com/oauth/token
```

## Headers
{: #headers }

Environment-level headers are automatically included in every request. Toggle **Include environment-level headers** on any endpoint to inherit them.

Manhattan Active environments automatically include organization headers (see below). You can also add custom headers in the environment's header configuration.

## Organization Selection (Manhattan Active)

Manhattan Active APIs require organization headers. Dobermann automatically detects available organizations and provides a selection interface.

**How it works:**
1. After authentication, Dobermann fetches available organizations
2. Select your organization from the dropdown
3. Organization headers are automatically added to all requests
4. Switch organizations anytime without re-authenticating

**Organization headers added:**
- `X-Organization-Id`
- `X-Tenant-Id`
- Other Manhattan Active-specific headers

**Visual indicators:**
- Green checkmark - Organization selected
- Warning icon - No organization selected (required for Manhattan Active)

## Variables
{: #variables }

Environment variables are key-value pairs accessible in templates via the `ENV:` prefix (e.g. `{{ENV:warehouse}}`). Set them in the Variables section of your environment configuration.

Common uses:
- Organization codes, warehouse IDs, tenant identifiers
- API keys and tokens that vary between environments
- Default values shared across multiple endpoints

See [Template Variables — ENV](template-variables#environment-variables-env) for usage syntax.

## Environment Tree View

Environments appear in the sidebar tree view with these indicators:

**Status icons:**
- Checkmark - Active environment (used for executions)
- Lock - Authenticated
- Warning - Authentication required or expired
- Building - Organization selected

**Actions:**
- Click name - Open environment editor
- Right-click - Context menu with actions
- Drag endpoints - Move endpoints between environments

## Troubleshooting

### Token Expired

**Symptoms:** API requests return 401 Unauthorized

**Solutions:**
- **JWT:** Paste a new token in environment settings
- **OAuth:** Click "Re-authenticate with OAuth"

### OAuth Flow Fails

**Symptoms:** Browser opens but authentication doesn't complete

**Check:**
- Redirect URI matches OAuth provider configuration
- Client ID and secret are correct
- Authorization URL and token URL are valid
- Network connectivity to OAuth provider

### Environment Not Selectable

**Symptoms:** Cannot set environment as active

**Solutions:**
- Ensure environment has valid authentication
- Check that base URL is accessible
- Verify environment is saved (not in unsaved state)

### API Calls Use Wrong URL

**Symptoms:** Requests go to incorrect server

**Check:**
- Correct environment is set as active (checkmark)
- Base URL in environment settings is correct
- Base URL does not have trailing slash
- Endpoint paths start with `/`

## Related Topics

- [Endpoints](endpoints) - Configure and manage API endpoints
- [Execution](execution) - Execute requests against environments
- [Import/Export](import-export) - Share environment configurations (excludes sensitive data)
