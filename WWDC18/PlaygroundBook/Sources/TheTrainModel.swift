//
//  AverageSpeedModel.swift
//  Book_Sources
//
//  Created by Brendoon Ryos on 23/03/19.
//

import SceneKit

public enum WagonsCount: Int {
  case Zero = 0
  case One
  case Two
  case Three
  case Four
  case Five
  case Six
}

public class TheTrainModel: BaseModel {
  var seconds: Double = 0
  var frames: Int = 0
  var isFalling: Bool = false
  var time: TimeInterval = 4.0
  var speed: Float = 20.0
  var wagonsCount: WagonsCount = .Two
  var gravity: Float = 10.0
  
  var scene: SCNScene
  var train = [SCNNode]()
  var bridge: SCNNode!
  var followCamera: SCNNode
  var followLight: SCNNode
  var particleHolder: SCNNode
  public var shouldFinish: ((Bool) -> ())?
  
  var assessmentSent = false {
    didSet {
      var shouldFinish = true
      
      for node in train {
        if node.presentation.position.y < 550 {
          shouldFinish = false
          break
        }
      }
      
      if shouldFinish {
        setupConfetti(scene: scene, particleHolder: particleHolder)
      }
      
      DispatchQueue.main.async {
        self.shouldFinish?(shouldFinish)
      }
    }
  }
  
  public init() {
    scene = SCNScene(named: "WorldResources.scnassets/page1.scn")!
    train.append(scene.rootNode.childNode(withName: "Steam Train", recursively: true)!)
    train[0].childNodes[0].isHidden = true
    train.append(scene.rootNode.childNode(withName: "Freight Wagon Blue", recursively: true)!)
    train.append(scene.rootNode.childNode(withName: "Freight Wagon Purple", recursively: true)!)
    train.append(scene.rootNode.childNode(withName: "Freight Wagon Red", recursively: true)!)
    train.append(scene.rootNode.childNode(withName: "Freight Wagon Orange", recursively: true)!)
    train.append(scene.rootNode.childNode(withName: "Freight Wagon Yellow", recursively: true)!)
    train.append(scene.rootNode.childNode(withName: "Freight Wagon Green", recursively: true)!)
    bridge = scene.rootNode.childNode(withName: "Bridge reference", recursively: true)!
    followLight = scene.rootNode.childNode(withName: "FollowLight", recursively: true)!
    followCamera = scene.rootNode.childNode(withName: "FollowCamera", recursively: true)!
    particleHolder = scene.rootNode.childNode(withName: "camera", recursively: true)!
  }
  
  func setup(wagonsCount: WagonsCount, speed: Float, time: TimeInterval) {
    self.wagonsCount = wagonsCount
    self.speed = speed
    self.time = time
    
    let wagons = train.filter{ $0.name!.contains("Wagon")}
    wagons.forEach{ $0.isHidden = true }
    if wagonsCount.rawValue != 0  {
      for i in 0..<wagons.count {
        wagons[i].isHidden = false
        if i == wagonsCount.rawValue - 1 {
          break
        }
      }
    }
  }
  
  func setup() {
    playSound(named: "Train.wav", node: train[0])
    train[0].childNodes[0].isHidden = false
  }
  
  private func bridgeFalls() {
    if isFalling == false {
      let removePhysics = SCNAction.run { (node) in
        node.physicsBody = .none
      }
      let rotate = SCNAction.rotateBy(x: -.pi/2, y: 0, z: 0, duration: 0.5)
      let move = SCNAction.move(by: SCNVector3Make(50, -50, 0), duration: 0.5)
      let destroy = SCNAction.run { (node) in
        node.removeFromParentNode()
      }
      
      let group = SCNAction.group([removePhysics, move, rotate])
      let sequence = SCNAction.sequence([SCNAction.wait(duration: time - 0.5), group, destroy])
      
      bridge.runAction(sequence)
      isFalling = true
    }
  }
  
  func update() {
    if !assessmentSent {
      
      followLight.position = followCamera.position
      
      if wagonsCount == .Zero {
        followCamera.position.z = self.train[0].presentation.position.z + 500
      } else {
        followCamera.position.z = self.train[0].presentation.position.z
      }
      
      if seconds >= Double(self.time){
        self.bridgeFalls()
      }
      
      frames += 1
      
      if frames == 3 {
        frames = 0
        seconds += 0.1
      }
      
      
      if train[0].presentation.position.z > 1950 || train[0].presentation.position.y < -500 {
  
        train[0].childNodes[0].isHidden = true
        train.forEach { $0.physicsBody?.clearAllForces() }
        train[0].removeAllAudioPlayers()
        assessmentSent = true
      } else if train[0].presentation.position.y < 0 {
        train[0].childNodes[0].isHidden = true
      } else {
        train.forEach { $0.physicsBody?.velocity.z = Float(speed*21)}
      }
    }
  }
}
