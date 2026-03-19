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

## Pipes in Markdown Table Code
Kramdown uses `|` as the table column separator. If you need a literal `|` inside
a backtick code span within a table cell, the backslash escape (`\|`) does NOT work
inside backticks — it renders as `\|` literally.

**Use `<code>` with `&#124;` instead:**
```
| Modifier | Example |
|----------|---------|
| Upper | <code>{{SKU:string&#124;upper}}</code> |
```

This renders as `{{SKU:string|upper}}` in the browser. Only needed for code spans
inside table cells that contain pipes. Regular text pipes use `\|` as normal.

## Code Block Syntax Highlighting
- Use `json` for valid JSON blocks (no comments, no trailing commas)
- Use `javascript` for JSONC blocks (with `//` comments or trailing commas)
- Use plain ` ``` ` for non-code content (error messages, plain text examples)

## Changelog
The **extension repo** (`vs_active_8/CHANGELOG.md`) is the single source of truth for the changelog.
`docs/changelog.md` here is a **copy** with YAML front matter added for Jekyll.

- **Never edit `docs/changelog.md` directly** — always update `vs_active_8/CHANGELOG.md` first
- At release time, the extension changelog content is copied here with YAML front matter added
- Both files must stay in sync

## Video Assets
Videos live in `assets/videos/`. Before embedding a video in any page or committing a new video file, check:

1. **Size** — should be under 2MB. If larger, compress with:
   ```bash
   ffmpeg -i INPUT.mp4 -an -c:v libx264 -crf 28 -preset slow -r 15 -movflags +faststart OUTPUT.mp4
   ```
2. **Faststart** — the `moov` atom must be at the start of the file, not the end. Verify with:
   ```bash
   python3 -c "
   import struct; f = open('FILE.mp4', 'rb'); pos = 0
   for _ in range(5):
       h = f.read(8)
       if len(h) < 8: break
       size = struct.unpack('>I', h[:4])[0]; name = h[4:8].decode('ascii', errors='replace')
       print(f'offset={pos} atom={name} size={size}'); f.seek(pos + size); pos += size
   "
   ```
   The `moov` atom should appear before `mdat`. If not, re-run the ffmpeg command above (`-movflags +faststart` fixes it).
3. **No audio** — strip audio with `-an` for screen recordings (saves ~10-15% file size)
4. **No junk files** — delete `Zone.Identifier` files and unused originals before committing

## Key Rules
- This is the single source of truth for user-facing documentation
- The private repo (vs_active_8) contains internal dev docs only
- Docs should be updated DURING feature development, not after
- Changelog source of truth is `vs_active_8/CHANGELOG.md` — `docs/changelog.md` is a copy
- Do not add internal development documentation here (devNotes, requirements, bugFixes)
- Blog posts go in `_posts/` — use for release announcements, tips, use cases
- Write `{{variable}}` naturally in docs — `render_with_liquid: false` handles it
