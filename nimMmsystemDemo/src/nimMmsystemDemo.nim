# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.

import math
import terminal
import winim/inc/mmsystem

const SRATE = 44100
const PI = 3.14159286

proc main() =
  var hWave: HWAVEOUT
  var whdr: WAVEHDR
  var wfe: WAVEFORMATEX
  var b_time = 1.0
  let data_len = int32(SRATE * b_time)
  var bWave: cstring = cast[cstring](alloc0(data_len))
  var f0 = 440.0
  var amplitude = 40.0

  for count in 0..data_len:
    bWave[count] = char(amplitude * sin(2 * PI * f0 * float(count) / SRATE))

  wfe.wFormatTag = WAVE_FORMAT_PCM
  wfe.nChannels = 1
  wfe.nSamplesPerSec = SRATE
  wfe.nAvgBytesPerSec = SRATE
  wfe.wBitsPerSample = 8
  wfe.nBlockAlign = uint16(int(wfe.nChannels) * int(wfe.wBitsPerSample) / 8)

  waveOutOpen(hWave.addr, WAVE_MAPPER, wfe.addr, 0, 0, CALLBACK_NULL)

  whdr.lpData = bWave
  whdr.dwBufferLength = data_len
  whdr.dwFlags = WHDR_BEGINLOOP or WHDR_ENDLOOP
  whdr.dwLoops = 1
  
  waveOutPrepareHeader(hWave, whdr.addr, int32(sizeof(WAVEHDR)))
  waveOutWrite(hWave, whdr.addr, int32(sizeof(WAVEHDR)))

  echo("終了するには何かキーを押してください:")
  discard getch()


when isMainModule:
  main()
