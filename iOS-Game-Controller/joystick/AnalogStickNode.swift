//
//  AnalogStickNode.swift
//  iOS-Game-Controller
//
//  Created by João Paulo de Oliveira Sabino on 04/04/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//
import SpriteKit

open class JoystickNode: SKNode {
    var substrate : AnalogStickComponent!
    var stick: AnalogStickComponent!
    var joystickIsEnabled = true
    private(set) var tracking = false
    private(set) var direction = CGPoint.zero
    
    var joystickDelegate: JoystickDelegate?
    var disabled: Bool {
        get {
            return !isUserInteractionEnabled
        }
        
        set(isDisabled) {
            isUserInteractionEnabled = !isDisabled
            if isDisabled { resetStick() }
        }
    }
    
    var diameter: CGFloat {
        get {
            return substrate.diameter
        }
        
        set(newDiameter) {
            substrate.diameter = newDiameter
        }
    }
    
    var radius : CGFloat {
        get {
            return diameter * 0.5
        }
        set(newRadius) {
            diameter = newRadius * 2
        }
    }
    
    init(substrate: AnalogStickComponent, stick: AnalogStickComponent) {
        super.init()
        
        self.substrate = substrate
        substrate.zPosition = 0
        self.stick = stick
        stick.zPosition = 1
        
        addChild(substrate)
        addChild(stick)
        
        disabled = false
    }
    
    convenience init(diameter: CGFloat, colors: (substrate: SKColor?, stick: SKColor?)? = nil, images: (substrate: UIImage?, stick: UIImage?)? = nil) {
        let substrate = AnalogStickComponent(diameter: diameter, color: colors?.substrate, image: images?.substrate)
        let stick = AnalogStickComponent(diameter: diameter * 0.5, color: colors?.stick, image: images?.stick)
        self.init(substrate: substrate, stick: stick)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Overrides
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = touches.first {
            tracking = true
            joystickIsEnabled = true
        }
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            guard tracking else { return }
            
            let maxDistance = substrate.radius - (stick.radius / 2)
            let realDistance = hypot(location.x, location.y)
            
            let limitedLocation = CGPoint(x: (location.x / realDistance) * maxDistance, y: (location.y / realDistance) * maxDistance)
            
            let needPosition = realDistance <= maxDistance  ? location : limitedLocation
            stick.position = needPosition
            direction = needPosition
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetStick()
        if let location = touches.first?.location(in: self) {
            joystickDelegate?.joystickDidEndTracking(direction: location)
        }
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetStick()
        if let location = touches.first?.location(in: self) {
            joystickDelegate?.joystickDidEndTracking(direction: location)
        }
        
    }
    
    //MARK: - Private methods
    private func resetStick() {
        tracking = false
        let moveToBack = SKAction.move(to: CGPoint.zero, duration: TimeInterval(0.1))
        moveToBack.timingMode = .easeOut
        stick.run(moveToBack)
        direction = .zero
    }
}
