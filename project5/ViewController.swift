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

        if let startURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startURLContent = try? String(contentsOf: startURL){
                allWords = startURLContent.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty {
            allWords = ["Empty because no file in bundle"]
        }
        
        title = allWords.randomElement()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }


}

