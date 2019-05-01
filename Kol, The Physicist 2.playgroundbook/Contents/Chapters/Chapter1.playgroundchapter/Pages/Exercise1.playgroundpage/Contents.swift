//#-hidden-code
import PlaygroundSupport
import UIKit
import SceneKit

let numberOfWagons: WagonsCount
let averageSpeed: Float
let time: Double
//#-end-hidden-code
/*:
 **Goal:** Help the train cross the bridge in time.
 
 Kol is driving the train, which is about to cross the bridge, but this bridge is about to fall. Kol needs your help to make the best adjustments in the train average speed and how long it will take until the bridge falls.
 
 But first, we need to learn what [**Average Speed**](glossary://AverageSpeed) is and how it relates to time.
 
 Now, you can help Kol.
 
 **Data:**
 
 The Steam Train has **10 meters**.
 
 ![Steam Train](SteamTrain.png)
 
 Each Wagon has **4 meters**.
 
 ![Wagon](Wagon.png)
 
 The Bridge has **46 meters**.
 
 ![Bridge](Bridge.png)
 
 
 */

// Set the number of wagons here.
numberOfWagons = /*#-editable-code*/.Six/*#-end-editable-code*/ // Max: .Six, Min: .Zero.

// Set the average speed here.
averageSpeed = /*#-editable-code*/20.0/*#-end-editable-code*/ // meters per second (m/s)

// Set the time that will take until the bridge falls.
time = /*#-editable-code*/3.0/*#-end-editable-code*/ // seconds (s)

//#-hidden-code

let page = PlaygroundPage.current

let controller = LiveViewController()

controller.finishAssessment = { status in
  if status {
    page.assessmentStatus = .pass(message: "### Great job! \n The train crossed the bridge just in time!\n\n\n[**Next Page**](@next)")
  } else {
    page.assessmentStatus = .fail(hints: ["The **train length** is the sum of the length of each wagon and the steam train length.", "The **distance traveled** is the sum of the train length and the bridge length.", "The **average speed** is the division of the distance traveled by the time interval."], solution: nil)
  }
}


controller.setup(wagonsCount: numberOfWagons, speed: averageSpeed, time: time)

page.liveView = controller

//#-end-hidden-code
