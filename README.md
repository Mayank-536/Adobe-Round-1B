# PDF Document Analyzer

The PDF Document Analyzer is a Python application designed to extract, rank, and refine information from PDF documents based on a user-defined persona and job-to-be-done. It utilizes `pdfplumber` for text extraction, `pytesseract` for OCR capabilities, and a locally-run TinyLlama model for intelligent ranking and summarization of document sections.

## Features

* **Intelligent Heading Extraction:** Identifies potential headings in PDFs based on font size, boldness, and a calculated "heading score."
* **OCR Fallback:** Automatically switches to OCR (Optical Character Recognition) using `pytesseract` for PDFs where direct text extraction is not possible (e.g., scanned documents).
* **AI-Powered Ranking:** Employs a TinyLlama language model to score the relevance of extracted headings to a specific `persona` and `job-to-be-done`.
* **Contextual Text Refinement:** Uses the TinyLlama model to extract and refine the text content immediately following high-ranking headings, focusing on key information relevant to the defined task.
* **Structured Output:** Generates a JSON output containing metadata, ranked document sections, and refined subsection analysis.
* **Dockerized Deployment:** Provides a `Dockerfile` for easy setup and deployment in a containerized environment, ensuring all dependencies are met.

---

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

* Python 3.8+
* `pip` (Python package installer)
* `tesseract-ocr` (and its language data)
* `poppler-utils` (for `pdf2image`)
* A pre-trained TinyLlama GGUF model (e.g., `tinyllama-1.1b-chat-v1.0.Q4_0.gguf`)

### Installation (Local)

1.  **Clone the repository:**

    ```bash
    git clone [https://github.com/your-username/pdf-document-analyzer.git](https://github.com/your-username/pdf-document-analyzer.git)
    cd pdf-document-analyzer
    ```

2.  **Install system dependencies:**

    * **Debian/Ubuntu:**
        ```bash
        sudo apt update
        sudo apt install tesseract-ocr poppler-utils build-essential cmake
        ```
    * **macOS (using Homebrew):**
        ```bash
        brew install tesseract poppler
        # For llama.cpp dependencies (might be needed for local builds if not using pre-built wheels)
        brew install cmake
        ```
    * **Windows:** Install Tesseract-OCR and Poppler for Windows. You may need to add their executables to your system's PATH. Building `llama-cpp-python` on Windows can be complex; consider using WSL2 or Docker.

3.  **Install Python dependencies:**

    ```bash
    pip install -r requirements.txt
    ```

4.  **Download the TinyLlama model:**
    Download the `tinyllama-1.1b-chat-v1.0.Q4_0.gguf` model file and place it in the project root directory. You can typically find this model on Hugging Face or similar model repositories. Ensure the filename matches what's expected in `TinyLlamaRanker` class.

---

## Usage

### Preparing Input

The application requires an input JSON file that defines the `persona`, `job_to_be_done`, and a list of `documents` to be analyzed.

**Example `input.json`:**

```json
{
  "persona": {
    "role": "Financial Analyst"
  },
  "job_to_be_done": {
    "task": "Identify key financial performance indicators and risk factors from company reports."
  },
  "documents": [
    {
      "filename": "annual_report_2023.pdf"
    },
    {
      "filename": "quarterly_earnings_q1_2024.pdf"
    }
  ]
}