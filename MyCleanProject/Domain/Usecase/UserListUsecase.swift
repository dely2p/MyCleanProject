//
//  UserListUsecase.swift
//  MyCleanProject
//
//  Created by elly on 10/22/24.
//

import Foundation

public protocol UserListUsecaseProtocol {
    /// 유저 리스트 불러오기 (원격)
    func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError>
    
    /// 전체 즐겨찾기 리스트 불러오기
    func getFavoriteUsers() -> Result<[UserListItem], CoreDataError>
    
    /// 즐겨찾기 유저 저장
    func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoreDataError>
    
    /// 즐겨찾기 유저 삭제
    func deleteFavoriteUser(userID: Int) -> Result<Bool, CoreDataError>
    
    
    /// 배열 -> Dicttionary [초성: [유저리스트]]
    func checkFavoriteState(fetchUsers: [UserListItem], favoriteUsers: [UserListItem]) -> [(user: UserListItem, isFavorite: Bool)]
    
    /// 유저리스트 - 즐겨찾기 포함된 유저인지
    func convertListToDictionary(favoriteUsers: [UserListItem]) -> [String: [UserListItem]]
}

public struct UserListUsercase: UserListUsecaseProtocol {
    
    private let repository: UserRepositoryProtocol
    
    private var fetchUserList: [UserListItem] = []
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    public func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError> {
        await repository.fetchUser(query: query, page: page)
        
//        if page == 1 {
//            fetchUserList.accept(users.items)
//        } else {
//            fetchUserList.accept(fetchUserList.value + users.items)
//        }
    }
    
    public func getFavoriteUsers() -> Result<[UserListItem], CoreDataError> {
        repository.getFavoriteUsers()
    }
    
    public func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoreDataError> {
        repository.saveFavoriteUser(user: user)
    }
    
    public func deleteFavoriteUser(userID: Int) -> Result<Bool, CoreDataError> {
        repository.deleteFavoriteUser(userID: userID)
    }
    
    public func checkFavoriteState(fetchUsers: [UserListItem], favoriteUsers: [UserListItem]) -> [(user: UserListItem, isFavorite: Bool)] {
        let favoriteSet = Set(favoriteUsers)
        return fetchUsers.map { user in
            let isFavorite = favoriteSet.contains(user)
            return (user: user, isFavorite: isFavorite)
        }
    }
    
    public func convertListToDictionary(favoriteUsers: [UserListItem]) -> [String : [UserListItem]] {
        return favoriteUsers.reduce(into: [String : [UserListItem]]()) { dict, user in
            if let firstString = user.login.first {
                let key = String(firstString).uppercased()
                dict[key, default: []].append(user)
            }
        }
    }
}
