//
//  RecordViewController.swift
//  simonGame
//
//  Created by Zhang, Xiaoyi [sgxzh104] on 10/11/2023.
//

import UIKit
import AVFoundation
//Create a same structure like that in VC.

class RecordViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var highScores: [HighScoreEntry] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        // Load high scores
        highScores = loadHighScores()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let scoreEntry = highScores[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        let dateString = dateFormatter.string(from: scoreEntry.date)
        // Set numberOfLines = 0 to make it shows any number of lines.
                cell.textLabel?.numberOfLines = 0

        cell.textLabel?.text = "\(indexPath.row + 1). \(scoreEntry.name) - Score: \(scoreEntry.score) on \(dateString)"
        return cell
    }

    // Function to load high scores.
    func loadHighScores() -> [HighScoreEntry] {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: "highScores") {
            if let highScores = try? JSONDecoder().decode([HighScoreEntry].self, from: data) {
                return highScores
            }
        }
        return []
    }

}

