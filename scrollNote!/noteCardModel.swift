//
//  noteCardModel.swift
//  scrollNote!
//
//  Created by 沈钰婷 on 2021/12/27.
//

import SwiftUI

class noteCardModel: ObservableObject{
    @Published var upRollCards: Array<Card>
    @Published var downRollCards: Array<Card>
    var numOfPairs: Int
    var selectedCard: Card = Card(isFaceUp: true, isMatched: false, content: "", id: -1, correspondingID: -1)
    
    struct Card: Identifiable {
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        var content: String
        var id: Int
        var correspondingID: Int
        var hasChooseAnimation: Bool = false
    }
    
    init() {
        upRollCards = Array<Card>()
        downRollCards = Array<Card>()
        let emojiArray: Array<String> = ["🐽","🐷","🐰","🦊"].shuffled()
        numOfPairs = emojiArray.count
        for pairIndex in (0..<numOfPairs) {
            let cardContent = emojiArray[pairIndex]
            upRollCards.append(Card(content: cardContent, id: pairIndex * 2, correspondingID: pairIndex * 2 + 1))
            downRollCards.append(Card(content: cardContent, id: pairIndex * 2 + 1, correspondingID: pairIndex * 2))
        }
        upRollCards.shuffle()
        downRollCards.shuffle()
    }
    
    
    //MARK: FUNCTIONS
    func choose(card: noteCardModel.Card) {
        // matching
        if !(selectedCard.isMatched || card.isMatched) {
            if (selectedCard.id == -1 || selectedCard.content == "" || selectedCard.correspondingID == -1) {
                selectedCard = card
                chooseAnimation(card: selectedCard)
                print("\(selectedCard)")
                //MARK: animation starts
            } else {
                if (selectedCard.correspondingID != card.id) {
                    chooseAnimationCancel(card: selectedCard)
                    //MARK: animation ends
                    selectedCard.id = -1
                    selectedCard.correspondingID = -1
                    selectedCard.content = ""
                } else {
                    print("A MATCH!")
                    chooseAnimationCancel(card: selectedCard)
                    chooseAnimationCancel(card: card)
                    flipCard(card: card)
                    flipCard(card: selectedCard)
                    //MARK: animation ends
                    setMatched(card1: card, card2: selectedCard)
                    selectedCard.id = -1
                    selectedCard.correspondingID = -1
                    selectedCard.content = ""
                }
            }
        }
    }
    
    func chooseAnimation(card: Card) -> () {
        let chosenCardIndex: Int = self.index(of: card)
        if (chosenCardIndex < 0) {
            downRollCards[(chosenCardIndex + 1) * -1].hasChooseAnimation = !downRollCards[(chosenCardIndex + 1) * -1].hasChooseAnimation
            print(downRollCards[(chosenCardIndex + 1) * -1].hasChooseAnimation)
        } else {
            upRollCards[chosenCardIndex].hasChooseAnimation = !upRollCards[chosenCardIndex].hasChooseAnimation
            print(upRollCards[chosenCardIndex].hasChooseAnimation)
        }
    }
    func chooseAnimationCancel(card: Card) -> () {
        let chosenCardIndex: Int = self.index(of: card)
        if (chosenCardIndex < 0) {
            downRollCards[(chosenCardIndex + 1) * -1].hasChooseAnimation = false
        } else {
            upRollCards[chosenCardIndex].hasChooseAnimation = false
        }
    }
    
    func flipCard(card: Card) {
        let chosenCardIndex: Int = self.index(of: card)
        if !card.isMatched {
            if (chosenCardIndex < 0) {
                downRollCards[(chosenCardIndex + 1) * -1].isFaceUp = !downRollCards[chosenCardIndex * -1].isFaceUp
            } else {
                upRollCards[chosenCardIndex].isFaceUp = !upRollCards[chosenCardIndex].isFaceUp
            }
        }
    }
    
    func setMatched(card1: Card, card2: Card) {
        let chosenCardIndex1: Int = self.index(of: card1)
        let chosenCardIndex2: Int = self.index(of: card2)
        if (chosenCardIndex1 < 0) {
            downRollCards[(chosenCardIndex1 + 1) * -1].isMatched = true
        } else {
            upRollCards[chosenCardIndex1].isMatched = true
        }
        if (chosenCardIndex2 < 0) {
            downRollCards[(chosenCardIndex2 + 1) * -1].isMatched = true
        } else {
            upRollCards[chosenCardIndex2].isMatched = true
        }
    }
    
    func index(of card: Card) -> Int {
        //TODO: distinct upRoll and downRoll
        for index in 0..<upRollCards.count {
            if upRollCards[index].id == card.id {
                return index
            }
        }
        for index in 0..<downRollCards.count {
            if downRollCards[index].id == card.id {
                return index * -1 - 1
            }
        }
        return 0
    }
}
