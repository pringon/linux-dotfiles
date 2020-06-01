package main

type Timer interface {
	IsPaused() bool
	TogglePaused()

	HasFinished() bool
	SetFinished()
}

type State struct {
	finished, paused bool
}

func NewTimer() Timer {
	return &State{finished: false, paused: false}
}

func (s *State) IsPaused() bool {
	return s.paused
}

func (s *State) TogglePaused() {
	s.paused = !s.paused
}

func (s *State) HasFinished() bool {
	return s.finished
}

func (s *State) SetFinished() {
	s.finished = true
}
