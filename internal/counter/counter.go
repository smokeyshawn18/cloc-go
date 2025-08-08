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

func shouldSkipDir(dirName string) bool {
    skipDirs := map[string]struct{}{
        "node_modules": {},
        ".git":         {},
        "vendor":       {},
        "dist":         {},
        ".next":        {},
        "env":          {},
        "build":        {},
        "out":          {},
        "coverage":     {},
        "tmp":          {},
        "temp":         {},
        "logs":         {},
        "log":          {},
        "cache":        {},
    }
    _, skip := skipDirs[dirName]
    return skip
}

// isSkippedFile checks if the file has an extension that should be skipped.
func isSkippedFile(fileName string) bool {
    skipExts := map[string]struct{}{
        ".json": {},
		".lock": {}, // e.g. package-lock.json, yarn.lock
		".txt":  {}, // plain text files
		".log":  {}, // log files
		".md":   {}, // markdown files
		".xml":  {}, // XML files
		".yml":  {}, // YAML files
		".yaml": {}, // YAML files
		".csv":  {}, // CSV files
		".svg":  {}, // SVG files
		".ico":  {}, // icon files
		".gif":  {}, // GIF images
		
        // add more extensions here if needed, e.g. ".md", ".lock"
    }
    ext := strings.ToLower(filepath.Ext(fileName))
    _, skip := skipExts[ext]
    return skip
}

func CountLines(dir string) ([]FileResult, error) {
    var results []FileResult

    err := filepath.Walk(dir, func(path string, info os.FileInfo, err error) error {
        if err != nil {
            return err
        }
        if info.IsDir() {
            base := filepath.Base(path)
            if shouldSkipDir(base) {
                return filepath.SkipDir
            }
            return nil
        }

        if isSkippedFile(path) {
            return nil // Skip files with extensions to be skipped
        }

        language := lang.DetectLanguage(path)
        if language == "Unknown" {
            return nil // Skip unknown file types
        }

        content, err := os.ReadFile(path)
        if err != nil {
            return err
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
        trimmed := strings.TrimSpace(line)
        if trimmed != "" {
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
