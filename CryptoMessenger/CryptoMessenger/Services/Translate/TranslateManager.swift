import Foundation

// MARK: - Language constants

let kLanguageEnglish = "en"
let kLanguageChinese = "zh-CN"
let kLanguageSpanish = "es"
let kLanguageItalian = "it"
let kLanguageFrench = "fr"
let kLanguageArabic = "ar"
let kLanguageGerman = "de"
let kLanguageRussian = "ru"

// swiftlint: disable: all

protocol TranslateManager {
    func translate(_ q: String, _ source: String, _ target: String, _ format: String, _ model: String, _ completion: @escaping ((_ text: String?, _ error: Error?) -> Void))
    func detect(_ q: String, _ completion: @escaping ((_ languages: [Detection]?, _ error: Error?) -> Void))
    func languages(_ target: String, _ model: String, _ completion: @escaping ((_ languages: [Language]?, _ error: Error?) -> Void))
    var isActive: Bool { get set }
}


public struct Language {
    let language: String
    let name: String
}

public struct Detection {
    let language: String
    let isReliable: Bool
    let confidence: Float
}

public class TranslateManagerAPI: TranslateManager {
    func translate(_ q: String, _ source: String, _ target: String, _ format: String = "text", _ model: String = "base", _ completion: @escaping ((_ text: String?, _ error: Error?) -> Void)) {
        guard var urlComponents = URLComponents(string: TranslateManagerAPI.API.translate.url) else {
            completion(nil, nil)
            return
        }
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "key", value: apiKey))
        queryItems.append(URLQueryItem(name: "q", value: q))
        queryItems.append(URLQueryItem(name: "target", value: target))
        queryItems.append(URLQueryItem(name: "source", value: source))
        queryItems.append(URLQueryItem(name: "format", value: format))
        queryItems.append(URLQueryItem(name: "model", value: model))
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            completion(nil, nil)
            return
        }
        
        debugPrint(urlComponents)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = API.translate.method
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data,                                // is there data
                  let response = response as? HTTPURLResponse,    // is there HTTP response
                  (200 ..< 300) ~= response.statusCode,            // is statusCode 2XX
                  error == nil else {                                // was there no error, otherwise ...
                completion(nil, error)
                return
            }
            
            guard let object = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any], let d = object["data"] as? [String: Any], let translations = d["translations"] as? [[String: String]], let translation = translations.first, let translatedText = translation["translatedText"] else {
                completion(nil, error)
                return
            }
            
            completion(translatedText, nil)
        }
        task.resume()
    }
    
    public func detect(_ q: String, _ completion: @escaping ((_ languages: [Detection]?, _ error: Error?) -> Void)) {
        guard var urlComponents = URLComponents(string: API.detect.url) else {
            completion(nil, nil)
            return
        }
        
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "key", value: apiKey))
        queryItems.append(URLQueryItem(name: "q", value: q))
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            completion(nil, nil)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = API.detect.method
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data,                                // is there data
                  let response = response as? HTTPURLResponse,    // is there HTTP response
                  (200 ..< 300) ~= response.statusCode,            // is statusCode 2XX
                  error == nil else {                                // was there no error, otherwise ...
                completion(nil, error)
                return
            }
            
            guard let object = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any], let d = object["data"] as? [String: Any], let detections = d["detections"] as? [[[String: Any]]] else {
                completion(nil, error)
                return
            }
            
            var result = [Detection]()
            for languageDetections in detections {
                for detection in languageDetections {
                    if let language = detection["language"] as? String, let isReliable = detection["isReliable"] as? Bool, let confidence = detection["confidence"] as? Float {
                        result.append(Detection(language: language, isReliable: isReliable, confidence: confidence))
                    }
                }
            }
            completion(result, nil)
        }
        task.resume()
    }
    
    public func languages(_ target: String, _ model: String, _ completion: @escaping ((_ languages: [Language]?, _ error: Error?) -> Void)) {
        guard var urlComponents = URLComponents(string: API.languages.url) else {
            completion(nil, nil)
            return
        }
        
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "key", value: apiKey))
        queryItems.append(URLQueryItem(name: "target", value: target))
        queryItems.append(URLQueryItem(name: "model", value: model))
        urlComponents.queryItems = queryItems
        
        guard let url =  urlComponents.url else {
            completion(nil, nil)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = API.languages.method
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data,                                // is there data
                  let response = response as? HTTPURLResponse,    // is there HTTP response
                  (200 ..< 300) ~= response.statusCode,            // is statusCode 2XX
                  error == nil else {                                // was there no error, otherwise ...
                completion(nil, error)
                return
            }
            
            guard let object = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any], let d = object["data"] as? [String: Any], let languages = d["languages"] as? [[String: String]] else {
                completion(nil, error)
                return
            }
            
            var result = [Language]()
            for language in languages {
                if let code = language["language"], let name = language["name"] {
                    result.append(Language(language: code, name: name))
                }
            }
            completion(result, nil)
        }
        task.resume()
    }
    
    
    // MARK: - Internal Properties
    
    public var languagesList: [Language] = []
    public var isActive = false
    public var source: String = ""
    public var target: String = kLanguageRussian
    
    /// API structure.
    ///
    public struct API {
        /// Base Google Translation API url.
        static let base = "https://translation.googleapis.com/language/translate/v2"
        /// A translate endpoint.
        struct translate {
            static let method = "POST"
            static let url = API.base
        }
        /// A detect endpoint.
        struct detect {
            static let method = "POST"
            static let url = API.base + "/detect"
        }
        /// A list of languages endpoint.
        struct languages {
            static let method = "GET"
            static let url = API.base + "/languages"
        }
    }
    /// API key.
    var apiKey: String!
    /// Default URL session.
    public let session = URLSession(configuration: .default)
    /**
     Initialization.
     
     
     - Parameters:
     - apiKey: A valid API key to handle requests for this API. If you are using OAuth 2.0 service account credentials (recommended), do not supply this parameter.
     */
    
    init() {
        self.start(with: "AIzaSyBjxzwADkUdbV1MzPO3c2FkME1Fqk2Lp8s")
    }
    
    public func start(with apiKey: String) {
        self.apiKey = apiKey
    }
}
