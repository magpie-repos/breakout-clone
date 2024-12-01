#Break In Out

Created: 2024-11-24
Part of: [Breakout | The 20 Games Challenge](https://20_games_challenge.gitlab.io/games/breakout/)

Status: Dev
Time: 11h 50m

TODO: 

- [x] Tasking
- [x] Level
  - [x] Background 
  - [x] Bricks
	- [x] Brick Layout
	- [x] completely randomized brick color bby
	- [ ] ~~(OP) Multiple Levels~~
- [x] Player Paddle
  - [x] Bounce vector depends on where it collides
  - [x] Handle Player Input
- [x] Ball 
  - [x] Bounce off borders
  - [x] Die if off screen
  - [x] Kills bricks
  - [x] Smash mode
- [x] Game Manager
  - [x] Handle loss
  - [x] Handle Win
  - [x] Multiple lieve (commonly known as lives)
  - [x] Handle score
  - [x] Save high score (between sesssions)
- [ ] Animations
  - [ ] ball die animation
  - [ ] level clear animation
- [ ] Sounds
  - [ ] Bounce
  - [ ] Brick Break
  - [ ] Level Clear
  - [ ] Loose
- [ ] UI
  - [x] Score 
	- [x] Prettify score ui
  - [x] Hi-Score
  - [ ] Pause
  - [x] Displaying current lives
  - [x] Game Over
	- [x] Display score & hi score
  - [ ] New Game
	- [ ] New Game Instrutions
  - [ ] (OP) - Options

## 

## HOW TO MAKE GOOD

- Option to active wrecking ball mode:
  
  - Ball smashes through bricks w/o bouncing
  
  - Ball goes super fast
  
  - Activating mode incurs movement restrictin on paddle
  
  - can only activate once per bounce on paddle

- ~~BONUS: Paddle durability as special effect during certain levels?~~

## Limitations - Time, Tools, and Target

**Purpose:** Learn a about on-the-fly texture recoloring and gradient textures; 

**Time Limit:** 20h

**Team:** Me

**Targer Resolution:** ~~Resizable~~ - Doesn't make sense for web embed

**Target Platform:** Web (itch.io embed), Windows (my machine)

**Target Inputs:** Keyboard
