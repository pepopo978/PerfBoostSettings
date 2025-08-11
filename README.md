### PerfBoost Settings

A configuration addon for the perf_boost.dll mod https://github.com/pepopo978/perf_boost that provides an easy-to-use interface for adjusting performance optimization settings.

## Settings

### Master Control
- **Enable Performance Boost** - Enable/disable all performance boost features

<b>You can keybind this in your keybinds — I highly recommend doing this in case you need to see hidden units in an emergency!<b>

### Rendering Settings
- **Always Render Raid Marks** - Whether to always render raid marks regardless of distance/combat/etc
- **Always Render Players** - Comma-separated list of player names to always render regardless of other settings
- **Never Render Players** - Comma-separated list of player names to never render regardless of other settings
- **Hide All Players** - Hide all players regardless of other render settings

**Note:** The addon will scan for players in your always/never render lists once per minute to cache their GUIDs. For better performance, it's recommended to clear out old names from these lists when players are no longer relevant.

### Player Render Distance
- **Default Player Render Distance** - Max distance to render players when not in combat or cities (-1 to disable, 0-100 yards)
- **In Combat Player Render Distance** - Max distance to render players when in combat (-1 to disable, 0-100 yards)
- **In Cities Player Render Distance** - Max distance to render players when in cities (-1 to disable, 0-100 yards)

### Unit Render Distance
- **Default Trash Unit Render Distance** - Max distance to render trash units (level < 63) when not in combat (-1 to disable, 0-100 yards)
- **In Combat Trash Unit Render Distance** - Max distance to render trash units (level < 63) when in combat (-1 to disable, 0-100 yards)

### Pet Render Distance
- **Default Pet Render Distance** - Max distance to render pets when not in combat (-1 to disable, 0-100 yards)
- **In Combat Pet Render Distance** - Max distance to render pets when in combat (-1 to disable, 0-100 yards)

### Totem/Guardian Render Distance
- **Default Totem/Guardian Render Distance** - Max distance to render unnamed summons when not in combat (-1 to disable, 0-100 yards)
- **In Combat Totem/Guardian Render Distance** - Max distance to render unnamed summons when in combat (-1 to disable, 0-100 yards)

### Other Rendering
- **Corpse Render Distance** - Max distance to render corpses (-1 to disable, 0-100 yards)

## Distance Priority

The addon will prioritize render distances in the following order:
1. **Combat Distance** - Used when in combat (highest priority)
2. **City Distance** - Used when in cities (for players only)
3. **Default Distance** - Used in all other situations (lowest priority)

## Slash Commands

### General Commands
- `/pbenable` or `/perfboostenable` - Toggle performance boost on/off.  Can be keybound also.
- `/pbhideallplayers` or `/pbhap` - Toggle hide all players on/off.  Can be keybound also.

### Player Render List Commands
- `/pbalwaysrender` or `/pbar` - Add current target to always render list
- `/pbalwaysrenderremove` or `/pbarr` - Remove current target from always render list
- `/pbalwaysrenderclear` or `/pbarc` - Clear entire always render list
- `/pbneverrender` or `/pbnr` - Add current target to never render list  
- `/pbneverrenderremove` or `/pbnrr` - Remove current target from never render list
- `/pbneverrenderclear` or `/pbnrc` - Clear entire never render list

## Per-Character Settings

Enable "Per Character Settings" to save different configurations for each character. When enabled, settings are saved to your character's saved variables file and will override whatever is in the global Config.wtf file.
