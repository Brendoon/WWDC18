//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  An auxiliary source file which is part of the book-level auxiliary sources.
//  Provides the implementation of the "always-on" live view.
//

import UIKit
import PlaygroundSupport
import SceneKit
import SpriteKit

@objc(Book_Sources_LiveViewController)
public class LiveViewController: UIViewController, PlaygroundLiveViewSafeAreaContainer {
  
  private let scnView = SCNView()
  private var sceneModel: BaseModel!
  private var isPlaying = false
  public var finishAssessment: ((Bool) -> ())?
  
  var cheeseCount: Int = 0
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    // show statistics such as fps and timing information
//    scnView.showsStatistics = true
    
    // configure the view
    scnView.backgroundColor = UIColor.black
    
    scnView.preferredFramesPerSecond = 30
    
    scnView.delegate = self
  }
  
  // MARK: The Moon Page
  public func setup() {
    let sceneModel = TheMoonModel()
    sceneModel.shouldFinish = finishAssessment
    scnView.scene = sceneModel.scene
    scnView.prepare(sceneModel.scene.rootNode.childNodes, completionHandler: { success in
      sceneModel.setup()
    })
    self.sceneModel = sceneModel
    
    // add a tap gesture recognizer
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
    scnView.addGestureRecognizer(tapGesture)
    // allows the user to manipulate the camera
    scnView.allowsCameraControl = true
  }
  
  // MARK: The Rocket Page
  public func setup(mass: Float, combustionRate: Float, speed: Float) {
    let sceneModel = TheRocketModel()
    sceneModel.shouldFinish = finishAssessment
    scnView.scene = sceneModel.scene
    sceneModel.setup(mass: mass, combustionRate: combustionRate, speed: speed)
    scnView.prepare(sceneModel.scene.rootNode.childNodes, completionHandler: { success in
      sceneModel.setup()
    })
    self.sceneModel = sceneModel
  }
  
  // MARK: The Car Page
  public func setup(curveRadius: CurveRadius, speed: Float) {
    let sceneModel = TheCarModel()
    sceneModel.shouldFinish = finishAssessment
    scnView.scene = sceneModel.scene
    sceneModel.setup(curveRadius: curveRadius, speed: speed)
    scnView.prepare(sceneModel.scene.rootNode.childNodes, completionHandler: { success in
      sceneModel.setup()
    })
    self.sceneModel = sceneModel
  }
  
  // MARK: The Train Page
  public func setup(wagonsCount: WagonsCount, speed: Float, time: TimeInterval) {
    let sceneModel = TheTrainModel()
    sceneModel.shouldFinish = finishAssessment
    scnView.scene = sceneModel.scene
    sceneModel.setup(wagonsCount: wagonsCount, speed: speed, time: time)
    scnView.prepare(sceneModel.scene.rootNode.childNodes, completionHandler: { success in
      sceneModel.setup()
    })
    self.sceneModel = sceneModel
  }
  
  public override func loadView() {
    self.view = scnView
  }
  
  @objc
  func handleTap(_ gestureRecognize: UIGestureRecognizer) {
    // check what nodes are tapped
    let p = gestureRecognize.location(in: self.scnView)
    let hitResults = scnView.hitTest(p, options: [:])
    // check that we clicked on at least one object
    if hitResults.count > 0 {
      // retrieved the first clicked object
      let result = hitResults[0]
      
      // get its material
      let material = result.node.geometry!.firstMaterial!
      
      // highlight it
      SCNTransaction.begin()
      SCNTransaction.animationDuration = 0.5
      
      // on completion - unhighlight
      SCNTransaction.completionBlock = {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.5
        
        material.emission.contents = UIColor.black
        
        SCNTransaction.commit()
      }
      
      material.emission.contents = UIColor.red
      
      SCNTransaction.commit()
      
      guard let name = NodeName.init(rawValue: result.node.name!) else { return }
      
      result.node.isHidden = true
      switch name {
      case .W1:
        let w1 = self.sceneModel.scene.rootNode.childNode(withName: "\(name.rawValue) Green", recursively: true)!
        w1.isHidden = false
      case .W2:
        let w2 = self.sceneModel.scene.rootNode.childNode(withName: "\(name.rawValue) Yellow", recursively: true)!
        w2.isHidden = false
      case .D:
        let d = self.sceneModel.scene.rootNode.childNode(withName: "\(name.rawValue) Orange", recursively: true)!
        d.isHidden = false
      case .C:
        let c = self.sceneModel.scene.rootNode.childNode(withName: "\(name.rawValue) Red", recursively: true)!
        c.isHidden = false
      case .Apple:
        let apple = self.sceneModel.scene.rootNode.childNode(withName: "\(name.rawValue) Rainbow", recursively: true)!
        apple.isHidden = false
      case .Rocket:
        result.node.isHidden = false
        if let sceneModel = self.sceneModel as? TheMoonModel {
          sceneModel.rocket.physicsBody?.velocity.y = 10
          sceneModel.particles.birthRate = 800
          sceneModel.particles.particleSize = 10
        }
      case .Cheese:
        cheeseCount += 1
        
        if cheeseCount == 19 {
          finishAssessment?(true)
        }
        result.node.isHidden = true
      }
    }
  }
}

extension LiveViewController: SCNSceneRendererDelegate {
  public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    sceneModel.update()
  }
}
