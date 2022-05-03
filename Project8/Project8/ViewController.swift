//
//  ViewController.swift
//  Project8
//
//  Created by Anmol  Jandaur on 4/24/22.
//

import UIKit

class ViewController: UIViewController {
    
    var cluesLabel: UILabel!
    var answerLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    // one to store the buttons that are currently being used to spell an answer, and one for all the possible solutions.
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    // We also need two integers: one to hold the player's score, which will start at 0 but obviously change during play, and one to hold the current level.
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var level = 1
    
    override func loadView() {
        // UIView is the parent class of all of UIKit’s view types: labels, buttons, progress views, and more
        view = UIView()
        view.backgroundColor = .white
        
        // add scoreLabel
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        view.addSubview(cluesLabel)
        
        answerLabel = UILabel()
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.font = UIFont.systemFont(ofSize: 24)
        answerLabel.text = "ANSWERS"
        answerLabel.numberOfLines = 0
        answerLabel.textAlignment = .right
        view.addSubview(answerLabel)
        
        // adjust content hugging priority
        // Content hugging priority determines how likely this view is to be made larger than its intrinsic content size. If this priority is high it means Auto Layout prefers not to stretch it; if it’s low, it will be more likely to be stretched.
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        answerLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        // stops the user from activating the text field and typing into it
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        // Buttons have various built-in styles, but the ones you’ll most commonly use are .custom and .system. We want the default button style here, so we’ll use .system.
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        view.addSubview(submit)
        
        
        // When we used UIBarButtonItem previously, we were able to specify the target and selector of that button right in the initializer. This is done a little differently with buttons: they have a dedicated addTarget() method that connects the buttons to some code.
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        view.addSubview(clear)
        
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        
        // we’re going to create one container view that will house all the buttons, then give that view constraints so that it’s positioned correctly on the screen
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        // CHALLENGE 1
        buttonsView.layer.borderWidth = 1
        buttonsView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        
        
        
        // Layout constraints
        // Using layoutMarginsGuide, which adds some extra margin so that views don’t run to the left and right edges of the screen
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            // pin the top of the clues label to the bottom of the score label
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            
            // pin the leading edge of the clues label to the leading edge of our layout margins, adding 100 for some space
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            
            // make the clues label 60% of the width of our laymout margins, minus 100
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            // also pin the top of the answer label to the bottom of the score label
            answerLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            
            // make the answer label stick to the trailing edge of our layout margins, minus 100
            answerLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            
            // make the answer label take up 40% of the available space, minus 100
            answerLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            
            // make the answers label match the height of the clues label
            answerLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            // we’re going to make this text field centered in our view, but only 50% its width – given how many characters it will hold, this is more than enough. We’re also going to place it below the clues label, with 20 points of spacing so the two don’t touch.
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            // submit and clear button constraints
            
            // For the submit button we’ll be using the bottom of the current answer text field, but for the clear button we’ll be setting its Y anchor so that its stays aligned with the Y position of the submit button. This means both buttons will remain aligned even if we move one.
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            // We’re going to center them both horizontally in our main view. To stop them overlapping, we’ll subtract 100 from the submit button’s X position, and add 100 to the clear button’s X position.
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            // We’re going to force both buttons to have a height of 44 points. iOS likes to make its buttons really small by default, but at the same time Apple’s human interface guidelines recommends buttons be at least 44x44 so they can be tapped easily.
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            // We’re going to give it a width and height of 750x320 so that it precisely contains the buttons inside it.
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            // It will be centered horizontally.
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // We’ll set its top anchor to be the bottom of the submit button, plus 20 points to add a little spacing.
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            // We’ll pin it to the bottom of our layout margins, -20 so that it doesn’t run quite to the edge.
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        
        
        // configuring buttons array
        
        // set some values for the width and height of each button
        let width = 150
        let height = 80
        
        // create 20 buttons as a 4x5 grid
        for row in 0..<4 {
            for col in 0..<5 {
                // craete a new button and give it a big font size
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                
                // give the button some temporary text so we can see it on-screen
                letterButton.setTitle("WW", for: .normal)
                
                // calculate the frame of this button using its column and row
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                // add it to the buttons view
                buttonsView.addSubview(letterButton)
                
                // and also to our letterButton array
                letterButtons.append(letterButton)
                
                // we want all the letter buttons to call letterTapped() when they are tapped
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.loadLevel()
        }
    }
    
    func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                
                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        
        letterBits.shuffle()
        
        DispatchQueue.main.async { [weak self] in
            // Now configure the buttons and labels
            self?.cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
            self?.answerLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if let letterButtons = self?.letterButtons {
                if letterBits.count == self?.letterButtons.count {
                    for i in 0 ..< letterButtons.count {
                        letterButtons[i].setTitle(letterBits[i], for: .normal)
                    }
                }
            }
            
        }
        
        
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        // It adds a safety check to read the title from the tapped button, or exit if it didn’t have one for some reason.
        guard let buttonTitle = sender.titleLabel?.text else { return }
        // Appends that button title to the player’s current answer
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        // Appends the button to the activatedButtons array
        activatedButtons.append(sender)
        sender.isHidden = true
    }
    
    // This method will use firstIndex(of:) to search through the solutions array for an item and, if it finds it, tells us its position.
    @objc func submitTapped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text else { return }
        
        if let solutionPosition = solutions.firstIndex(of: answerText) {
            activatedButtons.removeAll()
            
            var splitAnswers = answerLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            answerLabel.text = splitAnswers?.joined(separator: "\n")
            
            currentAnswer.text = ""
            score += 1
            
            // check if all buttons are hidden so that user can advance to the next level
            let allButtonsHidden = letterButtons.filter{ $0.isHidden }
            
            if  allButtonsHidden.count == letterButtons.count {
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go", style: .default, handler: levelUp))
                present(ac, animated: true)
                score = 0
            }
            
            
        } else {
            showErrorAlert()
            score -= 1
        }
    }
    
    // Challenge 2
    func showErrorAlert() {
        let ac = UIAlertController(title: "That is incorrect!", message: "Please try gain..", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default) {
            [weak currentAnswer] _ in
            currentAnswer?.text = ""
            
            for button in self.activatedButtons {
                button.isHidden = false
            }
            self.activatedButtons.removeAll()
        })
        
        present(ac, animated: true)
    }
    
    func levelUp(action: UIAlertAction) {
        level += 1
        solutions.removeAll(keepingCapacity: true)
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.loadLevel()
        }
    
        
        for button in letterButtons {
            button.isHidden = false
        }
    }
    
    // this method removes the text from the current answer text field, unhides all the activated buttons, then removes all the items from the activatedButtons array.
    @objc func clearTapped(_ sender: UIButton) {
        currentAnswer.text = ""
        
        for button in activatedButtons {
            button.isHidden = false
        }
        
        activatedButtons.removeAll()
    }
    
    
}

