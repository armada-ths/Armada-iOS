import UIKit

let FavoriteCompanies = _FavoriteCompanies()

class _FavoriteCompanies: SequenceType, CollectionType {
    
    private init() {}
    
    private let key = "FavoriteCompanies"
    
    private let Ω = NSUserDefaults.standardUserDefaults()
    
    
    var startIndex: Int {
        return 0
    }
    
    var endIndex: Int {
        return count
    }
    
    var isEmpty: Bool {
        return count == 0
    }
    
    func append(companyName: String) {
        var companyNames = (Ω[key] as? [String]) ?? []
        companyNames.append(companyName)
        companyNames = companyNames.sort({ $0 < $1 })
        Ω[key] = companyNames
    }
    
    func removeAtIndex(index: Int) {
        var companyNames = (Ω[key] as? [String]) ?? []
        companyNames.removeAtIndex(index)
        Ω[key] = companyNames
    }
    
    func remove(companyName: String) {
        var companyNames = (Ω[key] as? [String]) ?? []
        companyNames = companyNames.filter({ $0 != companyName })
        Ω[key] = companyNames
    }
    
    var count: Int {
        return ((Ω[key] as? [String]) ?? []).count
    }
    
    subscript(index: Int) -> String {
        return ((Ω[key] as? [String]) ?? [])[index]
    }
    
    func generate() -> AnyGenerator<String> {
        var index = 0
        return anyGenerator {
            if index < self.count {
                return self[index++]
            }
            return nil
        }
    }
}