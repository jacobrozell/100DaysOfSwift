//
//  GameScene.swift
//  project_11
//
//  Created by Jacob Rozell on 10/20/21.
//

import SpriteKit
import GameplayKit

#warning("Run on iPad (9th Gen)")

class GameScene: SKScene {
    var replayLabel: SKLabelNode!

    var remainingBallLabel: SKLabelNode!
    var remainingBallCount = 5 {
        didSet {
            remainingBallLabel.text = "Balls: \(remainingBallCount)"
        }
    }

    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    var editLabel: SKLabelNode!
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }

    override func didMove(to view: SKView) {
        // Create background
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)

        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self

        replayLabel = SKLabelNode(fontNamed: "Chalkduster")
        replayLabel.text = "Replay"
        replayLabel.horizontalAlignmentMode = .right
        replayLabel.position = CGPoint(x: 500, y: 700)
        addChild(replayLabel)

        remainingBallLabel = SKLabelNode(fontNamed: "Chalkduster")
        remainingBallLabel.text = "Balls: \(remainingBallCount)"
        remainingBallLabel.horizontalAlignmentMode = .right
        remainingBallLabel.position = CGPoint(x: 700, y: 700)
        addChild(remainingBallLabel)

        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)

        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)

        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)

        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let objects = nodes(at: location)

        if objects.contains(editLabel) {
            editingMode.toggle()
        } else if objects.contains(replayLabel) {
            // remove all bumpers
            remainingBallCount = 5
            score = 0
        } else {
            if editingMode {
                addChild(createBumperBox(at: location))
            } else {
                // Confirm that touch location was in bounds
                guard location.y > 550 else { return }

                if remainingBallCount != 0 {
                    addChild(createBall(at: location))
                }
            }
        }
    }

    // MARK: - Util Methods
    func createBall(at location: CGPoint) -> SKSpriteNode {
        let colors = ["Blue", "Cyan", "Green", "Grey", "Purple", "Red", "Yellow"]
        let ball = SKSpriteNode(imageNamed: "ball\(colors.randomElement()!)")
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
        ball.physicsBody?.restitution = 0.4
        ball.position = location
        ball.name = "ball"

        // detect collisions
        ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0

        remainingBallCount -= 1

        return ball
    }

    func createBumperBox(at location: CGPoint) -> SKSpriteNode {
        let size = CGSize(width: Int.random(in: 16...128), height: 16)
        let randomColor = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
        let box = SKSpriteNode(color: randomColor, size: size)

        box.zRotation = CGFloat.random(in: 0...3)
        box.position = location
        box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
        box.physicsBody?.isDynamic = false
        box.name = "bumper"

        return box
    }

    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.isDynamic = false // stay fixed in place when colliding
        addChild(bouncer)
    }

    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode

        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }

        slotBase.position = position
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false

        slotGlow.position = position

        addChild(slotBase)
        addChild(slotGlow)

        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
}

// MARK: - SKPhysicsContactDelegate Extension
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node,
              let nodeB = contact.bodyB.node
        else { return }

        if nodeA.name == "ball" {
            collision(between: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collision(between: nodeB, object: nodeA)
        }
    }

    // Collision Methods
    func collision(between ball: SKNode, object: SKNode) {
        if object.name == "good" {
            score += 1
            destroy(node: ball)
            remainingBallCount += 2
        } else if object.name == "bad" {
            score -= 1
            destroy(node: ball)
        } else if object.name == "bumper" {
            destroy(node: object, particleName: "MagicParticle")
        }
    }
    

    func destroy(node: SKNode, particleName: String = "FireParticles") {
        if let particles = SKEmitterNode(fileNamed: particleName) {
            particles.position = node.position
            addChild(particles)
        }

        node.removeFromParent()
    }
}
