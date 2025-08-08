## Install Requirements

brew install ocrmypdf tesseract
pip install markitdown

## Debian / Ubuntu

sudo apt install -y ocrmypdf tesseract-ocr
pip install markitdown

## Run IT

chmod +x scan2md.sh
./scan2md.sh scanned_book.pdf

Checks that a scanned PDF file is provided as input.

Installs required tools (ocrmypdf and markitdown) if missing.

Runs OCR on the scanned PDF to create a searchable PDF with embedded text.

Uses markitdown to convert the searchable PDF into a clean, formatted Markdown file (*_full.md).

Parses the full Markdown file and splits it into separate chapter files (*_chapter_01.md, *_chapter_02.md, etc.) based on detecting chapter-like headings such as:

# Heading

Chapter 1, CHAPTER I, Chapter One

Part Two, SECTION 3, etc.

Generates an index file listing all chapter files (*_chapters_index.md).

Outputs:

A searchable PDF copy of the original.

A full Markdown file with the entire book.

Multiple Markdown files split by chapter for easy editing or publishing.
