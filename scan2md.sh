#!/bin/bash
# Usage: ./scan2md.sh scanned.pdf
# Output: full_book.md + chapter_01.md, chapter_02.md, ...

if [ -z "$1" ]; then
    echo "Usage: $0 <scanned.pdf>"
    exit 1
fi

INPUT="$1"
BASENAME="${INPUT%.*}"

# ---- Check & install dependencies ----
if ! command -v ocrmypdf &> /dev/null; then
    echo "Installing ocrmypdf..."
    if command -v brew &> /dev/null; then
        brew install ocrmypdf
    else
        sudo apt install -y ocrmypdf
    fi
fi

if ! command -v markitdown &> /dev/null; then
    echo "Installing markitdown..."
    pip install markitdown
fi

# ---- Step 1: OCR the scanned PDF ----
echo "📄 Running OCR..."
ocrmypdf --tesseract-pagesegmode 1 --tesseract-oem 1 "$INPUT" "${BASENAME}_searchable.pdf"

# ---- Step 2: Convert to Markdown ----
echo "📝 Converting to Markdown with markitdown..."
markitdown "${BASENAME}_searchable.pdf" > "${BASENAME}_full.md"

# ---- Step 3: Split into chapters with advanced detection ----
echo "📚 Splitting into chapters..."
CHAPTER_NUM=0
CHAPTER_FILE=""

# Regex for chapter headings
CHAPTER_REGEX='^(# |CHAPTER|Chapter|PART|Part|Section|SECTION)[[:space:]]*([0-9IVXLC]+|One|Two|Three|Four|Five|Six|Seven|Eight|Nine|Ten)?'

while IFS= read -r line; do
    if [[ "$line" =~ $CHAPTER_REGEX ]]; then
        ((CHAPTER_NUM++))
        CHAPTER_FILE=$(printf "%s_chapter_%02d.md" "$BASENAME" "$CHAPTER_NUM")
        echo "$line" > "$CHAPTER_FILE"
        echo "$line" >> "${BASENAME}_chapters_index.md"
    else
        [[ -n "$CHAPTER_FILE" ]] && echo "$line" >> "$CHAPTER_FILE"
    fi
done < "${BASENAME}_full.md"

echo "✅ Done!"
echo "Full Markdown: ${BASENAME}_full.md"
echo "Chapter files: ${BASENAME}_chapter_01.md ... (see ${BASENAME}_chapters_index.md for list)"
echo "Searchable PDF: ${BASENAME}_searchable.pdf"
