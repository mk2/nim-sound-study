const dllname = "MIDIData.dll"

{.pragma: mididatalib_api, stdcall, importc, discardable, dynlib: dllname.}

## ****************************************************************************
##
## 　MIDIData.h - MIDIDataヘッダーファイル                  (C)2002-2020 くず
##
## ****************************************************************************
##  このモジュールは普通のＣ言語で書かれている。
##  このライブラリは、GNU 劣等一般公衆利用許諾契約書(LGPL)に基づき配布される。
##  プロジェクトホームページ："http://openmidiproject.sourceforge.jp/index.html"
##  MIDIイベントの取得・設定・生成・挿入・削除
##  MIDIトラックの取得・設定・生成・挿入・削除
##  MIDIデータの生成・削除・SMFファイル(*.mid)入出力
##  This library is free software; you can redistribute it and/or
##  modify it under the terms of the GNU Lesser General Public
##  License as published by the Free Software Foundation; either
##  version 2.1 of the License, or (at your option) any later version.
##  This library is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
##  Lesser General Public License for more details.
##  You should have received a copy of the GNU Lesser General Public
##  License along with this library; if not, write to the Free Software
##  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

##  C++からも使用可能とする

##  __stdcall, importcの定義
##
## #ifndef __stdcall, importc
## #if defined(WINDOWS) || defined(_WINDOWS) || defined(__WINDOWS) || \
## 	defined(WIN32) || defined(_WIN32) || defined(__WIN32) || \
## 	defined(WIN64) || defined(_WIN64) || defined(__WIN64)
## #define __stdcall, importc __stdcall, importc
## #else
## #define __stdcall, importc
## #endif
## #endif
##
##  MIDIEvent構造体
##  双方向ダブルリンクリスト構造
##  ノード順序は絶対時刻で決定されます

type
  MIDIEvent* {.bycopy.} = object
    m_lTempIndex*: clong       ##  このイベントの一時的なインデックス(0から始まる)
    m_lTime*: clong            ##  絶対時刻[Tick]又はSMPTEサブフレーム単位
    m_lKind*: clong            ##  イベントの種類(0x00～0xFF)
    m_lLen*: clong             ##  イベントのデータ長さ[バイト]
    m_pData*: ptr cuchar        ##  イベントのデータバッファへのポインタ
    m_lData*: culong           ##  イベントのデータバッファ(MIDIチャンネルイベントのとき使う)
    m_pNextEvent*: ptr MIDIEvent ##  次のイベントへのポインタ(なければNULL)
    m_pPrevEvent*: ptr MIDIEvent ##  前のイベントへのポインタ(なければNULL)
    m_pNextSameKindEvent*: ptr MIDIEvent ##  次の同じ種類のイベントへのポインタ(なければNULL)
    m_pPrevSameKindEvent*: ptr MIDIEvent ##  前の同じ種類のイベントへのポインタ(なければNULL)
    m_pNextCombinedEvent*: ptr MIDIEvent ##  次の結合イベント保持用ポインタ(なければNULL)
    m_pPrevCombinedEvent*: ptr MIDIEvent ##  前の結合イベント保持用ポインタ(なければNULL)
    m_pParent*: pointer        ##  親(MIDITrackオブジェクト)へのポインタ(なければNULL)
    m_lUser1*: clong           ##  ユーザー用自由領域1(未使用)
    m_lUser2*: clong           ##  ユーザー用自由領域2(未使用)
    m_lUser3*: clong           ##  ユーザー用自由領域3(未使用)
    m_lUserFlag*: clong        ##  ユーザー用自由領域4(未使用)


##  MIDITrack構造体
##  双方向リンクリスト構造

type
  MIDITrack* {.bycopy.} = object
    m_lTempIndex*: clong       ##  このトラックの一時的なインデックス(0から始まる)
    m_lNumEvent*: clong        ##  トラック内のイベント数
    m_pFirstEvent*: ptr MIDIEvent ##  最初のイベントへのポインタ(なければNULL)
    m_pLastEvent*: ptr MIDIEvent ##  最後のイベントへのポインタ(なければNULL)
    m_pPrevTrack*: ptr MIDIEvent ##  前のトラックへのポインタ(なければNULL)
    m_pNextTrack*: ptr MIDIEvent ##  次のトラックへのポインタ(なければNULL)
    m_pParent*: pointer        ##  親(MIDIDataオブジェクト)へのポインタ
    m_lInputOn*: clong         ##  入力(0=OFF, 1=On)
    m_lInputPort*: clong       ##  入力ポート(-1=n/a, 0～15=ポート番号)
    m_lInputChannel*: clong    ##  入力チャンネル(-1=n/1, 0～15=チャンネル番号)
    m_lOutputOn*: clong        ##  出力(0=OFF, 1=On)
    m_lOutputPort*: clong      ##  出力ポート(-1=n/a, 0～15=ポート番号)
    m_lOutputChannel*: clong   ##  出力チャンネル(-1=n/1, 0～15=チャンネル番号)
    m_lTimePlus*: clong        ##  タイム+
    m_lKeyPlus*: clong         ##  キー+
    m_lVelocityPlus*: clong    ##  ベロシティ+
    m_lViewMode*: clong        ##  表示モード(0=通常、1=ドラム)
    m_lForeColor*: clong       ##  前景色
    m_lBackColor*: clong       ##  背景色
    m_lReserved1*: clong       ##  予約領域1(使用禁止)
    m_lReserved2*: clong       ##  予約領域2(使用禁止)
    m_lReserved3*: clong       ##  予約領域3(使用禁止)
    m_lReserved4*: clong       ##  予約領域4(使用禁止)
    m_lUser1*: clong           ##  ユーザー用自由領域1(未使用)
    m_lUser2*: clong           ##  ユーザー用自由領域2(未使用)
    m_lUser3*: clong           ##  ユーザー用自由領域3(未使用)
    m_lUserFlag*: clong        ##  ユーザー用自由領域4(未使用)


##  MIDIData構造体
##  双方向リンクリスト構造

type
  MIDIData* {.bycopy.} = object
    m_lFormat*: culong         ##  SMFフォーマット(0/1)
    m_lNumTrack*: culong       ##  トラック数(0～∞)
    m_lTimeBase*: culong       ##  タイムベース(例：120)
    m_pFirstTrack*: ptr MIDIEvent ##  最初のトラックへのポインタ(なければNULL)
    m_pLastTrack*: ptr MIDIEvent ##  最後のトラックへのポインタ(なければNULL)
    m_pNextSeq*: ptr MIDIEvent ##  次のシーケンスへのポインタ(なければNULL)
    m_pPrevSeq*: ptr MIDIEvent ##  前のシーケンスへのポインタ(なければNULL)
    m_pParent*: pointer        ##  親(常にNULL。将来ソングリストをサポート)
    m_lReserved1*: clong       ##  予約領域1(使用禁止)
    m_lReserved2*: clong       ##  予約領域2(使用禁止)
    m_lReserved3*: clong       ##  予約領域3(使用禁止)
    m_lReserved4*: clong       ##  予約領域4(使用禁止)
    m_lUser1*: clong           ##  ユーザー用自由領域1(未使用)
    m_lUser2*: clong           ##  ユーザー用自由領域2(未使用)
    m_lUser3*: clong           ##  ユーザー用自由領域3(未使用)
    m_lUserFlag*: clong        ##  ユーザー用自由領域4(未使用)


##  その他のマクロ

const
  MIDIEVENT_MAXLEN* = 65536

##  フォーマットに関するマクロ

const
  MIDIDATA_FORMAT0* = 0x00000000
  MIDIDATA_FORMAT1* = 0x00000001
  MIDIDATA_FORMAT2* = 0x00000002

##  テンポに関するマクロ
##  注意：テンポの単位はすべて[マイクロ秒/tick]とする。

const
  MIDIEVENT_MAXTEMPO* = (16777216)
  MIDIEVENT_MINTEMPO* = (1)
  MIDIEVENT_DEFTEMPO* = (60000000 div 120)

##  トラック数に関するマクロ

const
  MIDIDATA_MAXMIDITRACKNUM* = 65535

##  タイムモードに関するマクロ

const
  MIDIDATA_TPQNBASE* = 0
  MIDIDATA_SMPTE24BASE* = 24
  MIDIDATA_SMPTE25BASE* = 25
  MIDIDATA_SMPTE29BASE* = 29
  MIDIDATA_SMPTE30BASE* = 30

##  タイムレゾリューション(分解能)に関するマクロ
##  TPQNベースの場合：4分音符あたりの分解能
##  ★注意：普通TPQNの分解能は、24,48,72,96,120,144,168,192,216,240,360,384,480,960である

const
  MIDIDATA_MINTPQNRESOLUTION* = 1
  MIDIDATA_MAXTPQNRESOLUTION* = 32767
  MIDIDATA_DEFTPQNRESOLUTION* = 120

##  SMPTEベースの場合：1フレームあたりの分解能
##  ★注意：普通SMPTEの分解能は、10,40,80などが代表的である

const
  MIDIDATA_MINSMPTERESOLUTION* = 1
  MIDIDATA_MAXSMPTERESOLUTION* = 255
  MIDIDATA_DEFSMPTERESOLUTION* = 10

##  最大ポート数

const
  MIDIDATA_MAXNUMPORT* = 256

##  SMPTEオフセットに関するマクロ

const
  MIDIEVENT_SMPTE24* = 0x00000000
  MIDIEVENT_SMPTE25* = 0x00000001
  MIDIEVENT_SMPTE30D* = 0x00000002
  MIDIEVENT_SMPTE30N* = 0x00000003

##  調性に関するマクロ

const
  MIDIEVENT_MAJOR* = 0x00000000
  MIDIEVENT_MINOR* = 0x00000001

##  MIDIEVENT_KINDマクロ (コメントのカッコ内はデータ部の長さを示す)

const
  MIDIEVENT_SEQUENCENUMBER* = 0x00000000
  MIDIEVENT_TEXTEVENT* = 0x00000001
  MIDIEVENT_COPYRIGHTNOTICE* = 0x00000002
  MIDIEVENT_TRACKNAME* = 0x00000003
  MIDIEVENT_INSTRUMENTNAME* = 0x00000004
  MIDIEVENT_LYRIC* = 0x00000005
  MIDIEVENT_MARKER* = 0x00000006
  MIDIEVENT_CUEPOINT* = 0x00000007
  MIDIEVENT_PROGRAMNAME* = 0x00000008
  MIDIEVENT_DEVICENAME* = 0x00000009
  MIDIEVENT_CHANNELPREFIX* = 0x00000020
  MIDIEVENT_PORTPREFIX* = 0x00000021
  MIDIEVENT_ENDOFTRACK* = 0x0000002F
  MIDIEVENT_TEMPO* = 0x00000051
  MIDIEVENT_SMPTEOFFSET* = 0x00000054
  MIDIEVENT_TIMESIGNATURE* = 0x00000058
  MIDIEVENT_KEYSIGNATURE* = 0x00000059
  MIDIEVENT_SEQUENCERSPECIFIC* = 0x0000007F
  MIDIEVENT_NOTEOFF* = 0x00000080
  MIDIEVENT_NOTEON* = 0x00000090
  MIDIEVENT_KEYAFTERTOUCH* = 0x000000A0
  MIDIEVENT_CONTROLCHANGE* = 0x000000B0
  MIDIEVENT_PROGRAMCHANGE* = 0x000000C0
  MIDIEVENT_CHANNELAFTERTOUCH* = 0x000000D0
  MIDIEVENT_PITCHBEND* = 0x000000E0
  MIDIEVENT_SYSEXSTART* = 0x000000F0
  MIDIEVENT_SYSEXCONTINUE* = 0x000000F7

##  MIDIEVENT_KINDマクロ (以下の4つはMIDIData_SetKindの引数に使われる)

const
  MIDIEVENT_NOTEONNOTEOFF* = 0x00000180
  MIDIEVENT_NOTEONNOTEON0* = 0x00000190
  MIDIEVENT_PATCHCHANGE* = 0x000001C0
  MIDIEVENT_RPNCHANGE* = 0x000001A0
  MIDIEVENT_NRPNCHANGE* = 0x000001B0

##  MIDIEVENT_CHARCODEマクロ
##  Standard MIDI File RP-026により、以下の4種類の文字コード指定が許容される。

const
  MIDIEVENT_NOCHARCODE* = 0
  MIDIEVENT_NOCHARCODELATIN* = (0x00010000 or 1252) ##  指定なしだが、{@LATIN} (ANSI)であるものと推定される。
  MIDIEVENT_NOCHARCODEJP* = (0x00010000 or 932) ##  指定なしだが、{@JP} (Shift-JIS)であるものと推定される。
  MIDIEVENT_NOCHARCODEUTF16LE* = (0x00010000 or 1200) ##  指定なしだが、UTF16リトルエンディアンであるものと推定される。
  MIDIEVENT_NOCHARCODEUTF16BE* = (0x00010000 or 1201) ##  指定なしだが、UTF16ビッグエンディアンであるものと推定される。
  MIDIEVENT_NOCHARCODEUTF8* = (0x00010000 or 65001) ##  指定なしだが、UTF8であるものと推定される。
  MIDIEVENT_LATIN* = 1252
  MIDIEVENT_JP* = 932
  MIDIEVENT_UTF16LE* = 1200
  MIDIEVENT_UTF16BE* = 1201
  MIDIEVENT_UTF8* = 65001

##  MIDIEVENT_DUMPマクロ

const
  MIDIEVENT_DUMPALL* = 0x0000FFFF
  MIDIEVENT_DUMPTIME* = 0x00000001
  MIDIEVENT_DUMPKIND* = 0x00000010
  MIDIEVENT_DUMPLEN* = 0x00000020
  MIDIEVENT_DUMPDATA* = 0x00000040
  MIDIEVENT_DUMPUSER1* = 0x00000100
  MIDIEVENT_DUMPUSER2* = 0x00000200
  MIDIEVENT_DUMPUSERFLAG* = 0x00000400

## ****************************************************************************
##
## 　MIDIDataLibクラス関数
##
## ****************************************************************************
##  デフォルト文字コードの設定

type
  wchar_t = uint16

proc MIDIDataLib_SetDefaultCharCode*(lCharCode: clong): clong {.mididatalib_api.}
##  ロケールの設定(20140517無効化)

proc MIDIDataLib_SetLocaleA*(nCategory: cint; pszLocale: cstring): cstring {.mididatalib_api.}
proc MIDIDataLib_SetLocaleW*(nCategory: cint; pszLocale: ptr wchar_t): ptr wchar_t {.mididatalib_api.}
when defined(UNICODE):
  const
    MIDIDataLib_SetLocale* = MIDIDataLib_SetLocaleW
else:
  const
    MIDIDataLib_SetLocale* = MIDIDataLib_SetLocaleA
## ****************************************************************************
##
## 　MIDIEventクラス関数
##
## ****************************************************************************
##  注：__stdcall, importcはWindows専用です。Linuxの場合は__stdcall, importcを消してください
##  結合イベントの最初のイベントを返す。
##  結合イベントでない場合、pEvent自身を返す。

proc MIDIEvent_GetFirstCombinedEvent*(pEvent: ptr MIDIEvent): ptr MIDIEvent {.mididatalib_api.}
##  結合イベントの最後のイベントを返す。
##  結合イベントでない場合、pEvent自身を返す。

proc MIDIEvent_GetLastCombinedEvent*(pEvent: ptr MIDIEvent): ptr MIDIEvent {.mididatalib_api.}
##  単体イベントを結合する

proc MIDIEvent_Combine*(pEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  結合イベントを切り離す

proc MIDIEvent_Chop*(pEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  MIDIイベントの削除(結合している場合でも単一のMIDIイベントを削除)

proc MIDIEvent_DeleteSingle*(pMIDIEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  MIDIイベントの削除(結合している場合、結合しているMIDIイベントも削除)

proc MIDIEvent_Delete*(pMIDIEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  MIDIイベント(任意)を生成し、MIDIイベントへのポインタを返す(失敗時NULL、以下同様)

proc MIDIEvent_Create*(lTime: clong; lKind: clong; pData: ptr cuchar; lLen: clong): ptr MIDIEvent {.
    mididatalib_api.}
##  指定イベントと同じMIDIイベントを生成し、MIDIイベントへのポインタを返す(失敗時NULL、以下同様)

proc MIDIEvent_CreateClone*(pMIDIEvent: ptr MIDIEvent): ptr MIDIEvent {.mididatalib_api.}
##  シーケンス番号イベントの生成

proc MIDIEvent_CreateSequenceNumber*(lTime: clong; lNum: clong): ptr MIDIEvent {.
    mididatalib_api.}
##  テキストベースのイベントの生成

proc MIDIEvent_CreateTextBasedEventA*(lTime: clong; lKind: clong; pszText: cstring): ptr MIDIEvent {.
    mididatalib_api.}
proc MIDIEvent_CreateTextBasedEventW*(lTime: clong; lKind: clong;
                                     pszText: ptr wchar_t): ptr MIDIEvent {.mididatalib_api.}
when defined(UNICODE):
  const
    MIDIEvent_CreateTextBasedEvent* = MIDIEvent_CreateTextBasedEventW
else:
  const
    MIDIEvent_CreateTextBasedEvent* = MIDIEvent_CreateTextBasedEventA
##  テキストベースのイベントの生成(文字コード指定あり)

proc MIDIEvent_CreateTextBasedEventExA*(lTime: clong; lKind: clong; lCharCode: clong;
                                       pszText: cstring): ptr MIDIEvent {.mididatalib_api.}
proc MIDIEvent_CreateTextBasedEventExW*(lTime: clong; lKind: clong; lCharCode: clong;
                                       pszText: ptr wchar_t): ptr MIDIEvent {.mididatalib_api.}
when defined(UNICODE):
  const
    MIDIEvent_CreateTextBasedEventEx* = MIDIEvent_CreateTextBasedEventExW
else:
  const
    MIDIEvent_CreateTextBasedEventEx* = MIDIEvent_CreateTextBasedEventExA
##  テキストイベントの生成

proc MIDIEvent_CreateTextEventA*(lTime: clong; pszText: cstring): ptr MIDIEvent {.
    mididatalib_api.}
proc MIDIEvent_CreateTextEventW*(lTime: clong; pszText: ptr wchar_t): ptr MIDIEvent {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDIEvent_CreateTextEvent* = MIDIEvent_CreateTextEventW
else:
  const
    MIDIEvent_CreateTextEvent* = MIDIEvent_CreateTextEventA
##  テキストイベントの生成(文字コード指定あり)

proc MIDIEvent_CreateTextEventExA*(lTime: clong; lCharCode: clong; pszText: cstring): ptr MIDIEvent {.
    mididatalib_api.}
proc MIDIEvent_CreateTextEventExW*(lTime: clong; lCharCode: clong;
                                  pszText: ptr wchar_t): ptr MIDIEvent {.mididatalib_api.}
when defined(UNICODE):
  const
    MIDIEvent_CreateTextEventEx* = MIDIEvent_CreateTextEventExW
else:
  const
    MIDIEvent_CreateTextEventEx* = MIDIEvent_CreateTextEventExA
##  著作権イベントの生成

proc MIDIEvent_CreateCopyrightNoticeA*(lTime: clong; pszText: cstring): ptr MIDIEvent {.
    mididatalib_api.}
proc MIDIEvent_CreateCopyrightNoticeW*(lTime: clong; pszText: ptr wchar_t): ptr MIDIEvent {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDIEvent_CreateCopyrightNotice* = MIDIEvent_CreateCopyrightNoticeW
else:
  const
    MIDIEvent_CreateCopyrightNotice* = MIDIEvent_CreateCopyrightNoticeA
##  著作権イベントの生成(文字コード指定あり)

proc MIDIEvent_CreateCopyrightNoticeExA*(lTime: clong; lCharCode: clong;
                                        pszText: cstring): ptr MIDIEvent {.mididatalib_api.}
proc MIDIEvent_CreateCopyrightNoticeExW*(lTime: clong; lCharCode: clong;
                                        pszText: ptr wchar_t): ptr MIDIEvent {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDIEvent_CreateCopyrightNoticeEx* = MIDIEvent_CreateCopyrightNoticeExW
else:
  const
    MIDIEvent_CreateCopyrightNoticeEx* = MIDIEvent_CreateCopyrightNoticeExA
##  トラック名イベントの生成

proc MIDIEvent_CreateTrackNameA*(lTime: clong; pszText: cstring): ptr MIDIEvent {.
    mididatalib_api.}
proc MIDIEvent_CreateTrackNameW*(lTime: clong; pszText: ptr wchar_t): ptr MIDIEvent {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDIEvent_CreateTrackName* = MIDIEvent_CreateTrackNameW
else:
  const
    MIDIEvent_CreateTrackName* = MIDIEvent_CreateTrackNameA
##  トラック名イベントの生成(文字コード指定あり)

proc MIDIEvent_CreateTrackNameExA*(lTime: clong; lCharCode: clong; pszText: cstring): ptr MIDIEvent {.
    mididatalib_api.}
proc MIDIEvent_CreateTrackNameExW*(lTime: clong; lCharCode: clong;
                                  pszText: ptr wchar_t): ptr MIDIEvent {.mididatalib_api.}
when defined(UNICODE):
  const
    MIDIEvent_CreateTrackNameEx* = MIDIEvent_CreateTrackNameExW
else:
  const
    MIDIEvent_CreateTrackNameEx* = MIDIEvent_CreateTrackNameExA
##  インストゥルメント名イベントの生成

proc MIDIEvent_CreateInstrumentNameA*(lTime: clong; pszText: cstring): ptr MIDIEvent {.
    mididatalib_api.}
proc MIDIEvent_CreateInstrumentNameW*(lTime: clong; pszText: ptr wchar_t): ptr MIDIEvent {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDIEvent_CreateInstrumentName* = MIDIEvent_CreateInstrumentNameW
else:
  const
    MIDIEvent_CreateInstrumentName* = MIDIEvent_CreateInstrumentNameA
##  インストゥルメント名イベントの生成(文字コード指定あり)

proc MIDIEvent_CreateInstrumentNameExA*(lTime: clong; lCharCode: clong;
                                       pszText: cstring): ptr MIDIEvent {.mididatalib_api.}
proc MIDIEvent_CreateInstrumentNameExW*(lTime: clong; lCharCode: clong;
                                       pszText: ptr wchar_t): ptr MIDIEvent {.mididatalib_api.}
when defined(UNICODE):
  const
    MIDIEvent_CreateInstrumentNameEx* = MIDIEvent_CreateInstrumentNameExW
else:
  const
    MIDIEvent_CreateInstrumentNameEx* = MIDIEvent_CreateInstrumentNameExA
##  歌詞イベントの生成

proc MIDIEvent_CreateLyricA*(lTime: clong; pszText: cstring): ptr MIDIEvent {.mididatalib_api.}
proc MIDIEvent_CreateLyricW*(lTime: clong; pszText: ptr wchar_t): ptr MIDIEvent {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDIEvent_CreateLyric* = MIDIEvent_CreateLyricW
else:
  const
    MIDIEvent_CreateLyric* = MIDIEvent_CreateLyricA
##  歌詞イベントの生成(文字コード指定あり)

proc MIDIEvent_CreateLyricExA*(lTime: clong; lCharCode: clong; pszText: cstring): ptr MIDIEvent {.
    mididatalib_api.}
proc MIDIEvent_CreateLyricExW*(lTime: clong; lCharCode: clong; pszText: ptr wchar_t): ptr MIDIEvent {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDIEvent_CreateLyricEx* = MIDIEvent_CreateLyricExW
else:
  const
    MIDIEvent_CreateLyricEx* = MIDIEvent_CreateLyricExA
##  マーカーイベントの生成

proc MIDIEvent_CreateMarkerA*(lTime: clong; pszText: cstring): ptr MIDIEvent {.mididatalib_api.}
proc MIDIEvent_CreateMarkerW*(lTime: clong; pszText: ptr wchar_t): ptr MIDIEvent {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDIEvent_CreateMarker* = MIDIEvent_CreateMarkerW
else:
  const
    MIDIEvent_CreateMarker* = MIDIEvent_CreateMarkerA
##  マーカーイベントの生成(文字コード指定あり)

proc MIDIEvent_CreateMarkerExA*(lTime: clong; lCharCode: clong; pszText: cstring): ptr MIDIEvent {.
    mididatalib_api.}
proc MIDIEvent_CreateMarkerExW*(lTime: clong; lCharCode: clong; pszText: ptr wchar_t): ptr MIDIEvent {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDIEvent_CreateMarkerEx* = MIDIEvent_CreateMarkerExW
else:
  const
    MIDIEvent_CreateMarkerEx* = MIDIEvent_CreateMarkerExA
##  キューポイントイベントの生成

proc MIDIEvent_CreateCuePointA*(lTime: clong; pszText: cstring): ptr MIDIEvent {.
    mididatalib_api.}
proc MIDIEvent_CreateCuePointW*(lTime: clong; pszText: ptr wchar_t): ptr MIDIEvent {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDIEvent_CreateCuePoint* = MIDIEvent_CreateCuePointW
else:
  const
    MIDIEvent_CreateCuePoint* = MIDIEvent_CreateCuePointA
##  キューポイントイベントの生成(文字コード指定あり)

proc MIDIEvent_CreateCuePointExA*(lTime: clong; lCharCode: clong; pszText: cstring): ptr MIDIEvent {.
    mididatalib_api.}
proc MIDIEvent_CreateCuePointExW*(lTime: clong; lCharCode: clong;
                                 pszText: ptr wchar_t): ptr MIDIEvent {.mididatalib_api.}
when defined(UNICODE):
  const
    MIDIEvent_CreateCuePointEx* = MIDIEvent_CreateCuePointExW
else:
  const
    MIDIEvent_CreateCuePointEx* = MIDIEvent_CreateCuePointExA
##  プログラム名イベントの生成

proc MIDIEvent_CreateProgramNameA*(lTime: clong; pszText: cstring): ptr MIDIEvent {.
    mididatalib_api.}
proc MIDIEvent_CreateProgramNameW*(lTime: clong; pszText: ptr wchar_t): ptr MIDIEvent {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDIEvent_CreateProgramName* = MIDIEvent_CreateProgramNameW
else:
  const
    MIDIEvent_CreateProgramName* = MIDIEvent_CreateProgramNameA
##  プログラム名イベントの生成(文字コード指定あり)

proc MIDIEvent_CreateProgramNameExA*(lTime: clong; lCharCode: clong; pszText: cstring): ptr MIDIEvent {.
    mididatalib_api.}
proc MIDIEvent_CreateProgramNameExW*(lTime: clong; lCharCode: clong;
                                    pszText: ptr wchar_t): ptr MIDIEvent {.mididatalib_api.}
when defined(UNICODE):
  const
    MIDIEvent_CreateProgramNameEx* = MIDIEvent_CreateProgramNameExW
else:
  const
    MIDIEvent_CreateProgramNameEx* = MIDIEvent_CreateProgramNameExA
##  デバイス名イベント生成

proc MIDIEvent_CreateDeviceNameA*(lTime: clong; pszText: cstring): ptr MIDIEvent {.
    mididatalib_api.}
proc MIDIEvent_CreateDeviceNameW*(lTime: clong; pszText: ptr wchar_t): ptr MIDIEvent {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDIEvent_CreateDeviceName* = MIDIEvent_CreateDeviceNameW
else:
  const
    MIDIEvent_CreateDeviceName* = MIDIEvent_CreateDeviceNameA
##  デバイス名イベント生成(文字コード指定あり)

proc MIDIEvent_CreateDeviceNameExA*(lTime: clong; lCharCode: clong; pszText: cstring): ptr MIDIEvent {.
    mididatalib_api.}
proc MIDIEvent_CreateDeviceNameExW*(lTime: clong; lCharCode: clong;
                                   pszText: ptr wchar_t): ptr MIDIEvent {.mididatalib_api.}
when defined(UNICODE):
  const
    MIDIEvent_CreateDeviceNameEx* = MIDIEvent_CreateDeviceNameExW
else:
  const
    MIDIEvent_CreateDeviceNameEx* = MIDIEvent_CreateDeviceNameExA
##  チャンネルプレフィックスイベントの生成

proc MIDIEvent_CreateChannelPrefix*(lTime: clong; lCh: clong): ptr MIDIEvent {.mididatalib_api.}
##  ポートプレフィックスイベントの生成

proc MIDIEvent_CreatePortPrefix*(lTime: clong; lNum: clong): ptr MIDIEvent {.mididatalib_api.}
##  エンドオブトラックイベントの生成

proc MIDIEvent_CreateEndofTrack*(lTime: clong): ptr MIDIEvent {.mididatalib_api.}
##  テンポイベントの生成

proc MIDIEvent_CreateTempo*(lTime: clong; lTempo: clong): ptr MIDIEvent {.mididatalib_api.}
##  SMPTEオフセットイベントの生成

proc MIDIEvent_CreateSMPTEOffset*(lTime: clong; lMode: clong; lHour: clong;
                                 lMin: clong; lSec: clong; lFrame: clong;
                                 lSubFrame: clong): ptr MIDIEvent {.mididatalib_api.}
##  拍子記号イベントの生成

proc MIDIEvent_CreateTimeSignature*(lTime: clong; lnn: clong; ldd: clong; lcc: clong;
                                   lbb: clong): ptr MIDIEvent {.mididatalib_api.}
##  調性記号イベントの生成

proc MIDIEvent_CreateKeySignature*(lTime: clong; lsf: clong; lmi: clong): ptr MIDIEvent {.
    mididatalib_api.}
##  シーケンサー独自のイベントの生成

proc MIDIEvent_CreateSequencerSpecific*(lTime: clong; pData: cstring; lLen: clong): ptr MIDIEvent {.
    mididatalib_api.}
##  ノートオフイベントの生成

proc MIDIEvent_CreateNoteOff*(lTime: clong; lCh: clong; lKey: clong; lVel: clong): ptr MIDIEvent {.
    mididatalib_api.}
##  ノートオンイベントの生成

proc MIDIEvent_CreateNoteOn*(lTime: clong; lCh: clong; lKey: clong; lVel: clong): ptr MIDIEvent {.
    mididatalib_api.}
##  ノートイベントの生成(MIDIEvent_CreateNoteOnNoteOn0と同じ)
##  (ノートオン・ノートオン(0x9n(vel==0))の2イベントを生成し、
##  ノートオンイベントへのポインタを返す。)

proc MIDIEvent_CreateNote*(lTime: clong; lCh: clong; lKey: clong; lVel: clong;
                          lDur: clong): ptr MIDIEvent {.mididatalib_api.}
##  ノートイベントの生成(0x8n離鍵型)
##  (ノートオン(0x9n)・ノートオフ(0x8n)の2イベントを生成し、
##  NoteOnへのポインタを返す)

proc MIDIEvent_CreateNoteOnNoteOff*(lTime: clong; lCh: clong; lKey: clong;
                                   lVel1: clong; lVel2: clong; lDur: clong): ptr MIDIEvent {.
    mididatalib_api.}
##  ノートイベントの生成(0x9n離鍵型)
##  (ノートオン(0x9n)・ノートオン(0x9n(vel==0))の2イベントを生成し、
##  NoteOnへのポインタを返す)

proc MIDIEvent_CreateNoteOnNoteOn0*(lTime: clong; lCh: clong; lKey: clong; lVel: clong;
                                   lDur: clong): ptr MIDIEvent {.mididatalib_api.}
##  キーアフタータッチイベントの生成

proc MIDIEvent_CreateKeyAftertouch*(lTime: clong; lCh: clong; lKey: clong; lVal: clong): ptr MIDIEvent {.
    mididatalib_api.}
##  コントローラーイベントの生成

proc MIDIEvent_CreateControlChange*(lTime: clong; lCh: clong; lNum: clong; lVal: clong): ptr MIDIEvent {.
    mididatalib_api.}
##  RPNイベントの生成
##  (CC#101+CC#100+CC#6の3イベントを生成し、CC#101へのポインタを返す)

proc MIDIEvent_CreateRPNChange*(lTime: clong; lCh: clong; lCC101: clong; lCC100: clong;
                               lVal: clong): ptr MIDIEvent {.mididatalib_api.}
##  NRPNイベントの生成
##  (CC#99+CC#98+CC#6の3イベントを生成し、CC#99へのポインタを返す)

proc MIDIEvent_CreateNRPNChange*(lTime: clong; lCh: clong; lCC99: clong; lCC98: clong;
                                lVal: clong): ptr MIDIEvent {.mididatalib_api.}
##  プログラムチェンジイベントの生成

proc MIDIEvent_CreateProgramChange*(lTime: clong; lCh: clong; lNum: clong): ptr MIDIEvent {.
    mididatalib_api.}
##  バンク・パッチイベントの生成
##  (CC#0+CC#32+PCの3イベントを生成し、CC#0へのポインタを返す)

proc MIDIEvent_CreatePatchChange*(lTime: clong; lCh: clong; lCC0: clong; lCC32: clong;
                                 lNum: clong): ptr MIDIEvent {.mididatalib_api.}
##  チャンネルアフタータッチイベントの生成

proc MIDIEvent_CreateChannelAftertouch*(lTime: clong; lCh: clong; lVal: clong): ptr MIDIEvent {.
    mididatalib_api.}
##  ピッチベンドイベントの生成

proc MIDIEvent_CreatePitchBend*(lTime: clong; lCh: clong; lVal: clong): ptr MIDIEvent {.
    mididatalib_api.}
##  システムエクスクルーシヴイベントの生成

proc MIDIEvent_CreateSysExEvent*(lTime: clong; pBuf: ptr cuchar; lLen: clong): ptr MIDIEvent {.
    mididatalib_api.}
##  メタイベントであるかどうかを調べる

proc MIDIEvent_IsMetaEvent*(pMIDIEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  シーケンス番号であるかどうかを調べる

proc MIDIEvent_IsSequenceNumber*(pMIDIEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  テキストイベントであるかどうかを調べる

proc MIDIEvent_IsTextEvent*(pMIDIEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  著作権イベントであるかどうかを調べる

proc MIDIEvent_IsCopyrightNotice*(pMIDIEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  トラック名イベントであるかどうかを調べる

proc MIDIEvent_IsTrackName*(pMIDIEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  インストゥルメント名イベントであるかどうかを調べる

proc MIDIEvent_IsInstrumentName*(pMIDIEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  歌詞イベントであるかどうかを調べる

proc MIDIEvent_IsLyric*(pMIDIEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  マーカーイベントであるかどうかを調べる

proc MIDIEvent_IsMarker*(pMIDIEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  キューポイントイベントであるかどうかを調べる

proc MIDIEvent_IsCuePoint*(pMIDIEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  プログラム名イベントであるかどうかを調べる

proc MIDIEvent_IsProgramName*(pEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  デバイス名イベントであるかどうかを調べる

proc MIDIEvent_IsDeviceName*(pEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  チャンネルプレフィックスイベントであるかどうかを調べる

proc MIDIEvent_IsChannelPrefix*(pEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  ポートプレフィックスイベントであるかどうかを調べる

proc MIDIEvent_IsPortPrefix*(pEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  エンドオブトラックイベントであるかどうかを調べる

proc MIDIEvent_IsEndofTrack*(pMIDIEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  テンポイベントであるかどうかを調べる

proc MIDIEvent_IsTempo*(pMIDIEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  SMPTEオフセットイベントであるかどうかを調べる

proc MIDIEvent_IsSMPTEOffset*(pMIDIEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  拍子記号イベントであるかどうかを調べる

proc MIDIEvent_IsTimeSignature*(pMIDIEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  調性記号イベントであるかどうかを調べる

proc MIDIEvent_IsKeySignature*(pMIDIEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  シーケンサ独自のイベントであるかどうかを調べる

proc MIDIEvent_IsSequencerSpecific*(pMIDIEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  MIDIイベントであるかどうかを調べる

proc MIDIEvent_IsMIDIEvent*(pMIDIEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  ノートオンイベントであるかどうかを調べる
##  (ノートオンイベントでベロシティ0のものはノートオフイベントとみなす。以下同様)

proc MIDIEvent_IsNoteOn*(pMIDIEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  ノートオフイベントであるかどうかを調べる

proc MIDIEvent_IsNoteOff*(pMIDIEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  ノートイベントであるかどうかを調べる

proc MIDIEvent_IsNote*(pMIDIEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  NOTEONOTEOFFイベントであるかどうかを調べる
##  これはノートオン(0x9n)とノートオフ(0x8n)が結合イベントしたイベントでなければならない。

proc MIDIEvent_IsNoteOnNoteOff*(pEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  NOTEONNOTEON0イベントであるかどうかを調べる
##  これはノートオン(0x9n)とノートオフ(0x9n,vel==0)が結合イベントしたイベントでなければならない。

proc MIDIEvent_IsNoteOnNoteOn0*(pEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  キーアフタータッチイベントであるかどうかを調べる

proc MIDIEvent_IsKeyAftertouch*(pEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  コントロールチェンジイベントであるかどうかを調べる

proc MIDIEvent_IsControlChange*(pEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  RPNチェンジイベントであるかどうかを調べる

proc MIDIEvent_IsRPNChange*(pEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  NRPNチェンジイベントであるかどうかを調べる

proc MIDIEvent_IsNRPNChange*(pEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  プログラムチェンジイベントであるかどうかを調べる

proc MIDIEvent_IsProgramChange*(pEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  パッチチェンジイベントであるかどうかを調べる

proc MIDIEvent_IsPatchChange*(pEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  チャンネルアフタータッチイベントであるかどうかを調べる

proc MIDIEvent_IsChannelAftertouch*(pEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  ピッチベンドイベントであるかどうかを調べる

proc MIDIEvent_IsPitchBend*(pEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  システムエクスクルーシヴイベントであるかどうかを調べる

proc MIDIEvent_IsSysExEvent*(pMIDIEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  浮遊イベントであるかどうか調べる

proc MIDIEvent_IsFloating*(pEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  結合イベントであるかどうか調べる

proc MIDIEvent_IsCombined*(pEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  イベントの種類を取得

proc MIDIEvent_GetKind*(pEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  イベントの種類を設定

proc MIDIEvent_SetKind*(pEvent: ptr MIDIEvent; lKind: clong): clong {.mididatalib_api.}
##  イベントの長さ取得

proc MIDIEvent_GetLen*(pEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  イベントのデータ部を取得

proc MIDIEvent_GetData*(pEvent: ptr MIDIEvent; pBuf: ptr cuchar; lLen: clong): clong {.
    mididatalib_api.}
##  イベントのデータ部を設定(この関数は大変危険です。整合性のチェキはしません)

proc MIDIEvent_SetData*(pEvent: ptr MIDIEvent; pBuf: ptr cuchar; lLen: clong): clong {.
    mididatalib_api.}
##  イベントの文字コードを取得(テキスト・著作権・トラック名・インストゥルメント名・
##  歌詞・マーカー・キューポイント・プログラム名・デバイス名のみ)

proc MIDIEvent_GetCharCode*(pMIDIEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  イベントの文字コードを設定(テキスト・著作権・トラック名・インストゥルメント名・
##  歌詞・マーカー・キューポイント・プログラム名・デバイス名のみ)

proc MIDIEvent_SetCharCode*(pMIDIEvent: ptr MIDIEvent; lCharCode: clong): clong {.
    mididatalib_api.}
##  イベントのテキストを取得(テキスト・著作権・トラック名・インストゥルメント名・
##  歌詞・マーカー・キューポイント・プログラム名・デバイス名のみ)

proc MIDIEvent_GetTextA*(pEvent: ptr MIDIEvent; pBuf: cstring; lLen: clong): cstring {.
    mididatalib_api.}
proc MIDIEvent_GetTextW*(pEvent: ptr MIDIEvent; pBuf: ptr wchar_t; lLen: clong): ptr wchar_t {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDIEvent_GetText* = MIDIEvent_GetTextW
else:
  const
    MIDIEvent_GetText* = MIDIEvent_GetTextA
##  イベントのテキストを設定(テキスト・著作権・トラック名・インストゥルメント名・
##  歌詞・マーカー・キューポイント・プログラム名・デバイス名のみ)

proc MIDIEvent_SetTextA*(pEvent: ptr MIDIEvent; pszText: cstring): clong {.mididatalib_api.}
proc MIDIEvent_SetTextW*(pEvent: ptr MIDIEvent; pszText: ptr wchar_t): clong {.mididatalib_api.}
when defined(UNICODE):
  const
    MIDIEvent_SetText* = MIDIEvent_SetTextW
else:
  const
    MIDIEvent_SetText* = MIDIEvent_SetTextA
##  SMPTEオフセットの取得(SMPTEオフセットイベントのみ)

proc MIDIEvent_GetSMPTEOffset*(pEvent: ptr MIDIEvent; pMode: ptr clong;
                              pHour: ptr clong; pMin: ptr clong; pSec: ptr clong;
                              pFrame: ptr clong; pSubFrame: ptr clong): clong {.mididatalib_api.}
##  SMPTEオフセットの設定(SMPTEオフセットイベントのみ)

proc MIDIEvent_SetSMPTEOffset*(pEvent: ptr MIDIEvent; lMode: clong; lHour: clong;
                              lMin: clong; lSec: clong; lFrame: clong;
                              lSubFrame: clong): clong {.mididatalib_api.}
##  テンポ取得(テンポイベントのみ)

proc MIDIEvent_GetTempo*(pEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  テンポ設定(テンポイベントのみ)

proc MIDIEvent_SetTempo*(pEvent: ptr MIDIEvent; lTempo: clong): clong {.mididatalib_api.}
##  拍子記号取得(拍子記号イベントのみ)

proc MIDIEvent_GetTimeSignature*(pEvent: ptr MIDIEvent; lnn: ptr clong; ldd: ptr clong;
                                lcc: ptr clong; bb: ptr clong): clong {.mididatalib_api.}
##  拍子記号の設定(拍子記号イベントのみ)

proc MIDIEvent_SetTimeSignature*(pEvent: ptr MIDIEvent; lnn: clong; ldd: clong;
                                lcc: clong; lbb: clong): clong {.mididatalib_api.}
##  調性記号の取得(調性記号イベントのみ)

proc MIDIEvent_GetKeySignature*(pEvent: ptr MIDIEvent; psf: ptr clong; pmi: ptr clong): clong {.
    mididatalib_api.}
##  調性記号の設定(調性記号イベントのみ)

proc MIDIEvent_SetKeySignature*(pEvent: ptr MIDIEvent; lsf: clong; lmi: clong): clong {.
    mididatalib_api.}
##  イベントのメッセージ取得(MIDIチャンネルイベント及びシステムエクスクルーシヴのみ)

proc MIDIEvent_GetMIDIMessage*(pEvent: ptr MIDIEvent; pMessage: cstring; lLen: clong): clong {.
    mididatalib_api.}
##  イベントのメッセージ設定(MIDIチャンネルイベント及びシステムエクスクルーシヴのみ)

proc MIDIEvent_SetMIDIMessage*(pEvent: ptr MIDIEvent; pMessage: cstring; lLen: clong): clong {.
    mididatalib_api.}
##  イベントのチャンネル取得(MIDIチャンネルイベントのみ)

proc MIDIEvent_GetChannel*(pEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  イベントのチャンネル設定(MIDIチャンネルイベントのみ)

proc MIDIEvent_SetChannel*(pEvent: ptr MIDIEvent; lCh: clong): clong {.mididatalib_api.}
##  イベントの時刻取得

proc MIDIEvent_GetTime*(pEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  イベントの時刻設定

proc MIDIEvent_SetTimeSingle*(pEvent: ptr MIDIEvent; lTime: clong): clong {.mididatalib_api.}
##  イベントの時刻設定

proc MIDIEvent_SetTime*(pEvent: ptr MIDIEvent; lTime: clong): clong {.mididatalib_api.}
##  イベントのキー取得(ノートオフ・ノートオン・チャンネルアフターのみ)

proc MIDIEvent_GetKey*(pEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  イベントのキー設定(ノートオフ・ノートオン・チャンネルアフターのみ)

proc MIDIEvent_SetKey*(pEvent: ptr MIDIEvent; lKey: clong): clong {.mididatalib_api.}
##  イベントのベロシティ取得(ノートオフ・ノートオンのみ)

proc MIDIEvent_GetVelocity*(pEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  イベントのベロシティ設定(ノートオフ・ノートオンのみ)

proc MIDIEvent_SetVelocity*(pEvent: ptr MIDIEvent; cVel: clong): clong {.mididatalib_api.}
##  結合イベントの音長さ取得(ノートのみ)

proc MIDIEvent_GetDuration*(pEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  結合イベントの音長さ設定(ノートのみ)

proc MIDIEvent_SetDuration*(pEvent: ptr MIDIEvent; lDuration: clong): clong {.mididatalib_api.}
##  結合イベントのバンク取得(RPNチェンジ・NRPNチェンジ・パッチチェンジのみ)

proc MIDIEvent_GetBank*(pEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  結合イベントのバンク上位(MSB)取得(RPNチェンジ・NRPNチェンジ・パッチチェンジのみ)

proc MIDIEvent_GetBankMSB*(pEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  結合イベントのバンク下位(LSB)取得(RPNチェンジ・NRPNチェンジ・パッチチェンジのみ)

proc MIDIEvent_GetBankLSB*(pEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  結合イベントのバンク設定(RPNチェンジ・NRPNチェンジ・パッチチェンジのみ)

proc MIDIEvent_SetBank*(pEvent: ptr MIDIEvent; lBank: clong): clong {.mididatalib_api.}
##  結合イベントのバンク上位(MSB)設定(RPNチェンジ・NRPNチェンジ・パッチチェンジのみ)

proc MIDIEvent_SetBankMSB*(pEvent: ptr MIDIEvent; lBankMSB: clong): clong {.mididatalib_api.}
##  結合イベントのバンク下位(LSB)設定(RPNチェンジ・NRPNチェンジ・パッチチェンジのみ)

proc MIDIEvent_SetBankLSB*(pEvent: ptr MIDIEvent; lBankLSB: clong): clong {.mididatalib_api.}
##  結合イベントのプログラムナンバーを取得(パッチイベントのみ)

proc MIDIEvent_GetPatchNum*(pEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  結合イベントのプログラムナンバーを設定(パッチイベントのみ)

proc MIDIEvent_SetPatchNum*(pEvent: ptr MIDIEvent; lNum: clong): clong {.mididatalib_api.}
##  結合イベントのデータエントリーMSBを取得(RPNチェンジ・NPRNチェンジのみ)

proc MIDIEvent_GetDataEntryMSB*(pEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  結合イベントのデータエントリーMSBを設定(RPNチェンジ・NPRNチェンジのみ)

proc MIDIEvent_SetDataEntryMSB*(pEvent: ptr MIDIEvent; lVal: clong): clong {.mididatalib_api.}
##  イベントの番号取得(コントロールチェンジ・プログラムチェンジのみ)

proc MIDIEvent_GetNumber*(pEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  イベントの番号設定(コントロールチェンジ・プログラムチェンジのみ)

proc MIDIEvent_SetNumber*(pEvent: ptr MIDIEvent; cNum: clong): clong {.mididatalib_api.}
##  イベントの値取得(キーアフター・コントローラー・チャンネルアフター・ピッチベンド)

proc MIDIEvent_GetValue*(pEvent: ptr MIDIEvent): clong {.mididatalib_api.}
##  イベントの値設定(キーアフター・コントローラー・チャンネルアフター・ピッチベンド)

proc MIDIEvent_SetValue*(pEvent: ptr MIDIEvent; nVal: clong): clong {.mididatalib_api.}
##  次のイベントへのポインタを取得(なければNULL)

proc MIDIEvent_GetNextEvent*(pMIDIEvent: ptr MIDIEvent): ptr MIDIEvent {.mididatalib_api.}
##  前のイベントへのポインタを取得(なければNULL)

proc MIDIEvent_GetPrevEvent*(pMIDIEvent: ptr MIDIEvent): ptr MIDIEvent {.mididatalib_api.}
##  次の同種のイベントへのポインタを取得(なければNULL)

proc MIDIEvent_GetNextSameKindEvent*(pMIDIEvent: ptr MIDIEvent): ptr MIDIEvent {.
    mididatalib_api.}
##  前の同種のイベントへのポインタを取得(なければNULL)

proc MIDIEvent_GetPrevSameKindEvent*(pMIDIEvent: ptr MIDIEvent): ptr MIDIEvent {.
    mididatalib_api.}
##  親トラックへのポインタを取得(なければNULL)

proc MIDIEvent_GetParent*(pMIDIEvent: ptr MIDIEvent): ptr MIDITrack {.mididatalib_api.}
##  イベントの内容を文字列表現に変換

proc MIDIEvent_ToStringExA*(pEvent: ptr MIDIEvent; pBuf: cstring; lLen: clong;
                           lFlags: clong): cstring {.mididatalib_api.}
proc MIDIEvent_ToStringExW*(pEvent: ptr MIDIEvent; pBuf: ptr wchar_t; lLen: clong;
                           lFlags: clong): ptr wchar_t {.mididatalib_api.}
when defined(UNICODE):
  const
    MIDIEvent_ToStringEx* = MIDIEvent_ToStringExW
else:
  const
    MIDIEvent_ToStringEx* = MIDIEvent_ToStringExA
##  イベンの内容トを文字列表現に変換

proc MIDIEvent_ToStringA*(pEvent: ptr MIDIEvent; pBuf: cstring; lLen: clong): cstring {.
    mididatalib_api.}
proc MIDIEvent_ToStringW*(pEvent: ptr MIDIEvent; pBuf: ptr wchar_t; lLen: clong): ptr wchar_t {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDIEvent_ToString* = MIDIEvent_ToStringW
else:
  const
    MIDIEvent_ToString* = MIDIEvent_ToStringA
## ****************************************************************************
##
## 　MIDITrackクラス関数
##
## ****************************************************************************
##  トラック内のイベントの総数を取得

proc MIDITrack_GetNumEvent*(pMIDITrack: ptr MIDITrack): clong {.mididatalib_api.}
##  トラックの最初のイベントへのポインタを取得(なければNULL)

proc MIDITrack_GetFirstEvent*(pMIDITrack: ptr MIDITrack): ptr MIDIEvent {.mididatalib_api.}
##  トラックの最後のイベントへのポインタを取得(なければNULL)

proc MIDITrack_GetLastEvent*(pMIDITrack: ptr MIDITrack): ptr MIDIEvent {.mididatalib_api.}
##  トラック内の指定種類の最初のイベント取得(なければNULL)

proc MIDITrack_GetFirstKindEvent*(pTrack: ptr MIDITrack; lKind: clong): ptr MIDIEvent {.
    mididatalib_api.}
##  トラック内の指定種類の最後のイベント取得(なければNULL)

proc MIDITrack_GetLastKindEvent*(pTrack: ptr MIDITrack; lKind: clong): ptr MIDIEvent {.
    mididatalib_api.}
##  次のMIDIトラックへのポインタ取得(なければNULL)(20080715追加)

proc MIDITrack_GetNextTrack*(pTrack: ptr MIDITrack): ptr MIDITrack {.mididatalib_api.}
##  前のMIDIトラックへのポインタ取得(なければNULL)(20080715追加)

proc MIDITrack_GetPrevTrack*(pTrack: ptr MIDITrack): ptr MIDITrack {.mididatalib_api.}
##  トラックの親MIDIデータへのポインタを取得(なければNULL)

proc MIDITrack_GetParent*(pMIDITrack: ptr MIDITrack): ptr MIDIData {.mididatalib_api.}
##  トラック内のイベント数をカウントし、各イベントのインデックスと総イベント数を更新し、イベント数を返す。

proc MIDITrack_CountEvent*(pMIDITrack: ptr MIDITrack): clong {.mididatalib_api.}
##  トラックの開始時刻(最初のイベントの時刻)[Tick]を取得(20081101追加)

proc MIDITrack_GetBeginTime*(pMIDITrack: ptr MIDITrack): clong {.mididatalib_api.}
##  トラックの終了時刻(最後のイベントの時刻)[Tick]を取得(20081101追加)

proc MIDITrack_GetEndTime*(pMIDITrack: ptr MIDITrack): clong {.mididatalib_api.}
##  トラックの名前を簡易に取得

proc MIDITrack_GetNameA*(pMIDITrack: ptr MIDITrack; pBuf: cstring; lLen: clong): cstring {.
    mididatalib_api.}
proc MIDITrack_GetNameW*(pMIDITrack: ptr MIDITrack; pBuf: ptr wchar_t; lLen: clong): ptr wchar_t {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDITrack_GetName* = MIDITrack_GetNameW
else:
  const
    MIDITrack_GetName* = MIDITrack_GetNameA
##  入力取得(0=OFF, 1=On)

proc MIDITrack_GetInputOn*(pTrack: ptr MIDITrack): clong {.mididatalib_api.}
##  入力ポート取得(-1=n/a, 0～15=ポート番号)

proc MIDITrack_GetInputPort*(pTrack: ptr MIDITrack): clong {.mididatalib_api.}
##  入力チャンネル取得(-1=n/a, 0～15=チャンネル番号)

proc MIDITrack_GetInputChannel*(pTrack: ptr MIDITrack): clong {.mididatalib_api.}
##  出力取得(0=OFF, 1=On)

proc MIDITrack_GetOutputOn*(pTrack: ptr MIDITrack): clong {.mididatalib_api.}
##  出力ポート(-1=n/a, 0～15=ポート番号)

proc MIDITrack_GetOutputPort*(pTrack: ptr MIDITrack): clong {.mididatalib_api.}
##  出力チャンネル(-1=n/a, 0～15=チャンネル番号)

proc MIDITrack_GetOutputChannel*(pTrack: ptr MIDITrack): clong {.mididatalib_api.}
##  タイム+取得

proc MIDITrack_GetTimePlus*(pTrack: ptr MIDITrack): clong {.mididatalib_api.}
##  キー+取得

proc MIDITrack_GetKeyPlus*(pTrack: ptr MIDITrack): clong {.mididatalib_api.}
##  ベロシティ+取得

proc MIDITrack_GetVelocityPlus*(pTrack: ptr MIDITrack): clong {.mididatalib_api.}
##  表示モード取得(0=通常、1=ドラム)

proc MIDITrack_GetViewMode*(pTrack: ptr MIDITrack): clong {.mididatalib_api.}
##  前景色取得

proc MIDITrack_GetForeColor*(pTrack: ptr MIDITrack): clong {.mididatalib_api.}
##  背景色取得

proc MIDITrack_GetBackColor*(pTrack: ptr MIDITrack): clong {.mididatalib_api.}
##  トラックの名前を簡易に設定

proc MIDITrack_SetNameA*(pMIDITrack: ptr MIDITrack; pszText: cstring): clong {.mididatalib_api.}
proc MIDITrack_SetNameW*(pMIDITrack: ptr MIDITrack; pszText: ptr wchar_t): clong {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDITrack_SetName* = MIDITrack_SetNameW
else:
  const
    MIDITrack_SetName* = MIDITrack_SetNameA
##  入力設定(0=OFF, 1=On)

proc MIDITrack_SetInputOn*(pTrack: ptr MIDITrack; lInputOn: clong): clong {.mididatalib_api.}
##  入力ポート設定(-1=n/a, 0～15=ポート番号)

proc MIDITrack_SetInputPort*(pTrack: ptr MIDITrack; lInputPort: clong): clong {.mididatalib_api.}
##  入力チャンネル設定(-1=n/a, 0～15=チャンネル番号)

proc MIDITrack_SetInputChannel*(pTrack: ptr MIDITrack; lInputChannel: clong): clong {.
    mididatalib_api.}
##  出力設定(0=OFF, 1=On)

proc MIDITrack_SetOutputOn*(pTrack: ptr MIDITrack; lOutputOn: clong): clong {.mididatalib_api.}
##  出力ポート(-1=n/a, 0～15=ポート番号)

proc MIDITrack_SetOutputPort*(pTrack: ptr MIDITrack; lOutputPort: clong): clong {.
    mididatalib_api.}
##  出力チャンネル(-1=n/a, 0～15=チャンネル番号)

proc MIDITrack_SetOutputChannel*(pTrack: ptr MIDITrack; lOutputChannel: clong): clong {.
    mididatalib_api.}
##  タイム+設定

proc MIDITrack_SetTimePlus*(pTrack: ptr MIDITrack; lTimePlus: clong): clong {.mididatalib_api.}
##  キー+設定

proc MIDITrack_SetKeyPlus*(pTrack: ptr MIDITrack; lKeyPlus: clong): clong {.mididatalib_api.}
##  ベロシティ+設定

proc MIDITrack_SetVelocityPlus*(pTrack: ptr MIDITrack; lVelocityPlus: clong): clong {.
    mididatalib_api.}
##  表示モード設定(0=通常、1=ドラム)

proc MIDITrack_SetViewMode*(pTrack: ptr MIDITrack; lMode: clong): clong {.mididatalib_api.}
##  前景色設定

proc MIDITrack_SetForeColor*(pTrack: ptr MIDITrack; lForeColor: clong): clong {.mididatalib_api.}
##  背景色設定

proc MIDITrack_SetBackColor*(pTrack: ptr MIDITrack; lBackColor: clong): clong {.mididatalib_api.}
##  XFであるとき、XFのヴァージョンを取得(XFでなければ0)

proc MIDITrack_GetXFVersion*(pMIDITrack: ptr MIDITrack): clong {.mididatalib_api.}
##  トラックの削除(含まれるイベントオブジェクトも削除されます)

proc MIDITrack_Delete*(pMIDITrack: ptr MIDITrack) {.mididatalib_api.}
##  トラックを生成し、トラックへのポインタを返す(失敗時NULL)

proc MIDITrack_Create*(): ptr MIDITrack {.mididatalib_api.}
##  MIDIトラックのクローンを生成

proc MIDITrack_CreateClone*(pTrack: ptr MIDITrack): ptr MIDITrack {.mididatalib_api.}
##  トラックにイベントを挿入(イベントはあらかじめ生成しておく)

proc MIDITrack_InsertSingleEventAfter*(pMIDITrack: ptr MIDITrack;
                                      pEvent: ptr MIDIEvent; pTarget: ptr MIDIEvent): clong {.
    mididatalib_api.}
##  トラックにイベントを挿入(イベントはあらかじめ生成しておく)

proc MIDITrack_InsertSingleEventBefore*(pMIDITrack: ptr MIDITrack;
                                       pEvent: ptr MIDIEvent;
                                       pTarget: ptr MIDIEvent): clong {.mididatalib_api.}
##  トラックにイベントを挿入(イベントはあらかじめ生成しておく)

proc MIDITrack_InsertEventAfter*(pMIDITrack: ptr MIDITrack; pEvent: ptr MIDIEvent;
                                pTarget: ptr MIDIEvent): clong {.mididatalib_api.}
##  トラックにイベントを挿入(イベントはあらかじめ生成しておく)

proc MIDITrack_InsertEventBefore*(pMIDITrack: ptr MIDITrack; pEvent: ptr MIDIEvent;
                                 pTarget: ptr MIDIEvent): clong {.mididatalib_api.}
##  トラックにイベントを挿入(イベントはあらかじめ生成しておく)

proc MIDITrack_InsertEvent*(pMIDITrack: ptr MIDITrack; pEvent: ptr MIDIEvent): clong {.
    mididatalib_api.}
##  トラックにシーケンス番号イベントを生成して挿入

proc MIDITrack_InsertSequenceNumber*(pMIDITrack: ptr MIDITrack; lTime: clong;
                                    lNum: clong): clong {.mididatalib_api.}
##  トラックにテキストベースのイベントを生成して挿入

proc MIDITrack_InsertTextBasedEventA*(pMIDITrack: ptr MIDITrack; lTime: clong;
                                     lKind: clong; pszText: cstring): clong {.mididatalib_api.}
proc MIDITrack_InsertTextBasedEventW*(pMIDITrack: ptr MIDITrack; lTime: clong;
                                     lKind: clong; pszText: ptr wchar_t): clong {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDITrack_InsertTextBasedEvent* = MIDITrack_InsertTextBasedEventW
else:
  const
    MIDITrack_InsertTextBasedEvent* = MIDITrack_InsertTextBasedEventA
##  トラックにテキストベースのイベントを生成して挿入(文字コード指定あり)

proc MIDITrack_InsertTextBasedEventExA*(pMIDITrack: ptr MIDITrack; lTime: clong;
                                       lKind: clong; lCharCode: clong;
                                       pszText: cstring): clong {.mididatalib_api.}
proc MIDITrack_InsertTextBasedEventExW*(pMIDITrack: ptr MIDITrack; lTime: clong;
                                       lKind: clong; lCharCode: clong;
                                       pszText: ptr wchar_t): clong {.mididatalib_api.}
when defined(UNICODE):
  const
    MIDITrack_InsertTextBasedEventEx* = MIDITrack_InsertTextBasedEventExW
else:
  const
    MIDITrack_InsertTextBasedEventEx* = MIDITrack_InsertTextBasedEventExA
##  トラックにテキストイベントを生成して挿入

proc MIDITrack_InsertTextEventA*(pMIDITrack: ptr MIDITrack; lTime: clong;
                                pszText: cstring): clong {.mididatalib_api.}
proc MIDITrack_InsertTextEventW*(pMIDITrack: ptr MIDITrack; lTime: clong;
                                pszText: ptr wchar_t): clong {.mididatalib_api.}
when defined(UNICODE):
  const
    MIDITrack_InsertTextEvent* = MIDITrack_InsertTextEventW
else:
  const
    MIDITrack_InsertTextEvent* = MIDITrack_InsertTextEventA
##  トラックにテキストイベントを生成して挿入(文字コード指定あり)

proc MIDITrack_InsertTextEventExA*(pMIDITrack: ptr MIDITrack; lTime: clong;
                                  lCharCode: clong; pszText: cstring): clong {.
    mididatalib_api.}
proc MIDITrack_InsertTextEventExW*(pMIDITrack: ptr MIDITrack; lTime: clong;
                                  lCharCode: clong; pszText: ptr wchar_t): clong {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDITrack_InsertTextEventEx* = MIDITrack_InsertTextEventExW
else:
  const
    MIDITrack_InsertTextEventEx* = MIDITrack_InsertTextEventExA
##  トラックに著作権イベントを生成して挿入

proc MIDITrack_InsertCopyrightNoticeA*(pMIDITrack: ptr MIDITrack; lTime: clong;
                                      pszText: cstring): clong {.mididatalib_api.}
proc MIDITrack_InsertCopyrightNoticeW*(pMIDITrack: ptr MIDITrack; lTime: clong;
                                      pszText: ptr wchar_t): clong {.mididatalib_api.}
when defined(UNICODE):
  const
    MIDITrack_InsertCopyrightNotice* = MIDITrack_InsertCopyrightNoticeW
else:
  const
    MIDITrack_InsertCopyrightNotice* = MIDITrack_InsertCopyrightNoticeA
##  トラックに著作権イベントを生成して挿入(文字コード指定あり)

proc MIDITrack_InsertCopyrightNoticeExA*(pMIDITrack: ptr MIDITrack; lTime: clong;
                                        lCharCode: clong; pszText: cstring): clong {.
    mididatalib_api.}
proc MIDITrack_InsertCopyrightNoticeExW*(pMIDITrack: ptr MIDITrack; lTime: clong;
                                        lCharCode: clong; pszText: ptr wchar_t): clong {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDITrack_InsertCopyrightNoticeEx* = MIDITrack_InsertCopyrightNoticeExW
else:
  const
    MIDITrack_InsertCopyrightNoticeEx* = MIDITrack_InsertCopyrightNoticeExA
##  トラックにトラック名イベントを生成して挿入

proc MIDITrack_InsertTrackNameA*(pMIDITrack: ptr MIDITrack; lTime: clong;
                                pszText: cstring): clong {.mididatalib_api.}
proc MIDITrack_InsertTrackNameW*(pMIDITrack: ptr MIDITrack; lTime: clong;
                                pszText: ptr wchar_t): clong {.mididatalib_api.}
when defined(UNICODE):
  const
    MIDITrack_InsertTrackName* = MIDITrack_InsertTrackNameW
else:
  const
    MIDITrack_InsertTrackName* = MIDITrack_InsertTrackNameA
##  トラックにトラック名イベントを生成して挿入(文字コード指定あり)

proc MIDITrack_InsertTrackNameExA*(pMIDITrack: ptr MIDITrack; lTime: clong;
                                  lCharCode: clong; pszText: cstring): clong {.
    mididatalib_api.}
proc MIDITrack_InsertTrackNameExW*(pMIDITrack: ptr MIDITrack; lTime: clong;
                                  lCharCode: clong; pszText: ptr wchar_t): clong {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDITrack_InsertTrackNameEx* = MIDITrack_InsertTrackNameExW
else:
  const
    MIDITrack_InsertTrackNameEx* = MIDITrack_InsertTrackNameExA
##  トラックにインストゥルメント名イベントを生成して挿入

proc MIDITrack_InsertInstrumentNameA*(pMIDITrack: ptr MIDITrack; lTime: clong;
                                     pszText: cstring): clong {.mididatalib_api.}
proc MIDITrack_InsertInstrumentNameW*(pMIDITrack: ptr MIDITrack; lTime: clong;
                                     pszText: ptr wchar_t): clong {.mididatalib_api.}
when defined(UNICODE):
  const
    MIDITrack_InsertInstrumentName* = MIDITrack_InsertInstrumentNameW
else:
  const
    MIDITrack_InsertInstrumentName* = MIDITrack_InsertInstrumentNameA
##  トラックにインストゥルメント名イベントを生成して挿入(文字コード指定あり)

proc MIDITrack_InsertInstrumentNameExA*(pMIDITrack: ptr MIDITrack; lTime: clong;
                                       lCharCode: clong; pszText: cstring): clong {.
    mididatalib_api.}
proc MIDITrack_InsertInstrumentNameExW*(pMIDITrack: ptr MIDITrack; lTime: clong;
                                       lCharCode: clong; pszText: ptr wchar_t): clong {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDITrack_InsertInstrumentNameEx* = MIDITrack_InsertInstrumentNameExW
else:
  const
    MIDITrack_InsertInstrumentNameEx* = MIDITrack_InsertInstrumentNameExA
##  トラックに歌詞イベントを生成して挿入

proc MIDITrack_InsertLyricA*(pMIDITrack: ptr MIDITrack; lTime: clong; pszText: cstring): clong {.
    mididatalib_api.}
proc MIDITrack_InsertLyricW*(pMIDITrack: ptr MIDITrack; lTime: clong;
                            pszText: ptr wchar_t): clong {.mididatalib_api.}
when defined(UNICODE):
  const
    MIDITrack_InsertLyric* = MIDITrack_InsertLyricW
else:
  const
    MIDITrack_InsertLyric* = MIDITrack_InsertLyricA
##  トラックに歌詞イベントを生成して挿入(文字コード指定あり)

proc MIDITrack_InsertLyricExA*(pMIDITrack: ptr MIDITrack; lTime: clong;
                              lCharCode: clong; pszText: cstring): clong {.mididatalib_api.}
proc MIDITrack_InsertLyricExW*(pMIDITrack: ptr MIDITrack; lTime: clong;
                              lCharCode: clong; pszText: ptr wchar_t): clong {.mididatalib_api.}
when defined(UNICODE):
  const
    MIDITrack_InsertLyricEx* = MIDITrack_InsertLyricExW
else:
  const
    MIDITrack_InsertLyricEx* = MIDITrack_InsertLyricExA
##  トラックにマーカーイベントを生成して挿入

proc MIDITrack_InsertMarkerA*(pMIDITrack: ptr MIDITrack; lTime: clong;
                             pszText: cstring): clong {.mididatalib_api.}
proc MIDITrack_InsertMarkerW*(pMIDITrack: ptr MIDITrack; lTime: clong;
                             pszText: ptr wchar_t): clong {.mididatalib_api.}
when defined(UNICODE):
  const
    MIDITrack_InsertMarker* = MIDITrack_InsertMarkerW
else:
  const
    MIDITrack_InsertMarker* = MIDITrack_InsertMarkerA
##  トラックにマーカーイベントを生成して挿入(文字コード指定あり)

proc MIDITrack_InsertMarkerExA*(pMIDITrack: ptr MIDITrack; lTime: clong;
                               lCharCode: clong; pszText: cstring): clong {.mididatalib_api.}
proc MIDITrack_InsertMarkerExW*(pMIDITrack: ptr MIDITrack; lTime: clong;
                               lCharCode: clong; pszText: ptr wchar_t): clong {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDITrack_InsertMarkerEx* = MIDITrack_InsertMarkerExW
else:
  const
    MIDITrack_InsertMarkerEx* = MIDITrack_InsertMarkerExA
##  トラックにキューポイントイベントを生成して挿入

proc MIDITrack_InsertCuePointA*(pMIDITrack: ptr MIDITrack; lTime: clong;
                               pszText: cstring): clong {.mididatalib_api.}
proc MIDITrack_InsertCuePointW*(pMIDITrack: ptr MIDITrack; lTime: clong;
                               pszText: ptr wchar_t): clong {.mididatalib_api.}
when defined(UNICODE):
  const
    MIDITrack_InsertCuePoint* = MIDITrack_InsertCuePointW
else:
  const
    MIDITrack_InsertCuePoint* = MIDITrack_InsertCuePointA
##  トラックにキューポイントイベントを生成して挿入(文字コード指定あり)

proc MIDITrack_InsertCuePointExA*(pMIDITrack: ptr MIDITrack; lTime: clong;
                                 lCharCode: clong; pszText: cstring): clong {.mididatalib_api.}
proc MIDITrack_InsertCuePointExW*(pMIDITrack: ptr MIDITrack; lTime: clong;
                                 lCharCode: clong; pszText: ptr wchar_t): clong {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDITrack_InsertCuePointEx* = MIDITrack_InsertCuePointExW
else:
  const
    MIDITrack_InsertCuePointEx* = MIDITrack_InsertCuePointExA
##  トラックにプログラム名イベントを生成して挿入

proc MIDITrack_InsertProgramNameA*(pTrack: ptr MIDITrack; lTime: clong;
                                  pszText: cstring): clong {.mididatalib_api.}
proc MIDITrack_InsertProgramNameW*(pTrack: ptr MIDITrack; lTime: clong;
                                  pszText: ptr wchar_t): clong {.mididatalib_api.}
when defined(UNICODE):
  const
    MIDITrack_InsertProgramName* = MIDITrack_InsertProgramNameW
else:
  const
    MIDITrack_InsertProgramName* = MIDITrack_InsertProgramNameA
##  トラックにプログラム名イベントを生成して挿入(文字コード指定あり)

proc MIDITrack_InsertProgramNameExA*(pTrack: ptr MIDITrack; lTime: clong;
                                    lCharCode: clong; pszText: cstring): clong {.
    mididatalib_api.}
proc MIDITrack_InsertProgramNameExW*(pTrack: ptr MIDITrack; lTime: clong;
                                    lCharCode: clong; pszText: ptr wchar_t): clong {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDITrack_InsertProgramNameEx* = MIDITrack_InsertProgramNameExW
else:
  const
    MIDITrack_InsertProgramNameEx* = MIDITrack_InsertProgramNameExA
##  トラックにデバイス名イベントを生成して挿入

proc MIDITrack_InsertDeviceNameA*(pTrack: ptr MIDITrack; lTime: clong;
                                 pszText: cstring): clong {.mididatalib_api.}
proc MIDITrack_InsertDeviceNameW*(pTrack: ptr MIDITrack; lTime: clong;
                                 pszText: ptr wchar_t): clong {.mididatalib_api.}
when defined(UNICODE):
  const
    MIDITrack_InsertDeviceName* = MIDITrack_InsertDeviceNameW
else:
  const
    MIDITrack_InsertDeviceName* = MIDITrack_InsertDeviceNameA
##  トラックにデバイス名イベントを生成して挿入(文字コード指定あり)

proc MIDITrack_InsertDeviceNameExA*(pTrack: ptr MIDITrack; lTime: clong;
                                   lCharCode: clong; pszText: cstring): clong {.
    mididatalib_api.}
proc MIDITrack_InsertDeviceNameExW*(pTrack: ptr MIDITrack; lTime: clong;
                                   lCharCode: clong; pszText: ptr wchar_t): clong {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDITrack_InsertDeviceNameEx* = MIDITrack_InsertDeviceNameExW
else:
  const
    MIDITrack_InsertDeviceNameEx* = MIDITrack_InsertDeviceNameExA
##  トラックにチャンネルプレフィックスイベントを生成して挿入

proc MIDITrack_InsertChannelPrefix*(pTrack: ptr MIDITrack; lTime: clong; lCh: clong): clong {.
    mididatalib_api.}
##  トラックにポートプレフィックスイベントを生成して挿入

proc MIDITrack_InsertPortPrefix*(pTrack: ptr MIDITrack; lTime: clong; lPort: clong): clong {.
    mididatalib_api.}
##  トラックにエンドオブトラックイベントを生成して挿入

proc MIDITrack_InsertEndofTrack*(pMIDITrack: ptr MIDITrack; lTime: clong): clong {.
    mididatalib_api.}
##  トラックにテンポイベントを生成して挿入

proc MIDITrack_InsertTempo*(pMIDITrack: ptr MIDITrack; lTime: clong; lTempo: clong): clong {.
    mididatalib_api.}
##  トラックにSMPTEオフセットイベントを生成して挿入

proc MIDITrack_InsertSMPTEOffset*(pTrack: ptr MIDITrack; lTime: clong; lMode: clong;
                                 lHour: clong; lMin: clong; lSec: clong;
                                 lFrame: clong; lSubFrame: clong): clong {.
    mididatalib_api.}
##  トラックに拍子記号イベントを生成して挿入

proc MIDITrack_InsertTimeSignature*(pMIDITrack: ptr MIDITrack; lTime: clong;
                                   lnn: clong; ldd: clong; lcc: clong; lbb: clong): clong {.
    mididatalib_api.}
##  トラックに調性記号イベントを生成して挿入

proc MIDITrack_InsertKeySignature*(pMIDITrack: ptr MIDITrack; lTime: clong;
                                  lsf: clong; lmi: clong): clong {.mididatalib_api.}
##  トラックにシーケンサー独自のイベントを生成して挿入

proc MIDITrack_InsertSequencerSpecific*(pMIDITrack: ptr MIDITrack; lTime: clong;
                                       pBuf: cstring; lLen: clong): clong {.mididatalib_api.}
##  トラックにノートオフイベントを生成して挿入

proc MIDITrack_InsertNoteOff*(pMIDITrack: ptr MIDITrack; lTime: clong; lCh: clong;
                             lKey: clong; lVel: clong): clong {.mididatalib_api.}
##  トラックにノートオンイベントを生成して挿入

proc MIDITrack_InsertNoteOn*(pMIDITrack: ptr MIDITrack; lTime: clong; lCh: clong;
                            lKey: clong; lVel: clong): clong {.mididatalib_api.}
##  トラックにノートイベントを生成して挿入

proc MIDITrack_InsertNote*(pMIDITrack: ptr MIDITrack; lTime: clong; lCh: clong;
                          lKey: clong; lVel: clong; lDur: clong): clong {.mididatalib_api.}
##  トラックにキーアフタータッチイベントを生成して挿入

proc MIDITrack_InsertKeyAftertouch*(pMIDITrack: ptr MIDITrack; lTime: clong;
                                   lCh: clong; lKey: clong; lVal: clong): clong {.
    mididatalib_api.}
##  トラックにコントロールチェンジイベントを生成して挿入

proc MIDITrack_InsertControlChange*(pMIDITrack: ptr MIDITrack; lTime: clong;
                                   lCh: clong; lNum: clong; lVal: clong): clong {.
    mididatalib_api.}
##  トラックにRPNチェンジイベントを生成して挿入

proc MIDITrack_InsertRPNChange*(pMIDITrack: ptr MIDITrack; lTime: clong; lCh: clong;
                               lCC101: clong; lCC100: clong; lVal: clong): clong {.
    mididatalib_api.}
##  トラックにNRPNチェンジイベントを生成して挿入

proc MIDITrack_InsertNRPNChange*(pMIDITrack: ptr MIDITrack; lTime: clong; lCh: clong;
                                lCC99: clong; lCC98: clong; lVal: clong): clong {.
    mididatalib_api.}
##  トラックにプログラムチェンジイベントを生成して挿入

proc MIDITrack_InsertProgramChange*(pMIDITrack: ptr MIDITrack; lTime: clong;
                                   lCh: clong; lNum: clong): clong {.mididatalib_api.}
##  トラックにパッチチェンジイベントを生成して挿入

proc MIDITrack_InsertPatchChange*(pMIDITrack: ptr MIDITrack; lTime: clong; lCh: clong;
                                 lCC0: clong; lCC32: clong; lNum: clong): clong {.
    mididatalib_api.}
##  トラックにチャンネルアフターイベントを生成して挿入

proc MIDITrack_InsertChannelAftertouch*(pMIDITrack: ptr MIDITrack; lTime: clong;
                                       lCh: clong; lVal: clong): clong {.mididatalib_api.}
##  トラックにピッチベンドイベントを生成して挿入

proc MIDITrack_InsertPitchBend*(pMIDITrack: ptr MIDITrack; lTime: clong; lCh: clong;
                               lVal: clong): clong {.mididatalib_api.}
##  トラックにシステムエクスクルーシヴイベントを生成して挿入

proc MIDITrack_InsertSysExEvent*(pMIDITrack: ptr MIDITrack; lTime: clong;
                                pBuf: ptr cuchar; lLen: clong): clong {.mididatalib_api.}
##  トラックからイベントを1つ取り除く(イベントオブジェクトは削除しません)

proc MIDITrack_RemoveSingleEvent*(pTrack: ptr MIDITrack; pEvent: ptr MIDIEvent): clong {.
    mididatalib_api.}
##  トラックからイベントを取り除く(イベントオブジェクトは削除しません)

proc MIDITrack_RemoveEvent*(pMIDITrack: ptr MIDITrack; pEvent: ptr MIDIEvent): clong {.
    mididatalib_api.}
##  MIDIトラックが浮遊トラックであるかどうかを調べる

proc MIDITrack_IsFloating*(pMIDITrack: ptr MIDITrack): clong {.mididatalib_api.}
##  MIDIトラックがセットアップトラックとして正しいことを確認する

proc MIDITrack_CheckSetupTrack*(pMIDITrack: ptr MIDITrack): clong {.mididatalib_api.}
##  MIDIトラックがノンセットアップトラックとして正しいことを確認する

proc MIDITrack_CheckNonSetupTrack*(pMIDITrack: ptr MIDITrack): clong {.mididatalib_api.}
##  タイムコードをミリ秒時刻に変換(指定トラック内のテンポイベントを基に計算)

proc MIDITrack_TimeToMillisec*(pMIDITrack: ptr MIDITrack; lTime: clong): clong {.
    mididatalib_api.}
##  ミリ秒時刻をタイムコードに変換(指定トラック内のテンポイベントを基に計算)

proc MIDITrack_MillisecToTime*(pMIDITrack: ptr MIDITrack; lMillisec: clong): clong {.
    mididatalib_api.}
##  タイムコードを小節：拍：ティックに分解(指定トラック内の拍子記号を基に計算)

proc MIDITrack_BreakTimeEx*(pMIDITrack: ptr MIDITrack; lTime: clong;
                           pMeasure: ptr clong; pBeat: ptr clong; pTick: ptr clong;
                           pnn: ptr clong; pdd: ptr clong; pcc: ptr clong; pbb: ptr clong): clong {.
    mididatalib_api.}
##  タイムコードを小節：拍：ティックに分解(指定トラック内の拍子記号を基に計算)

proc MIDITrack_BreakTime*(pMIDITrack: ptr MIDITrack; lTime: clong;
                         pMeasure: ptr clong; pBeat: ptr clong; pTick: ptr clong): clong {.
    mididatalib_api.}
##  小節：拍：ティックからタイムコードを生成(指定トラック内の拍子記号を基に計算)

proc MIDITrack_MakeTimeEx*(pMIDITrack: ptr MIDITrack; lMeasure: clong; lBeat: clong;
                          lTick: clong; pTime: ptr clong; pnn: ptr clong;
                          pdd: ptr clong; pcc: ptr clong; pbb: ptr clong): clong {.mididatalib_api.}
##  小節：拍：ティックからタイムコードを生成(指定トラック内の拍子記号を基に計算)

proc MIDITrack_MakeTime*(pMIDITrack: ptr MIDITrack; lMeasure: clong; lBeat: clong;
                        lTick: clong; pTime: ptr clong): clong {.mididatalib_api.}
##  指定位置におけるテンポを取得

proc MIDITrack_FindTempo*(pMIDITrack: ptr MIDITrack; lTime: clong; pTempo: ptr clong): clong {.
    mididatalib_api.}
##  指定位置における拍子記号を取得

proc MIDITrack_FindTimeSignature*(pMIDITrack: ptr MIDITrack; lTime: clong;
                                 pnn: ptr clong; pdd: ptr clong; pcc: ptr clong;
                                 pbb: ptr clong): clong {.mididatalib_api.}
##  指定位置における調性記号を取得

proc MIDITrack_FindKeySignature*(pMIDITrack: ptr MIDITrack; lTime: clong;
                                psf: ptr clong; pmi: ptr clong): clong {.mididatalib_api.}
## ****************************************************************************
##
## 　MIDIDataクラス関数
##
## ****************************************************************************
##  MIDIデータの指定トラックの直前にトラックを挿入

proc MIDIData_InsertTrackBefore*(pMIDIData: ptr MIDIData; pMIDITrack: ptr MIDITrack;
                                pTarget: ptr MIDITrack): clong {.mididatalib_api.}
##  MIDIデータの指定トラックの直後にトラックを挿入

proc MIDIData_InsertTrackAfter*(pMIDIData: ptr MIDIData; pMIDITrack: ptr MIDITrack;
                               pTarget: ptr MIDITrack): clong {.mididatalib_api.}
##  MIDIデータにトラックを追加(トラックは予め生成しておく)

proc MIDIData_AddTrack*(pMIDIData: ptr MIDIData; pMIDITrack: ptr MIDITrack): clong {.
    mididatalib_api.}
##  MIDIデータ内のトラックを複製する

proc MIDIData_DuplicateTrack*(pMIDIData: ptr MIDIData; pTrack: ptr MIDITrack): clong {.
    mididatalib_api.}
##  MIDIデータからトラックを除去(トラック自体及びトラック内のイベントは削除しない)

proc MIDIData_RemoveTrack*(pMIDIData: ptr MIDIData; pMIDITrack: ptr MIDITrack): clong {.
    mididatalib_api.}
##  MIDIデータの削除(含まれるトラック及びイベントもすべて削除)

proc MIDIData_Delete*(pMIDIData: ptr MIDIData) {.mididatalib_api.}
##  MIDIデータを生成し、MIDIデータへのポインタを返す(失敗時NULL)

proc MIDIData_Create*(lFormat: clong; lNumTrack: clong; lTimeMode: clong;
                     lResolution: clong): ptr MIDIData {.mididatalib_api.}
##  MIDIデータのフォーマット0/1/2を取得

proc MIDIData_GetFormat*(pMIDIData: ptr MIDIData): clong {.mididatalib_api.}
##  MIDIデータのフォーマット0/1/2を設定(変更時コンバート機能を含む)

proc MIDIData_SetFormat*(pMIDIData: ptr MIDIData; lFormat: clong): clong {.mididatalib_api.}
##  MIDIデータのタイムベース取得

proc MIDIData_GetTimeBase*(pMIDIData: ptr MIDIData; pMode: ptr clong;
                          pResolution: ptr clong): clong {.mididatalib_api.}
##  MIDIデータのタイムベースのタイムモード取得

proc MIDIData_GetTimeMode*(pMIDIData: ptr MIDIData): clong {.mididatalib_api.}
##  MIDIデータのタイムベースのレゾリューション取得

proc MIDIData_GetTimeResolution*(pMIDIData: ptr MIDIData): clong {.mididatalib_api.}
##  MIDIデータのタイムベース設定

proc MIDIData_SetTimeBase*(pMIDIData: ptr MIDIData; lMode: clong; lResolution: clong): clong {.
    mididatalib_api.}
##  MIDIデータのトラック数取得

proc MIDIData_GetNumTrack*(pMIDIData: ptr MIDIData): clong {.mididatalib_api.}
##  トラック数をカウントし、各トラックのインデックスと総トラック数を更新し、トラック数を返す。

proc MIDIData_CountTrack*(pMIDIData: ptr MIDIData): clong {.stdcall, importc, importc.}
##  XFであるとき、XFのヴァージョンを取得(XFでなければ0)

proc MIDIData_GetXFVersion*(pMIDIData: ptr MIDIData): clong {.mididatalib_api.}
##  MIDIデータの最初のトラックへのポインタを取得(なければNULL)

proc MIDIData_GetFirstTrack*(pMIDIData: ptr MIDIData): ptr MIDITrack {.mididatalib_api.}
##  MIDIデータの最後のトラックへのポインタを取得(なければNULL)

proc MIDIData_GetLastTrack*(pMIDIData: ptr MIDIData): ptr MIDITrack {.mididatalib_api.}
##  指定インデックスのMIDIトラックへのポインタを取得する(なければNULL)

proc MIDIData_GetTrack*(pMIDIData: ptr MIDIData; lTrackIndex: clong): ptr MIDITrack {.
    mididatalib_api.}
##  MIDIデータの開始時刻[Tick]を取得

proc MIDIData_GetBeginTime*(pMIDIData: ptr MIDIData): clong {.mididatalib_api.}
##  MIDIデータの終了時刻[Tick]を取得

proc MIDIData_GetEndTime*(pMIDIData: ptr MIDIData): clong {.mididatalib_api.}
##  MIDIデータのタイトルを簡易取得

proc MIDIData_GetTitleA*(pMIDIData: ptr MIDIData; pData: cstring; lLen: clong): cstring {.
    mididatalib_api.}
proc MIDIData_GetTitleW*(pMIDIData: ptr MIDIData; pData: ptr wchar_t; lLen: clong): ptr wchar_t {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDIData_GetTitle* = MIDIData_GetTitleW
else:
  const
    MIDIData_GetTitle* = MIDIData_GetTitleA
##  MIDIデータのタイトルを簡易設定

proc MIDIData_SetTitleA*(pMIDIData: ptr MIDIData; pszData: cstring): clong {.mididatalib_api.}
proc MIDIData_SetTitleW*(pMIDIData: ptr MIDIData; pszData: ptr wchar_t): clong {.mididatalib_api.}
when defined(UNICODE):
  const
    MIDIData_SetTitle* = MIDIData_SetTitleW
else:
  const
    MIDIData_SetTitle* = MIDIData_SetTitleA
##  MIDIデータのサブタイトルを簡易取得

proc MIDIData_GetSubTitleA*(pMIDIData: ptr MIDIData; pData: cstring; lLen: clong): cstring {.
    mididatalib_api.}
proc MIDIData_GetSubTitleW*(pMIDIData: ptr MIDIData; pData: ptr wchar_t; lLen: clong): ptr wchar_t {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDIData_GetSubTitle* = MIDIData_GetSubTitleW
else:
  const
    MIDIData_GetSubTitle* = MIDIData_GetSubTitleA
##  MIDIデータのサブタイトルを簡易設定

proc MIDIData_SetSubTitleA*(pMIDIData: ptr MIDIData; pszData: cstring): clong {.mididatalib_api.}
proc MIDIData_SetSubTitleW*(pMIDIData: ptr MIDIData; pszData: ptr wchar_t): clong {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDIData_SetSubTitle* = MIDIData_SetSubTitleW
else:
  const
    MIDIData_SetSubTitle* = MIDIData_SetSubTitleA
##  MIDIデータの著作権を簡易取得

proc MIDIData_GetCopyrightA*(pMIDIData: ptr MIDIData; pData: cstring; lLen: clong): cstring {.
    mididatalib_api.}
proc MIDIData_GetCopyrightW*(pMIDIData: ptr MIDIData; pData: ptr wchar_t; lLen: clong): ptr wchar_t {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDIData_GetCopyright* = MIDIData_GetCopyrightW
else:
  const
    MIDIData_GetCopyright* = MIDIData_GetCopyrightA
##  MIDIデータの著作権を簡易設定

proc MIDIData_SetCopyrightA*(pMIDIData: ptr MIDIData; pszData: cstring): clong {.
    mididatalib_api.}
proc MIDIData_SetCopyrightW*(pMIDIData: ptr MIDIData; pszData: ptr wchar_t): clong {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDIData_SetCopyright* = MIDIData_SetCopyrightW
else:
  const
    MIDIData_SetCopyright* = MIDIData_SetCopyrightA
##  MIDIデータのコメントを簡易取得

proc MIDIData_GetCommentA*(pMIDIData: ptr MIDIData; pData: cstring; lLen: clong): cstring {.
    mididatalib_api.}
proc MIDIData_GetCommentW*(pMIDIData: ptr MIDIData; pData: ptr wchar_t; lLen: clong): ptr wchar_t {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDIData_GetComment* = MIDIData_GetCommentW
else:
  const
    MIDIData_GetComment* = MIDIData_GetCommentA
##  MIDIデータのコメントを簡易設定

proc MIDIData_SetCommentA*(pMIDIData: ptr MIDIData; pszData: cstring): clong {.mididatalib_api.}
proc MIDIData_SetCommentW*(pMIDIData: ptr MIDIData; pszData: ptr wchar_t): clong {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDIData_SetComment* = MIDIData_SetCommentW
else:
  const
    MIDIData_SetComment* = MIDIData_SetCommentA
##  タイムコードをミリ秒に変換(フォーマット0/1の場合のみ)

proc MIDIData_TimeToMillisec*(pMIDIData: ptr MIDIData; lTime: clong): clong {.mididatalib_api.}
##  ミリ秒をタイムコードに変換(フォーマット0/1の場合のみ)

proc MIDIData_MillisecToTime*(pMIDIData: ptr MIDIData; lMillisec: clong): clong {.
    mididatalib_api.}
##  タイムコードを小節：拍：ティックに分解(最初のトラック内の拍子記号から計算)

proc MIDIData_BreakTime*(pMIDIData: ptr MIDIData; lTime: clong; pMeasure: ptr clong;
                        pBeat: ptr clong; pTick: ptr clong): clong {.mididatalib_api.}
##  タイムコードを小節：拍：ティックに分解(最初のトラック内の拍子記号を基に計算)

proc MIDIData_BreakTimeEx*(pMIDIData: ptr MIDIData; lTime: clong; pMeasure: ptr clong;
                          pBeat: ptr clong; pTick: ptr clong; pnn: ptr clong;
                          pdd: ptr clong; pcc: ptr clong; pbb: ptr clong): clong {.mididatalib_api.}
##  小節：拍：ティックからタイムコードを生成(最初のトラック内の拍子記号から計算)

proc MIDIData_MakeTime*(pMIDIData: ptr MIDIData; lMeasure: clong; lBeat: clong;
                       lTick: clong; pTime: ptr clong): clong {.mididatalib_api.}
##  小節：拍：ティックからタイムコードを生成(最初のトラック内の拍子記号を基に計算)

proc MIDIData_MakeTimeEx*(pMIDIData: ptr MIDIData; lMeasure: clong; lBeat: clong;
                         lTick: clong; pTime: ptr clong; pnn: ptr clong; pdd: ptr clong;
                         pcc: ptr clong; pbb: ptr clong): clong {.mididatalib_api.}
##  指定位置におけるテンポを取得

proc MIDIData_FindTempo*(pMIDIData: ptr MIDIData; lTime: clong; pTempo: ptr clong): clong {.
    mididatalib_api.}
##  指定位置における拍子記号を取得

proc MIDIData_FindTimeSignature*(pMIDIData: ptr MIDIData; lTime: clong;
                                pnn: ptr clong; pdd: ptr clong; pcc: ptr clong;
                                pbb: ptr clong): clong {.mididatalib_api.}
##  指定位置における調性記号を取得

proc MIDIData_FindKeySignature*(pMIDIData: ptr MIDIData; lTime: clong; psf: ptr clong;
                               pmi: ptr clong): clong {.mididatalib_api.}
##  このMIDIデータに別のMIDIデータをマージする(20080715廃止)
## long __stdcall, importc MIDIData_Merge (MIDIData* pMIDIData, MIDIData* pMergeData,
## 	long lTime, long lFlags, long* pInsertedEventCount, long* pDeletedEventCount);
##  保存・読み込み用関数
##  MIDIDataをスタンダードMIDIファイル(SMF)から読み込み、
##  新しいMIDIデータへのポインタを返す(失敗時NULL)

proc MIDIData_LoadFromSMFA*(pszFileName: cstring): ptr MIDIData {.mididatalib_api.}
proc MIDIData_LoadFromSMFW*(pszFileName: ptr wchar_t): ptr MIDIData {.mididatalib_api.}
when defined(UNICODE):
  const
    MIDIData_LoadFromSMF* = MIDIData_LoadFromSMFW
else:
  const
    MIDIData_LoadFromSMF* = MIDIData_LoadFromSMFA
##  MIDIデータをスタンダードMIDIファイル(SMF)として保存

proc MIDIData_SaveAsSMFA*(pMIDIData: ptr MIDIData; pszFileName: cstring): clong {.
    mididatalib_api.}
proc MIDIData_SaveAsSMFW*(pMIDIData: ptr MIDIData; pszFileName: ptr wchar_t): clong {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDIData_SaveAsSMF* = MIDIData_SaveAsSMFW
else:
  const
    MIDIData_SaveAsSMF* = MIDIData_SaveAsSMFA
##  MIDIDataをテキストファイルから読み込み、
##  新しいMIDIデータへのポインタを返す(失敗時NULL)

proc MIDIData_LoadFromTextA*(pszFileName: cstring): ptr MIDIData {.mididatalib_api.}
proc MIDIData_LoadFromTextW*(pszFileName: ptr wchar_t): ptr MIDIData {.mididatalib_api.}
when defined(UNICODE):
  const
    MIDIData_LoadFromText* = MIDIData_LoadFromTextW
else:
  const
    MIDIData_LoadFromText* = MIDIData_LoadFromTextA
##  MIDIDataをテキストファイルとして保存

proc MIDIData_SaveAsTextA*(pMIDIData: ptr MIDIData; pszFileName: cstring): clong {.
    mididatalib_api.}
proc MIDIData_SaveAsTextW*(pMIDIData: ptr MIDIData; pszFileName: ptr wchar_t): clong {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDIData_SaveAsText* = MIDIData_SaveAsTextW
else:
  const
    MIDIData_SaveAsText* = MIDIData_SaveAsTextA
##  MIDIDataをバイナリファイルから読み込み、
##  新しいMIDIデータへのポインタを返す(失敗時NULL)

proc MIDIData_LoadFromBinaryA*(pszFileName: cstring): ptr MIDIData {.mididatalib_api.}
proc MIDIData_LoadFromBinaryW*(pszFileName: ptr wchar_t): ptr MIDIData {.mididatalib_api.}
when defined(UNICODE):
  const
    MIDIData_LoadFromBinary* = MIDIData_LoadFromBinaryW
else:
  const
    MIDIData_LoadFromBinary* = MIDIData_LoadFromBinaryA
##  MIDIDataをバイナリファイルに保存

proc MIDIData_SaveAsBinaryA*(pMIDIData: ptr MIDIData; pszFileName: cstring): clong {.
    mididatalib_api.}
proc MIDIData_SaveAsBinaryW*(pMIDIData: ptr MIDIData; pszFileName: ptr wchar_t): clong {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDIData_SaveAsBinary* = MIDIData_SaveAsBinaryW
else:
  const
    MIDIData_SaveAsBinary* = MIDIData_SaveAsBinaryA
##  MIDIDataをCherrryファイル(*.chy)から読み込み、
##  新しいMIDIデータへのポインタを返す(失敗時NULL)

proc MIDIData_LoadFromCherryA*(pszFileName: cstring): ptr MIDIData {.mididatalib_api.}
proc MIDIData_LoadFromCherryW*(pszFileName: ptr wchar_t): ptr MIDIData {.mididatalib_api.}
when defined(UNICODE):
  const
    MIDIData_LoadFromCherry* = MIDIData_LoadFromCherryW
else:
  const
    MIDIData_LoadFromCherry* = MIDIData_LoadFromCherryA
##  MIDIデータをCherryファイル(*.chy)に保存

proc MIDIData_SaveAsCherryA*(pMIDIData: ptr MIDIData; pszFileName: cstring): clong {.
    mididatalib_api.}
proc MIDIData_SaveAsCherryW*(pMIDIData: ptr MIDIData; pszFileName: ptr wchar_t): clong {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDIData_SaveAsCherry* = MIDIData_SaveAsCherryW
else:
  const
    MIDIData_SaveAsCherry* = MIDIData_SaveAsCherryA
##  MIDIデータをMIDICSVファイル(*.csv)から読み込み
##  新しいMIDIデータへのポインタを返す(失敗時NULL)

proc MIDIData_LoadFromMIDICSVA*(pszFileName: cstring): ptr MIDIData {.mididatalib_api.}
proc MIDIData_LoadFromMIDICSVW*(pszFileName: ptr wchar_t): ptr MIDIData {.mididatalib_api.}
when defined(UNICODE):
  const
    MIDIData_LoadFromMIDICSV* = MIDIData_LoadFromMIDICSVW
else:
  const
    MIDIData_LoadFromMIDICSV* = MIDIData_LoadFromMIDICSVA
##  MIDIデータをMIDICSVファイル(*.csv)として保存

proc MIDIData_SaveAsMIDICSVA*(pMIDIData: ptr MIDIData; pszFileName: cstring): clong {.
    mididatalib_api.}
proc MIDIData_SaveAsMIDICSVW*(pMIDIData: ptr MIDIData; pszFileName: ptr wchar_t): clong {.
    mididatalib_api.}
when defined(UNICODE):
  const
    MIDIData_SaveAsMIDICSV* = MIDIData_SaveAsMIDICSVW
else:
  const
    MIDIData_SaveAsMIDICSV* = MIDIData_SaveAsMIDICSVA
##  MIDIデータを旧Cakewalkシーケンスファイル(*.wrk)から読み込み
##  新しいMIDIデータへのポインタを返す(失敗時NULL)

proc MIDIData_LoadFromWRKA*(pszFileName: cstring): ptr MIDIData {.mididatalib_api.}
proc MIDIData_LoadFromWRKW*(pszFileName: ptr wchar_t): ptr MIDIData {.mididatalib_api.}
when defined(UNICODE):
  const
    MIDIData_LoadFromWRK* = MIDIData_LoadFromWRKW
else:
  const
    MIDIData_LoadFromWRK* = MIDIData_LoadFromWRKA
##  MIDIデータをマビノギMMLファイル(*.mml)から読み込み
##  新しいMIDIデータへのポインタを返す(失敗時NULL)

proc MIDIData_LoadFromMabiMMLA*(pszFileName: cstring): ptr MIDIData {.mididatalib_api.}
proc MIDIData_LoadFromMabiMMLW*(pszFileName: ptr wchar_t): ptr MIDIData {.mididatalib_api.}
when defined(UNICODE):
  const
    MIDIData_LoadFromMabiMML* = MIDIData_LoadFromMabiMMLW
else:
  const
    MIDIData_LoadFromMabiMML* = MIDIData_LoadFromMabiMMLA