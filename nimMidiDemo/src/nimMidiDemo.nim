# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.

import winim
import MIDIData

proc main() =
  let midiData: ptr MIDIData = MIDIData_Create(MIDIDATA_FORMAT0, 1, MIDIDATA_TPQNBASE, 120)
  let midiTrack: ptr MIDITrack = MIDIData_GetFirstTrack(midiData)
  MIDITrack_InsertTrackNameW(midiTrack, 0, &T"ドレミ")
  MIDITrack_InsertTempo(midiTrack, 0, clong(60000000 / 120))
  MIDITrack_InsertProgramChange(midiTrack, 0, 0, 1)

  # 音符
  MIDITrack_InsertNote(midiTrack, 0, 0, 60, 100, 120) # ド
  MIDITrack_InsertNote(midiTrack, 120, 0, 62, 100, 120) # レ
  MIDITrack_InsertNote(midiTrack, 240, 0, 64, 100, 120) # ミ

  MIDITrack_InsertEndofTrack(midiTrack, 360)
  MIDIData_SaveAsSMFW(midiData, &T"doremi.midi")
  MIDIData_Delete(midiData)

when isMainModule:
  main()
