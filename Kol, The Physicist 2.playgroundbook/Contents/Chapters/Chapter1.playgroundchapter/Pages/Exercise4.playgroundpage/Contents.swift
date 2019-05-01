/*:
 **Goal:** Explore the Moon and collect all 19 cheeses.
 
**Commands:**
 
 **One Tap:** to select something.
 
 **Two Taps:** to go back to default camera.
 
 **Pan:** to zoom in and out the camera.
 
 **Swipe:** to rotate the camera.
 
 
 **Thank you!**
*/

//#-hidden-code
import UIKit
import PlaygroundSupport

let page = PlaygroundPage.current

let controller = LiveViewController()

controller.finishAssessment = { status in
  if status {
    page.assessmentStatus = .pass(message: "### Great job! \n You have collected all 19 cheeses!")
  }
}

controller.setup()

page.liveView = controller
//#-end-hidden-code
