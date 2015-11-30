//
//  Game.swift
//  FightTheLandLord
//
//  Created by  Zhao Shi Lin on 24/11/15.
//  Copyright © 2015年  Zhao Shi Lin. All rights reserved.
//

import Foundation
extension Array {
    mutating func shuffle() {
        if count < 2 { return }
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            swap(&self[i], &self[j])
        }
    }
}
class Game:NSObject{
    static var rankString: [String] = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
    var players:[Player]
    var currentTurn:Player?
    var cards:[Card]
    let numOfCardPack = 4
    
    override convenience init(){
        let emptyPlayers:[Player] = []
        self.init(enteredPlayers: emptyPlayers)
    }
    
    init(enteredPlayers:[Player]){
        self.cards = []
        self.players = enteredPlayers
        self.currentTurn = nil
        super.init()
        initCards()
        
    }
    
    func initCards(){
        cards.removeAll()
        for var index = 0; index < self.numOfCardPack; ++index {
            for rank in Game.rankString{
                for type in CardType.allValues{
                    var value = Game.getCardValue(rank)
                    var newCard = Card(cardType: type, cardValue: value, cardString: rank)
                    cards.append(newCard)
                    
                }
            }
        }
        RandomCard()
    }
    
    
    //start Game, assigned cards to all players
    func startGame(){
        if(players.count<2){
            return
        }
        RandomPlayer()
        
        if(cards.count<players.count*10){
            initCards()
        }
        for var player in players{
            player.cards.removeAll()
            player.hideCard = cards.removeLast()
            player.cards.append(cards.removeLast())
        }
    }
    
    func getCard(Id:String)->Card{
        var filterPlayers:[Player] = players.filter{ $0.Id == Id}
        var assignedCard:Card = cards.removeLast()
        filterPlayers[0].cards.append(assignedCard)
        return assignedCard
    }

    
    static func getCardValue(rank:String)->Int{
        var value:Int = rank == "A" ? 1 : Int(rank) == nil ? 10 : Int(rank)!
        return value
    }

    func getPlayer(playerId:String)->Player?{
        for player in players{
            if player.Id == playerId{
                return player
            }
        }
        return nil
    }
    
    private func getRemainingCardCount()->Int{
        return cards.count
    }
    

    
    
    //stopAccpetingCard
    func deny(palyerName:String){
        
    }
    
    
    //enter a new player
    func addPlayer(player:Player){
        players.append(player)
    }
    
    //return winner
    func getWinner()->Player?{
        return nil
    }
    
    func RandomCard(){
        cards.shuffle()
    }
    func RandomPlayer(){
        players.shuffle()
    }
    
    
    
    
}