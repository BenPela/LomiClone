//
//  LomiDeviceContent.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-02-01.
//

import SwiftUI
import AVKit

struct LomiDeviceContent: View {
    private let player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "serialNumberPosition", ofType: "mp4")!))
    private let videoAspectRatio: CGFloat = 1032/600
    
    @ObservedObject var viewModel: AddDeviceViewController
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            AVPlayerControllerRepresented(player: player)
                .frame(height: UIScreen.main.bounds.width/videoAspectRatio)
                .onAppear {
                    player.play()
                }
                .padding(.bottom)
            
            InputTextField(
                field: $viewModel.device.serialNumber,
                inputType: .deviceSerialNumber,
                prompt: viewModel.serialNumberPrompt,
                validIcon: "checkmark.circle"
            )
            .onChange(of: viewModel.device.serialNumber) { [oldSerialNum = viewModel.device.serialNumber] newSerialNum in
                viewModel.device.serialNumber = viewModel.isValidSerialNumInput(newSerialNum) ? newSerialNum : oldSerialNum
            }
            
            InputTextField(
                field: $viewModel.device.nickname,
                inputType: .deviceNickname,
                prompt: viewModel.nicknamePrompt,
                validIcon: "checkmark.circle"
            )
        }
    }
}


// MARK: - Helpers
extension LomiDeviceContent {
    /// Wrapper of AVPlayerVC for using as View
    struct AVPlayerControllerRepresented : UIViewControllerRepresentable {
        var player : AVPlayer

        func makeUIViewController(context: Context) -> AVPlayerViewController {
            let controller = AVPlayerViewController()
            controller.player = player
            controller.videoGravity = .resizeAspect
            controller.showsPlaybackControls = false
            controller.view.backgroundColor = UIColor(Color.primaryWhite)
            return controller
        }

        func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}

    }
}


// MARK: - Previews
struct LomiDeviceContent_Previews: PreviewProvider {
    static var previews: some View {
        LomiDeviceContent(viewModel: AddDeviceViewController(device: Device()))
    }
}
