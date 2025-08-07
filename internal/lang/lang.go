// Package lang contains logic for detecting programming languages based on file extensions.
package lang

import (
	"path/filepath"
	"strings"
)

// DetectLanguage identifies the programming language based on file extension.
func DetectLanguage(filePath string) string {
	ext := strings.ToLower(filepath.Ext(filePath))
	switch ext {
	case ".go":
		return "Go"
	case ".js", ".jsx":
		return "JavaScript"
	case ".ts", ".tsx":
		return "TypeScript"
	case ".py":
		return "Python"
	case ".java":
		return "Java"
	case ".cpp", ".cxx", ".cc":
		return "C++"
	case ".c":
		return "C"
	case ".html":
		return "HTML"
	case ".css":
		return "CSS"
	case ".json":
		return "JSON"
	case ".md":
		return "Markdown"
	case ".sh":
		return "Shell Script"
	case ".rb":
		return "Ruby"
	case ".php":
		return "PHP"
	case ".swift":
		return "Swift"
	case ".rs":
		return "Rust"
	default:
		return "Unknown"
	}
}