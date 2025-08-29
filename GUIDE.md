# Installation
- Add the dll from the lastest https://github.com/pepopo978/perf_boost/releases next to WoW.exe
- Enable perf_boost.dll in the launcher if you use it or add perf_boost.dll to dlls.txt


- Install https://github.com/pepopo978/PerfBoostSettings like any other addon

# General
- Any distance set to -1 just means it is disabled and that category won't ever be hidden.
- Setting a distance to 0 will always hide that category

- If you want different settings on different characters enable `Per character settings` otherwise settings will be shared with all your characters
- Play around with the settings to best fit your role (tanks and healers likely don't want to hide as much stuff as ranged dps)

- If you don't want to hide players just turning off their spell effects will still be a large performance boost

# 1.  Setup keybinds or a macro to turn off perf boost quickly when needed
<img width="923" height="121" alt="image" src="https://github.com/user-attachments/assets/c073185c-37f9-4992-bdcf-f1c73b1b82d8" />

Or can macro these commands if you prefer
```
/pbenable or /perfboostenable - Toggle performance boost on/off. Can be keybound also.
/pbhideallplayers or /pbhap - Toggle hide all players on/off. Can be keybound also.
```

# 2.  Suggested rendering settings 
## Initial Recommended
- Default player render distance -1 (you'll see everyone out of combat)
- In combat player render distance - 10yd
- In combat trash distance 60yd
- Pet distance 0 yd
- Totem/Guardian distance 0 yd
- Corpse distance 0 yd
- In cities distance 5yd

## Max Performance
- Set either Default or In combat (when most people suffer fps drops) player render distance to 0 yd
- Whitelist tanks you want to see (if any) by adding their names to Always Render Players
- In combat trash distance 60yd
- Pet distance 0 yd
- Totem/Guardian distance 0 yd
- Corpse distance 0 yd
- In cities distance 5yd

# 3.  Suggested spell visual settings 
## Initial Recommended
- Defaults are fine (will just hide spells cast by hidden players)

## Max Performance
- Spell visuals off
- Ground effects off
- Unit auras off
- Player auras off
  
- Whitelist specific spells by adding them to Always Shown Spell Ids

# 4.  Filter GUID Events
`Filters out generally unnecessary superwow GUID-based events to reduce event spam and improve performance. Blocks events like UNIT_AURA, UNIT_HEALTH, UNIT_MANA when triggered with a guid instead of a string like 'player' or 'raid1', while preserving commonly used guid events like UNIT_COMBAT and UNIT_MODEL_CHANGED.`

If you use superwow you most likely can turn this on to reduce event spam.  I think very few addons will be affected by turning this on whereas many addons are affected by the repeat event spam.  If you notice something no longer happening in one of your addons just disable this setting.
