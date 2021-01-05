//
//  Game.swift
//  Names
//
//  Created by SimonBabich on 02.01.2021.
//

import Foundation

///Структура для игры
struct Game {
    ///Загаданное слово
    var word: String
    
    ///Количество жизней
    var numberOfLives: Int
    
    var selectedLetter: [Character]
    
    var currentWord: String {
        
        ///Контейнер для отборажения слова на экране
        var currentWord: String = ""
        
        for letter in word {
            if selectedLetter.contains(letter) {
                currentWord.append(letter)
            } else if letter == " " || letter == "-" || letter == "," {
                currentWord.append(letter)
            } else {
                currentWord.append("_")
            }
        }
        return currentWord
    }
}
