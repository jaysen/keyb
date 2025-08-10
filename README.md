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

### **Navigation Arrows - Left Hand (WASD)**
| Chord          | Function |
| -------------- | -------- |
| **Caps + W / E** | Move cursor up | 
| **Caps + A**     | Move cursor left |
| **Caps + S**     | Move cursor down |
| **Caps + D**     | Move cursor right |

---

### **Navigation Arrows - Right Hand (IJKL)**
| Chord          | Function |
| -------------- | -------- |
| **Caps + I** | Move cursor up |
| **Caps + J** | Move cursor left |
| **Caps + K** | Move cursor down |
| **Caps + L** | Move cursor right |

---

### **Navigation by Word - Right Hand Centre**
| Chord             | Function                  |
| ----------------- | ------------------------- |
| **Caps + H**      | Move cursor by word (backward) |
| **Caps + ;**      | Move cursor by word (forward)  |
| **Caps + '**      | Move cursor by word (forward)  |

---

### **Selection by Line - Right Hand Top**
| Chord             | Function                     |
| ----------------- | ---------------------------- |
| **Caps + U**      | Move cursor to start of line  |
| **Caps + O**      | Move cursor to end of line    |
| **Caps + Y**      | Expand selection to start of line |
| **Caps + P**      | Expand selection to end of line   |
HomeZone Navigation & Selection
---

### **Selection by Chars and Words - Right Hand Bottom**
| Chord             | Function                               |
| ----------------- | -------------------------------------- |
| **Caps + N**      | Expand selection by word (backward)    |
| **Caps + M**      | Expand selection by character (left)   |
| **Caps + .**      | Expand selection by character (right)  |
| **Caps + /**      | Expand selection by word (forward)     |

---

### **Selection by Home/End - Left Hand Bottom**
| Chord             | Function                     |
| ----------------- | ---------------------------- |
| **Caps + Z**      | Expand selection to start of line |
| **Caps + X**      | Expand selection to end of line   |

---

### **Selection Up/Down - Left Hand Centre and Top**
| Chord             | Function                          |
| ----------------- | --------------------------------- |
| **Caps + R**      | Expand selection up one line      |
| **Caps + F**      | Expand selection down one line    |
| **Caps + T**      | Expand selection up one page      |
| **Caps + G**      | Expand selection down one page    |

---

### **Delete/Backspace - Left Hand Top**
| Chord             | Function       |
| ----------------- | -------------- |
| **Caps + Q**      | Delete character forward |
| **Caps + Tab**    | Delete character backward (Backspace) |

---

### **Function Keys**
| Chord             | Function |
| ----------------- | -------- |
| **Caps + 1..0, -, =** | F1..F12 |

---

## License

See [LICENSE.txt](LICENSE.txt) for details. This project is licensed under the **GPL-3.0-or-later**.
