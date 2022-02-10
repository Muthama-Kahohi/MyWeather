//
//  NetworkManager.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 06/02/2022.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol NetworkRequest {
    associatedtype Response
    
    var url: String { get }
    var method: HTTPMethod { get }
    var queryItems: [String : String] { get set }
    
    func decode(_ data: Data) throws -> Response
}

extension NetworkRequest where Response: Decodable {
    func decode(_ data: Data) throws -> Response {
        return try JSONDecoder().decode(Response.self, from: data)
    }
}

protocol NetworkService {
    func request<Request: NetworkRequest>(_ request: Request, completion: @escaping (Result<Request.Response, MyWeatherError>) -> Void)
    func buildUrl(path: String, queryItems: [String: String]) -> URL?
}

final class NetworkManager: NetworkService {
    
    static let shared = NetworkManager()
    
    func request<Request: NetworkRequest>(_ request: Request, completion: @escaping (Result<Request.Response, MyWeatherError>) -> Void) {
        
        guard let url = buildUrl(path: request.url, queryItems: request.queryItems) else {
            return completion(.failure(MyWeatherError.custom(404,  "url_build_error".localized())))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let _ = error {
                return completion(.failure(MyWeatherError.custom(1, "error_found_text".localized())))
            }
                        
            if let urlResponse = response as? HTTPURLResponse {
                let code = urlResponse.statusCode
                guard 200..<300 ~= code else {
                    return completion(.failure(MyWeatherError.custom(1, "error_found_text".localized())))
                }
            } else {
                return completion(.failure(MyWeatherError.custom(1, "error_found_text".localized())))
            }
            
            guard let responseData = data else {
                return completion(.failure(MyWeatherError.custom(1, "error_found_text".localized())))
            }
            
            do {
                try completion(.success(request.decode(responseData)))
            } catch _ {
                return completion(.failure(MyWeatherError.custom(1, "error_found_text".localized())))
            }
        }
        .resume()
    }
    
    func buildUrl(path: String, queryItems: [String: String]) -> URL? {
        let queries = queryItems.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        var components = URLComponents()
        components.scheme = URLS.scheme
        components.host = URLS.weatherHost
        components.path = path
        components.queryItems = queries
        
        return components.url
    }
}
