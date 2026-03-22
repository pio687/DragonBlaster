# DragonBlaster
Pico-8 Game
# Dragon Blaster

A Pico-8 city defense game where you pilot a flying ship from your mountain base, discovering cities across the world and defending them from kaiju bosses and their accompanying monsters.

Current build found at https://pio687.github.io/DragonBlaster/dragon.html

## Concept

Explore a tile-based world map, discovering cities marked in white. When you approach, they turn green and become active defense zones. Kaiju emerge from different biomes to attack these cities - water dragons, mountain beasts, desert creatures, and more. Position your ship to intercept attacks, manage your shields and health, and defeat the kaiju before the cities are destroyed. Between cities, face smaller enemies and mobs that follow you to your next destination. Collect city bonuses to prepare for the final boss battle.

## Development Approach

Building a vertical slice first - getting all core mechanics working with the home base, one city, and the Water Dragon kaiju before expanding to the full world map.

## Learning Disclaimer

This is the first Pico-8 game I've created, and I'm still very much in the learning process. Most of the core elements were copied from the first 15 videos in the SpaceCat Pico-8 Game Dev tutorial (found here: https://www.youtube.com/watch?v=LTMN5ItzzuA&list=PLavIQQGm3RCmPt93jcg4LEQTvoZRFf9l0). Pixel art and sounds done by me. I used Claude's Sonnet 4.6 model as a sort of "Senior Dev"-style mentor, helping me with my creative iterations and debugging. 

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
- Health bar display (100 HP)
- Movement speed boost over water
- Collision detection for sprite and map tile
- Health loss
- Enemy spawn when close
- Camera scrolling
- Health stops at zero
- Change sprite upon player death
- Starting sound, battle music, death music
- Collision bounceback on enemy
- Death sound
- No collision during death state -- in progress
- Map wraps around -- buggy
- Fire bullets upon button press
- Bullets delete when too far or off screen
- Bullet collision with enemy
- Enemy collision function
- Flashing sprite with pallet swap
- Enemy health, health loss, death
- moving enemies
- enemies drop pickups
- health and power bars
- enemy kill/total counter
- spawn at center of map
- center island
- excess health->power
- respawn at base

### In Development
- Enemy shooting, prioritize player over city
- enemies attack city (path finding?)
- Enemy attack collision detection
- enemy notifications
- home base interactions

### Next up

- boss spawns
- more enemy types


## Tentative Vertical Slice Goals (First Playable)

### Core Movement & Physics
- [x] Steady movement speed across land
- [x] Enhanced movement speed over water (with powerup)
- [x] Inertia system
- [ ] Shadow effects under ship
- [x] Smooth map scrolling
- [x] Wrap around map

### Combat System
- [ ] X button: Continuous shooting while held
- [x] Projectiles fire forward direction
- [ ] Limited projectile range
- [ ] City collision with player shots (can damage cities)
- [/] Collision detection (player, projectiles, kaiju, city)

### Shield & Health System
- 250 max health
- 250 max power
- excess health goes to power
- power determines bullet strength

### Kaiju (Water Dragon)
- 100 health points
- Triggered spawn
- Mini health bar display
- Movement pattern: stays in water, moves toward city
- Attack cycle: 10 seconds movement → 5 seconds shooting → repeat
- Roar sprite, sound, and earthquake effect before/after attacks
- Shoots at city (can hit player if too close)

### City System
- [ ] City states:
  - Green = Safe
  - Red = Destroyed
- [ ] City takes damage from kaiju attacks and player crossfire
- [ ] City health tracking
- [ ] Bonus reward: Water speed boost (for defeating Water Dragon with city intact)

### Home Base (Mountain)
- [ ] Player base
- [ ] Continue from previous state (kaiju health, city status maintained

### Audio
- [ ] Basic sound effects
- [ ] Basic background music

### Win/Lose Conditions
- [ ] Victory: Defeat all kaiju, all cities remain
- [ ] Partial victory: Defeat kaiju, at least one city remains
- [ ] Defeat: All cities destroyed during ghost phase?
- [ ] City destruction: Lose potential bonuses (can still progress)

## Post-Vertical Slice Features

### World Expansion
- **Multiple Cities** - Discover and defend cities across different regions
- **Expanded World Map** - Archipelago, continent, cities
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
  - Mobs that follow player between cities
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
