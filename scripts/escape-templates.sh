#!/bin/bash
# Escape {{...}} patterns in docs for Jekyll/Liquid processing.
# Wraps all {{...}} occurrences in {% raw %}...{% endraw %} tags
# so Liquid doesn't interpret them as template variables.
#
# Only processes docs/*.md files — blog and root pages may use
# real Liquid syntax ({{ post.title }}) and must not be escaped.

set -e

DOCS_DIR="${1:-docs}"

if [ ! -d "$DOCS_DIR" ]; then
    echo "Directory $DOCS_DIR not found"
    exit 1
fi

count=0
for file in "$DOCS_DIR"/*.md; do
    [ -f "$file" ] || continue

    # Replace {{...}} with {% raw %}{{...}}{% endraw %}
    # Pattern: {{ followed by anything except }}, then }}
    # Uses perl for non-greedy matching and proper escaping
    if grep -q '{{' "$file" 2>/dev/null; then
        perl -i -pe 's/\{\{((?:(?!\}\}).)*?)\}\}/{% raw %}{{\1}}{% endraw %}/g' "$file"
        count=$((count + 1))
        echo "Processed: $file"
    fi
done

echo "Escaped template variables in $count file(s)"
