//
//  ItemInNotes.swift
//  NotesApp
//
//  Created by @andreev2k on 11.01.2023.
//

import Foundation



struct Items: Identifiable, Codable {
    var id = UUID().hashValue
    var title: String
    var note: AttributedString
}
