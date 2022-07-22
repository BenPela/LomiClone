//
//  Mode.swift
//  Lomi
//
//  Created by Chris Worman on 2021-09-07.
//

import Foundation

enum DeviceMode {
    case grow, ecoExpress, lomiApproved
}
// A Lomi appliance mode
struct Mode {
    var id: DeviceMode
    var title: String
    var time: String // eg. 10+ hours
    var imageName: String
    var description: String
    var sections: [Section]
    
    struct Section: Hashable {
        var header: String
        var body: String
    }
}

extension Mode: Identifiable {}
extension Mode: Hashable {}

extension Mode {
    static let modes: [Mode] = [
        Mode(
            id: .grow,
            title: "Grow",
            time: "16-20",
            imageName: "growIcon",
            description: "Turn your waste into treasure! This mode produces nutrient-rich dirt for your garden or house plants in just one day.",
            sections: [
                Section(
                    header: "Why choose this mode",
                    body: "The Grow mode cycle runs longest and at a lower temperature to ensure the perfect heat, humidity & time conditions for microbial cultures to grow and thrive. The dirt at the end of this cycle is exactly what your plants crave!"
                ),
                Section(
                    header: "What can go in",
                    body: "Grow mode is for food scraps and plant waste. See our Do’s & Don’ts list for full details on what Lomi likes best. A diverse mix will give the best results! \n\nWe also recommend adding a LomiPod to fast track biodegradation and help create the most healthy output. Simply add a LomiPod on top of your food waste along with 50ml of water before you start the cycle."
                ),
                Section(
                    header: "What to do with the dirt",
                    body: "Rich in microbial cultures and nutrients like nitrogen, phosphorus and sodium, this dirt can be mixed with soil (1:10 ratio) in your garden or house plants. You can also toss it in your home compost or green bin."
                )
            ]
        ),
        Mode(
            id: .ecoExpress,
            title: "Eco-Express",
            time: "3-5",
            imageName: "ecoExpressIcon",
            description: "Sometimes you just want to get rid of your food waste quickly. This mode will turn your kitchen scraps to dirt in a flash!",
            sections: [
                Section(
                    header: "Why choose this mode",
                    body: "This is the best mode if you’re looking for fast results and low energy consumption."
                ),
                Section(
                    header: "What can go in",
                    body: "Eco-Express mode is for food scraps and plant waste. See our Do’s & Don’ts list for more details. And remember, add a variety of kitchen and plant scraps to get the best dirt!"
                ),
                Section(
                    header: "What to do with the dirt",
                    body: "Toss this dirt into your home compost or green bin."
                )
            ]
        ),
        Mode(
            id: .lomiApproved,
            title: "Lomi Approved",
            time: "5-8",
            imageName: "lomiApprovedIcon",
            description: "The first of its kind in home composting, this mode breaks down certified Lomi Approved bioplastics, compostable products & packaging.",
            sections: [
                Section(
                    header: "Why choose this mode",
                    body: "This mode is your solution for Lomi Approved non-food compostable waste. With smart sensors that control grinding, heat and moisture, this mode breaks down Lomi Approved bioplastics and compostable products much faster than a traditional compost. "
                ),
                Section(
                    header: "What can go in",
                    body: "Mix plenty of plant & food waste with your Lomi Approved materials – we recommend a maximum of 10% non-food waste in a cycle. And add a LomiPod with 50ml of water to create the best conditions to break down these materials! \n\nLomi Approved products and packaging meet extensive compost certification requirements and are proven to disintegrate in Lomi. For more information go to pela.earth/lomi-approved"
                ),
                Section(
                    header: "What to do with the dirt",
                    body: "This dirt is still undergoing active decomposition and may still contain small pieces of bioplastic waste. Throw this dirt in your green bin."
                )
            ]
        )
    ]
}
