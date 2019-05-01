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

// Set the combustion rate of the rocket in kilograms per second.
combustionRate = /*#-editable-code*/2.5/*#-end-editable-code*/ // (kg/s)

// Set the relative speed with the value which the rocket expels combustion gases in meters per second.
speed = /*#-editable-code*/2000/*#-end-editable-code*/ // (m/s)


//#-hidden-code
let page = PlaygroundPage.current

let controller = LiveViewController()

controller.finishAssessment = { status in
  if status {
    page.assessmentStatus = .pass(message: "### Great job! \n Kol was able to launch the rocket to the moon!\n\n\n[**Next Page**](@next)")
  } else {
    page.assessmentStatus = .fail(hints: ["![Formula3](Formula3.png)\n**B** is the thrust; **W** is the weight of the rocket, including fuel; and **a** is the acceleration of the rocket at the moment it has mass **m**.", "![Formula4](Formula4.png) \n**B** is the thrust; **T** is the combustion rate; and **V** is the relative speed.", "![Formula5](Formula5.png)\n**B** is the thrust; and **a** is the acceleration of the rocket at the moment it has mass **m**."], solution: "A possible solution is mass = **710 (kg)**, combustionRate = **2.5 (kg/s)** and speed = **3000 (m/s)**")
  }
}

controller.setup(mass: mass, combustionRate: combustionRate, speed: speed)

page.liveView = controller
//#-end-hidden-code

