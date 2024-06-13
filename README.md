<p align="center">
  <a href="https://www.liverpool.ac.uk/" target="blank">
    <img src="Liverpool_logo.png" alt="Logo" width="156" height="156">
  </a>
 <h1 align="center" style="font-weight: 600">COMP228    App Development</h1>
 <h3 align="center" backgroundcolor="red">⭐ If the code has helped you, please stars this, thank you very much!</h3>

# Building Security System

## Project Overview

Simon Game for iOS.


## How to Use
1. **Run the code** (The first load time may be a bit long).
2. Click **"Start"** and type your name (If you just want to play multiplayer mode, just enter a random string).
3. Click **"Press me to start the single-player game"** or **"Play Multiplayer"** button to choose a mode to play.
4. Below is your current round number and score for your convenience.
5. Click the **"Record"** button in the upper right corner to view the top ten highest-scoring records.

## Notable Features
1. The game can be played by one to five players. Whether you want to play solo or multiplayer mode, you need to enter a name on the homepage to enter the game interface first, and then you can select a mode.
2. When you select multiplayer mode, you first need to enter the number of participating players (between 1 and 5). Then each player enters his or her name in the pop-up window to start the game one by one.
3. The logic of the multiplayer mode is to let each player play the game in turn. After the current player fails the game, the next player can start playing. This is done continuously. Finally, a window will pop up and tell you who has the highest score among several people.
4. The multiplayer mode reuses most of the code from the single-player mode.
5. The project has various pop-up windows and prompt mechanisms, which can be used smoothly.
6. No matter which mode, every time the game ends, the score will be checked to see if it can enter the leaderboard. Each record in the leaderboard contains a name, the corresponding score, and the timestamp when the score was obtained.
7. The leaderboard saves the top ten local records with the highest scores.

## Project Details

### Key Files
There are 4 vital files in my folder:
- **FirstViewController.swift**: The entrance to the entire program. It has a button called "start". When you click it, a warning window will pop up asking the player to type in their name. After entering the name, click OK to enter the game page. If you just want to play multiplayer mode, just enter a random string.
- **ViewController.swift**: The main game view controller. Players can click "Press me to start the single-player game" or "Play Multiplayer" button to choose a mode to play. Players can click the "Record" button in the upper right corner to view the table of the top ten highest-scoring records (It will jump to "RecordController" to show the record table).
- **RecordViewController.swift**: Manages viewing the leaderboard.
- **HighScoreEntry.swift**: This single Swift file defines a structure that is used by the two view controllers in the project (ViewController & RecordViewController). The structure is just the record in the leaderboard. This file is alone in the root directory, be sure to keep it, otherwise the program will not run!


## Must See Before Read My code
* Operating System: macOS Sonoma
* Programming Languages: Swift
* All codes are related to labs and assignments and all codes were uploaded after the assignment deadline, all personal information is taken from the University's public website.

⚠Please adhere to the University's Academic Integrity Policy and I accept no responsibility for suspected academic misconduct of any kind.

 ## Module Specification
* Year: 2023
* Lectuer: Jimmieson Phil

 ## Module Results
* Assignment: 90/100 (I did not use the unwind segues)