import SwiftUI

struct HomeView: View {
    
    @State var musicApp = UserDefaults.standard.bool(forKey: "musicApp") {
        didSet {
            UserDefaults.standard.set(musicApp, forKey: "musicApp")
        }
    }
    
    @State var soundApp = UserDefaults.standard.bool(forKey: "soundApp") {
        didSet {
            if soundApp {
                UserDefaults.standard.set(true, forKey: "soundApp")
            } else {
                UserDefaults.standard.set(false, forKey: "soundApp")
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button {
                        withAnimation(.linear(duration: 0.5)) {
                            musicApp = !musicApp
                        }
                    } label: {
                        if musicApp {
                            Image("music_enabled_button")
                        } else {
                            Image("music_inactive_button")
                        }
                    }
                    Spacer()
                    Button {
                        withAnimation(.linear(duration: 0.5)) {
                            soundApp = !soundApp
                        }
                    } label: {
                        if soundApp {
                            Image("sound_enabled_button")
                        } else {
                            Image("sound_inactive_button")
                        }
                    }
                }
                .padding(.horizontal)
                Spacer()
                NavigationLink(destination: GameView()
                    .navigationBarBackButtonHidden(true)) {
                    Image("game_button")
                }
                HStack {
                    NavigationLink(destination: ProgressCardsView()
                        .navigationBarBackButtonHidden(true)) {
                        Image("progress_button")
                    }
                    Spacer()
                    Button {
                        exit(0)
                    } label: {
                        Image("off_app_button")
                    }
                }
                .padding()
            }
            .background(
                Image("menu_back_image")
                    .resizable()
                    .frame(minWidth: UIScreen.main.bounds.width,
                           minHeight: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    HomeView()
}
