//
//  ViewController.swift
//  BlackJackAPP
//
//  Created by 姜又寧 on 2021/12/10.
//
enum Cards: String, CaseIterable {
    case spade = "♠︎", clubs = "♣︎", heart = "♥︎", diamond = "♦︎"
}

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var bankerCardsImage: [UIImageView]!
    
    @IBOutlet var playerCardsImage: [UIImageView]!
    
    @IBOutlet weak var bankerPointLabel: UILabel!
    
    @IBOutlet weak var playerPointLabel: UILabel!
    
    @IBOutlet weak var playerTotalCash: UILabel!
    
    @IBOutlet weak var pourCash: UILabel!
    
    @IBOutlet weak var dealButton: UIButton!
    
    var cards : [String] = []
    var cardsIndex : Int = 1
    var bkPoint : Int = 0
    var plPoint : Int = 0
    var imageIndex : Int = 1
    
    var playerPourCash : Int = 100
    var totalCash : Int = 2000
    
    var changePlayerAcePoint : Bool = true
    var changeBankerAcePoint : Bool = true
    
    var checkFirstPoint : Bool = true
    
    var openOrCloseFirstPoke : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for suit in Cards.allCases {
            for numbers in 1...13 {
                var value = suit.rawValue
                value.append(contentsOf: "\(numbers)")
                cards.append(value)
            }
        }
        self.resetCards()
    }
    
    func resetCards() {
        self.cards.shuffle()
        cardsIndex = 1
        bkPoint = 0
        plPoint = 0
        imageIndex = 1
        playerPourCash = 100
        changeBankerAcePoint = true
        changePlayerAcePoint = true
        checkFirstPoint = true
        openOrCloseFirstPoke = false
        self.dealButton.isHidden = false
        self.pourCash.text = "$\(self.playerPourCash)"
        self.playerTotalCash.text = "$\(self.totalCash)"
        self.getBKPointLabel(self.bkPoint)
        self.getPLPointLabel(self.plPoint)
        
        for i in 0...4 {
            self.bankerCardsImage[i].image = UIImage(named: "")
            self.playerCardsImage[i].image = UIImage(named: "")
        }
    }
    
    
    @IBAction func dealButtonClicked(_ sender: UIButton) {

        self.bankerCardsImage[0].image = UIImage(named: "image")
        self.bankerCardsImage[1].image = UIImage(named: self.getCardsIndex())
        self.getBKPoint(self.cardsIndex)
        
        self.playerCardsImage[0].image = UIImage(named: "image")
        self.playerCardsImage[1].image = UIImage(named: self.getCardsIndex())
        self.getPLPoint(self.cardsIndex)
        
        self.dealButton.isHidden = true
    }
    
    @IBAction func checkFirstPoke(_ sender: UIButton) {
        if self.checkFirstPoint {
            self.playerCardsImage[0].image = UIImage(named: "\(self.cards[1])")
            self.getPLFirstCardPoint(1)
            self.checkFirstPoint = false
        }else{
            if self.openOrCloseFirstPoke {
                self.playerCardsImage[0].image = UIImage(named: "\(self.cards[1])")
            }else{
                self.playerCardsImage[0].image = UIImage(named: "image")
            }
            self.openOrCloseFirstPoke = !self.openOrCloseFirstPoke
        }
        
    }
    @IBAction func getNextCard(_ sender: UIButton) {
        self.imageIndex += 1
        self.playerCardsImage[self.imageIndex].image = UIImage(named: self.getCardsIndex())
        self.getPLNextCardPoint(self.cardsIndex)
        if plPoint > 21 {
            self.alertController("You Lose", "next game", "OK")
            self.totalCash -= self.playerPourCash
        }
    }
    
    @IBAction func standCards(_ sender: UIButton) {
        self.bankerCardsImage[0].image = UIImage(named: "\(cards[0])")
        self.playerCardsImage[0].image = UIImage(named: "\(self.cards[1])")
        self.getBKFirstCardPoint(0)
        for index in 2...4 {
            if bkPoint < 17 {
                self.bankerCardsImage[index].image = UIImage(named: self.getCardsIndex())
                self.getBKNextCardPoint(self.cardsIndex)
            }else{
                break
            }
        }
        self.ckeckWinOrLose()
    }
    
    func ckeckWinOrLose() {
        if (self.plPoint > self.bkPoint) || self.bkPoint > 21{
            self.alertController("You Win", "congratulation", "OK")
            self.totalCash += self.playerPourCash
        }else{
            self.alertController("You Lose", "next game", "OK")
            self.totalCash -= self.playerPourCash
        }
    }
    
    func getBKPoint(_ number: Int) {
        var bkPoint = cards[number]
        bkPoint.removeFirst()
        let point = Int(bkPoint) ?? 0
        if point == 1 {
            self.bkPoint += 11
        }else if point > 9{
            self.bkPoint += 10
        }else{
            self.bkPoint += point
        }
        self.getBKPointLabel(self.bkPoint)
    }
    
    func getBKPointLabel(_ value: Int) {
        self.bankerPointLabel.text = "\(value)"
    }
    
    func getPLPoint(_ number: Int) {
        var plPoint = cards[number]
        plPoint.removeFirst()
        let point = Int(plPoint) ?? 0
        if point == 1 {
            self.plPoint += 11
        }else if point > 9{
            self.plPoint += 10
        }else{
            self.plPoint += point
        }
        self.getPLPointLabel(self.plPoint)
    }
    
    func getPLPointLabel(_ value: Int) {
        self.playerPointLabel.text = "\(value)"
    }
    
    func getBKFirstCardPoint(_ number: Int) {
        var bkPoint = cards[number]
        var firstBKPoint = cards[0]
        var secondBKPoint = cards[2]
        bkPoint.removeFirst()
        firstBKPoint.removeFirst()
        secondBKPoint.removeFirst()
        let point = Int(bkPoint) ?? 0
        let firstPoint = Int(firstBKPoint) ?? 0
        let secondPoint = Int(secondBKPoint) ?? 0
        if firstPoint == 1 && secondPoint == 1 {
            self.bkPoint = 12
//            self.changeBankerAcePoint = false
        }else if point > 9{
            self.bkPoint += 10
        }else if point == 1{
            self.bkPoint += 11
        }else{
            self.bkPoint += point
        }
        self.getBKPointLabel(self.bkPoint)
    }

    func getPLFirstCardPoint(_ number: Int) {
        var plPoint = cards[number]
        var firstPLPoint = cards[1]
        var secondPLPoint = cards[3]
        plPoint.removeFirst()
        firstPLPoint.removeFirst()
        secondPLPoint.removeFirst()
        let point = Int(plPoint) ?? 0
        let firstPoint = Int(firstPLPoint) ?? 0
        let secondPoint = Int(secondPLPoint) ?? 0
        if firstPoint == 1 && secondPoint == 1{
            self.plPoint = 12
//            self.changePlayerAcePoint = false
        }else if point > 9{
            self.plPoint += 10
        }else if point == 1{
            self.plPoint += 11
        }else{
            self.plPoint += point
        }
        self.getPLPointLabel(self.plPoint)
    }

    func getPLNextCardPoint(_ number: Int) {
        var plPoint = cards[number]
        var firstPLPoint = cards[1]
        var secondPLPoint = cards[3]
        plPoint.removeFirst()
        firstPLPoint.removeFirst()
        secondPLPoint.removeFirst()
        let point = Int(plPoint) ?? 0
        let firstPoint = Int(firstPLPoint) ?? 0
        let secondPoint = Int(secondPLPoint) ?? 0
        if point > 9 {
            self.plPoint += 10
        }else if point == 1 && self.plPoint <= 10{
            self.plPoint += 11
        }else{
            self.plPoint += point
        }
            
        guard (firstPoint == 1 || secondPoint == 1) && (self.plPoint > 21) && self.changePlayerAcePoint else {
            self.getPLPointLabel(self.plPoint)
            return
        }
        self.plPoint -= 10
        self.changePlayerAcePoint = false

        self.getPLPointLabel(self.plPoint)
    }

    func getBKNextCardPoint(_ number: Int) {
        var bkPoint = cards[number]
        var firstBKPoint = cards[0]
        var secondBKPoint = cards[2]
        bkPoint.removeFirst()
        firstBKPoint.removeFirst()
        secondBKPoint.removeFirst()
        let point = Int(bkPoint) ?? 0
        let firstPoint = Int(firstBKPoint) ?? 0
        let secondPoint = Int(secondBKPoint) ?? 0
        if point > 9 {
            self.bkPoint += 10
        }else if point == 1 && self.bkPoint <= 10{
            self.bkPoint += 11
        }else{
            self.bkPoint += point
        }

        guard (firstPoint == 1 || secondPoint == 1) && (self.bkPoint > 21) && self.changeBankerAcePoint else {
            self.getBKPointLabel(self.bkPoint)
            return
        }
        self.bkPoint -= 10
        self.changeBankerAcePoint = false

        self.getBKPointLabel(self.bkPoint)
    }
    
    func getCardsIndex() -> String {
        self.cardsIndex += 1
        return cards[self.cardsIndex]
    }
    
    func alertController(_ title: String, _ message: String, _ actionTitle: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default) { _ in
            if self.totalCash <= 0 {
                self.resetGameAlertController("You are broke", "to restart", "OK")
            }
            self.resetCards()
        }
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
        
    }
    
    func resetGameAlertController(_ title: String, _ message: String, _ actionTitle: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default) { _ in
            self.resetCards()
            self.totalCash = 2000
            self.playerTotalCash.text = "\(self.totalCash)"
        }
            controller.addAction(action)
            present(controller, animated: true, completion: nil)
    }
    
    @IBAction func pourPointButtonClicked(_ sender: UIButton) {
        let sender = sender.tag
        switch sender {
        case 1:
            self.playerPourCash += sender
            self.pourCash.text = "$\(self.playerPourCash)"
        case 10:
            self.playerPourCash += sender
            self.pourCash.text = "$\(self.playerPourCash)"
        case 100:
            self.playerPourCash += sender
            self.pourCash.text = "$\(self.playerPourCash)"
        default:
            break
        }
    }
    
}

