//
//  GameScene.swift
//  iOS-Game-Controller
//
//  Created by João Paulo de Oliveira Sabino on 04/04/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import SpriteKit
import GameplayKit
import MultipeerConnectivity

final class GameScene: SKScene {
    let connectivityService = ConnectivityService.shared
    
    lazy var joystickController: JoystickController = {
        let joystick = JoystickController(size: CGSize(width: size.width, height: size.height))
        joystick.zPosition = 10
        joystick.position = self.position
        joystick.joystickDelegate = self
        addChild(joystick)
        
        return joystick
    }()
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        connectivityService.mcSession.delegate = self
    }
}

extension GameScene: JoystickDelegate {
    func joystickDidStartTracking() { }
    func joystickUpdateTracking(direction: CGPoint) { }
    
    func joystickDidMoved(direction: CGPoint) {
        let message: Message = .move(dx: Float(direction.x), dy: Float(direction.y))
        connectivityService.sendData(data: message.archive())
    }
    
    func joystickDidEndTracking(direction: CGPoint) {
        let message: Message = .move(dx: 0, dy: 0)
        connectivityService.sendData(data: message.archive())
    }
    
    func joystickDidTapButtonA() {
        let message: Message = .pressA
        connectivityService.sendData(data: message.archive())
    }
    
    func joystickDidTapButtonB() {
        let message: Message = .pressB
        connectivityService.sendData(data: message.archive())
    }
    
    func joystickDidTapButtonMenu() {
        //join session multipeer
        let mcBrowser = MCBrowserViewController(serviceType: "hws-kb", session: connectivityService.mcSession)
        mcBrowser.delegate = self
        
        let vc = self.view?.window?.rootViewController
        vc?.present(mcBrowser, animated: true, completion: nil)
    }

}

extension GameScene: MCSessionDelegate, MCBrowserViewControllerDelegate {
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) { }
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) { }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) { }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
            
        case .connecting:
            print("Connecting: \(peerID.displayName)")
            
        case .notConnected:
            print("Not Connected: \(peerID.displayName)")
        @unknown default:
            fatalError("Error: state not handled")
        }
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)
    }
}
