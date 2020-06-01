package main

import (
	"fmt"
       "bufio"
       "os"
       "time"
       "strconv"
)

type UserEvent int
const (
       PAUSE UserEvent = iota
       EXIT
)

var countdownFinished = false
var countdownPaused = false

func main() {
       // Run the entire program within another function because
       // os.Exit does not honor defers
       exitCode, err := bootstrap()
       if err != nil {
              panic(err)
       }
       os.Exit(exitCode)
}

func bootstrap() (int, error) {
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

       // Set terminal discipline to raw mode
       termios, err := MakeRawTerminal()
       if err != nil {
              return 1, err
       }
       defer RestoreTerminalDiscipline(termios)

       go countdown(targetSeconds, count)
       go takeInput(events)
       rawPrintln("Press `q` to exit or `p` to pause.")
       // Keep program going while goroutines are exeuting
       for {
              if countdownFinished {
                     return 0, nil
              }

              select {
              case elapsed := <-count:
                     timePanel(targetSeconds, elapsed)
              case event := <-events:
                     if len(count) > 0 {
                            elapsed := <- count
                            timePanel(targetSeconds, elapsed)
                     }
                     switch event {
                     case PAUSE:
                            countdownPaused = !countdownPaused
                     case EXIT:
                            return 0, nil
                     }
              }
       }
}

func timePanel(target int, elapsed int) {
       rawPrintln(fmt.Sprintf("Target: %s", formatTime(target)))
       rawPrintln(fmt.Sprintf("Current: %s", formatTime(elapsed)))
}

// When running in raw mode \n does not get expandend to \n\r
func rawPrintln(str string) {
       fmt.Printf("%s\n\r", str)
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
       reader := bufio.NewReader(os.Stdin)
       for {
              event, _, err := reader.ReadRune()
              if err != nil {
                     panic(err)
              }

              switch event {
              case 'q':
                     events <- EXIT
              case 'p':
                     events <- PAUSE
              default:
                     fmt.Println("Press `q` to exit or `p` to pause.\n")
              }
       }
}

func countdown(targetSeconds int, count chan<- int) {
       secondsElapsed := 0

       for true {
              for countdownPaused {}
              if targetSeconds == secondsElapsed {
                     rawPrintln("Countdown finished.")
                     countdownFinished = true
              }
              count <- secondsElapsed
              secondsElapsed++
              time.Sleep(time.Second)
       }
}
