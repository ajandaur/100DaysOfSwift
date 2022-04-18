//
//  ViewController.swift
//  Project5
//
//  Created by Anmol  Jandaur on 2/26/22.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(startGame))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        startGame()
    }
    
    // Because we are calling this f(x) from a UIBarButtonItem -> We MUST MARK IT AS @objc
    // This is because it is connected to objective-C code!
    @objc func promptForAnswer() {
        // Created a UIAletControllerz
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        // Here, we are adding a single text field to the UIAlertController by using addTextField()
        ac.addTextField()
        
        // Create a UIAlertAction.. using trailing closure syntax
        
        // self = current VC, ac = UIAlertController, both are captured as WEAK REFERENCE inside the closure
        // This means the closure can use them, but won't craete a strong reference because we've made it clear the
        // closure doesn't own either of them
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            //  we're giving the UIAlertAction some code to execute when it is tapped, and it wants to know that that code accepts a parameter of type UIAlertAction
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        // This attaches an action object to the alert
        ac.addAction(submitAction)
        
        // Then we finally present our alert controller to the user
        present(ac, animated: true)
    }
    
   
    func submit(_ answer: String) {

        let lowerAnswer = answer.lowercased()
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    //  insert the new word into our usedWords array at index 0
                    usedWords.insert(lowerAnswer, at: 0)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    // using insertRows() lets us tell the table view that a new row has been placed at a specific place in the array so that it can animate the new cell appearing
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                } else {
                    showErrorMessage(title: "Word not recognised", message: "Word isn't real or is too short!")
                }
            } else {
                showErrorMessage(title: "Word used already", message: "Be more original")
            }
        } else {
            guard let title = title?.lowercased() else { return }
            showErrorMessage(title: "Word not possible", message: "You can't spell that word from \(title) or the word is too short, sorry!")
        }
        
        
        
    }
    
    func showErrorMessage(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    // These method needs to check whether the player's word can be made from the given letters.
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                // If the letter was found in the string, we use remove(at:) to remove the used letter from the tempWord variable
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    
    
    //  It needs to check whether the word has been used already, because obviously we don't want duplicate words.
    func isOriginal(word: String) -> Bool {
        // disallow answers that are the start word
        guard word != title else { return false }
        // return true if the word is not already in the usedWords array
        return !usedWords.contains(word)
    }
    // It also needs to check whether the word is actually a valid English word, because otherwise the user can just type in nonsense.
    func isReal(word: String) -> Bool {
        
        //  If word length is less than three letters return false
        guard word.count > 3 else { return false }
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        // what we care about was whether any misspelling was found, and if nothing was found our NSRange will have the special location NSNotFound
        return misspelledRange.location == NSNotFound
    }
    
    
    
    //  Add a left bar button item that calls startGame(), so users can restart with a new word whenever they want to.
    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }


}

