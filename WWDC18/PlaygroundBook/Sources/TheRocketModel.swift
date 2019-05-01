//
//  TheRocketModel.swift
//  Book_Sources
//
//  Created by Brendoon Ryos on 24/03/19.
//

import SceneKit

public class TheRocketModel: BaseModel {
  var followCamera: SCNNode
  
  var followLight: SCNNode
  
  var particleHolder: SCNNode
  
  private var rocket: SCNNode
  
  private var plane: SCNNode
  
  private var particles: SCNParticleSystem
  
  private var stars: SCNParticleSystem
  
  private var starsNode: SCNNode
  
  var scene: SCNScene
  
  var speed: Float = 3300.0
  
  var gravity: Float = 10.0
  
  var shouldFinish: ((Bool) -> ())?
  
  private var isCorrect = false {
    didSet {
      assessmentSent = true
    }
  }
  
  private var seconds: Double = 0
  private var frames: Int = 0
  private var isFalling: Bool = false
  private var isCurving: Bool = false
  
  private var mass: Float = 710.0
  private var combustionRate: Float = 2.5
  private var buoyancy: Float = 0
  
  var assessmentSent = false {
    didSet {
      DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
        self.shouldFinish?(self.isCorrect)
      }
    }
  }
  
  init() {
    scene = SCNScene(named: "WorldResources.scnassets/page3.scn")!
    followLight = scene.rootNode.childNode(withName: "FollowLight", recursively: true)!
    followCamera = scene.rootNode.childNode(withName: "FollowCamera", recursively: true)!
    particleHolder = scene.rootNode.childNode(withName: "camera", recursively: true)!
    rocket = self.scene.rootNode.childNode(withName: "Rocket", recursively: true)!
    plane = self.scene.rootNode.childNode(withName: "plane", recursively: true)!
    particles = self.rocket.childNodes[0].particleSystems![0]
    particles.birthRate = 0
    starsNode = self.scene.rootNode.childNode(withName: "Stars", recursively: true)!
    stars = starsNode.particleSystems![0]
    stars.birthRate = 0
  }
  
  func setup(mass: Float, combustionRate: Float, speed: Float) {
    self.mass = mass
    self.combustionRate = combustionRate
    self.speed = speed
  }
  
  func setup() {
    particles.birthRate = 800
    particles.particleSize = 10
    particles.colliderNodes = [rocket, plane]
    rocket.physicsBody?.mass = CGFloat(mass)

    isCorrect = checkRocketParameters()
    
    playSound(named: "Rocket.wav", node: self.rocket)
  }
  
  private func checkRocketParameters() -> Bool {
    buoyancy = speed*combustionRate
    
    if mass == 0 {
      return false
    }

    let aceleration = buoyancy/mass
    
    if aceleration > Float(gravity) {
      return true
    }
    return false
  }
  
  func update() {
    
    followCamera.position.y = rocket.presentation.position.y
    
    followLight.position = followCamera.position
    
    if rocket.presentation.position.y >= starsNode.position.y {
      starsNode.position.y = rocket.presentation.position.y
    }
    
    if seconds >= 1 {
      if isCorrect {
        stars.birthRate = 300
        rocket.physicsBody?.applyForce(SCNVector3(x: 0, y: buoyancy, z: 0), asImpulse: true)
      } else if !isFalling {
        isFalling = true
        rocket.physicsBody?.applyForce(SCNVector3(x: 0, y: buoyancy*2, z: 0), asImpulse: true)
      } else if !isCurving {
        isCurving = true
        rocket.physicsBody?.applyForce(SCNVector3(x: 0, y: -Float(buoyancy + Float(gravity))*4, z: 0), asImpulse: true)
        
        let sequence = SCNAction.sequence([SCNAction.wait(duration: 0.5), SCNAction.rotateBy(x: 0, y: 0, z: -.pi/2, duration: 1)])
        rocket.runAction(sequence)
        rocket.removeAllAudioPlayers()
        particles.birthRate = 0
      }
      seconds = 0
    }
    
    frames += 1
    
    if frames == 3 {
      frames = 0
      seconds += 0.1
    }
  }
}
