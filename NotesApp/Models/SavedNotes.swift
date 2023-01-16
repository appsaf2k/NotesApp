//
//  UserDefault.swift
//  NotesApp
//
//  Created by @andreev2k on 11.01.2023.
//

import Foundation


class SavedNotes {
    var items = [(Items)]() {
        didSet {
            if let encode = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encode, forKey: "Items")
                
            }
        }
    }
    
    init() {
        if let savedItem = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItem = try? JSONDecoder().decode([(Items)].self, from: savedItem) {
                items = decodedItem
                return
            }
        }
        items = []
    }
}
