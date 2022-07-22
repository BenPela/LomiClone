//
//  ControlEntry.swift
//  Lomi
//
//  Created by Chris Worman on 2021-09-07.
//

import Foundation

// An entry in the Lomi "Controls", which provides a quick overview of button usage of Lomi.
struct ControlState: Identifiable {
    var id: String
    var title: String
    var imageName: String
    var description: String
}

extension ControlState {
    static let controls: [ControlState] = [
        ControlState(
            id: "on-standby",
            title: "On/Standby",
            imageName: "onStandby",
            description: "When plugged in Lomi will beep and all lights will flash green. When in standby, lights will turn off. Lomi’s ready to start a cycle when you are!"
        ),
        ControlState(
            id: "select-mode",
            title: "Select mode",
            imageName: "selectMode",
            description: "Lomi is set to Eco-Express when you turn it on. To select Grow or Lomi Approved, press & hold the button for 3 seconds, until the green light shifts to the mode you want."
        ),
        ControlState(
            id: "start",
            title: "Start",
            imageName: "start",
            description: "When Lomi is in the mode you want, simply press the button to start your cycle."
        ),
        ControlState(
            id: "pause-restart",
            title: "Pause/Resume",
            imageName: "pauseRestart",
            description: "Press the button if you need to pause Lomi during a cycle. The cycle will resume when you press the button again. If you open the lid when Lomi is paused, pressing the button again will restart the cycle."
        ),
        ControlState(
            id: "reset",
            title: "Reset",
            imageName: "reset",
            description: "Hold the button down for 10 seconds, until all lights flash green and Lomi beeps. Lomi’s ready to run a cycle."
        ),
        ControlState(
            id: "cycle-status",
            title: "Cycle status",
            imageName: "cycleStatus",
            description: "Lomi shows you where it’s at in the cycle by illuminating the phases that are in progress or complete."
        ),
        ControlState(
            id: "cycle-complete",
            title: "Cycle complete",
            imageName: "cycleComplete",
            description: "When the button and all cycle lights are illuminated green, the cycle is complete. After 30 minutes, Lomi will go into standby mode and all lights will turn off."
        )
    ]
    
    static let troubleshooting: [ControlState] = [
        ControlState(
            id: "lid-open",
            title: "Lid open during cycle",
            imageName: "lidOpen",
            description: "Cycle will pause. All lights will flash red and Lomi beeps. When you secure the lid back in place, press the button to resume the cycle."
        ),
        ControlState(
            id: "heating-issue",
            title: "Heating issue",
            imageName: "heatingIssue",
            description: "Cycle will pause. Selected mode will remain illuminated. Drying light will flash red, followed by 3 beeps."
        ),
        ControlState(
            id: "grinder-jam",
            title: "Grinder jam",
            imageName: "grinderJam",
            description: "Grinder will reverse 3-4 times. If not fixed, cycle will pause. Selected mode will remain illuminated. Drying light will flash red, followed by 3 beeps."
        ),
        ControlState(
            id: "ventilation-issue",
            title: "Ventilation issue",
            imageName: "ventilationIssue",
            description: "Cycle will pause. Selected mode will remain illuminated. Cooling light will flash red, followed by 3 beeps."
        ),
        ControlState(
            id: "change-filter",
            title: "Change filter",
            imageName: "changeFilter",
            description: "Filter light is on. Refill the top and back filters with new activated charcoal. If the filter light remains on, press the main button for 10 seconds to reset."
        )
    ]
}
