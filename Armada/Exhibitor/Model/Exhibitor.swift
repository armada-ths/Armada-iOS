struct Exhibitor: Codable {
    let id: Int
    let name: String
    let companyWebsite: String?
    let about: String?
    let purpose: String?
    let logoSquared: String?
    let logoFreeSize: String?
    let contactName: String?
    let contactEmail: String?
    let contactPhoneNumber: String?
    let industries: [Industry]
    let employments: [Employment]
    let locations: [Location]
    let benefits: [Benefit]
    let averageAge: Int?
    let founded: Int?
    let booths: [Booth]

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case companyWebsite = "company_website"
        case about
        case purpose
        case logoSquared = "logo_squared"
        case logoFreeSize = "logo_freesize"
        case contactName = "contact_name"
        case contactEmail = "contact_email_address"
        case contactPhoneNumber = "contact_phone_number"
        case industries
        case employments
        case locations
        case benefits
        case averageAge = "average_age"
        case founded
        case booths
    }
}
