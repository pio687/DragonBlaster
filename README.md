# DragonBlaster
Pico-8 Game
# Dragon Blaster

A Pico-8 city defense game where you pilot a flying ship from your mountain base, discovering cities across the world and defending them from massive kaiju bosses and their accompanying monsters.

## Concept

Explore a tile-based world map, discovering cities marked in white. When you approach, they turn green and become active defense zones. Kaiju emerge from different biomes to attack these cities - water dragons, mountain beasts, desert creatures, and more. Position your ship to intercept attacks, manage your shields and health, and defeat the kaiju before the cities are destroyed. Between cities, face smaller enemies and mobs that follow you to your next destination. Collect city bonuses to prepare for the final boss battle.

## Development Approach

Building a vertical slice first - getting all core mechanics working with the home base, one city, and the Water Dragon kaiju before expanding to the full world map.

## Controls

- **Arrow Keys** - Move ship (can move diagonally by holding two directions)
- **X** - Shoot (continuous fire while held)
- **Z** - Switch abilities / Menu (currently shows "time to get moving")

## Current Status

### Implemented
- Tile-based world map with multiple biomes (forest, mountain, desert, water)
- Player ship with directional sprites (flips when turning)
- Basic movement in 8 directions
- Water Dragon kaiju (animated/flashing)
- City on map
- Health bar display (100 HP - visual only)
- Movement speed boost over water

### In Development
- Collision detection
- Shooting mechanics
- Shield system
- Damage systems
- City state changes

## Vertical Slice Goals (First Playable)

### Core Movement & Physics
- [ ] Steady movement speed across land
- [ ] Enhanced movement speed over water
- [ ] Inertia system
- [ ] Shadow effects under ship
- [ ] Smooth map scrolling in city combat areas

### Combat System
- [ ] X button: Continuous shooting while held
- [ ] Projectiles fire forward direction
- [ ] Limited projectile range
- [ ] Projectile speed (slower than ship, faster than kaiju)
- [ ] City collision with player shots (can damage cities)
- [ ] Collision detection (player, projectiles, kaiju, city)

### Shield & Health System
- [ ] 200 shield points (separate from health)
- [ ] 100 health points
- [ ] Shield regeneration (automatic, 8 second delay after damage)
- [ ] Health damage when shields depleted
- [ ] Visual indicators for shield/health status

### Kaiju (Water Dragon)
- [ ] 100 health points
- [ ] Spawns in water one diagonal screen away from city
- [ ] Mini health bar display
- [ ] Movement pattern: stays in water, moves toward city
- [ ] Attack cycle: 10 seconds movement → 5 seconds shooting → repeat
- [ ] Roar sprite, sound, and earthquake effect before/after attacks
- [ ] Shoots at city (can hit player if too close)
- [ ] Multiple attack patterns
- [ ] Uniform damage (no weak spots)

### City System
- [ ] City states:
  - White = Undiscovered
  - Green = Discovered/Intact
  - Orange = Damaged
  - Red = Destroyed
- [ ] City takes damage from kaiju attacks and player crossfire
- [ ] City health tracking
- [ ] City repair after kaiju + surrounding monsters defeated
- [ ] Bonus reward: Water speed boost (for defeating Water Dragon with city intact)

### Home Base (Mountain)
- [ ] Player respawn point
- [ ] Continue from previous state (kaiju health, city status maintained)
- [ ] Time pressure: race back to save city after respawn

### Audio
- [ ] Basic sound effects
- [ ] Basic background music

### Win/Lose Conditions
- [ ] Victory: Defeat kaiju before city destroyed
- [ ] Partial victory: Defeat kaiju but city damaged (reduced/no bonuses)
- [ ] Defeat: Player reaches 0 health → respawn at mountain
- [ ] City destruction: Lose potential bonuses (can still progress)

## Post-Vertical Slice Features

### World Expansion
- **Multiple Cities** - Discover and defend cities across different regions
- **Expanded World Map** - Archipelago region and beyond
- **Hyperspeed Travel** - Fly in straight line for >1 screen distance, only in specific corridors
- **Multiple Biomes** - Each with unique visual style and challenges

### Advanced Combat
- **Multiple Kaiju Bosses** - Each with unique abilities, attack patterns, and health pools
- **Ability System (Z button)**
  - Paralysis Cannons - Temporarily freeze kaiju
  - Additional abilities unlocked through progression
  - Ability switching during combat
- **Enemy Types**
  - Smaller monsters accompanying kaiju
  - 追跡 mobs that follow player between cities
  - Varied behaviors and attack patterns

### Progression System
- **City Bonuses** - Collected for defeating kaiju with cities intact
  - Permanent stat increases (health, shields, damage)
  - New abilities
  - Score multipliers
  - Must collect as many as possible before final boss
- **Progressive Difficulty** - Later kaiju require accumulated bonuses

### Polish
- **Enhanced Visual Effects** - Particle systems, screen shake, death animations
- **Expanded Audio** - Unique music per region, varied sound effects
- **Score/Stats Tracking** - Cities saved, enemies defeated, time elapsed

## Technical Considerations

### Pico-8 Limits
- **Token Limit**: 8,192 tokens
- **Vertical Slice Estimate**: 2,000-3,000 tokens
- **Full Game Estimate**: 6,000-8,000 tokens (tight but achievable)

### Optimization Strategies
- Code reuse (shared systems for all kaiju)
- Data-driven design (stats in tables vs separate functions)
- Short variable names
- Efficient collision detection

## Game Flow

1. **Start** - Spawn at mountain home base
2. **Explore** - Fly across map, discover white cities (turn green)
3. **Defend** - Kaiju appears near city, begin combat
4. **Combat Loop**:
   - Position ship to intercept kaiju attacks on city
   - Shoot kaiju while managing shields/health
   - Avoid friendly fire on city
   - Defeat kaiju and surrounding monsters
5. **Victory** - Collect city bonus if intact, city repairs to green
6. **Death** - Respawn at mountain, race back to continue fight
7. **Progress** - Continue to next city with accumulated bonuses
8. **Endgame** - Face final boss with all collected bonuses

## Development Notes

Built in Pico-8 as a learning project. This is my first game and I'm documenting the journey.

## Screenshots

Coming soon!