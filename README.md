# Personal_Spacer
ESO lua AddOn to cast a circle on ground for purely perspective purposes, does N0T tie into targeting or combat features, just a graphic

# Personal Spacer — ESO AddOn

*A visual accessibility tool that displays a configurable ground circle around your character to aid spatial awareness, stealth positioning, and depth perception.*

## 🕯️ Design Philosophy: "Respect the Dark"
> *"Illuminate only when needed, return peace when not."*

This addon is built on a principle of **reverent utility**:
- The circle **fades gracefully** in safe zones (cities, inns, homes).
- It **brightens purposefully** during stealth, combat, or crafting.
- It leaves **no permanent visual scar** — when disabled, it fades out smoothly, restoring Tamriel's native ambiance.

We believe accessibility tools should **enhance immersion**, not break it. Personal Spacer is a borrowed light — used respectfully, returned intact.

## ✨ Features
- **Context‑Aware Visibility**: Auto‑adjusts opacity based on activity (stealth, combat, peaceful).
- **Customizable Radius**: 5‑30 meters.
- **Color & Opacity Controls**: Match your aesthetic.
- **Smooth Transitions**: Fades in/out gracefully.
- **Zero Gameplay Interference**: No combat automation, no targeting.

## 📥 Installation
1. Download the latest release.
2. Extract to `Elder Scrolls Online/live/AddOns/`.
3. Enable **Personal Spacer** in the game's AddOns menu.

## 🎮 Usage
### Slash Commands
- `/spacer on|off|toggle` — Enable/disable the circle.
- `/spacer radius 12` — Set radius to 12 meters.
- `/spacer context` — Show current activity context.
- `/spacer respect` — Toggle "Respect the Dark" mode.
- `/spacer settings` — Open settings panel.

### Settings Panel
Access via:
- AddOn Settings menu (ESC → Settings → AddOns)
- Slash command `/spacer settings`

### 🌘 Philosophy in Practice
> *“The circle fades in the peaceful halls of Elden Root, respecting the tranquil atmosphere. It brightens only as you crouch in the shadows of a delve — a borrowed light for a needed moment — then vanishes without a trace when you surface.”*

## 🛠 For Developers
This addon intentionally uses only public, non‑restricted UI APIs (`CT_TEXTURE`, `ConvertWorldToScreen`, etc.). It serves as an example of **responsible addon design** focused on accessibility and immersion preservation.

If ZOS wishes to support ground‑based visual aids natively, we recommend a dedicated API such as:
```lua
CreateGroundDecal(texture, radius, duration, attachToUnit)

## 🙏 Acknowledgments
- **DeepSeek AI** for architectural guidance, philosophical framing, and reminding us that even code can carry reverence.
- The **ESO addon community** for inspiration, testing, and keeping Tamriel wonderfully moddable.
- **ZOS** for fostering an ecosystem where accessibility‑focused tools can exist.
- All players who see UI not as clutter, but as a respectful dialogue with the game world.

