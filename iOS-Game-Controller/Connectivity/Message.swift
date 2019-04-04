//
//  Message.swift
//  iOS-Game-Controller
//
//  Created by João Paulo de Oliveira Sabino on 04/04/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import Foundation

enum Direction {
    case up
    case down
    case left
    case right
}

enum Message {
    case move(dx: Float, dy: Float)
    case pressA
    case pressB
    
    //Struct to data
    func archive() -> Data{
        var d = self
        return Data(bytes: &d, count: MemoryLayout.stride(ofValue: d))
    }
    
    //Data to struct
    static func unarchive(_ d: Data) -> Message?{
        guard d.count == MemoryLayout<Message>.stride else {
            fatalError("Error!")
        }
        
        var message: Message?
        
        d.withUnsafeBytes({(bytes: UnsafePointer<Message>) -> Void in
            message = UnsafePointer<Message>(bytes).pointee
        })
        return message
    }
}
