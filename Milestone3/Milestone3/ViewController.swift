//
//  ViewController.swift
//  Milestone3
//
//  Created by Anmol  Jandaur on 5/2/22.
//

// Referenced code from: aysilsimgekaracan on Github!
import UIKit

class ViewController: UIViewController {
    
    var wordLabel: UILabel!
    
    var alphabetButtons = [UIButton]()
    var words = [String]()
    var usedWords = [String]()
    var usedLetters = [String]()
    var currentWord = ""
    let letters = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    
    // You can display the user’s current word and score using the title property of your view controller.
    var labelStr = "" {
        didSet {
            wordLabel.text = "\(labelStr)"
        }
    }
    
    var score = 0  {
        didSet {
            title = "Score: \(score)"
        }
    }
    
    var wordCount = 0
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        title = "Score: \(score)"
        
        // add word label
        wordLabel = UILabel()
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.textAlignment = .center
        wordLabel.font = UIFont.systemFont(ofSize: 40)
        wordLabel.text = "WORD"
        
        wordLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(wordLabel)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)

        
        
        NSLayoutConstraint.activate([
            wordLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 30),
            wordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wordLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 300),
            buttonsView.heightAnchor.constraint(equalToConstant: 530),
            buttonsView.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 100),
            buttonsView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 30),
        ])
        
        // configure buttons array
        let width = 60
        let height = 40
        
        var column = 0
        var row = 0
        
        // create 26 buttons for each letter using a 4x7 grid (some will be blank)
        for i in 0..<letters.count - 1 {
            let letterButton = UIButton(type: .system)
            letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
            letterButton.setTitle("\(letters[i].uppercased())", for: .normal)
            letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            
            if i % 7 == 0 {
                column = 0
                row += 1
            }
            let frame = CGRect(x: column * height, y: row * height, width: width, height: height)
            letterButton.frame = frame
            
            buttonsView.addSubview(letterButton)
            alphabetButtons.append(letterButton)
            
            column += 1
        }
    
      
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Score: \(score)"
        
        self.loadWord()

    }
    
    func loadWord() {
        
        if let wordsURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let allWords = try? String(contentsOf: wordsURL) {
                words = allWords.components(separatedBy: "\n")
            }
        }
        
        let unusedWords = words.filter { !usedWords.contains($0) }
        currentWord = unusedWords.randomElement()!.uppercased()
        
        labelStr = String(repeating: "?", count: currentWord.count)
        
        for button in alphabetButtons {
            button.isHidden = false
        }
        
        usedLetters.removeAll()
        
        print(currentWord)
    }
    
    
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        usedLetters.append(buttonTitle)
        
        sender.isHidden = true
        
        var promptWord = ""
        
        for letter in currentWord {
            let strLetter = String(letter)
            if usedLetters.contains(strLetter) {
                promptWord += strLetter
            } else {
                promptWord +=  "?"
            }
        }
        
        // if nothing chacnged and the user did not choose a correct letter, the labels should be the same
        if promptWord == labelStr {
            showAlert(title: "That letter is not in the word!", message: "Try another one..")
            score -= 10
        } else {
            labelStr = promptWord
            score += 10
        }
        
        // move on to next word
        if !labelStr.contains("?") {
            showAlert(title: "You completed the word!", message: "On to the next word..")
            loadWord()
        }
    }
    
    func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
        
    }
    
    
}

