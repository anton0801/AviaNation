import SwiftUI

struct ProgressCardsView: View {
    
    @Environment(\.presentationMode) var backMode
    @StateObject private var viewModel: ProgressViewModel = ProgressViewModel(numberOfCards: 12)
    
    var body: some View {
        VStack {
            Text("PROGRESS")
                .font(.custom("Lalezar-Regular", size: 52))
                .foregroundColor(.white)
            
            Spacer()
            
            if let currentCard = viewModel.currentCard {
                if currentCard.isOpened {
                    Image(currentCard.id)
                        .resizable()
                        .frame(width: 240, height: 240)
                } else {
                    Image("progress_card_closed")
                        .resizable()
                        .frame(width: 240, height: 240)
                }
            }
            
            Spacer()
            
            HStack {
                Button {
                    withAnimation {
                        viewModel.previousCard()
                    }
                } label: {
                    Image("left_button")
                        .opacity(viewModel.currentIndex == 0 ? 0.7 : 1)
                }
                .disabled(viewModel.currentIndex == 0 ? true : false)
                Button {
                    withAnimation {
                        viewModel.nextCard()
                    }
                } label: {
                    Image("right_button")
                        .opacity(viewModel.currentIndex == viewModel.cards.count - 1 ? 0.7 : 1)
                }
                .disabled(viewModel.currentIndex == viewModel.cards.count - 1 ? true : false)
            }
            Button {
                backMode.wrappedValue.dismiss()
            } label: {
                Image("home_button")
            }
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
    ProgressCardsView()
}
