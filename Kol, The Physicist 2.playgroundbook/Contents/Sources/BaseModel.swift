//
//  BaseModel.swift
//  Book_Sources
//
//  Created by Brendoon Ryos on 23/03/19.
//

import SceneKit

protocol BaseModel {
  var followCamera: SCNNode { get set }
  var followLight: SCNNode { get set }
  var particleHolder: SCNNode { get set }
  var scene: SCNScene { get set }
  var speed: Float { get set }
  var gravity: Float { get set }
  var shouldFinish: ((Bool) -> ())? { get set }
  var assessmentSent: Bool { get set }
  func setup()
  func update()
  func playSound(named: String, node: SCNNode)
}

extension BaseModel {
  func playSound(named: String, node: SCNNode) {
    if let source = SCNAudioSource(fileNamed: named)
    {
      source.volume = 1.0
      source.isPositional = true
      source.shouldStream = true
      if named == "Moon.wav" {
        source.loops = true
      }
      source.load()
      let playSound = SCNAction.playAudio(source, waitForCompletion: true)
      node.runAction(playSound)
    }
  }
  
  func setupConfetti(scene: SCNScene, particleHolder: SCNNode) {
    let ground = scene.rootNode.childNode(withName: "floor", recursively: false)!
    
    let confetti = Confetti(colliderNodes: [ground])
    
    particleHolder.addParticleSystem(confetti)
    
    let wait = SCNAction.wait(duration: 5)
    
    let action = SCNAction.run { node in
      node.removeAllParticleSystems()
    }
    
    let sequence = SCNAction.sequence([wait, action])
    
    particleHolder.runAction(sequence)
    
  }
}
