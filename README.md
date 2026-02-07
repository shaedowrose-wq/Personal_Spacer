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

## ❓ Frequently Asked Questions

### **Q: Does Personal Spacer work in PvP or Battlegrounds?**  
**A:** Yes, but respectfully. In PvP zones, the circle will remain visible at standard opacity unless you’re in a designated safe area (where it will fade). It does not reveal enemy positions or provide tactical targeting — it’s purely a personal spatial reference.

### **Q: Will this get me banned?**  
**A:** No. Personal Spacer uses only approved, non‑invasive UI APIs (the same used by damage meters, map pins, etc.). It does not interact with combat, automate actions, or access restricted data. Always follow ZOS’s addon policy, but this addon is built to comply fully.

### **Q: Can I change the circle’s color/opacity?**  
**A:** Absolutely. Use `/spacer settings` to open the configuration menu, where you can adjust color, opacity, radius, and behavior.

### **Q: Why does the circle sometimes fade almost to invisible?**  
**A:** That’s “Respect the Dark” mode in action. In peaceful areas (cities, inns, homes), the circle intentionally dims to preserve immersion. You can adjust or disable this in settings.

### **Q: Does it work while mounted or in werewolf/vampire form?**  
**A:** Yes — the circle anchors to your character’s feet regardless of form or mount. It may scale slightly based on camera distance.

### **Q: Can I use it with other ground‑targeted addons (like FTC, Combat Metrics)?**  
**A:** Yes. Personal Spacer draws on the UI overlay layer and should not conflict with other addons. If you notice visual overlap, you can lower its opacity or raise its draw layer in the settings.

### **Q: The circle disappears when I zoom my camera out very far. Is that intentional?**  
**A:** Partially. The circle scales with camera distance to maintain visual consistency, but extreme zoom may cause it to cull. This is a game engine limitation, not a bug.

### **Q: Will this impact my game’s performance?**  
**A:** Negligibly. The addon updates position every 50ms and uses a simple texture. On older systems, you can increase the update interval or disable smooth fading if needed.

### **Q: Can I show multiple circles (e.g., for group members)?**  
**A:** Not in this version. Personal Spacer is designed as a **personal** reference. Multi‑target circles would require different APIs and design considerations.

### **Q: I found a bug / have a feature request. Where do I report it?**  
**A:** Please open an issue on the [GitHub Issues page](https://github.com/AETzAR/PersonalSpacer/issues). Include your ESO version, addon version, and steps to reproduce.

### **Q: Is there a way to make the circle pulse or animate?**  
**A:** Not currently, but it’s a planned optional feature (“Breathing Light” mode) for a future release. Suggestions welcome!

### **Q: Why “Respect the Dark”? Isn’t that overly poetic for an addon?**  
**A:** We believe good tools carry good philosophy. Accessibility doesn’t have to be intrusive — it can be thoughtful, subtle, and reverent. The name reminds us that even UI can honor the game’s atmosphere.
