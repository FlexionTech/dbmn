# CLAUDE.md — Dobermann (dbmn.io)

## Overview
Public website, documentation, and blog for Dobermann (https://dbmn.io).
Built with Jekyll + just-the-docs theme. Deployed via GitHub Actions on push to main.

## Structure
- `index.html` — Landing page (custom HTML, not processed by Jekyll theme)
- `docs/` — User documentation (Markdown, processed by Jekyll)
- `docs/index.md` — Documentation hub with quick links
- `docs/changelog.md` — Release history
- `blog/index.md` — Blog listing page
- `_posts/` — Blog posts (YYYY-MM-DD-title-slug.md format)
- `images/` — Site images and logos
- `_config.yml` — Jekyll configuration
- `.github/ISSUE_TEMPLATE/` — Public issue templates
- `.github/workflows/deploy-pages.yml` — GitHub Actions deployment workflow
- `scripts/escape-templates.sh` — Utility to escape `{{}}` for Liquid (not used in build pipeline)

## Adding a New Doc Page
1. Create `docs/page-name.md` with front matter:
   ```yaml
   ---
   title: Page Title
   layout: default
   nav_order: N
   parent: Documentation
   ---
   ```
2. Add to quick links table in `docs/index.md`
3. Commit and push — auto-deploys in ~60 seconds

## Adding a Blog Post
1. Create `_posts/YYYY-MM-DD-title-slug.md` with front matter:
   ```yaml
   ---
   title: "Post Title"
   layout: default
   ---
   ```
2. Commit and push — auto-deploys

## Template Variable Syntax in Docs
Dobermann uses `{{variable}}` syntax which clashes with Jekyll's Liquid templating.
This is handled automatically — **write docs with `{{}}` naturally**, no escaping needed.

The `_config.yml` sets `render_with_liquid: false` for all files under `docs/`,
which tells Jekyll 4 to skip Liquid processing entirely on documentation pages.
Source files in the repo stay clean and readable.

**Important:** This only applies to `docs/*.md` files. Blog posts and `index.html`
may use real Liquid syntax (e.g. `{{ post.title }}`) and are processed normally.

## Key Rules
- This is the single source of truth for user-facing documentation
- The private repo (vs_active_8) contains internal dev docs only
- Docs should be updated DURING feature development, not after
- Changelog entries go in `docs/changelog.md`
- Do not add internal development documentation here (devNotes, requirements, bugFixes)
- Blog posts go in `_posts/` — use for release announcements, tips, use cases
- Write `{{variable}}` naturally in docs — `render_with_liquid: false` handles it
