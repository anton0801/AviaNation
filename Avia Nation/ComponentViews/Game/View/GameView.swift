import SwiftUI
import SpriteKit

struct GameView: View {
    
    @StateObject var observers: Observers = Observers()
    var gameViewModel: GameViewModel = GameViewModel(countOfCards: Int.random(in: 4...6))
    @State var gameScene: GameScene?
    
    var body: some View {
        VStack {
            if let gameScene = gameScene {
                SpriteView(scene: gameScene)
                    .ignoresSafeArea()
            }
        }.onAppear {
            gameScene = GameScene(gameViewModel: gameViewModel)
        }
    }
    
}

class Observers: ObservableObject {
    
    @Published var winActionValue = false
    @Published var loseActionValue = false
    @Published var pauseActionValue = false
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(winAction), name: Notification.Name("ALL_MATCHED"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loseAction), name: Notification.Name("NOT_MATCHED"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pauseAction), name: Notification.Name("PAUSE_ACTION"), object: nil)
    }
    
    @objc private func winAction() {
        winActionValue = true
    }
    
    @objc private func loseAction() {
        loseActionValue = true
    }
    
    @objc private func pauseAction() {
        pauseActionValue = true
    }
    
}

#Preview {
    GameView()
}
