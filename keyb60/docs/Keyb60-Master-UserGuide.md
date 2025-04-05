# Keyboard Master - User Guide

This comprehensive system enhances your 60%/70% mechanical keyboard experience with navigation helpers, Vim-style editing, application launching, and text expansion macros.

## Getting Started

1. **Installation**:
   - Make sure you have AutoHotkey v2.0+ installed 
   - Place all script files in the same folder
   - Run `keyboard_launcher.ahk` to start the system
   - Add it to your Windows startup folder for automatic loading

2. **Core Files**:
   - `keyboard_launcher.ahk` - The main entry point, run this to start everything
   - `keyboard_master.ahk` - The main functionality implementation
   - `key60_lib.ahk` - Shared functions and utilities
   - `keyboard_settings.ahk` - User customization settings
   - `vim.ahk` - Vim emulation functionality

## Navigation Mode

**Activation**: Press `Win+J` to toggle

When active, you get dual layer navigation systems:

### WASD Navigation
- `W` = Up Arrow
- `A` = Left Arrow
- `S` = Down Arrow
- `D` = Right Arrow

### IJKL Navigation
- `I` = Up Arrow
- `J` = Left Arrow
- `K` = Down Arrow
- `L` = Right Arrow

### Additional Navigation Keys
- `H` or `Q` = Home
- `'` or `E` = End
- `P` = Page Up
- `/` = Page Down
- `,` = Ctrl+Left (previous word)
- `.` = Ctrl+Right (next word)
- `U` = Ctrl+Up (paragraph up)
- `M` = Ctrl+Down (paragraph down)

### Function Keys
- `1-0` = F1-F10
- `-` = F11
- `=` = F12

### Media Controls
- `[` = Volume Down
- `]` = Volume Up
- `\` = Mute
- `Backspace` = Delete
- `Enter` = Insert

### Window Management
- `Z` = Snap window left
- `X` = Snap window right
- `C` = Minimize window
- `V` = Maximize window
- `B` = Alt+Tab (window switching)

### Mouse Control
- `Q` = Move cursor left
- `W` = Move cursor up
- `E` = Move cursor down
- `R` = Move cursor right
- `F` = Left click
- `G` = Right click
- `T` = Middle click
- `Z` = Scroll up
- `X` = Scroll down

## Vim Mode

**Activation**: Press `Win+V` to toggle

Provides Vim-style keyboard commands in any text editor:

### Modes
- Escape = Return to Normal mode
- `i` = Insert mode
- `v` = Visual (selection) mode

### Movement (Normal mode)
- `h/j/k/l` = Move cursor left/down/up/right
- `w` = Jump to next word
- `b` = Jump to previous word
- `0` = Start of line
- `$` = End of line
- `gg` = Start of document
- `G` = End of document
- `Ctrl+u` = Page up
- `Ctrl+d` = Page down

### Editing (Normal mode)
- `x` = Delete character
- `s` = Delete character and enter Insert mode
- `dd` = Delete line
- `yy` = Copy line
- `p` = Paste after cursor
- `P` = Paste before cursor
- `u` = Undo
- `Ctrl+r` = Redo
- `/` = Find

### Commands (Normal mode)
- `I` = Insert at start of line
- `A` = Append at end of line
- `o` = Open line below
- `O` = Open line above
- `C` = Change to end of line
- `r` = Replace character

### Visual Mode
- `h/j/k/l` = Extend selection left/down/up/right
- `w` = Extend selection to next word
- `b` = Extend selection to previous word
- `0` = Select to start of line
- `$` = Select to end of line
- `y` = Copy selection
- `d` = Cut selection
- `x` = Delete selection

## App Launcher Mode

**Activation**: Press `Win+A` to toggle

Quick application launching using single keystrokes:

- `C` = Calculator
- `N` = Notepad
- `B` = Edge Browser
- `F` = File Explorer
- `W` = Word
- `E` = Excel
- `V` = VS Code
- `T` = Windows Terminal
- `G` = Git Bash
- `P` = PowerShell
- `S` = Stack Overflow
- `D` = Visual Studio
- `M` = Email
- `K` = Task Manager
- `L` = Windows Settings
- `J` = Add/Remove Programs

## Macro Mode

**Activation**: Press `Win+M` to toggle

Text expansion for frequently used text:

- `D` = Current date (YYYY-MM-DD)
- `T` = Current time (HH:MM:SS)
- `E` = Your email address
- `S` = Signature
- `A` = Your address
- `1-3` = Predefined messages

## Customization

Edit `keyboard_settings.ahk` to customize:

1. **Hotkeys**: Change which key combinations trigger each mode
2. **Visual Settings**: Modify colors, indicators, tooltips
3. **App Shortcuts**: Change which applications open in App Launcher mode
4. **Macros**: Edit text snippets for Macro mode
5. **Navigation**: Enable/disable specific navigation features

## Tips for 60% Keyboard Users

1. **Use CapsLock as a modifier**: Hold CapsLock to temporarily activate Navigation mode
2. **Win+CapsLock**: Toggle the actual CapsLock state when needed
3. **Memorize mode toggles**: Win+J (Nav), Win+V (Vim), Win+A (Apps), Win+M (Macros)
4. **Learn app shortcuts**: The App Launcher mode saves you from hunting through menus
5. **Customize your settings**: Edit the settings file to match your workflow and preferences
6. **Use both WASD and IJKL**: Learn both navigation styles to find which is more comfortable
7. **Try the mouse controls**: When you need precise mouse control without reaching for your actual mouse

## Practice Regimen

To master your keyboard setup, try this progressive practice approach:

### Week 1: Basic Navigation
- Start with Navigation mode only
- Spend 30 minutes each day using WASD/IJKL instead of arrow keys
- Practice using Home/End/Page Up/Page Down keys
- Try to avoid touching your mouse completely for text navigation

### Week 2: Window Management
- Continue Navigation mode practice
- Add window management shortcuts (Z/X/C/V)
- Practice snapping windows to different sides of the screen
- Use Alt+Tab (B key in Navigation mode) to switch between applications

### Week 3: App Launcher
- Add the App Launcher to your workflow
- Create a list of your most-used applications
- Customize the app shortcuts in keyboard_settings.ahk
- Time yourself launching applications with and without the launcher

### Week 4: Vim Basics
- Begin learning Vim mode with basic movements (h/j/k/l)
- Practice switching between Insert and Normal modes
- Learn basic editing commands (x, dd, yy, p)
- Use Vim mode for at least 30 minutes each day, even if it slows you down

### Week 5: Advanced Vim
- Add more Vim commands to your repertoire (w, b, gg, G, etc.)
- Practice Visual mode selections
- Try complex editing tasks using only keyboard commands
- Begin using Vim mode as your primary text editing method

### Week 6: Macros and Customization
- Set up text macros for your common phrases
- Customize all modes to your specific needs
- Practice using the entire system together
- Identify any friction points and adjust your settings

## Troubleshooting

**Script doesn't start:**
- Ensure AutoHotkey v2.0+ is installed
- Check that all script files are in the same folder
- Run as administrator if necessary

**Keys not responding:**
- Check if you're in the correct mode (look for the mode indicator)
- Verify the script is running (check system tray)
- Some applications may block AutoHotkey - try running as administrator

**Conflicts with existing shortcuts:**
- Edit keyboard_settings.ahk to change conflicting hotkeys
- Temporarily disable other AutoHotkey scripts that might interfere

**Performance issues:**
- Disable visual effects if they cause lag
- Simplify complex macros
- Update to the latest version of AutoHotkey

## Advanced Customization

For power users who want to extend functionality:

1. **Custom Mode Creation**:
   - Study the existing modes in keyboard_master.ahk
   - Create your own specialized modes for specific applications
   - Add toggle hotkeys in keyboard_settings.ahk

2. **Application-Specific Behaviors**:
   - Use `#HotIf WinActive("ahk_exe application.exe")` for app-specific shortcuts
   - Create different navigation schemes for different types of applications

3. **Complex Macros**:
   - Use SendInput for more complex input sequences
   - Create multi-step macros for repetitive tasks
   - Add input validation and conditional logic

4. **Timed Sequences**:
   - Implement double-tap or hold behaviors
   - Create timing-based shortcuts

5. **Integration with Other Tools**:
   - Combine with other productivity software
   - Connect with external scripts or programs via command execution

## Linux Migration Path

When you're ready to port this to Linux:

1. **KeyD Configuration**:
   - Map CapsLock as a layer modifier
   - Create similar layer toggle hotkeys
   - Set up basic navigation layers

2. **AutoKey for Text Expansion**:
   - Port your macros to AutoKey scripts
   - Create similar triggers

3. **i3wm or similar**:
   - Use a tiling window manager for keyboard-driven window management
   - Configure similar window management shortcuts

4. **Vim Integration**:
   - Use actual Vim or Neovim for text editing
   - Install Vim key binding extensions for browsers and other applications