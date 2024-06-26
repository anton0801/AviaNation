import Foundation

class GameViewModel {
    
    var cards: [String] = []
    
    init(countOfCards: Int) {
        setOrderOfCards(countOfCards)
    }
    
    private func setOrderOfCards(_ countOfCards: Int) {
        let cards = (1...12).map { "progress_card_\($0)" }.shuffled()
        let takedCards = getFirstNItems(cards, countOfCards)
        self.cards = takedCards
    }
    
    func getFirstNItems(_ c: [String], _ n: Int) -> [String] {
        return Array(c.prefix(n))
    }
    
}
