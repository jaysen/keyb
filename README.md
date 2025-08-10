# keyb — Home-row navigation and text selection (AHK on Windows, keyd on Linux)

---

## Why this exists

Provide simple keyboard shortcuts for navigation and text selection without using arrow keys. Inspired by Vim, but works in all apps on both Linux and Windows.

* **CapsLayer/NavMode** for arrows, selection, word/line jumps, and page/document movement.
* Slight Vim influence for keeping hands on the home row.
* Same bindings across both OSes.

---

## Windows

* **AutoHotkey v2** scripts.
* Libraries:

  * `nav_lib.ahk` - movement
  * `text_lib.ahk` - text editing
  * `ui_lib.ahk` - modes/layers, tooltips

## Linux

* Using keyd for low-latency, system-wide remaps.

## Multiplatform

* Planning to use [Kanata](https://github.com/jtroo/kanata)

---

## Keymap (universal)

| Chord             | Action                      |
| ----------------- | --------------------------- |
| **Caps + W / E / I** | Up                        |
| **Caps + A / J**  | Left                        |
| **Caps + S / K**  | Down                        |
| **Caps + D / L**  | Right                       |
| **Caps + Q / Tab**| Delete / Backspace          |
| **Caps + H**      | Ctrl+Left                   |
| **Caps + ; / '**  | Ctrl+Right                  |
| **Caps + U / O**  | Home / End                  |
| **Caps + Y / P**  | Shift+Home / Shift+End      |
| **Caps + N**      | Shift+Ctrl+Left             |
| **Caps + M**      | Shift+Left                  |
| **Caps + .**      | Shift+Right                 |
| **Caps + /**      | Shift+Ctrl+Right            |
| **Caps + Z / X**  | Shift+Home / Shift+End      |
| **Caps + R / F**  | Shift+Up / Shift+Down       |
| **Caps + T / G**  | Shift+PageUp / Shift+PageDown |
| **Caps + 1..0 / - / =** | F1..F12                |

---

## License

See [LICENSE.txt](LICENSE.txt) for details. This project is licensed under the **GPL-3.0-or-later**.


