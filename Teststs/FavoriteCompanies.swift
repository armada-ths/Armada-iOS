import UIKit

let FavoriteCompanies = _FavoriteCompanies()

class _FavoriteCompanies: Sequence, Collection {
    /// Returns the position immediately after the given index.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be less than
    ///   `endIndex`.
    /// - Returns: The index value immediately after `i`.
    public func index(after i: Int) -> Int {
        return i+1;
    }

    
    fileprivate init() {}
    
    fileprivate let key = "FavoriteCompanies"
    
    fileprivate let Ω = UserDefaults.standard
    
    
    var startIndex: Int {
        return 0
    }
    
    var endIndex: Int {
        return count
    }
    
    var isEmpty: Bool {
        return count == 0
    }
    
    func append(_ companyName: String) {
        var companyNames = (Ω[key] as? [String]) ?? []
        companyNames.append(companyName)
        companyNames = companyNames.sorted(by: { $0 < $1 })
        Ω[key] = companyNames as AnyObject?
    }
    
    func removeAtIndex(_ index: Int) {
        var companyNames = (Ω[key] as? [String]) ?? []
        companyNames.remove(at: index)
        Ω[key] = companyNames as AnyObject?
    }
    
    func remove(_ companyName: String) {
        var companyNames = (Ω[key] as? [String]) ?? []
        companyNames = companyNames.filter({ $0 != companyName })
        Ω[key] = companyNames as AnyObject?
    }
    
    var count: Int {
        return ((Ω[key] as? [String]) ?? []).count
    }
    
    subscript(index: Int) -> String {
        return ((Ω[key] as? [String]) ?? [])[index]
    }
    
    func makeIterator() -> AnyIterator<String> {
        var index = 0
        return AnyIterator {
            if index < self.count {
                index += 1
                return self[index-1]
            }
            return nil
        }
    }
}
