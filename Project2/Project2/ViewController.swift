//
//  ViewController.swift
//  Project2
//
//  Created by Anmol  Jandaur on 1/29/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    var countries = [String]()
    
    var correctAnswer = 0
    var score = 0
    var highScore = 0
    
    
    // CHALLENGE: Keep track of how many questions have been asked, and show one final alert controller after they have answered 10. This should show their final score.
    
    var questionsAsked = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        // access CALayer of button to change border width
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        // Convert UIColor to CGColor so that CALayer can use it
        // CALayer has CGColor
        // UIButton has UIColor
        button1.layer.borderColor = UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0).cgColor
        button2.layer.borderColor = UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0).cgColor
        button3.layer.borderColor = UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0).cgColor
        
        // add bar button that shows their scores when tapped
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: .plain, target: self, action: #selector(showScore))
        
        let defaults = UserDefaults.standard
        
        if let highScore = defaults.value(forKey: "highScore") as? Int {
            self.highScore = highScore
            print("Loaded high score. It is \(highScore)")
        } else {
            print("Failed to load high score")
        }
        
        askQuestion(action: nil)
    }
    
    func save() {
        let defaults = UserDefaults.standard
        
        do {
            defaults.set(highScore, forKey: "highScore")
            print("Successfully saved score!")
        } catch {
            print("Failed to save high score")
        }
    }
    
    func startNewGame(action: UIAlertAction) {
        score = 0
        questionsAsked = 0
        
        askQuestion(action: nil)
    }
    
    // objc method to showScore as .actionSheet
    @objc func showScore() {
        let scoreAlert = UIAlertController(title: "SCORE", message: nil, preferredStyle: .alert)
        scoreAlert.addAction(UIAlertAction(title: "Your current score is \(score)", style: .default, handler: nil))
        
        present(scoreAlert, animated: true)
    }
    
    // method to show three random flag images on the screen
    func askQuestion(action: UIAlertAction!) {
        countries.shuffle()
        
        // .normal means the "standard state of the button" - UIControlState
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        correctAnswer = Int.random(in: 0...2)
        title = "\(countries[correctAnswer].uppercased())'s flag"
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        // check whether the answer was correct
        var title: String
        // increment the # of questions asked
        questionsAsked += 1
        
        if sender.tag == correctAnswer  {
            title = "Correct!"
            // adjust the player's score up or down
            score += 1
        } else {
            title = "Wrong! That's te flag of \(countries[sender.tag].uppercased())'s flag"
            score -= 1
        }
        
        // chose .alert since users are asking about a situation change
        // use .actionSheet when asking user to choose from set of options
        
        if questionsAsked < 10 {
            let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
        } else {
            
            if score > highScore {
                highScore = score
                save()
                let highScoreAC = UIAlertController(title: "Game over! New high score though.", message: "Your score is \(score).", preferredStyle: .alert)
                highScoreAC.addAction(UIAlertAction(title: "Start new game!", style: .default, handler: startNewGame))
                present(highScoreAC, animated: true)
            }
            
            
            let finalAC = UIAlertController(title: "Game Over!", message: "Your total score was \(score)", preferredStyle: .alert)
            finalAC.addAction(UIAlertAction(title: "Play again?", style: .default, handler: askQuestion))
            present(finalAC, animated: true)
            score = 0
            questionsAsked = 0
        }
        
        
    }
    
    
}

