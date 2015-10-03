//: Playground - noun: a place where people can play

import UIKit





var letters = "aofjeiöshråÄ4bch".characters.map { String($0) }




let sortedLetters = letters.sort {
    let result = $0.compare($1, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: NSLocale(localeIdentifier: "se"))
    switch result {
    case .OrderedAscending, .OrderedSame:
        return true
    case .OrderedDescending:
        return false
    }
}



Int("x")