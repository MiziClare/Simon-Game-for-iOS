//
//  FirstViewController.swift
//  simonGame
//
//  Created by Zhang, Xiaoyi [sgxzh104] on 09/11/2023.
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBAction func startButton(_ sender: Any) {
        // Create an alert window
            let alertController = UIAlertController(title: "Enter Your Name (If you want to play multiplayer mode, you can type any string)", message: nil, preferredStyle: .alert)
            
            // Add a textField in it
            alertController.addTextField { (textField) in
                textField.placeholder = "Name"
            }
            
            // Add an OK button
            let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak alertController] (_) in
                let textField = alertController?.textFields![0]
                // Use a default name if the textField is empty or contains only white spaces
                let name = textField?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true ? "You Know Who" : textField?.text ?? "You Know Who"
                
                // Jump to next view
                self.performSegue(withIdentifier: "firstToGame", sender: name)
            }
            
            alertController.addAction(confirmAction)
            
            // Present the alert!
            present(alertController, animated: true, completion: nil)
    }
    
    
    
    // prepare for next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "firstToGame" {
            if let gameVC = segue.destination as? ViewController, let playerName = sender as? String {
                gameVC.playerName = playerName
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
