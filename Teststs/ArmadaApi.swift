import UIKit
import CoreData

public struct ArmadaEvent {
    public let title: String
    public let summary: String
    public let location: String?
    public let startDate: NSDate
    public let endDate: NSDate
    public let signupLink: String?
    public let signupStartDate: NSDate?
    public let signupEndDate: NSDate?
    public let imageUrl: NSURL?
    
    var image: UIImage? {
        return UIImage(named: title.stringByReplacingOccurrencesOfString("ä", withString: ""))
    }
    
}

public struct News {
    public let title: String
    public let content: String
    public let publishedDate: NSDate
}

enum Response<T> {
    case Success(T)
    case Error(ErrorType)
    
    func map<G>(transform: T -> G) -> Response<G> {
        switch self {
        case .Success(let value):
            return .Success(transform(value))
        case .Error(let error):
            return .Error(error)
        }
        
    }
    
    static func flatten<T>(response: Response<Response<T>>) -> Response<T> {
        switch response {
        case .Success(let innerResponse):
            return innerResponse
        case .Error(let error):
            return .Error(error)
        }
    }
    
    func flatMap<G>(transform: T -> Response<G>) -> Response<G> {
        return Response.flatten(map(transform))
    }
}

infix operator >>= {}
func >>=<T, G>(response: Response<T>, transform: T -> Response<G>) -> Response<G> {
    return response.flatMap(transform)
}

let ArmadaApi = _ArmadaApi()

public class _ArmadaApi {
    
    var companies = [Company]()
    
    var numberOfCompaniesForPropertyValueMap = [CompanyProperty:[String: Int]]()
    
    private let applicationDocumentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last!
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        return NSManagedObjectModel(contentsOfURL: NSBundle(forClass: self.dynamicType).URLForResource("CompanyModel", withExtension: "momd")!)!
        }()
    
    let persistentStoreUrl = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent("Companies.sqlite")
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        print("Persisten store: \(self.persistentStoreUrl)")
    
        let databaseExists = NSFileManager.defaultManager().fileExistsAtPath(self.persistentStoreUrl.path!)
        do {
            if !databaseExists {
                print("persistentStoreCoordinator does not exist - copying from bundle")
                try self.copyDatabaseFromBundle()
            } else {
                print("persistentStoreCoordinator exists")
            }
            
            try persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: self.persistentStoreUrl, options: nil)
        } catch {
            do {
                print("persistentStoreCoordinator fucked up - deleting database")
                try self.deleteDatabase()
                if databaseExists {
                    print("persistentStoreCoordinator old database sucked - testing bundle")
                    try self.copyDatabaseFromBundle()
                }
                try persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: self.persistentStoreUrl, options: nil)
            } catch {
                print("persistentStoreCoordinator - the bundle sucked too")
                do {
                    try self.deleteDatabase()
                    try persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: self.persistentStoreUrl, options: nil)
                } catch {
                    print("persistentStoreCoordinator oh god - we messed up - goodbye")
                    print(error)
                    abort()
                }

            }
        }
        return persistentStoreCoordinator
        }()
    
    func deleteDatabase() throws {
        let persistentStoreUrlShm = NSURL(string: persistentStoreUrl.absoluteString + "-shm")!
        let persistentStoreUrlWal = NSURL(string: persistentStoreUrl.absoluteString + "-wal")!
        
        try NSFileManager.defaultManager().removeItemAtURL(persistentStoreUrl)
        try NSFileManager.defaultManager().removeItemAtURL(persistentStoreUrlShm)
        try NSFileManager.defaultManager().removeItemAtURL(persistentStoreUrlWal)
        
    }
    
    var persistentStoreUrlShm: NSURL {
        return NSURL(string: persistentStoreUrl.absoluteString + "-shm")!
    }
    var persistentStoreUrlWal: NSURL {
        return NSURL(string: persistentStoreUrl.absoluteString + "-wal")!
    }
    
    func copyDatabaseFromBundle() throws {
        let sqliteUrl = NSBundle(forClass: self.dynamicType).URLForResource("Companies", withExtension: "sqlite")!
        let sqliteUrlShm = NSBundle(forClass: self.dynamicType).URLForResource("Companies", withExtension: "sqlite-shm")!
        let sqliteUrlWal = NSBundle(forClass: self.dynamicType).URLForResource("Companies", withExtension: "sqlite-wal")!
        
        try NSFileManager.defaultManager().copyItemAtURL(sqliteUrl, toURL: persistentStoreUrl)
        try NSFileManager.defaultManager().copyItemAtURL(sqliteUrlShm, toURL: persistentStoreUrlShm)
        try NSFileManager.defaultManager().copyItemAtURL(sqliteUrlWal, toURL: persistentStoreUrlWal)
        print("Copied companies from bundle")
        
    }
    
    private lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
        }()
    
    func generateMap() {
        var numberOfCompaniesForPropertyValueMap = [CompanyProperty:[String: Int]]()
        
        _ = {
            numberOfCompaniesForPropertyValueMap[.WorkFields] = [:]
            let fetchRequest = NSFetchRequest()
            fetchRequest.entity = NSEntityDescription.entityForName("WorkField", inManagedObjectContext: managedObjectContext)!
            let workFields =  try! managedObjectContext.executeFetchRequest(fetchRequest) as! [WorkField]
            workFields[0]
            for workField in workFields {
                numberOfCompaniesForPropertyValueMap[.WorkFields]![workField.workField] = workField.companies.count
            }
            }()
        
        
        _ = {
            numberOfCompaniesForPropertyValueMap[.Programmes] = [:]
            let fetchRequest = NSFetchRequest()
            fetchRequest.entity = NSEntityDescription.entityForName("Programme", inManagedObjectContext: managedObjectContext)!
            let programmes =  try! managedObjectContext.executeFetchRequest(fetchRequest) as! [Programme]
            for programme in programmes {
                numberOfCompaniesForPropertyValueMap[.Programmes]![programme.programme] = programme.companies.count
            }
            }()
        
        _ = {
            numberOfCompaniesForPropertyValueMap[.CompanyValues] = [:]
            let fetchRequest = NSFetchRequest()
            fetchRequest.entity = NSEntityDescription.entityForName("CompanyValue", inManagedObjectContext: managedObjectContext)!
            let companyValues =  try! managedObjectContext.executeFetchRequest(fetchRequest) as! [CompanyValue]
            for companyValue in companyValues {
                numberOfCompaniesForPropertyValueMap[.CompanyValues]![companyValue.companyValue] = companyValue.companies.count
            }
            }()
        
        
        _ = {
            numberOfCompaniesForPropertyValueMap[.Continents] = [:]
            let fetchRequest = NSFetchRequest()
            fetchRequest.entity = NSEntityDescription.entityForName("Continent", inManagedObjectContext: managedObjectContext)!
            let continents =  try! managedObjectContext.executeFetchRequest(fetchRequest) as! [Continent]
            for continent in continents {
                numberOfCompaniesForPropertyValueMap[.Continents]![continent.continent] = continent.companies.count
            }
            }()
        
        
        _ = {
            numberOfCompaniesForPropertyValueMap[.JobTypes] = [:]
            let fetchRequest = NSFetchRequest()
            fetchRequest.entity = NSEntityDescription.entityForName("JobType", inManagedObjectContext: managedObjectContext)!
            let jobTypes =  try! managedObjectContext.executeFetchRequest(fetchRequest) as! [JobType]
            for jobType in jobTypes {
                numberOfCompaniesForPropertyValueMap[.JobTypes]![jobType.jobType] = jobType.companies.count
            }
            }()
        
        _ = {
            numberOfCompaniesForPropertyValueMap[.WorkWays] = [:]
            let fetchRequest = NSFetchRequest()
            fetchRequest.entity = NSEntityDescription.entityForName("WorkWay", inManagedObjectContext: managedObjectContext)!
            let workWays =  try! managedObjectContext.executeFetchRequest(fetchRequest) as! [WorkWay]
            for workWay in workWays {
                numberOfCompaniesForPropertyValueMap[.WorkWays]![workWay.workWay] = workWay.companies.count
            }
            }()
        
        
        self.numberOfCompaniesForPropertyValueMap = numberOfCompaniesForPropertyValueMap
    }
    
    func numberOfCompaniesContainingValue(value: String, forProperty property: CompanyProperty) -> Int? {
        return numberOfCompaniesForPropertyValueMap[property]![value]
    }
    
    
    private init() {
        let cacheSizeMemory = 64*1024*1024
        let cacheSizeDisk = 64*1024*1024
        let sharedCache = NSURLCache(memoryCapacity: cacheSizeMemory, diskCapacity: cacheSizeDisk, diskPath: (NSTemporaryDirectory() as NSString).stringByAppendingPathComponent("nsurlcache"))
        NSURLCache.setSharedURLCache(sharedCache)
        let stopWatch = StopWatch()
        
        print(persistentStoreUrl)
        
        
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Company", inManagedObjectContext: managedObjectContext)!
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: "caseInsensitiveCompare:")]
        companies = try! managedObjectContext.executeFetchRequest(fetchRequest) as! [Company]
        
        print("Result: \(companies.count)")
        stopWatch.print("Fetching managed companies ")
        
        
    }
    
    
    func updateCompanies(callback: () -> ()) {
        let stopWatch = StopWatch()
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Company", inManagedObjectContext: managedObjectContext)!
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: "caseInsensitiveCompare:")]
        companies = try! managedObjectContext.executeFetchRequest(fetchRequest) as! [Company]
        
        _ArmadaApi.getCompaniesRespectingEtag() {
            switch $0 {
            case .Success(let (_, usedCache, etag)):
                if !usedCache {
                    _ArmadaApi.getJson(self.armadaUrlWithPath("companies")) {
                        switch $0 {
                        case .Success(let json):
                            if let companiesJson = json["companies"] as? [AnyObject] {
                                NSOperationQueue.mainQueue().addOperationWithBlock {
                                    print("DESTROYING THE DATABASE!!!!!")
                                    if companiesJson.count > 0 {
                                        for company in self.companies {
                                            self.managedObjectContext.deleteObject(company)
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
                            
                        case .Error:
                            callback()
                        }
                    }
                } else {
                    callback()
                }
            case .Error(let error):
                print(error)
                callback()
            }
        }
        
        print("Result: \(companies.count)")
        stopWatch.print("Fetching managed companies ")
    }
    
    
    func storeLogos() {
        let imageDirectory = applicationDocumentsDirectory.URLByAppendingPathComponent("logos")
        for company in companies {
            
            try! NSFileManager.defaultManager().createDirectoryAtURL(imageDirectory, withIntermediateDirectories: true, attributes: nil)
            if let url = NSURL(string: company.logoUrl) {
                _ArmadaApi.getData(url) {
                    if case .Success(let data) = $0 {
                        data.writeToURL(imageDirectory.URLByAppendingPathComponent(company.imageName + ".png"), atomically: true)
                    }
                }
            }
        }
    }
    
    class func getCompaniesRespectingEtag(callback: Response<(NSData, Bool, String)> -> Void) {
        let url = NSURL(string: "http://staging.armada.nu/api/companies")!
        let session = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: url)
        var usedCache = false
        let dataTask = session.dataTaskWithRequest(request) {
            (data, response, error) in
            var etag: String?
            if let httpResponse = response as? NSHTTPURLResponse {
                etag = httpResponse.etag
                usedCache = httpResponse.etag == ArmadaApi.companies.first?.etag
            }
            if let data = data,
                let etag = etag {
                    let zebra = (data, usedCache, etag)
                    print("Url: \(url.absoluteString), cached: \(usedCache)")
                    callback(.Success(zebra))
            } else if let error = error {
                callback(.Error(error))
            } else {
                callback(.Error(NSError(domain: "getData", code: 1337, userInfo: nil)))
            }
        }
        dataTask.resume()
    }
    
    class func getData(url: NSURL, callback: Response<NSData> -> Void) {
        let session = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: url)
        let dataTask = session.dataTaskWithRequest(request) {
            (data, response, error) in
            if let data = data {
                callback(.Success(data))
            } else if let error = error {
                callback(.Error(error))
            } else {
                callback(.Error(NSError(domain: "getData", code: 1337, userInfo: nil)))
            }
        }
        dataTask.resume()
    }
    
    class func getJson(url: NSURL, callback: Response<AnyObject> -> Void) {
        getData(url) {
            callback($0 >>= { data in
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                    return .Success(json)
                } catch {
                    return .Error(error)
                }
                })
        }
    }
    
    
    var jobTypes: [String] {
        return Array(Set(companies.flatMap({ $0.jobTypes }).map { $0.jobType })).sort(<)
    }
    
    var companyValues: [String] {
        return Array(Set(companies.flatMap({ $0.companyValues }).map { $0.companyValue })).sort(<)
    }
    
    var workWays: [String] {
        return Array(Set(companies.flatMap({ $0.workWays }).map { $0.workWay })).sort(<)
    }
    
    var continents: [String] {
        return Array(Set(companies.flatMap({ $0.continents }).map { $0.continent })).sort(<)
    }
    
    var workFields: [String] {
        return Array(Set(companies.flatMap({ $0.workFields }).map { $0.workField })).sort(<)
    }
    
    var educationTypes: [String] {
        return Array(Set(companies.flatMap({ $0.programmes }).map { $0.programme })).sort(<)
    }
    
    func dateFromString(string: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        let b = string.componentsSeparatedByString(":")
        return dateFormatter.dateFromString(b[0..<b.count-1].joinWithSeparator(":") + b[b.count-1])!
    }
    
    
    var programmes: [String] {
        return educationTypes
    }
    
    public func eventsFromJson( jsonOriginal: AnyObject) -> [ArmadaEvent] {
        let json = jsonOriginal["events"]
        
        return Array.removeNils((json as? [[String: AnyObject]])?.map { json -> ArmadaEvent? in
            if let title = json["title"] as? String,
                let summary = json["description"] as? String,
                let startDateString = json["starts_at"] as? String,
                let endDateString = json["ends_at"] as? String {
                    let location = json["location"] as? String
                    let signupLink = json["external_signup_link"] as? String
                    let signupStartDateString = json["signup_starts_at"] as? String
                    let signupEndDateString = json["signup_ends_at"] as? String
                    let signupStartDate: NSDate? = signupStartDateString != nil ? self.dateFromString(signupStartDateString!) : nil
                    let signupEndDate: NSDate? = signupEndDateString != nil ? self.dateFromString(signupEndDateString!) : nil
                    let title = title.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    let imageUrlString = json["picture_url"] as? String
                    let imageUrl: NSURL? = imageUrlString != nil ? NSURL(string: imageUrlString!) : nil
                    let summary = summary.stringByReplacingOccurrencesOfString("\\s+", withString: " ", options: .RegularExpressionSearch, range: nil)
                    return ArmadaEvent(title: title, summary: summary, location: location, startDate: self.dateFromString(startDateString), endDate: self.dateFromString(endDateString), signupLink: signupLink, signupStartDate: signupStartDate, signupEndDate: signupEndDate, imageUrl: imageUrl)
            }
            return nil
            } ?? []).filter({ $0.startDate.timeIntervalSince1970 >=  NSDate().timeIntervalSince1970 }).sort({ $0.startDate.timeIntervalSince1970 < $1.startDate.timeIntervalSince1970 })
    }
    
    public func newsFromJson(jsonOriginal: AnyObject) -> [News] {
        let json = jsonOriginal["news"]
        
        return Array.removeNils((json as? [[String: AnyObject]])?.map { json -> News? in
            if let title = json["title"] as? String,
                let content = json["content"] as? String,
                let date = json["date_published"] as? String{
                    return News(title: title, content: content, publishedDate: self.dateFromString(date))
            }
            return nil
            } ?? [])
    }
    
    public func sponsorsFromJson(jsonOriginal: AnyObject) -> [Sponsor] {
        let json = jsonOriginal["sponsors"]
        return Array.removeNils((json as? [[String: AnyObject]])?.map { json -> Sponsor? in
            if let name = json["name"] as? String ?? json["title"] as? String,
                let description = json["full_text"] as? String,
                let imageUrlString = json["logo_url"] as? String,
                let imageUrl = NSURL(string: imageUrlString),
                let websiteUrlString = json["website_url"] as? String,
                let websiteUrl = NSURL(string: websiteUrlString) {

                    let isMainPartner = json["main_partner"] as? Bool ?? false
                    let isMainSponsor = json["main_sponsor"] as? Bool ?? false
                    let isGreenPartner = json["green_partner"] as? Bool ?? false
                    return Sponsor(name: name, imageUrl: imageUrl, description: description, websiteUrl: websiteUrl, isMainPartner: isMainPartner, isMainSponsor: isMainSponsor, isGreenPartner: isGreenPartner)
                    
            }
            return nil
            } ?? [])
    }
    
    static let companiesFileName = "companies.json"
    
    static let dir = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as [String])[0]
    
    let apiUrl = "http://staging.armada.nu/api"
    
    func eventsFromServer(callback: Response<[ArmadaEvent]> -> Void) {
        _ArmadaApi.getJson(armadaUrlWithPath("events")) {
            callback($0.map(self.eventsFromJson))
        }
    }
    
    func newsFromServer(callback: Response<[News]> -> Void) {
        _ArmadaApi.getJson(armadaUrlWithPath("news")) {
            callback($0.map(self.newsFromJson))
        }
    }
    
    func sponsorsFromServer(callback: Response<[Sponsor]> -> Void) {
        _ArmadaApi.getJson(armadaUrlWithPath("sponsors")) {
            callback($0.map(self.sponsorsFromJson))
        }
    }
    
    func armadaUrlWithPath(path: String) -> NSURL {
        return NSURL(string: (apiUrl as NSString).stringByAppendingPathComponent(path))!
    }
    
    func pagesFromServer(callback: Response<AnyObject> -> Void) {
        _ArmadaApi.getJson(armadaUrlWithPath("pages")) {
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
}

extension Array {
    static func removeNils(array: [Element?]) -> [Element] {
        return array.filter { $0 != nil }.map { $0! }
    }
}

extension NSHTTPURLResponse {
    var etag: String? {
        return allHeaderFields["Etag"] as? String
    }
}