package main

import (
	"fmt"
	"strconv"
)

// When running in raw mode \n does not get expandend to \n\r
func RawPrintln(str string) {
	fmt.Printf("%s\n\r", str)
}

func TargetTime(input string) (int, error) {
	userInput, err := strconv.Atoi(input)
	if err != nil {
			return -1, err
	}
	return 60 * userInput, nil
}

func TimePanel(target int, elapsed int) {
	RawPrintln(fmt.Sprintf("Target: %s", formatTime(target)))
	RawPrintln(fmt.Sprintf("Current: %s", formatTime(elapsed)))
}

func formatTime(seconds int) string {
	if seconds < 0 {
			return "NaN"
	}
	return fmt.Sprintf("%d:%d", seconds / 60, seconds % 60)
}
