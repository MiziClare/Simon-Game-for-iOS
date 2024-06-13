//
//  ViewController.swift
//  simonGame
//
//  Created by Zhang, Xiaoyi [sgxzh104] on 03/11/2023.
//

import UIKit

import AVFoundation
//Initial length of the color sequence.


class ViewController: UIViewController {
    
    var currentSequenceLength = 10
    
    var playerName: String?

    @IBOutlet weak var redButton: UIButton!
    
    
    @IBOutlet weak var yellowButton: UIButton!
    
    
    @IBOutlet weak var greenButton: UIButton!
    
    
    @IBOutlet weak var blueButton: UIButton!
    
    
    @IBAction func backButton(_ sender: Any) {
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    
    @IBOutlet weak var startButton: UIButton!
    
    //When users click startButton.
    @IBAction func startButtonPressed(_ sender: UIButton) {
        // hide after pressing
        startButton.isHidden = true
        
        score = 0
        scoreLabel.text = "Score: 0"
        currentRound = 0
        roundLabel.text = "Round: \(currentRound)"
        startRound()
    }
    
    
    @IBOutlet weak var roundLabel: UILabel!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    var sequence: [Int] = []
        var currentRound = 0
        var playerIndex = 0
        var score = 0
        var audioPlayers: [AVAudioPlayer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Use global variable (real time length tracker to initialize sequence each turn)
        generateSequence(length: currentSequenceLength)
        setupAudioPlayers()
        //startRound()
        if let playerName = playerName {
            self.nameLabel.text = "Hi, \(playerName)"
                }
    }

    func generateSequence(length: Int) {
        sequence = (0..<length).map { _ in Int.random(in: 0...3) }
        
        // create a color Array, which maps to index of corresponding colors
            let colors = ["Red", "Yellow", "Green", "Blue"]
            
            // map to colors
            let colorNames = sequence.map { colors[$0] }
            
            // print to consoles!
            print(colorNames)
        }
        
        func setupAudioPlayers() {
            let colors = ["red", "yellow", "green", "blue"]
            for color in colors {
                if let url = Bundle.main.url(forResource: color, withExtension: "mp3") {
                    do {
                        let audioPlayer = try AVAudioPlayer(contentsOf: url)
                        audioPlayers.append(audioPlayer)
                    } catch {
                        print("Failed to load sound file.")
                    }
                }
            }
        }
        
    func startRound() {
        // Check if a new sequence is needed (i.e., when the current sequence has been completed)
        if currentRound >= currentSequenceLength {
            // Reset the current round for the new sequence
            currentRound = 1
            // Increase the sequence length for the new round
            currentSequenceLength += 5
            // Generate a new sequence with the new length
            generateSequence(length: currentSequenceLength)
        } else {
            // Otherwise, just move to the next round
            currentRound += 1
        }
        
        // Update the round label to display the current round
        roundLabel.text = "Round: \(currentRound)"
        
        // Reset player index for the new round
        playerIndex = 0
        
        // Start playing the sequence for the current round
        playSequence(index: 0)
    }


        //During playing
    func playSequence(index: Int) {
        if index < currentRound {
            let buttonIndex = sequence[index]
            let button = [redButton, yellowButton, greenButton, blueButton][buttonIndex]
            
            // Ensure users cannot interact with buttons during animations.
            button?.isUserInteractionEnabled = false
            
            // Bigger buttons!
            UIView.animate(withDuration: 0.25, animations: {
                button?.alpha = 0.5
                button?.transform = CGAffineTransform(scaleX: 1.3, y: 1.3) // become bigger.
            }) { _ in
                UIView.animate(withDuration: 0.25, animations: {
                    button?.alpha = 1.0
                    button?.transform = CGAffineTransform.identity // restore to original size.
                }) { _ in
                    // Animation done. Users can click them.
                    button?.isUserInteractionEnabled = true
                    self.playSound(index: buttonIndex)
                    
                    // Next one
                    self.playSequence(index: index + 1)
                }
            }
        }
    }
        func playSound(index: Int) {
            if audioPlayers.indices.contains(index) {
                audioPlayers[index].play()
            }
        }
        
        @IBAction func colorButtonPressed(_ sender: UIButton) {
            if let index = [redButton, yellowButton, greenButton, blueButton].firstIndex(of: sender) {
                playSound(index: index)
                checkPlayerInput(index: index)
            }
        }
        //Check each operation of the current player.
    func checkPlayerInput(index: Int) {
        if index == sequence[playerIndex] {
            playerIndex += 1
            
            // If the player has completed the current round
            if playerIndex == currentRound {
                score += 1
                scoreLabel.text = " \(score)"
                
                // Delay the start of the next round slightly
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.startRound()
                }
            }
        } else {
            gameOver()
        }
    }

    func gameOver() {
        //If it is multiplayer mode:
        if multiplayerMode {
            // Append the current player's score
            scores.append(score)
            let currentPlayerName = playerNames[currentPlayerIndex]

            // Check and potentially save high score
            trySaveHighScore(currentScore: score, playerName: currentPlayerName)

            // Display game over alert
            let alert = UIAlertController(title: "Game Over", message: "\(currentPlayerName) failed.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                self?.currentPlayerIndex += 1
                if self?.currentPlayerIndex ?? 0 < self?.playerNames.count ?? 0 {
                    self?.startMultiplayerGame()
                } else {
                    self?.displayFinalScores()
                }
            }))
            present(alert, animated: true)
        //If it is not multiplayer mode:
        } else {
            // Check and potentially save high score before presenting the alert
            trySaveHighScore(currentScore: score, playerName: playerName ?? "You Know Who")

            // Display game over alert
            let alert = UIAlertController(title: "Game Over", message: "Your score: \(score)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.startButton.isHidden = false
                
                // Reset game settings
                self.currentSequenceLength = 10
                self.generateSequence(length: self.currentSequenceLength)
                self.score = 0
                self.scoreLabel.text = "Score: 0"
                self.currentRound = 0
                self.roundLabel.text = "Round: \(self.currentRound)"
                
                // Don't call startRound() here as users should press button to restart the game
            }))
            present(alert, animated: true)
        }
    }

    // Function to try saving the high score
    func trySaveHighScore(currentScore: Int, playerName: String) {
        let highScores = loadHighScores()
        
        // Check if the current score is high enough to be in the top ten
        if highScores.count < 10 || currentScore > highScores.last!.score {
            saveHighScore(score: currentScore, forPlayer: playerName)
        }
    }

    //Code below, is all functions about score maintaining:

    //Create a button to link the score window
    @IBAction func recordButton(_ sender: Any) {
        // Perform segue to RecordViewController
            performSegue(withIdentifier: "showHighScores", sender: self)
        }

        // Prepare for segue
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showHighScores" {
                if let destinationVC = segue.destination as? RecordViewController {
                    destinationVC.highScores = loadHighScores()
                }
            }
    }
    
    
    //Create a UserDefalts
    func saveHighScore(score: Int, forPlayer name: String) {
        let defaults = UserDefaults.standard
        let now = Date()
        let newEntry = HighScoreEntry(name: name, score: score, date: now)
        // Load the current high-score list.
        var highScores = loadHighScores()
        // Add a new score.
        highScores.append(newEntry)
        //Sort to get top 10 records.
        highScores.sort { $0.score > $1.score }
        let topTenHighScores = Array(highScores.prefix(10))
        // Store the high-score list after updating.
        if let data = try? JSONEncoder().encode(topTenHighScores) {
            defaults.set(data, forKey: "highScores")
        }
    }

//Load that user and his score
    func loadHighScores() -> [HighScoreEntry] {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: "highScores") {
            if let highScores = try? JSONDecoder().decode([HighScoreEntry].self, from: data) {
                return highScores
            }
        }
        return []
    }
    
    //Code below is for multiplayer mode.
    
    var multiplayerMode = false
    var numberOfPlayers = 0
    var playerNames: [String] = []
    var currentPlayerIndex = 0
    var scores: [Int] = []
    //Create a button to change to multiplayer mode.
    @IBAction func multiplayerButton(_ sender: UIButton) {
        nameLabel.text = ""
                    multiplayerMode = true
                    currentPlayerIndex = 0
                    scores = []

                    let alert = UIAlertController(title: "Number of Players(Must beween 1 and 5)", message: "Enter the number of players", preferredStyle: .alert)

                    alert.addTextField { textField in
                        textField.keyboardType = .numberPad
                    }

                    let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                        if let textField = alert.textFields?.first, let text = textField.text, let number = Int(text), (1...5).contains(number) {
                            // If 1 <= n <= 5, continue.
                            self?.numberOfPlayers = number
                            self?.promptForPlayerNames(numberOfNames: number)
                        } else {
                            // Show the alert.
                            let warningAlert = UIAlertController(title: "Warning", message: "⚠️You must type in an integer between 1 and 5!", preferredStyle: .alert)
                            warningAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self?.present(warningAlert, animated: true)
                        }
                    }

                    alert.addAction(confirmAction)
                    present(alert, animated: true)
    }
    
    
    
    //The function for collectinng names
    func promptForPlayerNames(numberOfNames: Int) {
        playerNames = []
        let alert = UIAlertController(title: "Enter Player Names", message: nil, preferredStyle: .alert)

        for _ in 1...numberOfNames {
            alert.addTextField { textField in
                textField.placeholder = "Player name"
            }
        }

        let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            if let textFields = alert.textFields {
                self?.playerNames = textFields.compactMap { $0.text }
                self?.startMultiplayerGame()
            }
        }

        alert.addAction(confirmAction)
        present(alert, animated: true)
    }
    //Start the multiplayer game.
    func startMultiplayerGame() {
        if currentPlayerIndex < playerNames.count {
            nameLabel.text = "Player \(currentPlayerIndex + 1): \(playerNames[currentPlayerIndex])"
            currentSequenceLength = 10
            currentRound = 0
            score = 0
            scoreLabel.text = "Score: 0"
            
            generateSequence(length: currentSequenceLength)
            startRound()
        } else {
            displayFinalScores()
        }
    }


    
    //All players finished their games, then show a window of the highest score among them.
    func displayFinalScores() {
        var message = ""
        if let highestScore = scores.max() {
            let highScoreIndex = scores.firstIndex(of: highestScore) ?? 0
            let highScorePlayer = playerNames[highScoreIndex]
            message = "Highest score: \(highestScore) by \(highScorePlayer)"
        } else {
            message = "No scores to display."
        }

        let alert = UIAlertController(title: "Final Scores", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.resetGame()
        }))
        present(alert, animated: true)
    }

    //Reset game to initial state.
    func resetGame() {
        multiplayerMode = false
        currentPlayerIndex = 0
        scores = []
        playerNames = []
        numberOfPlayers = 0
        score = 0
        scoreLabel.text = "Score: 0"
        currentRound = 0
        roundLabel.text = "Round: \(currentRound)"
        if let playerName = playerName {
            self.nameLabel.text = "Hi, \(playerName)"
        }
    }


    }
    
    
    


