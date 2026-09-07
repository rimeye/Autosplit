# FC Game Autosplitters

This repository contains a set of **LiveSplit** autosplitter scripts (ASL) for the FC/NES games
*Mega Man* (*Rockman*) 1–6 and *Jackal*. Each script reads emulator memory and splits the timer
automatically at level / boss milestones.

## Games and files

| Game | File | Notes |
|---|---|---|
| Jackal | [Jackalautosplit.asl](Jackalautosplit.asl) | Splits on every STAGE CLEAR screen, final split on boss kill |
| Mega Man 1 | [lkr1ye.asl](lkr1ye.asl) |  |
| Mega Man 2 | [lkr2ye.asl](lkr2ye.asl) |  |
| Mega Man 3 | [lkr3ye.asl](lkr3ye.asl) |  |
| Mega Man 4 | [lkr4ye.asl](lkr4ye.asl) |  |
| Mega Man 5 | [lkr5ye.asl](lkr5ye.asl) | Splits on black-screen fades |
| Mega Man 5 | [lkr5ye_alt.asl](lkr5ye_alt.asl) | Ascension-timing splits |
| Mega Man 6 | [lkr6ye.asl](lkr6ye.asl) | **US version only** |

> Mega Man 5 has two scripts: `lkr5ye.asl` (black-screen fade splits) and `lkr5ye_alt.asl`
> (original-timing splits). Pick whichever matches your segment layout.

## Declarations

- All autosplitter scripts in this repository are independently written original works.

## Supported emulators

Currently supported emulators:

- **Mesen 2.1.1**
- **Mesen 0.9.9**
- **MesenRTA (0.0.7)**
- **fceux-2.6.6-y320-Win64-汉化版 (Emucheat)**

The script auto-detects the emulator version on load:

- Mesen family: picks the version by comparing the SHA1 of `MesenCore.dll`;
- FCEUX: identifies the 64-bit 汉化版 (Emucheat) build by module memory size.

## Usage

1. Open LiveSplit, right-click the timer → **Edit Layout…**;
2. Click **＋** and add a **Scriptable Auto Splitter** (under the Control category);
3. Double-click that **Scriptable Auto Splitter** to open **Layout Settings**;
4. Click **Browse…**, find the matching `.asl` file and open it;
5. Click **OK** when done.

The script auto-detects the emulator version and splits on level/boss milestones as you play.

> For more details, see the original post from ye:
> [https://www.bilibili.com/opus/1224952598747938821](https://www.bilibili.com/opus/1224952598747938821)

## Alternative: LiveSplit's autosplitter library

LiveSplit downloads a public registry of known games (`LiveSplit.AutoSplitters.xml`) on startup.
If your Game Name matches an entry, you can use this flow instead:

1. Open LiveSplit, right-click → **Edit Splits**;
2. Set the **Game Name** to the matching title (optional; used for registry lookup, e.g. **"Mega Man 5"**);
3. Set up **16 segments** below (required);
4. Click **Activate** to enable the script, then click **Settings**;
5. Click **Browse…** and open the matching `.asl` from this folder (e.g. `lkr5ye.asl`);
6. Check **Star Split**; under **Options**, check **"Split on black screen after Mega Man vanishes in Dark 4"** (if you want a Dark 4 split);
7. Click **OK** when done.

## Notes

- Each script contains an Info/description block with its split rules;
- If you get "Unrecognized Mesen version" or a detection failure, verify the emulator is one of the supported versions above.
