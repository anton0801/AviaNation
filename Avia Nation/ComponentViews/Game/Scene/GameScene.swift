import Foundation
import SwiftUI
import SpriteKit

class GameScene: SKScene {
    
    private var gameViewModel: GameViewModel
    
    private var gameBackground: SKSpriteNode = SKSpriteNode()
    
    private var levelLabel = SKLabelNode(text: "SET ALL")
    
    private var timeLabel = SKLabelNode(text: "00:15")
    
    var cardNodes: [SKSpriteNode] = []
    
    private var pauseButton: SKSpriteNode = SKSpriteNode(imageNamed: "pause_button")
    
    private var errors = 0 {
        didSet {
            setUpErrors()
        }
    }
    private var errorNodes: [SKNode] = []
    private var orderLabels: [SKNode] = []
    private var orderOfCards: [String] = []
    
    private var cardsSorted = false
    
    init(gameViewModel: GameViewModel) {
        self.gameViewModel = gameViewModel
        super.init(size: CGSize(width: 750, height: 1335))
        self.setLabelBaseData(levelLabel)
        self.setLabelBaseData(timeLabel, size: 62)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        createBackImage()
        setUpGameLabel()
        createTimeLabel()
        createGameContent()
        setUpErrors()
    }
    
    private func setUpErrors() {
        for errorNode in errorNodes {
            errorNode.removeFromParent()
        }
        errorNodes = []
        
        for i in 1...3 {
            var node: SKSpriteNode
            if i <= errors {
                node = .init(imageNamed: "error_active")
            } else {
                node = .init(imageNamed: "error_inactive")
            }
            node.size = CGSize(width: 100, height: 95)
            let startXPoint = CGFloat(i) * (node.size.width + 35) + pauseButton.size.width + 35
            node.position = CGPoint(x: startXPoint, y: 80)
            addChild(node)
            let action = SKAction.fadeIn(withDuration: 0.5)
            node.run(action)
        }
    }
    
    private func createGameContent() {
        let gameContentBackBlack = SKSpriteNode(color: .black.withAlphaComponent(0.5), size: CGSize(width: size.width, height: 500))
        gameContentBackBlack.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(gameContentBackBlack)
        
        cardNodes = gameViewModel.cards.map { createCardNode(for: $0) }
        positionCardNodes()
        showNeededOrder()
        createPauseButton()
    }
    
    private func createPauseButton() {
        pauseButton.size = CGSize(width: 130, height: 120)
        pauseButton.position = CGPoint(x: 120, y: 80)
        pauseButton.name = "pause_button"
        addChild(pauseButton)
    }
    
    private var cardOrderLabels: [SKLabelNode] = []
    
    private func showNeededOrder() {
        for (index, card) in cardNodes.enumerated() {
            let cardPosition = card.position
            let cardNeedorderLabel: SKLabelNode = .init(text: "\(index + 1)")
            setLabelBaseData(cardNeedorderLabel, size: 72)
            cardNeedorderLabel.fontColor = .red
            cardNeedorderLabel.position = cardPosition
            cardNeedorderLabel.position.y -= 18
            addChild(cardNeedorderLabel)
            cardOrderLabels.append(cardNeedorderLabel)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            for label in self.cardOrderLabels {
                label.removeFromParent()
            }
            self.confuseCards()
        }
    }
    
    private func confuseCards() {
        var pointsOfCards = cardNodes.map { $0.position }
        for card in cardNodes {
            let actionMoveToCenterPoint = SKAction.move(to: CGPoint(x: size.width / 2, y: size.height / 2), duration: 0.5)
            card.run(actionMoveToCenterPoint)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            for card in self.cardNodes {
                let cardPosition = pointsOfCards.randomElement() ?? pointsOfCards[0]
                let actionMoveToCenterPoint = SKAction.move(to: cardPosition, duration: 0.5)
                card.run(actionMoveToCenterPoint)
                if let pointIndex = pointsOfCards.firstIndex(of: cardPosition) {
                    pointsOfCards.remove(at: pointIndex)
                }
            }
            self.cardsSorted = true
        }
    }
    
    private func createCardNode(for card: String) -> SKSpriteNode {
        let cardTexture = SKTexture(imageNamed: card)
        let cardNode = SKSpriteNode(texture: cardTexture)
        cardNode.name = card
        cardNode.size = CGSize(width: 100, height: 92)
        return cardNode
    }
    
    private func positionCardNodes() {
        let totalCards = cardNodes.count
        let half = (totalCards + 1) / 2 // First half goes to the top row, second half to the bottom row
        let maxColumns = half // Max columns per row will be half the total cards, rounded up
        
        let cardWidth: CGFloat = 100 // Example card width, adjust as needed
        let cardHeight: CGFloat = 92 // Example card height, adjust as needed
        let spacing: CGFloat = 12 // Space between cards
        
        // Calculate the total width and height needed
        let totalWidth = CGFloat(maxColumns) * (cardWidth + spacing) - spacing
        let totalHeight = CGFloat(2) * (cardHeight + spacing) - spacing // Two rows of cards
        
        // Start positions to center the grid
        let startX = (size.width - totalWidth) / 2 + cardWidth / 2
        let startYTop = (size.height + cardHeight + spacing) / 2
        let startYBottom = startYTop - (cardHeight + spacing)
        
        for (index, cardNode) in cardNodes.enumerated() {
            let row = index < half ? 0 : 1
            let column = index % half
            
            let xPosition = startX + CGFloat(column) * (cardWidth + spacing)
            let yPosition = row == 0 ? startYTop : startYBottom
            
            cardNode.position = CGPoint(x: xPosition, y: yPosition)
            addChild(cardNode)
        }
    }
    
    private func createBackImage() {
        let backImage: SKSpriteNode = .init(imageNamed: "game_back_image")
        backImage.size = size
        backImage.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(backImage)
    }
    
    private func setUpGameLabel() {
        let levelLabelBackground = SKSpriteNode(imageNamed: "level_label_back_image")
        levelLabelBackground.position = CGPoint(x: size.width / 2, y: size.height - 137)
        levelLabel.position = CGPoint(x: size.width / 2, y: size.height - 150)
        addChild(levelLabelBackground)
        addChild(levelLabel)
    }
    
    private func createTimeLabel() {
        timeLabel.position = CGPoint(x: size.width / 2, y: size.height - 240)
        addChild(timeLabel)
    }
    
    private func setLabelBaseData(_ l: SKLabelNode, size: CGFloat = 42) {
        l.fontName = "Lalezar-Regular"
        l.fontSize = size
        l.fontColor = .white
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let node = atPoint(location)
            if cardsSorted {
                if node.name?.contains("progress_card") == true {
                    orderOfCards.append(node.name!)
                    addOrderLabel(node)
                    if orderOfCards.count == gameViewModel.cards.count {
                        checkGameWin()
                    }
                }
            }
            
            if node.name == "pause_button" {
                pauseAction()
                return
            }
        }
    }
    
    private func checkGameWin() {
        var gameWin = true
        for (index, orderOfCard) in orderOfCards.enumerated() {
            if gameViewModel.cards[index] != orderOfCard {
                gameWin = false
                break
            }
        }
        if gameWin {
            winAction()
        } else {
            errors += 1
            for n in orderLabels {
                n.removeFromParent()
            }
            orderLabels = []
            orderOfCards = []
        }
    }
    
    private func addOrderLabel(_ node: SKNode) {
        let cardPosition = node.position
        let cardOrderLabel: SKLabelNode = .init(text: "\(orderOfCards.count)")
        setLabelBaseData(cardOrderLabel, size: 72)
        cardOrderLabel.fontColor = .green
        cardOrderLabel.position = cardPosition
        cardOrderLabel.position.y -= 18
        addChild(cardOrderLabel)
        orderLabels.append(cardOrderLabel)
    }
    
    private func loseAction() {
        NotificationCenter.default.post(name: Notification.Name("NOT_MATCHED"), object: nil)
    }
    
    private func winAction() {
        NotificationCenter.default.post(name: Notification.Name("ALL_MATCHED"), object: nil)
    }
    
    private func pauseAction() {
        isPaused = true
        NotificationCenter.default.post(name: Notification.Name("PAUSE_ACTION"), object: nil)
    }
    
    func continueGame() {
        isPaused = false
    }
    
    func startNewGame() -> GameScene {
        let newScene = GameScene(gameViewModel: gameViewModel)
        view?.presentScene(newScene)
        return newScene
    }
    
}

#Preview {
    VStack {
        SpriteView(scene: GameScene(gameViewModel: GameViewModel(countOfCards: 4)))
            .ignoresSafeArea()
    }
}
