package main

import (
	"cloc-go/internal/counter"
	"fmt"
	"os"

	"github.com/spf13/cobra"
)

var (
    version = "v1.0.0" // define your version here

    outputFormat string
    showVersion  bool
)

var mainCmd = &cobra.Command{
    Use:   "cloc-go [directory]",
    Short: "Count lines of code in a directory and identify programming languages",
    Args:  cobra.MaximumNArgs(1),
    RunE: func(cmd *cobra.Command, args []string) error {
        if showVersion {
            fmt.Println("cloc-go version:", version)
            return nil
        }

        dir := "."
        if len(args) > 0 {
            dir = args[0]
        }

        results, err := counter.CountLines(dir)
        if err != nil {
            return fmt.Errorf("failed to count lines: %v", err)
        }

        if outputFormat == "json" {
            // hypothetic JSON output, implement accordingly
            // e.g. json.NewEncoder(os.Stdout).Encode(results)
            return nil
        }

        // Default: human-readable output
        fmt.Println("Lines of Code by File:")
        fmt.Println("----------------------")
        for _, result := range results {
            fmt.Printf("%s (%s): %d lines\n", result.FilePath, result.Language, result.Lines)
        }

        summary := counter.Summarize(results)
        fmt.Println("\nSummary by Language:")
        fmt.Println("----------------------")
        for lang, lines := range summary {
            fmt.Printf("%s: %d lines\n", lang, lines)
        }

        return nil
    },
}

func init() {
    mainCmd.Flags().BoolVarP(&showVersion, "version", "v", false, "Show version information")
    mainCmd.Flags().StringVarP(&outputFormat, "output", "o", "text", "Output format: text or json")
}

func main() {
    if err := mainCmd.Execute(); err != nil {
        fmt.Fprintf(os.Stderr, "Error: %v\n", err)
        os.Exit(1)
    }
}
