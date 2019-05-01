//#-hidden-code
import PlaygroundSupport

var mass: Float
var combustionRate: Float
var speed: Float
//#-end-hidden-code
/*:
 **Goal:** Help Kol launch the rocket to the moon.
 
 Kol wants to go to the moon, for that he needs your help to launch his rocket.
 
 But first we need to learn the basics of **Rocket Dynamics** to perform a rocket launch. It is related to [**Newton's Second Law**](glossary://SecondLaw) and [**Momentum Conservation Principle**](glossary://MomentumConservationPrinciple).
 
  Now, you can help Kol.
 
 ![RocketSchema](RocketSchema.png)
 
 */
// Set the mass of the rocket in kilograms.
mass = /*#-editable-code*/710/*#-end-editable-code*/ // (kg)

// Set the comnustion rate of the rocket in kilograms per second.
combustionRate = /*#-editable-code*/2.5/*#-end-editable-code*/ // (kg/s)

// Set the relative speed with the value which the rocket expels combustion gases in meters per second.
speed = /*#-editable-code*/2000/*#-end-editable-code*/ // (m/s)


//#-hidden-code
let page = PlaygroundPage.current

let controller = LiveViewController()

controller.finishAssessment = { status in
  if status {
    page.assessmentStatus = .pass(message: "### Great job! \n Kol was able to keep his car on the road!\n\n\n[**Next Page**](@next)")
  } else {
    page.assessmentStatus = .fail(hints: ["![Formula2](Formula2.png)\nμs = **0.7**, g = **10 (m/sˆ2)**, r = **Curve Radius**.", "If the curve radius is equal to **20 meters**, the speed must be equal or less than **12 (m/s)**."], solution: nil)
  }
}

controller.setup(mass: mass, combustionRate: combustionRate, speed: speed)

page.liveView = controller
//#-end-hidden-code

