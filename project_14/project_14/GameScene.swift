//
//  GameScene.swift
//  project_14
//
//  Created by Jacob Rozell on 10/21/21.
//

import SpriteKit

enum GameSound: String {
    case fail = "whackBad.caf"
    case good = "whack.caf"
//    case gameOver = "Game Over Sound Effect.caf"
}

class GameScene: SKScene {
    var gameScore: SKLabelNode!
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }

    var slots = [WhackSlot]()
    var initialPopupTime = 0.85
    var popupTime = 0.85 // bit faster than once a second

    var roundLabel: SKLabelNode!
    var roundNum = 0 {
        didSet {
            roundLabel.text = "Round: \(roundNum)"
        }
    }

    var gameOver: SKSpriteNode!
    var multiplier: Int = 1
    
    override func didMove(to view: SKView) {
        // Add background
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)

        // Add score
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)

        // Add round label
        roundLabel = SKLabelNode(fontNamed: "Chalkduster")
        roundLabel.text = "Round: 0"
        roundLabel.position = CGPoint(x: 500, y: 8)
        roundLabel.horizontalAlignmentMode = .left
        roundLabel.fontSize = 48
        addChild(roundLabel)

        // Create slots
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320)) }
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140)) }

        // Create first enemy to start the recursion
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.createEnemy()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)

        for node in tappedNodes {

            // If gameOver tapped.
            if node.name == "gameOver" {
                restartGame()
            }

            guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
            if !whackSlot.isVisible { continue }
            if whackSlot.isHit { continue }

            whackSlot.hit()

            if node.name == "charFriend" {
                multiplier = 1
                score -= 5
                run(SKAction.playSoundFileNamed(GameSound.fail.rawValue, waitForCompletion: false))
            } else if node.name == "charEnemy" {
                whackSlot.charNode.xScale = 0.85
                whackSlot.charNode.yScale = 0.85
                score += 1 * multiplier
                multiplier += 1
                run(SKAction.playSoundFileNamed(GameSound.good.rawValue, waitForCompletion: false))
            }
        }
    }

    // MARK: - Util
    func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }

    func createEnemy() {

        // Update round
        roundNum += 1

        // Check if game is over
        if roundNum >= 30 {
            for slot in slots {
                slot.hide()
            }

            makeGameOverLabel()
            return
        }

        // Increase popupTime with each enemy
        popupTime *= 0.991

        // Shuffle slots
        slots.shuffle()

        // Create slot
        slots[0].show(hideTime: popupTime)

        if Int.random(in: 0...12) > 4 { slots[1].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 8 { slots[2].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 10 { slots[3].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 11 { slots[4].show(hideTime: popupTime) }

        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)

        // Start Recursion
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.createEnemy()
        }
    }

    func restartGame() {
        score = 0
        roundNum = 0
        popupTime = initialPopupTime
        gameOver.removeFromParent()

        // Create first enemy to start the recursion
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.createEnemy()
        }
    }

    func makeGameOverLabel() {
        gameOver = SKSpriteNode(imageNamed: "gameOver")
        gameOver.position = CGPoint(x: 512, y: 384)
        gameOver.zPosition = 1
        gameOver.name = "gameOver"
//        run(SKAction.playSoundFileNamed(GameSound.gameOver.rawValue, waitForCompletion: false))
        addChild(gameOver)
    }
}
