//
//  UnbankedCurveModel.swift
//  Book_Sources
//
//  Created by Brendoon Ryos on 24/03/19.
//

import SceneKit

public enum CurveRadius: Int {
  case Twenty = 20
  case Forty = 40
  case Sixty = 60
  case Eighty = 80
  case OneHundred = 100
  case OneHundredAndTwenty = 120
  case OneHundredAndForty = 140
  case OneHundredAndSixty = 160
}

public class TheCarModel: BaseModel {
  var followCamera: SCNNode
  
  var followLight: SCNNode
  
  var particleHolder: SCNNode
  
  private var car: SCNNode
  
  private var center: SCNNode
  
  var scene: SCNScene
  
  var speed: Float = 16.0
  
  var gravity: Float = 10.0
  
  var shouldFinish: ((Bool) -> ())?
  
  private var curveRadius: CurveRadius = .Forty
  
  private var isCurving = false
  
  private var isSpeedCorrect = false
  
  private var friction: Float = 0.7
  
  var assessmentSent = false {
    didSet {
      var shouldFinish = false
      
      if car.presentation.position.x > 400 {
        shouldFinish = true
      }
      
      if shouldFinish {
        setupConfetti(scene: scene, particleHolder: particleHolder)
      }
      
      DispatchQueue.main.async {
        self.shouldFinish?(shouldFinish)
      }
    }
  }
  
  init() {
    scene = SCNScene(named: "WorldResources.scnassets/page2.scn")!
    followLight = scene.rootNode.childNode(withName: "FollowLight", recursively: true)!
    followCamera = scene.rootNode.childNode(withName: "FollowCamera", recursively: true)!
    particleHolder = scene.rootNode.childNode(withName: "camera", recursively: true)!
    car = scene.rootNode.childNode(withName: "Car reference", recursively: true)!
    center = scene.rootNode.childNode(withName: "Center", recursively: true)!
    center.isHidden = true
  }
  
  func setup(curveRadius: CurveRadius, speed: Float) {
    self.curveRadius = curveRadius
    self.speed = speed
    
    let space: Float = 46
    switch curveRadius {
    case .Forty:
      car.position.x -= space
      center.childNodes[0].position.x -= space
    case .Sixty:
      car.position.x -= 2*space
      center.childNodes[0].position.x -= 2*space
    case .Eighty:
      car.position.x -= 3*space
      center.childNodes[0].position.x -= 3*space
    case .OneHundred:
      car.position.x -= 4*space
      center.childNodes[0].position.x -= 4*space
    case .OneHundredAndTwenty:
      car.position.x -= 5*space
      center.childNodes[0].position.x -= 5*space
    case .OneHundredAndForty:
      car.position.x -= 6*space
      center.childNodes[0].position.x -= 6*space
    case .OneHundredAndSixty:
      car.position.x -= 7*space
      center.childNodes[0].position.x -= 7*space
    default:
      break
    }
  }
  
  private func checkSpeed() -> Bool {
    let correctAnswer: Double = Double(sqrt(Float(curveRadius.rawValue) * friction * gravity))
    
    if correctAnswer >= Double(speed) || abs(correctAnswer - Double(speed)) < 1  {
      return true
    }
    return false
  }
  
  func setup() {
    isSpeedCorrect = checkSpeed()
    playSound(named: "Car.wav", node: followLight)
  }
  
  func update() {
    if !assessmentSent {
      followLight.position = followCamera.position
      
      if car.isHidden {
        if  #available(iOS 11.0, *)  {
          followCamera.position.z = center.childNodes[0].presentation.worldPosition.z
          followCamera.position.x = center.childNodes[0].presentation.worldPosition.x
        }
      } else {
        followCamera.position.z = car.presentation.position.z
        followCamera.position.x = car.presentation.position.x
      }
      
      if #available(iOS 11.0, *) {
        if car.presentation.position.x > 500 {
          car.physicsBody?.clearAllForces()
          followLight.removeAllAudioPlayers()
          assessmentSent = true
        } else if self.car.presentation.position.z > -106.8 && isCurving == false {
          
          isCurving = true
          
          let hide = SCNAction.run { (node) in
            self.center.childNodes[0].worldPosition.z = self.car.presentation.worldPosition.z
            self.car.isHidden = true
            self.center.isHidden = false
          }
          
          var factor: Float = 2.0
          var factor2: Float = 50.0
          if !isSpeedCorrect {
            factor = Float(8)
            factor2 =  factor * factor2
          }
          let rotate = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi / factor), z: 0, duration: TimeInterval((factor/factor2)*self.speed))
          
          let move = SCNAction.run { (node) in
            self.car.transform = self.center.childNodes[0].worldTransform
            self.center.isHidden = true
            self.car.isHidden = false
          }
          
          let sequence = SCNAction.sequence([hide, rotate, move])
          
          self.center.runAction(sequence)
          
        } else if isCurving {
          
          if !isSpeedCorrect {
            car.physicsBody?.velocity.z = Float(speed*5)
            car.physicsBody?.velocity.x = 0
            if car.presentation.position.z > 450 {
              car.physicsBody?.velocity.y = -Float(speed*5)
            }
          } else {
            car.physicsBody?.velocity.z = 0
            car.physicsBody?.velocity.x = Float(speed*5)
          }
          
        } else {
          car.physicsBody?.velocity.z = Float(speed*5)
        }
        
        if car.presentation.position.y < -50 {
          followLight.removeAllAudioPlayers()
          car.physicsBody?.clearAllForces()
          assessmentSent = true
        }
      }
    }
  }
}
