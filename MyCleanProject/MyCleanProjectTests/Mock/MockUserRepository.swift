//
//  MockUserRepository.swift
//  MyCleanProject
//
//  Created by elly on 10/26/24.
//

import Foundation
@testable import MyCleanProject

public struct MockUserRepository: UserRepositoryProtocol {
    public func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError> {
        .failure(.dataNil)
    }
    
    public func getFavoriteUsers() -> Result<[UserListItem], CoreDataError> {
        .failure(.entityNotFound(""))
    }
    
    public func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoreDataError> {
        .failure(.entityNotFound(""))
    }
    
    public func deleteFavoriteUser(userID: Int) -> Result<Bool, CoreDataError> {
        .failure(.entityNotFound(""))
    }
}
