import Foundation

class ProgressViewModel: ObservableObject {
    @Published private(set) var cards: [ProgressItem]
    @Published var currentCard: ProgressItem?
    
    private let userDefaultsKey = "savedCards"
    
    var currentIndex: Int = 0 {
        didSet {
            currentCard = cards[currentIndex]
        }
    }
    
    init(numberOfCards: Int) {
        self.cards = (1...numberOfCards).map { ProgressItem(id: "progress_card_\($0)", isOpened: false) }

        // Load saved cards from UserDefaults if available
        if let savedCards = loadCards() {
            self.cards = savedCards
        }
        // Set the current card to the first card
        self.currentCard = cards.first
    }
    
    func openRandomCard() {
       let unopenedCards = cards.filter { !$0.isOpened }
       
       guard let randomCard = unopenedCards.randomElement(),
             let index = cards.firstIndex(where: { $0.id == randomCard.id }) else {
           return
       }
       
       cards[index].isOpened = true
       saveCards()
       sortCards()
       if let newIndex = cards.firstIndex(where: { $0.id == randomCard.id }) {
           currentIndex = newIndex
       }
   }
   
   // Method to check if a card is opened
   func isCardOpened(withId id: String) -> Bool {
       return cards.first(where: { $0.id == id })?.isOpened ?? false
   }
   
   // Method to navigate to the next card
   func nextCard() {
       if currentIndex < cards.count - 1 {
           currentIndex += 1
       }
   }
   
   // Method to navigate to the previous card
   func previousCard() {
       if currentIndex > 0 {
           currentIndex -= 1
       }
   }
   
   // Method to update the current card
   private func updateCurrentCard() {
       currentCard = cards[currentIndex]
   }
   
   // Method to sort cards with opened ones first
   private func sortCards() {
       cards.sort { $0.isOpened && !$1.isOpened }
   }
   
   // Method to get the first N items from the sorted cards array
   func getFirstNItems(_ n: Int) -> [ProgressItem] {
       return Array(cards.prefix(n))
   }
   
   // Method to save cards state to UserDefaults
   private func saveCards() {
       do {
        let encoded = try JSONEncoder().encode(cards)
        UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
       } catch {
       }
   }
   
   // Method to load cards state from UserDefaults
    private func loadCards() -> [ProgressItem]? {
        guard let savedData = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            return nil
        }
        
        do {
            let savedCards = try JSONDecoder().decode([ProgressItem].self, from: savedData)
            return savedCards
        } catch {
            print("Failed to load cards: \(error)")
            return nil
        }
    }

}
