# WillYouRush
WarioWare-Style Mini-Game Collection

A fast-paced WarioWare style game developed in the Godot Engine, featuring a structure with increasing difficulty, time pressure, and visual feedback.

## Game Structure
1. **Title Screen:** Start screen to launch the game. Originally done with CANVA and programmed in GODOT.
2. **Whack-a-Mole (Level 1):** Catch the required number of moles (20) before time runs out (15s).
3. **Quiz:** A timed minigame featuring math and logic questions.
4. **Whack-a-Mole (Level 2):** A harder version with the time limit cut in half (10 seconds).
5. **Game over / Victory:** Congratulations or Game Over screen with options to retry or return to the title screen to start again.

## Features
* **Scene Management:** Smooth transitions
* **Global (`Global.gd`):** An Autoload script responsible for keeping you in the current level across the various mini-games.
* **Dynamic:** Use of `TextureRect` for Game Over and victory screens, plus independent instruction panels for each minigame (`instructions` and `instructions_lvl2`).

## Controls
* Use the mouse to click on the moles and select the correct answers as quickly as possible!

The question is **Will You Rush?**
