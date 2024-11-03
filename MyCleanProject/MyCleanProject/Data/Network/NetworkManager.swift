//
//  NetworkManager.swift
//  MyCleanProject
//
//  Created by elly on 10/22/24.
//

import Foundation
import Alamofire

protocol NetworkManagerProtocol {
    func fetchData<T: Decodable>(url: String, method: HTTPMethod, parameters: Parameters?) async -> Result<T, NetworkError>
}

public class NetworkManager: NetworkManagerProtocol {
    private let session: SessionProtocol
    private let apiToken: String
    
    init(session: SessionProtocol) {
        self.session = session
        guard let token = Environment.value(for: "API_TOKEN") else {
                    fatalError("API Token is missing in the .env file")
                }
        self.apiToken = token
    }
    
    private lazy var tokenHeader: HTTPHeaders = {
        let tokenHeader = HTTPHeader(name: "Authorization", value: apiToken)
        return HTTPHeaders([tokenHeader])
    }()
    
    func fetchData<T: Decodable>(url: String, method: HTTPMethod, parameters: Parameters?) async -> Result<T, NetworkError> {
        guard let url = URL(string: url) else { return .failure(.urlError) }
        let result = await session.request(url, method: method, parameters: parameters, headers: tokenHeader).serializingData().response
        if let error = result.error { return .failure(.requestFailed(error.localizedDescription))}
        guard let data = result.data else { return .failure(.dataNil)}
        guard let response = result.response else { return .failure(.invalidResponse)}
        if 200..<400 ~= response.statusCode {
            do {
                let data = try JSONDecoder().decode(T.self, from: data)
                return .success(data)
            } catch {
                return .failure(.failToDecode(error.localizedDescription))
            }
        } else {
            return .failure(.serverError(response.statusCode))
        }
    }
}
