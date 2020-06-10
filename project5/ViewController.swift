//
//  ViewController.swift
//  project5
//
//  Created by Sultan Ali on 09/06/2020.
//  Copyright © 2020 Sultan Ali. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))

        if let startURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startURLContent = try? String(contentsOf: startURL){
                allWords = startURLContent.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty {
            allWords = ["Empty because no file in bundle"]
        }
        
        startGame()
    }
    
    @objc func startGame(){
        title = allWords.randomElement()
        usedWords.removeAll()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func promptAnswer(){
        let ac = UIAlertController(title: nil, message: "Enter Word", preferredStyle: .alert)
        ac.addTextField()
        
        let okButton = UIAlertAction(title: "OK", style: .default) {
           [weak self , weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(okButton)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String){
        
        let lowerAnswer = answer.lowercased()
        
        if doesContain(word: lowerAnswer){
            if isNew(word: lowerAnswer){
                if isReal(word: lowerAnswer){
                    if isShortWord(word: lowerAnswer) {
                        
                        usedWords.insert(answer, at: 0)
                        let indexPath = IndexPath(row: 0, section: 0)
                        tableView.insertRows(at: [indexPath], with: .fade)
                        return
                    } else {

                        showErrorMessage(err: "short")
                    }
                   
                } else {
                    showErrorMessage(err: "wrong")
                }
            } else {
                showErrorMessage(err: "duplicate")
            }
        } else {
            showErrorMessage(err: "default")
        }
    }
    
    func showErrorMessage(err message: String){
        let errorTitle: String
        let errorMessage: String
        
        switch message {
        case "short":
            errorTitle = "Short Word"
            errorMessage = "Enter a word longer than 3 letters"

        case "duplicate":
            errorTitle = "Duplicate word"
            errorMessage = "your answer is already there babe"
        case "wrong":
            errorTitle = "Wrong Word"
            errorMessage = "what the heck, dont make up words you sexy"
        default:
            errorTitle = "Really?!"
            errorMessage = "ahh i cant handle it"
        }
        
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(ac, animated: true)
        
    }
    
    func doesContain(word : String) -> Bool {
        // check if the title does actually contain all the letters of the word that the user is entering
        guard var titleLowercassed = title?.lowercased() else {return false}
        for letter in word {
            if titleLowercassed.contains(letter){ //paul huson did it without this if line its working
                if let position = titleLowercassed.firstIndex(of: letter) {
                titleLowercassed.remove(at: position)
                }
            } else {
                return false
            }
        }
        return true
    }
    
    func isNew(word : String) -> Bool {
        // checking if the word isnt added before
        // this code could be replaced by -> return !usedWords.contains(word)
        if usedWords.contains(word){
            return false
        } else {
        return true
        }
    }
    
    func isReal(word : String) -> Bool {
        // This code checks the spelling of the entered word
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
       // return misspelledRange.location == NSNotFound -> this pauls code
        if misspelledRange.location == NSNotFound {
            return true
        } else{
            return false
            
        }
    }
    
    func isShortWord(word: String) -> Bool {
        if word.count < 4 {
            return false
        } else {
            return true
        }
    }


}

