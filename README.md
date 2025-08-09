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

  * `nav_lib.ahk` – movement
  * `text_lib.ahk` – text editing
  * `ui_lib.ahk` – modes/layers, tooltips

## Linux

* Using keyd for low‑latency, system‑wide remaps.

## Multiplatform

* Planning to use [Kanata](https://github.com/jtroo/kanata)

---

## Keymap (universal)

| Chord           | Action                      |
| --------------- | --------------------------- |
| Caps + W/A/S/D  | ↑ / ← / ↓ / →               |
| Caps + I/J/K/L  | ↑ / ← / ↓ / → (alt cluster) |
| Caps + H / '    | Home / End                  |
| Caps + Q / Tab  | Delete / Backspace          |
| Caps + Y / U    | Ctrl+← / Ctrl+→             |
| Caps + N / M    | Shift+Ctrl+← / Shift+Ctrl+→ |
| Caps + X        | Shift+End                   |
| Caps + , / .    | Shift+← / Shift+→           |
| Caps + P / /    | Shift+↑ / Shift+↓           |
| Caps + 1..0/-/= | F1..F12                     |

---

## License

See [LICENSE.txt](LICENSE.txt) for details. This project is licensed under the **GPL‑3.0‑or‑later**.
