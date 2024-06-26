import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button {
                         
                    } label: {
                        Image("music_enabled_button")
                    }
                    Spacer()
                    Button {
                         
                    } label: {
                        Image("sound_enabled_button")
                    }
                }
                .padding(.horizontal)
                Spacer()
                NavigationLink(destination: EmptyView()) {
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
