//
//  ButtonNode.swift
//  iOS-Game-Controller
//
//  Created by João Paulo de Oliveira Sabino on 04/04/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//
import SpriteKit

class ButtonNode: SKNode {
    var shape : SKShapeNode!
    var buttonName: SKLabelNode!
    var actionBlock : (() -> Void)?
    override init() {
        super.init()
    }
    
    convenience init(name: String, radius: CGFloat, fillColor: SKColor, inPosition: CGPoint){
        self.init()
        self.isUserInteractionEnabled = true
        shape = SKShapeNode(circleOfRadius: radius)
        shape.fillColor = fillColor
        shape.strokeColor = SKColor.clear
        shape.alpha = 0.5
        self.position = CGPoint(x: 0, y: 0)
        shape.position = inPosition
        addChild(shape)
        
        buttonName = SKLabelNode(text: name)
        buttonName.verticalAlignmentMode = .center
        buttonName.position = CGPoint.zero
        buttonName.fontName = "HelveticaNeue-Bold"
        buttonName.fontColor = SKColor.white
        buttonName.fontSize = 32
        shape.addChild(buttonName)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        actionBlock?()
        self.run(SKAction.fadeAlpha(to: 0.2, duration: 0.1))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
