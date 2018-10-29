import UIKit
import CoreData
import SwiftyJSON

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
    public let passedDays: Int
    
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
    public let imageUrlWide: String
    public let imageUrlSquare: String
    public var content: String
    public let ingress: String
    public let publishedDate: Date
    public let featured: Bool
    public let contentUrl: String
}

public struct ArmadaMember: Equatable {
    let name: String
    let imageUrl: URL?
    let role: String
}

public struct ArmadaBanquetPlacement {
    let firstName: String
    let lastName: String
    let linkedinUrl: URL?
    let table: Int
    let seat: Int
    let jobTitle: String
    public init?(json: AnyObject){
        if let firstName = json["first_name"] as? String,
            let lastName = json["last_name"] as? String,
            let seat = json["seat"] as? Int {
            
            var table: Int = 0
            if let tmp = json["table"] as? Int{
                table = tmp
            }else if let tmpString =  json["table"] as? String,
                let tmp = Int(tmpString) {
                table = tmp
            }
            
            self.firstName = firstName
            self.lastName = lastName
            self.table = table
            self.seat = seat
            self.jobTitle = json["job_title"] as? String ?? "No title"
            if let urlString = json["linkedin_url"] as? String,
                urlString.characters.count > 5 {
                
                self.linkedinUrl = URL(string: urlString)
            } else {
                self.linkedinUrl = nil
            }
            return 
        }
        return nil
    }
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
    case Diversity = "icon_diversity"
    case Sustainability = "icon_sustainability"
    
    static var All: [ArmadaField] {
        return [.Startup, .Diversity, .Sustainability]
    }
    
    var title: String {
        switch self {
        case .Startup: return "Startup"
        case .Diversity: return "Diversity"
        case .Sustainability: return "Sustainability"
        }
    }
    
    var image: UIImage {
        switch self {
        case .Startup: return UIImage(named: "Rocket")!
        case .Diversity: return UIImage(named: "diversity")!
        case .Sustainability: return UIImage(named: "sustainability")!
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
            //throw NSError(domain: "fake error", code: 1, userInfo: nil)
            if !databaseExists {
                print("persistentStoreCoordinator does not exist - copying from bundle")
                try self.copyDatabaseFromBundle()
            } else {
                print("persistentStoreCoordinator exists")
            }
            
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.persistentStoreUrl, options: nil)
        } catch {
            try? self.deleteDatabase() // Silently fail and hope the coming operations work if we cant delete the db
            do {
                //throw NSError(domain: "fake error", code: 2, userInfo: nil)
                print("persistentStoreCoordinator fucked up - deleting database")
                if databaseExists {
                    print("persistentStoreCoordinator old database sucked - testing bundle")
                    try self.copyDatabaseFromBundle()
                }
                try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.persistentStoreUrl, options: nil)
            } catch {
                print("persistentStoreCoordinator - the bundle sucked too")
                try? self.deleteDatabase() // Silently fail and hope the coming operations work if we cant delete the db
                do {
                    //throw NSError(domain: "fake error", code: 3, userInfo: nil)
                    try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.persistentStoreUrl, options: nil)
                } catch {
                    print("persistentStoreCoordinator oh god - we messed up - goodbye")
                    debugPrint(error)
                    print("This might not be as bad as we think, lets try without a persistent store. Exciting!")
                    //This gives a far worse user experience, but at least the app works.
                    //abort()
                    
                }
                
            }
        }
        return persistentStoreCoordinator
    }()
    

    static let dir = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true) as [String])[0]
    
    let apiUrl = "https://ais.armada.nu/api"
    let newsUrl = "http://armada.nu"
    let matchUrl = "http://gotham.armada.nu/api/questions"
    
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
                    let date = Date()
                    let calendar = Calendar.current
                if(calendar.component(.year, from: startDate) < calendar.component(.year, from: date)){
                    return nil
                }
                    let endDate = Date(timeIntervalSince1970: TimeInterval(endDateTimestamp))
                    let location = json["location"] as? String
                    let summaryWithoutHtml = description.strippedFromHtmlString
                    let signupLink = json["signup_link"] as? String
                    let registrationStartDate: Date?
                    let date2 = calendar.startOfDay(for: endDate)
                    let date1 = calendar.startOfDay(for: Date())
                    let start = calendar.ordinality(of: .day, in: .era, for: date1)!
                    let end = calendar.ordinality(of: .day, in: .era, for: date2)!
                    var diff = end - start
                    if(diff > 0){
                        diff = 0
                    }
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
                    let summary = description
                    let registrationRequired = json["registration_required"] as? Bool ?? true
                return ArmadaEvent(title: name, summary: summary, summaryWithoutHtml: summaryWithoutHtml, location: location, startDate: startDate, endDate: endDate, signupLink: signupLink, signupStartDate: registrationStartDate, signupEndDate: registrationEndDate, imageUrl: imageUrl, registrationRequired: registrationRequired, passedDays: diff)
            }
            return nil
            } ?? []).sorted(by: { $0.startDate.timeIntervalSince1970 < $1.startDate.timeIntervalSince1970 }).sorted(by: { $0.passedDays > $1.passedDays })
        return events
    }
    

    
    open func newsFromJson(_ json: AnyObject) -> [News] {
        return Array.removeNils((json as? [[String: AnyObject]])?.map { json -> News? in
            if((json["layout"] as? String) == "News"){
                if let title = json["title"] as? String,
                let contentUrl = json["__url"] as? String,
                let dateTimestamp = json["date"] as? String{
                    let featured = json["featured"] as? Bool != nil ? json["featured"] as! Bool: false
                    let imageUrlWide = json["cover_wide"] as? String != nil ? newsUrl + (json["cover_wide"] as? String)! : ""
                    let imageUrlSquare = json["cover_square"] as? String != nil ? newsUrl + (json["cover_square"] as? String)! : ""
                    let ingress = json["ingress"] as? String != nil ? json["ingress"] as! String : ""

                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    let publishedDate = dateFormatter.date(from: dateTimestamp)!
                    var date = Date()
                    date = date.addingTimeInterval(7200)
                    if (date < publishedDate){
                        return nil
                    }
                    return News(title: title, imageUrlWide : imageUrlWide.replacingOccurrences(of: " ", with: "%20"), imageUrlSquare: imageUrlSquare.replacingOccurrences(of: " ", with: "%20"), content: "", ingress: ingress, publishedDate: publishedDate, featured: featured, contentUrl: newsUrl + contentUrl)
                }
            }
            return nil
            } ?? []).sorted(by: { $0.publishedDate > $1.publishedDate })
    }
    
    open func sponsorsFromJson(_ json: AnyObject) -> [Sponsor] {
        return Array.removeNils((json as? [[String: AnyObject]])?.map { json -> Sponsor? in
            if let name = json["name"] as? String,
                let imageUrlString = json["logo_url"] as? String,
                let imageUrl = URL(string: imageUrlString),
                let websiteUrlString = json["link_url"] as? String,
                let websiteUrl = URL(string: websiteUrlString) {
                    let description = json["full_text"] as? String ?? ""
                    let isMainPartner = json["is_main_partner"] as? Bool ?? false
                    return Sponsor(name: name, imageUrl: imageUrl, description: description, websiteUrl: websiteUrl, isMainPartner: isMainPartner)
                    
            }
            return nil
            } ?? [])
    }
    
    open func organisationGroupsFromJson(_ jsonOriginal: AnyObject) -> [ArmadaGroup] {
        var organisationGroups = [ArmadaGroup]()
        if let json = jsonOriginal as? [AnyObject] {
            for roleJson in json {
                var members = [ArmadaMember]()
                if let groupTitle = roleJson["role"] as? String,
                    let roleJson = roleJson["people"] as? [AnyObject],
                    groupTitle != "Armada" {//Everybody is in the correct group and armada group, so ignore the armada group.
                    
                    for memberJson in roleJson {
                        if let name = memberJson["name"] as? String,
                            let imageUrlString = memberJson["picture"] as? String {
                            let imageUrl = URL(string: imageUrlString)
                            members += [ArmadaMember(name: name, imageUrl: imageUrl, role: groupTitle)]
                        }
                    }
                    if members.count != 0 {//Some groups are empty, we dont want those
                        organisationGroups += [ArmadaGroup(name: groupTitle, members: members)]
                    }
                }
            }
        }
        return organisationGroups
    }
    
    public func banquetPlacementFromJson(_ jsonOriginal: [AnyObject]) -> [ArmadaBanquetPlacement] {
        if let json = jsonOriginal as? [AnyObject]{
            return json.flatMap { ArmadaBanquetPlacement(json: $0) }
        }
        return []
    }

    
    func eventsFromServer(_ callback: @escaping (Response<[ArmadaEvent]>) -> Void) {
        armadaUrlWithPath("events").getJson() {
            callback($0.map(self.eventsFromJson))
        }
    }
    
    
    func parseHTML(HTMLContent: String)->Any{
        let collections = HTMLContent.components(separatedBy: "window.__COLLECTION__ = [")
        let news = collections[1].components(separatedBy: "];")
        let test = "[" + news[0] + "]"
        var data: NSData = test.data(using: String.Encoding.utf8)! as NSData
        do{
            let json = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions())
                return json
        }
        catch{
        }
        return []
    }
    
    func newsFromServer(_ callback: @escaping (Array<News>, Bool, String) -> Void) {
        let request = NSMutableURLRequest(url: (URL(string: newsUrl))!)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if (data == nil){
                callback(Array<News>(), true, (error?.localizedDescription)!)
            }
            else{
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                let newsJson = self.parseHTML(HTMLContent: responseString! as String)
                var newsObjects = self.newsFromJson(newsJson as AnyObject)
                if (newsObjects.count == 0){}
                 else if(newsObjects[0].featured != true && newsObjects.count > 1){
                    for i in 1 ... newsObjects.count-1{
                        if(newsObjects[i].featured == true){
                            let tempNews = newsObjects[i]
                            newsObjects.remove(at: i)
                            newsObjects.insert(tempNews, at: 0)
                            break
                        }
                    }
                }
                callback(newsObjects, false, "")
            }
        }.resume()
    }
    
    func getNewsContent(_ json: Any, url: String) -> String{
        let content = json as! [String: Any]
        let json = content["pages"] as! [String: Any]
        let newsArticle = json[(url.components(separatedBy: newsUrl)[1])] as! [String: AnyObject]
        var news = newsArticle["body"] as! String
        news = news.replacingOccurrences(of: ">#<", with: "><")
        news = news.replacingOccurrences(of: "img src=\"/assets", with: "img src=\"https://armada.nu")
        return news
    }
    
    
  func parseNewsContent(content: String, urlString: String)->String{
        let splitContent = content.components(separatedBy: "window.__INITIAL_STATE__ =")
        if (splitContent.count < 2){
            return ""
        }
        let jsonFormat = splitContent[1].components(separatedBy: "</script>")
        let data: NSData = jsonFormat[0].data(using: String.Encoding.utf8)! as NSData
        do{
            let json = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions())
            return getNewsContent(json, url: urlString)
        }
        catch{
        }
        return ""       
    }
    
    func newsContentFromServer(contentUrl: String,_ callback: @escaping (String) -> Void){
        let request = NSMutableURLRequest(url: (URL(string: contentUrl))!)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if(data == nil){
                callback("")
            }
            else{
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            callback(self.parseNewsContent(content: responseString! as String, urlString: contentUrl))
            }
        }.resume()
    }
    
    func sponsorsFromServer(_ callback: @escaping (Response<[Sponsor]>) -> Void) {
        armadaUrlWithPath("partners").getJson() {
            callback($0.map(self.sponsorsFromJson))
        }
    }
    
    
    func organisationGroupsFromServer(_ callback: @escaping (Response<[ArmadaGroup]>) -> Void) {
        armadaUrlWithPath("organization").getJson() {
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
    func banquetPlacementFromServer(_ callback: @escaping (Response<AnyObject>) -> Void) {
        armadaUrlWithPath("banquet_placement").getJson(callback)
    }
    
    func banquetPlacementsFromServer(_ callback: @escaping (Response<[(table: Int, people: [ArmadaBanquetPlacement])]>) -> Void) {
        banquetPlacementFromServer {
            switch $0 {
            case .success(let json):
                if let json = json as? [AnyObject]{
                    let placements = self.banquetPlacementFromJson(json)
                    let tables = Array(Set(placements.map{ $0.table }))
                    let result = tables.map{ table in (table, placements.filter{ $0.table == table })}
                    callback(.success(result))
                }else{
                    callback(.error(NSError(domain: "banquetPlacementsFromServer", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse result from server"])))
                }
            case .error(let error):
                callback(.error(error))
            }
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
