//
//  WhackSlot.swift
//  project_14
//
//  Created by Jacob Rozell on 10/21/21.
//

import SpriteKit

class WhackSlot: SKNode {
    var charNode: SKSpriteNode!
    var isVisible = false
    var isHit = false

    func configure(at position: CGPoint) {
        self.position = position

        // Create hole
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)

        // Add cropNode to hide penguin
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")

        // Create penguin sprite
        charNode = SKSpriteNode(imageNamed: "penguinGood")

        // placed at -90 because we want it to be hidden
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"

        // Add penguin to cropNode
        cropNode.addChild(charNode)

        // Add cropNode to self
        addChild(cropNode)
    }

    func show(hideTime: Double) {
        if isVisible { return }

        charNode.xScale = 1
        charNode.yScale = 1

        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        isVisible = true
        isHit = false

        if Int.random(in: 0...2) == 0 {
            // good penguin
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            // bad penguin
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [weak self] in
            self?.hide()
        }
    }

    func hide() {
        if !isVisible { return }

        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false

        if let mudParticles = SKEmitterNode(fileNamed: "MudParticle") {
            mudParticles.position = charNode.position
            mudParticles.numParticlesToEmit = 35
            addChild(mudParticles)
        }
    }

    func hit() {
        isHit = true

        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run { [weak self] in self?.isVisible = false }
        let sequence = SKAction.sequence([delay, hide, notVisible])

        if let smokeParicle = SKEmitterNode(fileNamed: "SmokeParticle") {
            smokeParicle.position = charNode.position
            smokeParicle.numParticlesToEmit = 15
            addChild(smokeParicle)
        }
        
        charNode.run(sequence)
    }
}
