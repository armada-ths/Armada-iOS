import UIKit
import CoreData

public struct ArmadaEvent {
    public let title: String
    public let summary: String
    public let summaryWithoutHtml: String
    public let location: String?
    public let startDate: Date
    public let endDate: Date?
    public let signupLink: String?
    public let signupStartDate: Date?
    public let signupEndDate: Date?
    public let imageUrl: URL?
    public let registrationRequired: Bool
    
    
    
    
    enum SignupState {
        case passed, notRequired, notAvailable, now, future
//        
//        var description: String {
//            switch self {
//            case .Passed: return "Registration is over"
//            case .NotRequired: return "No registration required"
//            case .NotAvailable: return "Registration TBA"
//            case .Now: return "Sign up"
//            case .Future: return "Registration starts at \(signupStartDate.readableString)"
//            }
//        }
    }
    
    var signupStateString: String {
        switch signupState {
        case .passed: return "Registration is over"
        case .notRequired: return "No registration required"
        case .notAvailable: return "Registration TBA"
        case .now: return "Sign up before \(signupEndDate?.readableString ?? "")"
        case .future: return "Registration starts at \(signupStartDate?.readableString ?? "")"
        }

    }
    
    var signupState: SignupState {
        if registrationRequired {
            if startDate < Date() || signupEndDate != nil && signupEndDate! < Date() {
                return .passed
            } else {
                if let signupStartDate = signupStartDate,
                    let signupLink = signupLink , !signupLink.isEmpty,
                    let _ = URL(string: signupLink) {
                        if signupStartDate < Date() {
                            return .now
                        } else {
                            return .future
                        }
                } else {
                    return .notAvailable
                }
            }
        } else {
            return .notRequired
        }
    }
    
}

public struct News {
    public let title: String
    public let content: String
    public let publishedDate: Date
}

public struct ArmadaMember: Equatable {
    let name: String
    let imageUrl: URL
    let role: String
}

public func ==(x: ArmadaMember, y: ArmadaMember) -> Bool {
    return x.name == y.name && x.role == y.role
}

public struct Sponsor {
    let name: String
    let imageUrl: URL
    let description: String
    let websiteUrl: URL
    
    let isMainPartner: Bool
    let isMainSponsor: Bool
    let isGreenPartner: Bool
}

struct ArmadaFieldInfo {
    let title: String
    let description: String
    let armadaField: ArmadaField
}

public struct ArmadaGroup {
    let name: String
    let members: [ArmadaMember]
}

enum ArmadaField: String {
    case Startup = "icon_startup"
    case ClimateCompensation = "icon_climate_compensation"
    case Diversity = "icon_diversity"
    case Sustainability = "icon_sustainability"
    
    static var All: [ArmadaField] {
        return [.Startup, .ClimateCompensation, .Diversity, .Sustainability]
    }
    
    var title: String {
        switch self {
        case .Startup: return "Startup"
        case .Diversity: return "Diversity"
        case .ClimateCompensation: return "Climate Compensation"
        case .Sustainability: return "Sustainability"
        }
    }
    
    var image: UIImage {
        switch self {
        case .Startup: return UIImage(named: "Rocket")!
        case .ClimateCompensation: return UIImage(named: "Tree")!
        case .Diversity: return UIImage(named: "diversity")!
        case .Sustainability: return UIImage(named: "Leaf")!
        }
    }
    
}

enum Response<T> {
    case success(T)
    case error(Error)
    
    //Applicerar en transform om success annars inte.
    func map<G>(_ transform: (T) -> G) -> Response<G> {
        switch self {
        case .success(let value):
            return .success(transform(value))
        case .error(let error):
            return .error(error)
        }
        
    }
    
    static func flatten<T>(_ response: Response<Response<T>>) -> Response<T> {
        switch response {
        case .success(let innerResponse):
            return innerResponse
        case .error(let error):
            return .error(error)
        }
    }
    
    func flatMap<G>(_ transform: (T) -> Response<G>) -> Response<G> {
        return Response.flatten(map(transform))
    }
}

infix operator >>=
func >>=<T, G>(response: Response<T>, transform: (T) -> Response<G>) -> Response<G> {
    return response.flatMap(transform)
}

let ArmadaApi = _ArmadaApi()
open class _ArmadaApi {
    
    var companies = [Company]()
    
    var numberOfCompaniesForPropertyValueMap = [CompanyProperty:[String: Int]]()
    
    fileprivate let applicationDocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    
    fileprivate lazy var managedObjectModel: NSManagedObjectModel = {
        return NSManagedObjectModel(contentsOf: Bundle(for: type(of: self)).url(forResource: "CompanyModel", withExtension: "momd")!)!
    }()
    
    let persistentStoreUrl = URL(fileURLWithPath: dir).appendingPathComponent("Companies.sqlite")
    
    fileprivate lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        print("Persisten store: \(self.persistentStoreUrl)")
        
        let databaseExists = FileManager.default.fileExists(atPath: self.persistentStoreUrl.path)
        do {
            if !databaseExists {
                print("persistentStoreCoordinator does not exist - copying from bundle")
                try self.copyDatabaseFromBundle()
            } else {
                print("persistentStoreCoordinator exists")
            }
            
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.persistentStoreUrl, options: nil)
        } catch {
            do {
                print("persistentStoreCoordinator fucked up - deleting database")
                try self.deleteDatabase()
                if databaseExists {
                    print("persistentStoreCoordinator old database sucked - testing bundle")
                    try self.copyDatabaseFromBundle()
                }
                try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.persistentStoreUrl, options: nil)
            } catch {
                print("persistentStoreCoordinator - the bundle sucked too")
                do {
                    try self.deleteDatabase()
                    try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.persistentStoreUrl, options: nil)
                } catch {
                    print("persistentStoreCoordinator oh god - we messed up - goodbye")
                    print(error)
                    abort()
                }
                
            }
        }
        return persistentStoreCoordinator
    }()
    
    
    static let companiesFileName = "companies.json"
    
    static let dir = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true) as [String])[0]
    
    //let apiUrl = "http://armada.nu/api"
    let apiUrl = "https://ais.armada.nu/api"
    
    
    var persistentStoreUrlShm: URL {
        return URL(string: persistentStoreUrl.absoluteString + "-shm")!
    }
    var persistentStoreUrlWal: URL {
        return URL(string: persistentStoreUrl.absoluteString + "-wal")!
    }
    
    func deleteDatabase() throws {
        let persistentStoreUrlShm = URL(string: persistentStoreUrl.absoluteString + "-shm")!
        let persistentStoreUrlWal = URL(string: persistentStoreUrl.absoluteString + "-wal")!
        
        try FileManager.default.removeItem(at: persistentStoreUrl)
        try FileManager.default.removeItem(at: persistentStoreUrlShm)
        try FileManager.default.removeItem(at: persistentStoreUrlWal)
        
    }
    

    
    func copyDatabaseFromBundle() throws {
        let sqliteUrl = Bundle(for: type(of: self)).url(forResource: "Companies", withExtension: "sqlite")!
        let sqliteUrlShm = Bundle(for: type(of: self)).url(forResource: "Companies", withExtension: "sqlite-shm")!
        let sqliteUrlWal = Bundle(for: type(of: self)).url(forResource: "Companies", withExtension: "sqlite-wal")!
        
        try FileManager.default.copyItem(at: sqliteUrl, to: persistentStoreUrl)
        try FileManager.default.copyItem(at: sqliteUrlShm, to: persistentStoreUrlShm)
        try FileManager.default.copyItem(at: sqliteUrlWal, to: persistentStoreUrlWal)
        print("Copied companies from bundle")
        
    }
    
    fileprivate lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    func generateMap() {
        var numberOfCompaniesForPropertyValueMap = [CompanyProperty:[String: Int]]()
        
        _ = {
            numberOfCompaniesForPropertyValueMap[.workFields] = [:]
            let fetchRequest = NSFetchRequest<WorkField>()
            fetchRequest.entity = NSEntityDescription.entity(forEntityName: "WorkField", in: managedObjectContext)!
            let workFields =  try! managedObjectContext.fetch(fetchRequest)
            for workField in workFields {
                numberOfCompaniesForPropertyValueMap[.workFields]![workField.workField] = workField.companies.count
            }
            }()
        
        
        _ = {
            numberOfCompaniesForPropertyValueMap[.programmes] = [:]
            let fetchRequest = NSFetchRequest<Programme>()
            fetchRequest.entity = NSEntityDescription.entity(forEntityName: "Programme", in: managedObjectContext)!
            let programmes =  try! managedObjectContext.fetch(fetchRequest)
            for programme in programmes {
                numberOfCompaniesForPropertyValueMap[.programmes]![programme.programme] = programme.companies.count
            }
            }()
        
        _ = {
            numberOfCompaniesForPropertyValueMap[.companyValues] = [:]
            let fetchRequest = NSFetchRequest<CompanyValue>()
            fetchRequest.entity = NSEntityDescription.entity(forEntityName: "CompanyValue", in: managedObjectContext)!
            let companyValues =  try! managedObjectContext.fetch(fetchRequest)
            for companyValue in companyValues {
                numberOfCompaniesForPropertyValueMap[.companyValues]![companyValue.companyValue] = companyValue.companies.count
            }
            }()
        
        
        _ = {
            numberOfCompaniesForPropertyValueMap[.continents] = [:]
            let fetchRequest = NSFetchRequest<Continent>()
            fetchRequest.entity = NSEntityDescription.entity(forEntityName: "Continent", in: managedObjectContext)!
            let continents =  try! managedObjectContext.fetch(fetchRequest)
            for continent in continents {
                numberOfCompaniesForPropertyValueMap[.continents]![continent.continent] = continent.companies.count
            }
            }()
        
        
        _ = {
            numberOfCompaniesForPropertyValueMap[.jobTypes] = [:]
            let fetchRequest = NSFetchRequest<JobType>()
            fetchRequest.entity = NSEntityDescription.entity(forEntityName: "JobType", in: managedObjectContext)!
            let jobTypes =  try! managedObjectContext.fetch(fetchRequest)
            for jobType in jobTypes {
                numberOfCompaniesForPropertyValueMap[.jobTypes]![jobType.jobType] = jobType.companies.count
            }
            }()
        
        _ = {
            numberOfCompaniesForPropertyValueMap[.workWays] = [:]
            let fetchRequest = NSFetchRequest<WorkWay>()
            fetchRequest.entity = NSEntityDescription.entity(forEntityName: "WorkWay", in: managedObjectContext)!
            let workWays =  try! managedObjectContext.fetch(fetchRequest) 
            for workWay in workWays {
                numberOfCompaniesForPropertyValueMap[.workWays]![workWay.workWay] = workWay.companies.count
            }
            }()
        
        
        self.numberOfCompaniesForPropertyValueMap = numberOfCompaniesForPropertyValueMap
    }
    
    func numberOfCompaniesContainingValue(_ value: String, forProperty property: CompanyProperty) -> Int? {
        return numberOfCompaniesForPropertyValueMap[property]![value]
    }
    
    
    fileprivate init() {
        let cacheSizeMemory = 256*1024*1024
        let cacheSizeDisk = 256*1024*1024
        let sharedCache = URLCache(memoryCapacity: cacheSizeMemory, diskCapacity: cacheSizeDisk, diskPath: (NSTemporaryDirectory() as NSString).appendingPathComponent("nsurlcache"))
        //URLCache.setSharedURLCache(sharedCache)
        URLCache.shared = sharedCache
        let stopWatch = StopWatch()
        print(persistentStoreUrl)
        
        let fetchRequest = NSFetchRequest<Company>()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "Company", in: managedObjectContext)!
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
        companies = try! managedObjectContext.fetch(fetchRequest)
        print("Result: \(companies.count)")
        stopWatch.print("Fetching managed companies ")
    }
    
    
    func updateCompanies(_ callback: @escaping () -> ()) {
        let stopWatch = StopWatch()
        let fetchRequest = NSFetchRequest<Company>()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "Company", in: managedObjectContext)!
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))]
        companies = try! managedObjectContext.fetch(fetchRequest)
        
        _ArmadaApi.getCompaniesRespectingEtag() {
            switch $0 {
            case .success(let (_, usedCache, etag)):
                if !usedCache {
                    self.armadaUrlWithPath("companies").getJson() {
                        switch $0 {
                        case .success(let json):
                            if let companiesJson = json["companies"] as? [AnyObject] {
                                OperationQueue.main.addOperation {
                                    print("DESTROYING THE DATABASE!!!!!")
                                    if companiesJson.count > 0 {
                                        for company in self.companies {
                                            self.managedObjectContext.delete(company)
                                        }
                                        try! self.managedObjectContext.save()
                                        self.companies = []
                                        for json in companiesJson {
                                            if let company = Company.companyFromJson(json, managedObjectContext: self.managedObjectContext) {
                                                company.etag = etag
                                                self.companies.append(company)
                                            }
                                        }
                                        try! self.managedObjectContext.save()
                                    }
                                    callback()
                                }
                            } else {
                                callback()
                            }
                            
                        case .error:
                            callback()
                        }
                    }
                } else {
                    callback()
                }
            case .error(let error):
                print(error)
                callback()
            }
        }
        
        print("Result: \(companies.count)")
        stopWatch.print("Fetching managed companies ")
    }
    
    // Used for pre-fetching all companies logos - it's while the app is running in production
    func storeLogos() {
        let imageDirectory = applicationDocumentsDirectory.appendingPathComponent("logos")
        for company in companies {
            
            try! FileManager.default.createDirectory(at: imageDirectory, withIntermediateDirectories: true, attributes: nil)
            if let url = URL(string: company.logoUrl) {
                url.getData() {
                    if case .success(let data) = $0 {
                        try? data.write(to: imageDirectory.appendingPathComponent(company.imageName + ".png"), options: [.atomic])
                    }
                }
            }
        }
    }
    
    class func getCompaniesRespectingEtag(_ callback: @escaping (Response<(Data, Bool, String)>) -> Void) {
        let url = URL(string: "http://armada.nu/api/companies")!
        let session = URLSession.shared
        let request = URLRequest(url: url)
        var usedCache = false
        let dataTask = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            var etag: String?
            if let httpResponse = response as? HTTPURLResponse {
                etag = httpResponse.etag
                usedCache = httpResponse.etag == ArmadaApi.companies.first?.etag
            }
            if let data = data,
                let etag = etag {
                    let zebra = (data, usedCache, etag)
                    print("Url: \(url.absoluteString), cached: \(usedCache)")
                    callback(.success(zebra))
            } else if let error = error {
                callback(.error(error))
            } else {
                callback(.error(NSError(domain: "getData", code: 1337, userInfo: nil)))
            }
        }) 
        dataTask.resume()
    }
    
    var jobTypes: [String] {
        return Array(Set(companies.flatMap({ $0.jobTypes }).map { $0.jobType })).sorted(by: <)
    }
    
    var companyValues: [String] {
        return Array(Set(companies.flatMap({ $0.companyValues }).map { $0.companyValue })).sorted(by: <)
    }
    
    var workWays: [String] {
        return Array(Set(companies.flatMap({ $0.workWays }).map { $0.workWay })).sorted(by: <)
    }
    
    var continents: [String] {
        return Array(Set(companies.flatMap({ $0.continents }).map { $0.continent })).sorted(by: <)
    }
    
    var workFields: [String] {
        return Array(Set(companies.flatMap({ $0.workFields }).map { $0.workField })).sorted(by: <)
    }
    
    var educationTypes: [String] {
        return Array(Set(companies.flatMap({ $0.programmes }).map { $0.programme })).sorted(by: <)
    }
    
    var programmes: [String] {
        return educationTypes
    }
    
    func dateFromString(_ string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        let b = string.components(separatedBy: ":")
        return dateFormatter.date(from: b[0..<b.count-1].joined(separator: ":") + b[b.count-1])
    }
    
    open func eventsFromJson( _ json: AnyObject) -> [ArmadaEvent] {
        
        let events =  Array.removeNils((json as? [[String: AnyObject]])?.map { json -> ArmadaEvent? in
            if let name = json["name"] as? String,
                let description = json["description"] as? String,
                let startDateTimestamp = json["event_start"] as? Int,
                let endDateTimestamp = json["event_end"] as? Int {
                    let startDate = Date(timeIntervalSince1970: TimeInterval(startDateTimestamp))
                    let endDate = Date(timeIntervalSince1970: TimeInterval(endDateTimestamp))
                    let location = json["location"] as? String
                    let summaryWithoutHtml = description.strippedFromHtmlString
                    let signupLink = json["signup_link"] as? String
                    let registrationStartDate: Date?
                    if let registrationStartDateTimestamp = json["registration_start"] as? Int {
                        registrationStartDate = Date(timeIntervalSince1970: TimeInterval(registrationStartDateTimestamp))
                    } else {
                        registrationStartDate = nil
                    }
                    let registrationEndDate: Date?
                    if let registrationEndDateTimestamp = json["registration_end"] as? Int {
                        registrationEndDate = Date(timeIntervalSince1970: TimeInterval(registrationEndDateTimestamp))
                    } else {
                        registrationEndDate = nil
                    }
                    let name = name.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    let imageUrlString = json["image_url"] as? String
                    let imageUrl: URL? = imageUrlString != nil ? URL(string: imageUrlString!) : nil
                    let summary = description.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression, range: nil)
                    let registrationRequired = json["registration_required"] as? Bool ?? true
                    return ArmadaEvent(title: name, summary: summary, summaryWithoutHtml: summaryWithoutHtml, location: location, startDate: startDate, endDate: endDate, signupLink: signupLink, signupStartDate: registrationStartDate, signupEndDate: registrationEndDate, imageUrl: imageUrl, registrationRequired: registrationRequired)
            }
            return nil
            } ?? []).sorted(by: { $0.startDate.timeIntervalSince1970 > $1.startDate.timeIntervalSince1970 })
        let lastDate = events.first?.startDate ?? Date()
        let filteredEvents = events.filter{ $0.startDate.format("yyyy") == lastDate.format("yyyy") }
        if (filteredEvents.count < 3) {return events}
        return filteredEvents
    }
    
    open func newsFromJson(_ jsonOriginal: AnyObject) -> [News] {
        let json = jsonOriginal["news"]
        
        return Array.removeNils((json as? [[String: AnyObject]])?.map { json -> News? in
            if let title = json["title"] as? String,
                let content = json["content"] as? String,
                let dateString = json["date_published"] as? String,
                let date = self.dateFromString(dateString) {
                    return News(title: title, content: content, publishedDate: date)
            }
            return nil
            } ?? [])
    }
    
    open func sponsorsFromJson(_ jsonOriginal: AnyObject) -> [Sponsor] {
        let json = jsonOriginal["sponsors"]
        return Array.removeNils((json as? [[String: AnyObject]])?.map { json -> Sponsor? in
            if let name = json["name"] as? String ?? json["title"] as? String,
                let description = json["full_text"] as? String,
                let imageUrlString = json["logo_url"] as? String,
                let imageUrl = URL(string: imageUrlString),
                let websiteUrlString = json["website_url"] as? String,
                let websiteUrl = URL(string: websiteUrlString) {
                    let isMainPartner = json["main_partner"] as? Bool ?? false
                    let isMainSponsor = json["main_sponsor"] as? Bool ?? false
                    let isGreenPartner = json["green_partner"] as? Bool ?? false
                    return Sponsor(name: name, imageUrl: imageUrl, description: description, websiteUrl: websiteUrl, isMainPartner: isMainPartner, isMainSponsor: isMainSponsor, isGreenPartner: isGreenPartner)
                    
            }
            return nil
            } ?? [])
    }
    
    open func organisationGroupsFromJson(_ jsonOriginal: AnyObject) -> [ArmadaGroup] {
        var organisationGroups = [ArmadaGroup]()
        if let json = jsonOriginal["organisation_groups"] as? [AnyObject] {
            for object in json {
                var members = [ArmadaMember]()
                if let name = object["name"] as? String,
                    let jsonMembers = object["members"] as? [AnyObject] {
                        for member in jsonMembers {
                            if let name = member["name"] as? String,
                                let role = member["role"] as? String,
                                let imageUrlString = member["picture_url"] as? String,
                                let imageUrl = URL(string: imageUrlString) {
                                    members += [ArmadaMember(name: name, imageUrl: imageUrl, role: role)]
                            }
                        }
                        organisationGroups += [ArmadaGroup(name: name, members: members)]
                }
            }
        }
        return organisationGroups
    }

    
    func eventsFromServer(_ callback: @escaping (Response<[ArmadaEvent]>) -> Void) {
        armadaUrlWithPath("events").getJson() {
            callback($0.map(self.eventsFromJson))
        }
    }
    
    func newsFromServer(_ callback: @escaping (Response<[News]>) -> Void) {
        armadaUrlWithPath("news").getJson() {
            callback($0.map(self.newsFromJson))
        }
    }
    
    func sponsorsFromServer(_ callback: @escaping (Response<[Sponsor]>) -> Void) {
        armadaUrlWithPath("sponsors").getJson() {
            callback($0.map(self.sponsorsFromJson))
        }
    }
    
    
    func organisationGroupsFromServer(_ callback: @escaping (Response<[ArmadaGroup]>) -> Void) {
        armadaUrlWithPath("organisation_groups").getJson() {
            callback($0.map(self.organisationGroupsFromJson))
        }
    }
    
    func armadaUrlWithPath(_ path: String) -> URL {
        return URL(string: (apiUrl as NSString).appendingPathComponent(path))!
    }
    
    func pagesFromServer(_ callback: @escaping (Response<AnyObject>) -> Void) {
        armadaUrlWithPath("pages").getJson() {
            callback($0.map {
                json in
                var armadaPages = [String: AnyObject]()
                if let pages = json["pages"] as? [AnyObject] {
                    for page in pages {
                        armadaPages[page["slug"] as? String ?? ""] = page
                    }
                }
                return armadaPages as AnyObject
                })
        }
    }
    
    func armadaFieldInfosFromServer(_ callback: @escaping (Response<[ArmadaFieldInfo]>) -> Void) {
        pagesFromServer() {
            callback($0 >>= {
                json in
                var armadaFieldInfos = [ArmadaFieldInfo]()
                for armadaField in ArmadaField.All {
                    if let title = Json(object: json)[armadaField.rawValue]["title"].string,
                        let description = (Json(object: json)[armadaField.rawValue]["app_text"].string) {
                        armadaFieldInfos += [ArmadaFieldInfo(title: title, description: description, armadaField: armadaField)]
                    }
                }
                return .success(armadaFieldInfos)
            })
        }
    }
    
}

extension Array {
    static func removeNils(_ array: [Element?]) -> [Element] {
        return array.filter { $0 != nil }.map { $0! }
    }
}

extension HTTPURLResponse {
    var etag: String? {
        return allHeaderFields["Etag"] as? String
    }
}
