//
//  ViewController.swift
//  Names
//
//  Created by SimonBabich on 02.01.2021.
//

import UIKit

class ViewController: UIViewController {
    
    ///Apple tree
    @IBOutlet weak var treeImageView: UIImageView!
    
    ///Kayboard
    @IBOutlet var letterButtons: [UIButton]!
    
    ///word label
    @IBOutlet weak var wordLabel: UILabel!
    
    ///counters label
    @IBOutlet weak var countersLabel: UILabel!
    
    //Количество жизней по умолчанию
    let maxNumberOfLives: Int = 7
    
    var currentGame: Game!
    
    var numberOfFails: Int = 0
    var numberOfWins: Int = 0
    
    var msg: String = ""
    var start: Bool = true
    var gameType: String = "Names"
    var gameName: String = "Имена"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTargetToButtons()
        
        //выбрать игру
        
        //currentGame.word = "Start"
        wordLabel.text = "С т а р т"
        countersLabel.text = ""
//        showAlert(alertTitle: "Старт")
        //но начало иры почему-то приходится задавать здесь
        //setupNewGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showAlert(alertTitle: "Старт")
    }

    
    /// Создаем новую игру
    func setupNewGame() {
        // Если у нас оставлиьс неиспользуемые имена, то конфигурируем игру
        
        if gameType == "Names" && names.isEmpty == false {
            let index = Int(arc4random_uniform(UInt32(names.count - 1)))
            let word = names.remove(at: index).uppercased()
            ConfigureNewGame(word,"")
        }
        else if cities.isEmpty == false {
            let index = Int(arc4random_uniform(UInt32(cities.count)))
            let country = cities.remove(at: index) //  .array.keys[index]
            let word = country.0.uppercased()
            //let flag = country.2
            ConfigureNewGame(word,country.1)
        }
        else {
                enableButtons(false)
                wordLabel.text = "Game Over"
        }
        
        //обновляем интерфейс
        updateUI()
    }
    
    //Конфигурируем новую игру
    func ConfigureNewGame(_ word: String,_ country: String) {
        currentGame = Game(
            word: word,
            country: country,
            numberOfLives: maxNumberOfLives,
            selectedLetter: [])
        enableButtons(true)
    }
    
    /// Обновляем интерфейс
    func updateUI() {
        //Опрелделяем название картинки
        let imageName: String = "Tree \(currentGame.numberOfLives)"
        //получаем картинку
        let image: UIImage? = UIImage(named: imageName)
        //добавляем картику на экран
        treeImageView.image = image
        
        //данные о слове
        var letters = [String]()
        // с разделителем пробел
        for letter in currentGame.currentWord {
            letters.append("\(letter)")
        }
        let formaterString = letters.joined(separator: " ")
        
        wordLabel.text = formaterString
        
        //отображаем счетчик
        gameName = gameType == "Names" ? "Имена": "Столицы"
        countersLabel.text = "\(gameName) Выигрышей: \(numberOfWins), Проигрышей: \(numberOfFails)"
    }
    
    /// Добавляем таркеты кнопкам
    func addTargetToButtons() {
        //прокручиваем массив кнопок через цикл
        for button in letterButtons {
            button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
    }
    //// Обработка нажатий кнопок
    @objc func buttonPressed(_ sender: UIButton) {
    
        if start == true {
            setupNewGame()
            start = false
        }
        
        // disable button letter
        sender.isEnabled = false
        
        if let letter = sender.title(for: .normal) {
            let character = Character(letter.uppercased())
            currentGame.selectedLetter.append(character)
            print(letter)
            
            if currentGame.word.contains(character) == false {
                currentGame.numberOfLives -= 1
            }
            changeGameState()
        }
    }
    
    ///Обновляем этапы игры
    func changeGameState() {
        //проиграли если не осталось ни одного яблока, то есть еще одна попытка.
        //Изменил <=0 на <0
        //таким образом получается 8 попыток, а не 7. И картинок у нас 8
        if currentGame.numberOfLives < 0 {
            //Увеличиваем счетчик проигышей
            numberOfFails += 1
            //выдаем сообщение о проигрыше с загаданным именем и начинаем новую игру
            showAlert(alertTitle: "Проигрыш")
        }
        else if currentGame.currentWord == currentGame.word {
            //Увеличиваем счетчик Побед
            numberOfWins += 1
            //выдаем сообщение о выигрыше с загаданным именем и начинаем новую игру
            showAlert(alertTitle: "Выигрыш")
        }
        else {
            updateUI()
        }
    }
    
    //выдаем сообщение о резултьате игры с загаданным именем и начинаем новую игру
    func showAlert(alertTitle: String) {
        //при перовом запуске еще нет слова, поэтому сообщение = Выберете игру
        if start == true {
            msg = "Выберете игру"
        } else if gameType == "Cities" {
            msg = "Загаданая столица: \(currentGame.word) Страна: \(currentGame.country)"
        } else {
            msg = "Загаданное имя: \(currentGame.word)"
        }
        
        let alert = UIAlertController(title: alertTitle, message: msg, preferredStyle: .alert)
        let namesGame = UIAlertAction(title: "Имена", style: .cancel, handler: { action in
            self.gameType = "Names"
            self.setupNewGame()
        })
        alert.addAction(namesGame)
        
        //Если городов не осталось, то нет выбора иры Города
        if cities.isEmpty == false {
            let citiesGame = UIAlertAction(title: "Столицы мира", style: .default, handler: { action in
                self.gameType = "Cities"
                self.setupNewGame()
            })
            alert.addAction(citiesGame)
        }
        
        self.present(alert, animated: true, completion: nil)
        print(alertTitle)
        print(gameType)
        
        //При выигрыше или проигыше создаем новую игру
        //start = false
        //setupNewGame()
    }
    
    //включаем / выключам все кнопки
    func enableButtons(_ isEnabled: Bool){
        for button in letterButtons {
            button.isEnabled = isEnabled
        }
    }
        
    
}

