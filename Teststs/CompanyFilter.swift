import Foundation

let CatalogueFilter = _CompanyFilter(userDefaultsKey: "CompanyFilter")
let MatchFilter = _CompanyFilter(userDefaultsKey: "MatchFilter")
let FakeMatchFilter = _CompanyFilter(userDefaultsKey: "FakeMatchFilter")

class _CompanyFilter {
    
    let userDefaultsKey: String
    
    private init(userDefaultsKey: String) {
        self.userDefaultsKey = userDefaultsKey
    }
    
    func copyFilter(filter: _CompanyFilter) {
        for property in CompanyProperty.All {
            self[property] = filter[property]
        }
        self.armadaFields = filter.armadaFields
        
    }
    
    let Ω = NSUserDefaults.standardUserDefaults()
    
    var isEmpty: Bool {
        for property in CompanyProperty.All {
            if !self[property].isEmpty {
                return false
            }
        }
        for field in ArmadaField.All {
            if armadaFields.contains(field) {
                return false
            }
        }
        return true
    }
    
    func reset() {
        for property in CompanyProperty.All {
            self[property] = []
        }
        self.armadaFields = []
    }
    
    subscript(companyProperty: CompanyProperty) -> [String] {
        get { return Ω["\(userDefaultsKey)\(companyProperty)"] as? [String] ?? [] }
        set { Ω["\(userDefaultsKey)\(companyProperty)"] = newValue }
    }
    
    var armadaFields: [ArmadaField] {
        get { return (Ω["\(userDefaultsKey)armadaField"] as? [String] ?? []).map { ArmadaField(rawValue: $0) ?? .Startup } }
        set { Ω["\(userDefaultsKey)armadaField"] = newValue.map { $0.rawValue } }
    }
    
    var filteredCompanies: [Company] {
        var filteredCompanies = ArmadaApi.companies
        for armadaFieldType in armadaFields {
            filteredCompanies = filteredCompanies.filter { $0.hasArmadaFieldType(armadaFieldType) }
        }
        for property in CompanyProperty.All {
            let filterValues = self[property]
            if !filterValues.isEmpty {
                filteredCompanies = filteredCompanies.filter { company in
                    !Set(company[property]).intersect(filterValues).isEmpty
                }
            }
        }
        return filteredCompanies
    }
    
    
    var description: String {
        var string = ""
        for property in CompanyProperty.All {
            string += "\(property): \(self[property])\n"
        }
        return string
        
    }
    
}