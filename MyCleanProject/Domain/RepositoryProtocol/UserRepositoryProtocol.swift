//
//  UserRepositoryProtocol.swift
//  MyCleanProject
//
//  Created by elly on 10/22/24.
//

import Foundation

public protocol UserRepositoryProtocol {
    /// 유저 리스트 불러오기 (원격)
    func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError>
    
    /// 전체 즐겨찾기 리스트 불러오기
    func getFavoriteUsers() -> Result<[UserListItem], CoreDataError>
    
    /// 즐겨찾기 유저 저장
    func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoreDataError>
    
    /// 즐겨찾기 유저 삭제
    func deleteFavoriteUser(userID: Int) -> Result<Bool, CoreDataError>
    
}
