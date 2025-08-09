# cloc-go

A lightweight command-line tool written in Go to count lines of code (LOC) in a directory and identify programming languages. Ideal for analyzing codebases like React or WebApp projects.

## Features

- Counts non-empty lines in source code files.
- Identifies programming languages based on file extensions.
- Supports common languages: Go, JavaScript, TypeScript, Python, Java, C++, C, HTML, CSS, JSON, Markdown.
- Provides per-file details and a summary by language.
- Fast and portable, with a single binary.

## Installation

1. **Download and Install**:
   ```bash
   curl -sSL https://raw.githubusercontent.com/smokeyshawn18/cloc-go/main/install.sh | bash
   ```

Usage

Run cloc-go in a directory to analyze its code:

cloc-go [directory]

[directory]: Optional path to analyze (defaults to current directory).

Development



Build

chmod +x build.sh
./build.sh

Creates bin/cloc-go (binary) and bin/cloc-go-v1.0.0.zip (archive).

Install Locally

chmod +x install.sh
./install.sh

Installs to /usr/local/bin/cloc-go and tags the repository with v1.0.0.
