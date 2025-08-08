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
  
* Example bindings:

  * **Caps + WASD / IJKL** → arrows
  * **Caps + H / ' (quote)** → Home / End
  * **Caps + P / /** → PageUp / PageDown
  * **Caps + , / .** → Ctrl+Left / Ctrl+Right
  * **Caps + U / M** → move up/down 2 lines
  * **Caps + Y / N** → move up/down 5 lines
  * **Caps + T / B** → move up/down 10 lines
  * **Caps + E / R** → expand selection by word backward/forward
  * **Caps + C / V** → expand selection by char backward/forward
  * **Caps + Q / Tab** → expand selection by char forward/backward
  * **Caps + X / Z** → expand selection to line end/start
  * **Caps + \[ / ]** → expand selection by word backward/forward
  * **Caps + F / G / \\** → select current word / select line
  * **Win + J** → toggle NavMode
  * **Caps + numbers / - / =** → F‑keys (F1–F12)

---

## Linux

* Use **keyd** for low‑latency, system‑wide remaps.

## Multiplatform

* Planning to use [Kanata](https://github.com/jtroo/kanata)


---

## Keymap (starter set)

| Chord             | Action                                    |
| ----------------- | ----------------------------------------- |
| Caps + W/A/S/D    | ↑ / ← / ↓ / →                             |
| Caps + I/J/K/L    | ↑ / ← / ↓ / → (alt cluster)               |
| Caps + H / '      | Home / End                                |
| Caps + P / /      | PageUp / PageDown                         |
| Caps + , / .      | Ctrl+← / Ctrl+→                           |
| Caps + U / M      | Move up/down 2 lines                      |
| Caps + Y / N      | Move up/down 5 lines                      |
| Caps + T / B      | Move up/down 10 lines                     |
| Caps + E / R      | Expand selection by word backward/forward |
| Caps + C / V      | Expand selection by char backward/forward |
| Caps + Q / Tab    | Expand selection by char forward/backward |
| Caps + X / Z      | Expand selection to line end/start        |
| Caps + \[ / ]     | Expand selection by word backward/forward |
| Caps + F / G / \\ | Select current word / Select line         |
| Win + J           | Toggle NavMode                            |
| Caps + 1..0/-/=   | F1..F12                                   |

---

## License

See  [LICENSE.txt](LICENSE.txt) for details. This project is licensed under the **GPL‑3.0‑or‑later**.
