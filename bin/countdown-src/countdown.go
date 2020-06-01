package main

import (
	"fmt"
       "bufio"
       "os"
       "time"
)

type UserEvent int
const (
       PAUSE UserEvent = iota
       EXIT
)

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
              targetSeconds, err = TargetTime(os.Args[1])
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

       timer := NewTimer()
       go countdown(timer, targetSeconds, count)
       go takeInput(events)
       RawPrintln("Press `q` to exit or `p` to pause.")
       // Keep program going while goroutines are exeuting
       for {
              if timer.HasFinished() {
                     return 0, nil
              }

              select {
              case elapsed := <-count:
                     TimePanel(targetSeconds, elapsed)
              case event := <-events:
                     // If a timer tick came in at the same time process that first
                     if len(count) > 0 {
                            elapsed := <- count
                            TimePanel(targetSeconds, elapsed)
                     }
                     switch event {
                     case PAUSE:
                            timer.TogglePaused()
                     case EXIT:
                            return 0, nil
                     }
              }
       }
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

func countdown(timer Timer, targetSeconds int, count chan<- int) {
       secondsElapsed := 0

       for true {
              for timer.IsPaused() {}
              if targetSeconds == secondsElapsed {
                     RawPrintln("Countdown finished.")
                     timer.SetFinished()
              }
              count <- secondsElapsed
              secondsElapsed++
              time.Sleep(time.Second)
       }
}
