//
//  TheMoonModel.swift
//  Book_Sources
//
//  Created by Brendoon Ryos on 24/03/19.
//

import SceneKit

enum NodeName: String {
  case W1
  case W2
  case D
  case C
  case Apple
  case Rocket
  case Cheese
}

public class TheMoonModel: BaseModel {
  var followCamera: SCNNode
  
  var followLight: SCNNode
  
  var particleHolder: SCNNode
  
  var rocket: SCNNode
  
  var particles: SCNParticleSystem
  
  var anchor: SCNNode
  
  var scene: SCNScene
  
  var speed: Float = 20.0
  
  var gravity: Float = 10.0
  
  var shouldFinish: ((Bool) -> ())?
  
  var assessmentSent: Bool = false
  
  init() {
    scene = SCNScene(named: "WorldResources.scnassets/page4.scn")!
    followLight = scene.rootNode.childNode(withName: "FollowLight", recursively: true)!
    followCamera = scene.rootNode.childNode(withName: "FollowCamera", recursively: true)!
    particleHolder = scene.rootNode.childNode(withName: "camera", recursively: true)!
    rocket = scene.rootNode.childNode(withName: "Rocket", recursively: true)!
    particles = rocket.childNodes[0].particleSystems![0]
    particles.birthRate = 0
    anchor = scene.rootNode.childNode(withName: "Anchor", recursively: true)!
  }
  
  private func animateAstronault() {
    let rotate = SCNAction.rotateBy(x: 0, y: .pi*2, z: 0, duration: 18)
    let upAction = SCNAction.move(by: SCNVector3Make(0, 80, 0), duration: 1)
    let downAction = SCNAction.move(by: SCNVector3Make(0, -80, 0), duration: 1)
    let sequence = SCNAction.sequence([upAction, downAction, upAction, downAction, upAction, downAction])
    let sequence1 = SCNAction.sequence([sequence, sequence,  sequence])
    
    let group = SCNAction.group([rotate, sequence1])
    anchor.presentation.runAction(SCNAction.repeatForever(group))
  }
  
  func setup() {
    animateAstronault()
    playSound(named: "Moon.wav", node: anchor)
  }
  
  func update() {}
}
