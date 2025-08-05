#!/bin/bash

# Format all Markdown files in the repository
# Usage: ./format_markdown.sh

echo "🔧 Formatting Markdown files..."

# Activate virtual environment and run mdformat
source .venv/bin/activate && mdformat --wrap=80 docs/

echo "✅ Markdown formatting complete!"
echo "📝 Run 'pre-commit run --all-files' to run all checks"
