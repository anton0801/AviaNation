import SwiftUI

struct PauseNodeGameView: View {

   @Environment(\.presentationMode) var backMode
   
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
        VStack {
            Text("PAUSE")
                 .font(.custom("Lalezar-Regular", size: 52))
                 .foregroundColor(.white)
            
            Spacer()
            
            Text("GAME PAUSED")
                 .font(.custom("Lalezar-Regular", size: 32))
                 .foregroundColor(.white)
            
            Spacer()
            
            HStack {
                Button {
                    backMode.wrappedValue.dismiss()
                } label: {
                    Image("home_button")
                        .resizable()
                        .frame(width: 100, height: 100)
                }
                Button {
                    NotificationCenter.default.post(name: Notification.Name("GAME_CONTINUE"), object: nil)
                } label: {
                    Image("game_button")
                        .resizable()
                        .frame(width: 100, height: 100)
                }
                Button {
                    NotificationCenter.default.post(name: Notification.Name("GAME_RESTART"), object: nil)
                } label: {
                    Image("restart_button")
                        .resizable()
                        .frame(width: 100, height: 100)
                }
            }
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
           .padding(.vertical)
            
            Spacer()
        }
        .background(
            Image("progress_back_image")
                .resizable()
                .frame(minWidth: UIScreen.main.bounds.width,
                       minHeight: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    PauseNodeGameView()
}
