#!/usr/bin/env python3

import os
import json
import sys
from pathlib import Path
from Model_1b import DocumentAnalyzer

def create_input_json(pdf_filename):
    """Create a default input JSON configuration for a PDF file."""
    return {
        "persona": {
            "role": "Document Analyst"
        },
        "job_to_be_done": {
            "task": "Extract and analyze key sections from the document"
        },
        "documents": [
            {
                "filename": pdf_filename
            }
        ]
    }

def process_pdfs(input_dir, output_dir):
    # Create output directory if it doesn't exist
    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)
    
    # Initialize analyzer with input directory
    analyzer = DocumentAnalyzer(input_dir)
    
    # Process each PDF file
    pdf_files = list(Path(input_dir).glob("*.pdf"))
    if not pdf_files:
        print("No PDF files found in input directory", file=sys.stderr)
        return
    
    for pdf_path in pdf_files:
        try:
            # Create temporary input JSON for this PDF
            temp_json_path = output_dir / f"{pdf_path.stem}_input.json"
            input_config = create_input_json(pdf_path.name)
            
            with open(temp_json_path, 'w', encoding='utf-8') as f:
                json.dump(input_config, f, indent=2)
            
            # Process the PDF
            result = analyzer.analyze(str(temp_json_path))
            
            # Save the output
            output_path = output_dir / f"{pdf_path.stem}.json"
            with open(output_path, 'w', encoding='utf-8') as f:
                json.dump(result, f, indent=2)
            
            print(f"Processed {pdf_path.name} -> {output_path.name}")
            
            # Clean up temporary input JSON
            temp_json_path.unlink()
            
        except Exception as e:
            print(f"Error processing {pdf_path.name}: {str(e)}", file=sys.stderr)
            continue
    
    # Create summary file
    summary = {
        "processed_files": [f"{pdf.stem}.json" for pdf in pdf_files],
        "total_files": len(pdf_files)
    }
    
    with open(output_dir / "output.json", 'w', encoding='utf-8') as f:
        json.dump(summary, f, indent=2)

if __name__ == "__main__":
    input_dir = "/app/input"
    output_dir = "/app/output"
    process_pdfs(input_dir, output_dir)
