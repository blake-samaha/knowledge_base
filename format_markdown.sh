#!/bin/bash

# Format all Markdown files in the repository
# Usage: ./format_markdown.sh

echo "🔧 Formatting Markdown files..."

# Activate virtual environment to ensure pre-commit is available
source .venv/bin/activate

# Run mdformat and markdownlint via pre-commit to ensure consistent behavior
pre-commit run mdformat --all-files --disable-extension number
pre-commit run markdownlint --all-files

echo "✅ Markdown formatting complete!"
echo "📝 Run 'pre-commit run --all-files' to run all checks"
