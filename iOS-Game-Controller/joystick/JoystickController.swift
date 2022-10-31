//
//  JoystickController.swift
//  iOS-Game-Controller
//
//  Created by João Paulo de Oliveira Sabino on 04/04/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//
import SpriteKit

class JoystickController: SKSpriteNode {
    var joystick: JoystickNode!
    var joystickDelegate : JoystickDelegate?
    var virtualButtonA: ButtonNode!
    var virtualButtonB: ButtonNode!
    var virtualButtonMenu: ButtonNode!
    
    var isDown: Bool = false
    var touchLeft = UITouch()
    
    init(size: CGSize) {
        super.init(texture: nil, color: SKColor.clear, size: size)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.isUserInteractionEnabled = true
        joystick = JoystickNode(diameter: 180, colors: (substrate: SKColor.gray, stick: SKColor.gray))
        joystick.disabled = true
        let joystickXPosition = -(self.size.width/2) + 120
        let joystickYPosition = -(self.size.height/2) + 100
        joystick.position = CGPoint(x: joystickXPosition, y: joystickYPosition)
        addChild(joystick)
        
        
        let positionButtonA  = CGPoint(x: (self.size.width/2) - 220, y: -(self.size.height/2) + 120)
        virtualButtonA = ButtonNode(name: "A", radius: 60, fillColor: SKColor.gray, inPosition: positionButtonA)
        addChild(virtualButtonA)
        let positionButtonB  = CGPoint(x: (self.size.width/2) - 100, y: -(self.size.height/2) + 200)
        virtualButtonB = ButtonNode(name: "B", radius: 60, fillColor: SKColor.gray, inPosition: positionButtonB)
        addChild(virtualButtonB)
        
        let positionButtonMenu  = CGPoint(x: (self.size.width/2) - 40, y: (self.size.height/2) - 40)
        virtualButtonMenu = ButtonNode(name: "MENU", radius: 20, fillColor: SKColor.gray, inPosition: positionButtonMenu)
        virtualButtonMenu.buttonName.fontSize = 10
        addChild(virtualButtonMenu)
        
        virtualButtonA.actionBlock = {
            self.joystickDelegate?.joystickDidTapButtonA()
        }
        virtualButtonB.actionBlock = {
            self.joystickDelegate?.joystickDidTapButtonB()
        }
        virtualButtonMenu.actionBlock = {
            self.joystickDelegate?.joystickDidTapButtonMenu()
        }
        
        let updateJoystick = CADisplayLink(target: self, selector: #selector(update))
        updateJoystick.preferredFramesPerSecond = 60
        updateJoystick.add(to: .current, forMode: .default)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func update(){
        if joystick.tracking {
            joystickDelegate?.joystickUpdateTracking(direction: joystick.direction)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, (touch.location(in: self).x < 0), (touchLeft != touch) {
            touchLeft = touch
            joystick.disabled = false
            joystick.position = touch.location(in: self)
            joystick.touchesBegan([touch], with: event)
            joystickDelegate?.joystickDidStartTracking()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, (touch.location(in: self).x < 0), (touchLeft == touch) {
            joystick.touchesMoved([touch], with: event)
            joystickDelegate?.joystickDidMoved(direction: joystick.direction)
            
            isDown = joystick.direction.y < -20 ? true : false
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, (touchLeft == touch) {
            touchLeft = UITouch()
            joystick.disabled = true
            joystick.touchesEnded([touch], with: event)
            joystickDelegate?.joystickDidEndTracking(direction: joystick.direction)
            
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                self.isDown = false
            }
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, (touchLeft == touch) {
            touchLeft = UITouch()
            joystick.disabled = true
            joystick.touchesCancelled([touch], with: event)
            joystickDelegate?.joystickDidEndTracking(direction: joystick.direction)
            
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                self.isDown = false
            }
        }
    }
}
