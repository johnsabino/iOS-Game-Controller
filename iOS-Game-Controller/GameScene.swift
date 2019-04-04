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

class GameScene: SKScene {
    var joystickController: JoystickController!
    
    var connectivityService = ConnectivityService.shared
    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        setupJoystick()
        
        self.connectivityService.mcSession.delegate = self
    }
    
    func setupJoystick(){
        let inputSize = CGSize(width: self.size.width, height: self.size.height)
        joystickController = JoystickController(size: inputSize)
        joystickController.zPosition = 10
        joystickController.position = self.position
        joystickController.joystickDelegate = self
        
        addChild(joystickController)
        
    }
}

extension GameScene: JoystickDelegate {
    func joystickDidStartTracking() {
        
    }
    
    func joystickDidMoved(direction: CGPoint) {
        let message: Message = .move(dx: Float(direction.x), dy: Float(direction.y))
        connectivityService.sendData(data: message.archive())
    }
    
    func joystickUpdateTracking(direction: CGPoint) {
        
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
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
            
        case .connecting:
            print("Connecting: \(peerID.displayName)")
            
        case .notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)
    }
    
    
}
