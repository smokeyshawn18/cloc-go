// Package counter contains logic for counting lines of code and summarizing results.
package counter

import (
	"os"
	"path/filepath"
	"strings"

	"cloc-go/internal/lang"
)

// FileResult holds the LOC count and language for a single file.
type FileResult struct {
	FilePath string
	Language string
	Lines    int
}

// CountLines counts lines of code in all files in the given directory.
func CountLines(dir string) ([]FileResult, error) {
	var results []FileResult

	// Directories to skip
	skipDirs := map[string]struct{}{
		".git":         {},
		"node_modules": {},
		"vendor":       {},
		".vscode":      {},
		"dist":         {},
		"build":        {},
		".cache":       {},
	}

	err := filepath.Walk(dir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			// Continue on read error
			return nil
		}

		// Skip hidden files and directories
		base := filepath.Base(path)
		if strings.HasPrefix(base, ".") && base != ".env" {
			if info.IsDir() {
				return filepath.SkipDir
			}
			return nil
		}

		// Skip unwanted directories
		if info.IsDir() {
			if _, shouldSkip := skipDirs[base]; shouldSkip {
				return filepath.SkipDir
			}
			return nil
		}

		// Detect language
		language := lang.DetectLanguage(path)
		if language == "Unknown" {
			return nil
		}

		// Read file and count non-empty lines
		content, err := os.ReadFile(path)
		if err != nil {
			return nil // Skip unreadable files
		}

		lines := countNonEmptyLines(string(content))

		results = append(results, FileResult{
			FilePath: path,
			Language: language,
			Lines:    lines,
		})

		return nil
	})

	if err != nil {
		return nil, err
	}
	return results, nil
}

// countNonEmptyLines counts non-empty, non-whitespace lines in content.
func countNonEmptyLines(content string) int {
	lines := strings.Split(content, "\n")
	count := 0
	for _, line := range lines {
		if strings.TrimSpace(line) != "" {
			count++
		}
	}
	return count
}

// Summarize aggregates total lines by language and also returns total LOC.
func Summarize(results []FileResult) (map[string]int, int) {
	summary := make(map[string]int)
	total := 0
	for _, result := range results {
		summary[result.Language] += result.Lines
		total += result.Lines
	}
	return summary, total
}
