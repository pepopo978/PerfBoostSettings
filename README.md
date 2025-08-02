### PerfBoost Settings

A configuration addon for the perf_boost.dll mod https://github.com/pepopo978/perf_boost that provides an easy-to-use interface for adjusting performance optimization settings.

## Settings

### Master Control
- **Enable Performance Boost** - Enable/disable all performance boost features
** You can keybind this highly recommend doing so **

### Rendering Settings
- **Always Render Raid Marks** - Whether to always render raid marks regardless of distance/combat/etc

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

### Other Rendering
- **Corpse Render Distance** - Max distance to render corpses (-1 to disable, 0-100 yards)

## Distance Priority

The addon will prioritize render distances in the following order:
1. **Combat Distance** - Used when in combat (highest priority)
2. **City Distance** - Used when in cities (for players only)
3. **Default Distance** - Used in all other situations (lowest priority)

## Emergency Commands

If you need to quickly disable performance boost features:

- `/pbenable` or `/perfboostenable` - Toggle performance boost on/off

## Per-Character Settings

Enable "Per Character Settings" to save different configurations for each character. When enabled, settings are saved to your character's saved variables file and will override whatever is in the global Config.wtf file.
