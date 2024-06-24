//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Héctor Manuel Sandoval Landázuri on 22/06/24.
//

import SwiftUI

@Observable
class Favorites {
    // the actual resorts the user has favorited
    private var resorts: Set<String>

    // the key we're using to read/write in UserDefaults
    private let key = "Favorites"

    init() {
        // load our saved data
        if let savedSet = UserDefaults.standard.array(forKey: key) as? [String] {
            resorts = Set(savedSet)
            return
        }

        // still here? Use an empty array
        resorts = []
    }

    // returns true if our set contains this resort
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }

    // adds the resort to our set and saves the change
    func add(_ resort: Resort) {
        resorts.insert(resort.id)
        save()
    }

    // removes the resort from our set and saves the change
    func remove(_ resort: Resort) {
        resorts.remove(resort.id)
        save()
    }

    func save() {
        // write out our data
        UserDefaults.standard.set(Array(resorts), forKey: key)
    }
}
