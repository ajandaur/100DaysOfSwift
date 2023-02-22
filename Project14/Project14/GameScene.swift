//
//  GameScene.swift
//  Project14
//
//  Created by Anmol  Jandaur on 2/21/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var gameScore: SKLabelNode!
    
    var finalgameScore: SKLabelNode!
    
    var numRounds = 0
    
    // show method is triggered by VC managed by this property
    var popupTime = 0.85
    
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    // An array in which we can store all our slots for referencing later.
    var slots = [WhackSlot]()
    
    // A createSlot(at:) method that handles slot creation.
    func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    
    func createEnemy() {
        
        numRounds += 1
        
        if numRounds >= 30 {
            for slot in slots {
                slot.hide()
            }
            
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)
            
            // Challenge 2: When showing “Game Over” add an SKLabelNode showing their final score.
            finalgameScore = SKLabelNode(fontNamed: "Chalkduster")
            gameScore.text = gameScore.text
            gameScore.position = CGPoint(x: 512, y: 450)
            gameScore.horizontalAlignmentMode = .center
            addChild(finalgameScore)
            
            return
        }
        
        // Decrease popupTime each time it's called. I'm going to multiply it by 0.991 rather than subtracting a fixed amount, otherwise the game gets far too fast.
        popupTime *= 0.991
        
       // Shuffle the list of available slots using the shuffle() method we've used previously.
        slots.shuffle()
        
        // Make the first slot show itself, passing in the current value of popupTime for the method to use later.
        slots[0].show(hideTime: popupTime)
        
        // Generate four random numbers to see if more slots should be shown. Potentially up to five slots could be shown at once.
        if Int.random(in: 0...12) > 4 { slots[1].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 8 { slots[2].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 10 { slots[3].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 11 { slots[4].show(hideTime: popupTime) }
        
        // Call itself again after a random delay. The delay will be between popupTime halved and popupTime doubled. For example, if popupTime was 2, the random number would be between 1 and 4.
        
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)
   
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.createEnemy()
        }
     
        
    }

    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        
        // Four loops, one for each row.
        // need to figure out which positions to use for the slots
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320)) }
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140)) }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.createEnemy()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
            if !whackSlot.isVisible { continue }
            if whackSlot.isHit { continue }
            whackSlot.hit()

            if node.name == "charFriend" {
                // they shouldn't have whacked this penguin
                score -= 5

                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
            } else if node.name == "charEnemy" {
                // they should have whacked this one
                whackSlot.charNode.xScale = 0.85
                whackSlot.charNode.yScale = 0.85
                score += 1

                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            }
        }
    }
}
