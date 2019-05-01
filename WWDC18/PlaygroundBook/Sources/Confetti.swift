//
//  Confetti.swift
//  WWDC19
//
//  Created by Brendoon Ryos on 24/03/19.
//  Copyright © 2018 Brendoon Ryos. All rights reserved.
//

import SceneKit

public class Confetti: SCNParticleSystem {
    
    init(colliderNodes: [SCNNode]?) {
        super.init()
        self.emitterShape = SCNBox(width: 500, height: 500, length: 500, chamferRadius: 0)
        self.birthRate = 100
        self.particleLifeSpan = 80
        self.particleLifeSpanVariation = 0
        self.spreadingAngle = 20
        self.particleSize = 10
        self.particleVelocity = 5
        self.particleVelocityVariation = 2
        self.birthDirection = .constant
        self.emittingDirection = SCNVector3Make(0, -1, 0)
        self.birthLocation = .volume
        self.particleImage = UIImage(named: "confetti")
        self.orientationMode = .free
        self.sortingMode = .distance
        self.particleAngleVariation = 180
        self.particleAngularVelocity = 200
        self.particleAngularVelocityVariation = 400
        self.particleColor = .green
        self.particleColorVariation = SCNVector4Make(0.2, 0.1, 0.1, 0)
        self.particleBounce = 0
        self.particleFriction = 0.6
        self.colliderNodes = colliderNodes
        self.blendMode = .alpha
        
        let floatAnimation = CAKeyframeAnimation(keyPath: nil)
        floatAnimation.values = [1, 1, 0]
        floatAnimation.keyTimes = [0, 0.9, 1]
        floatAnimation.duration = 1.0
        floatAnimation.isAdditive = false
        
        self.propertyControllers = [.opacity: SCNParticlePropertyController(animation: floatAnimation)]
        self.birthHandle()
        self.collisionHandle()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func birthHandle() {
        self.handle(.birth, forProperties: [.color]) { (data, dataStride, indices, count) in
            for i in 0..<count {
                let colorsPointer: UnsafeMutableRawPointer = data[0] + dataStride[0] * i
                let rgbaBuffer = colorsPointer.bindMemory(to: Float.self, capacity: dataStride[0])
                if(arc4random_uniform(2) == 1) {
                    rgbaBuffer[0] = rgbaBuffer[1]
                    rgbaBuffer[1] = 0
                }
            }
        }
    }
    
    private func collisionHandle() {
        self.handle(.collision, forProperties: [.angle, .rotationAxis, .angularVelocity, .velocity, .contactNormal]) { (data, dataStride, indices, count) in
            for i in 0..<count {
                // fix orientation
                let angle: UnsafeMutableRawPointer = data[0] + dataStride[0] * Int(indices![i])
                let angleBuffer = angle.bindMemory(to: Float.self, capacity: dataStride[0])
                let axis: UnsafeMutableRawPointer = data[1] + dataStride[1] * Int(indices![i])
                let axisBuffer = axis.bindMemory(to: Float.self, capacity: dataStride[1])
                
                let colNrm: UnsafeMutableRawPointer = data[4] + dataStride[4] * Int(indices![i])
                let colNrmBuffer = colNrm.bindMemory(to: Float.self, capacity: dataStride[4])
                let collisionNormal = SCNVector3(colNrmBuffer[0], colNrmBuffer[1], colNrmBuffer[2])
                let cp = self.SCNVector3CrossProduct(a: collisionNormal, b: SCNVector3Make(0, 0, 1))
                let cpLen: Float = self.SCNVector3Length(a: cp)
                angleBuffer[0] = asin(cpLen)
                
                axisBuffer[0] = cp.x / cpLen
                axisBuffer[1] = cp.y / cpLen
                axisBuffer[2] = cp.z / cpLen
                
                // kill angular rotation
                let angVel: UnsafeMutableRawPointer = data[2] + dataStride[2] * Int(indices![i])
                let angVelBuffer = angVel.bindMemory(to: Float.self, capacity: dataStride[2])
                angVelBuffer[0] = 0
                
                if colNrmBuffer[1] > 0.4 {
                    let vel: UnsafeMutableRawPointer = data[3] + dataStride[3] * Int(indices![i])
                    let velBuffer = vel.bindMemory(to: Float.self, capacity: dataStride[3])
                    velBuffer[0] = 0
                    velBuffer[1] = 0
                    velBuffer[2] = 0
                }
                
            }
        }
    }
    
    private func SCNVector3CrossProduct(a: SCNVector3, b: SCNVector3) -> SCNVector3 {
        var out = SCNVector3()
        out.x = a.y*b.z - a.z*b.y
        out.y = a.z*b.x - a.x*b.z
        out.z = a.x*b.y - a.y*b.x
        
        return out
    }
    
    private func SCNVector3Length(a: SCNVector3) -> Float {
        return Float(sqrt(a.x * a.x + a.y * a.y + a.z * a.z))
    }

}
