//#-hidden-code
import PlaygroundSupport

let curveRadius: CurveRadius
let speed: Float
//#-end-hidden-code
/*:
 **Goal:** Help Kol keep his car on the road while he makes a turn.
 
 Kol is driving the car, which is about to make a turn. Kol needs your help to make the best adjustments in the car speed, so he doesn't get off the curve.
 
 But first, we need to learn with what [**Unbanked Curve**](glossary://UnbankedCurve) is and how to determine the [**Max Speed**](glossary://MaxSpeed).
 
 Now, you can help Kol.
 
 **Curve Radius:**
 
 ![Curve](Curve.png)
 
 */

// Set the curve radius in meters.
curveRadius = /*#-editable-code*/.Forty/*#-end-editable-code*/ //(m), Max:.OneHundredSixty, Min: .Twenty.

// Set the maximum speed in meters per second.
speed = /*#-editable-code*/20.0/*#-end-editable-code*/ //(m/s)

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


controller.setup(curveRadius: curveRadius, speed: speed)

page.liveView = controller
//#-end-hidden-code
