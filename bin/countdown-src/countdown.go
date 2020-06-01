package main

import (
	"fmt"
       "os"
       "time"
       "strconv"
)

type UserEvent int
const (
       Pause UserEvent = iota
       Exit
)

func main() {
       var targetSeconds int
       if len(os.Args) > 1 {
              var err error
              targetSeconds, err = targetTime(os.Args[1])
              if err != nil {
                     fmt.Println("%s is not a valid number!", os.Args[1])
                     os.Exit(1)
              }
       } else {
              targetSeconds = -1
       }

       count := make(chan int)
       events := make(chan UserEvent)

       go countdown(targetSeconds, count)
       go takeInput(events)
       fmt.Println("Press `q` to exit or `p` to pause.\n")
       // Keep program going while goroutines are exeuting
       for {
              select {
              case elapsed := <-count:
                     fmt.Printf("Target: %s\nCurrent: %s\n", formatTime(targetSeconds), formatTime(elapsed))
              case event := <-events:
                     switch event {
                     case Pause:
                            fmt.Println("Should pause")
                     case Exit:
                            os.Exit(0)
                     }
              }
       }
}

func formatTime(seconds int) string {
       if seconds < 0 {
              return "NaN"
       }
       return fmt.Sprintf("%d:%d", seconds / 60, seconds % 60)
}

func targetTime(input string) (int, error) {
       userInput, err := strconv.Atoi(os.Args[1])
       if err != nil {
              return -1, err
       }
       return 60 * userInput, nil
}

func takeInput(events chan<- UserEvent) {
}

func countdown(targetSeconds int, count chan<- int) {
       secondsElapsed := 0

       for true {
              if targetSeconds == secondsElapsed {
                     fmt.Println("Countdown finished.")
                     os.Exit(0)
              }
              count <- secondsElapsed
              secondsElapsed++
              time.Sleep(time.Second)
       }
}
