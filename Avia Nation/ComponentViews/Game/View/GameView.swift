import SwiftUI
import SpriteKit

struct GameView: View {
    
    @StateObject var observers: Observers = Observers()
    var gameViewModel: GameViewModel = GameViewModel(countOfCards: Int.random(in: 4...6))
    @State var gameScene: GameScene?
    
    var body: some View {
        ZStack {
            if let gameScene = gameScene {
                SpriteView(scene: gameScene)
                    .ignoresSafeArea()
            }
            
            if observers.gameRestartAction {
                Text("")
                    .onAppear {
                        gameScene = gameScene?.startNewGame()
                        withAnimation {
                            observers.showGame()
                        }
                    }
            }
            
            if observers.gameContinueValue {
                Text("")
                    .onAppear {
                        gameScene?.continueGame()
                        withAnimation {
                            observers.showGame()
                        }
                    }
            }
            if observers.loseActionValue {
                LoseNodeGameVIew()
            }
            if observers.winActionValue {
                WinNodeGameView()
            }
            if observers.pauseActionValue {
                PauseNodeGameView()
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
    @Published var gameRestartAction = false
    @Published var gameContinueValue = false
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(winAction), name: Notification.Name("ALL_MATCHED"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loseAction), name: Notification.Name("NOT_MATCHED"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pauseAction), name: Notification.Name("PAUSE_ACTION"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gameRestart), name: Notification.Name("GAME_RESTART"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gameContinue), name: Notification.Name("GAME_CONTINUE"), object: nil)
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
    
    @objc private func gameRestart() {
        gameRestartAction = true
    }
    
    @objc private func gameContinue() {
        gameContinueValue = true
    }
    
    func showGame() {
        winActionValue = false
        loseActionValue = false
        pauseActionValue = false
        gameRestartAction = false
        gameContinueValue = false
    }
    
}

#Preview {
    GameView()
}
