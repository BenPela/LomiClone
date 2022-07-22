//
//  OnboardingVideoScreen.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-02-04.
//

import SwiftUI
import AVKit

struct OnboardingVideoScreen: View {
    private let player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "onboarding", ofType: "mp4")!))
    private let playerDidFinishNotification = NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)
    @EnvironmentObject var environment: AppEnvironment
    @State private var didPlayEnd: Bool = false
    @State private var isPlaying: Bool = true
    @State private var isMuted: Bool = true
    @State private var isLoading: Bool = false
    var onComplete: () -> Void
    var body: some View {
            ZStack{
                AVPlayerControllerRepresented(player: player)
                    .ignoresSafeArea()
                    .onReceive(playerDidFinishNotification, perform: { _ in
                        withAnimation {
                            didPlayEnd = true
                            isPlaying = false
                        }
                    })
                    .onChange(of: isPlaying, perform: { newValue in
                        newValue ? player.play() : player.pause()
                    })
                    .onTapGesture {
                        if didPlayEnd {
                            player.seek(to: .zero)
                            didPlayEnd.toggle()
                            isPlaying.toggle()
                        } else {
                            withAnimation(.easeInOut(duration: 0.24)) {
                                isPlaying.toggle()
                            }
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            player.play()
                        }
                        player.isMuted = true
                        AnalyticsLogger.singleton.logEvent(
                            .screenView,
                            parameters: [.screenName: AnalyticsScreenName.onboardingVideo]
                        )
                    }

                controlButton
                    .opacity(isPlaying ? 0:0.8)

                VStack {
                    Spacer()
                    completeButton
                        .opacity(didPlayEnd ? 1:0)
                    
                    HStack {
                        nextButton
                        Spacer()
                        soundButton
                            .onTapGesture {
                                withAnimation {
                                    isMuted.toggle()
                                }
                            }
                            .onChange(of: isMuted) { newValue in
                                player.isMuted = newValue
                            }
                    }
                }
                
                ProgressModal(showing: isLoading)
            }
    }
}


// MARK: - Subviews
extension OnboardingVideoScreen {
    var controlButton: some View {
        Image(systemName: didPlayEnd ? "arrow.counterclockwise.circle" : "play.circle")
            .font(.system(size: 80).weight(.thin))
            .foregroundColor(.inputFieldsOffWhite)
            .allowsHitTesting(false)
    }

    var soundButton: some View {
        ZStack(alignment: .leading) {
            muteButton
                .opacity(isMuted ? 1 : 0)
            unmuteButton
                .opacity(!isMuted ? 1 : 0)
        }
            .font(.title2)
            .foregroundColor(Color.primaryIndigoGreen)
            .padding()
            .contentShape(Rectangle())
            .zIndex(999)
    }
    
    var unmuteButton: some View {
        Image(systemName: "speaker.wave.2")
    }
    
    var muteButton: some View {
        HStack(alignment: .center, spacing: -4) {
            Image(systemName: "speaker")
            Image(systemName: "multiply")
                .font(.caption2.weight(.bold))
        }
    }

    var completeButton: some View {
        ButtonConfirm(text: "Let’s make dirt!", color: .primaryIndigoGreen, action: {
            AnalyticsLogger.singleton.logEvent(.onboardingVideoComplete)
            postOnboardingComplete()
        })
            .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
            .padding(.horizontal, 40)
            .padding(.bottom)
    }

    var nextButton: some View {
        Button(action: {
            if (didPlayEnd) {
                AnalyticsLogger.singleton.logEvent(.onboardingVideoComplete)
            } else {
                AnalyticsLogger.singleton.logEvent(.onboardingVideoSkip)
            }
            postOnboardingComplete()
        }) {
            HStack(alignment: .center, spacing: 2) {
                Text("Next")
                    .fontWeight(.medium)
                Image(systemName: "chevron.right.2")
                    .font(.footnote.weight(.medium))
            }
        }
        .foregroundColor(Color.primaryIndigoGreen)
        .padding()
    }
}

// MARK: - Logics
extension OnboardingVideoScreen {
    private func postOnboardingComplete() {
        isLoading = true
        player.pause()
        let onboardingComplete = Metadata(key: LomiApiAuth.onboardingCompleteKey, value: "true")
        if let auth = try? environment.getLomiApiAuth() {
            environment.lomiApi.updateUserMetadata(
                authToken: auth.authToken,
                request: UpdateUserMetadataRequest(
                    _id: auth.user.id,
                    metadata: [onboardingComplete]
                ),
                onSuccess: { _ in
                    onComplete()
                    isLoading = false
                },
                onError: {
                    (apiError: LomiApiErrorResponse) -> Void in
                    environment.handleApiErrorResponse(apiError: apiError)
                    isLoading = false
                }
            )
        } else {
            environment.handleError(error: "AuthError.NoAuth".localized())
            isLoading = false
        }
    }
}


// MARK: - Helpers
extension OnboardingVideoScreen {
    /// Wrapper of AVPlayerVC for using as View
    struct AVPlayerControllerRepresented : UIViewControllerRepresentable {
        var player : AVPlayer

        func makeUIViewController(context: Context) -> AVPlayerViewController {
            //Allow sound if it is unmuted and regardless of silent mode.
            try? AVAudioSession.sharedInstance().setCategory(.playback)
            let controller = AVPlayerViewController()
            controller.player = player
            controller.videoGravity = .resizeAspectFill
            controller.showsPlaybackControls = false
            controller.view.backgroundColor = UIColor(Color.primaryWhite)
            return controller
        }

        func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
    }
}


// MARK: - Previews
struct OnboardingVideoScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingVideoScreen(onComplete: {})
            
    }
}
