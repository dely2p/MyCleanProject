//
//  MyCleanProjectTests.swift
//  MyCleanProjectTests
//
//  Created by elly on 10/14/24.
//

import XCTest
@testable import MyCleanProject

final class UserUsecaseTests: XCTestCase {
    var usecase: UserListUsecaseProtocol!
    var repository: UserRepositoryProtocol!
    override func setUp() {
        super.setUp()
        repository = MockUserRepository()
        usecase = UserListUsercase(repository: repository)
    }
    
    func testCheckFavoriteState() {
        let favoriteUsers = [
            UserListItem(id: 1, login: "user1", imageURL: ""),
            UserListItem(id: 2, login: "user2", imageURL: "")
        ]
        
        let fetchUsers = [
            UserListItem(id: 1, login: "user1", imageURL: ""),
            UserListItem(id: 3, login: "user2", imageURL: "")
        ]
        
        let result = usecase.checkFavoriteState(fetchUsers: fetchUsers, favoriteUsers: favoriteUsers)
        
        XCTAssertEqual(result[0].isFavorite, true)
        XCTAssertEqual(result[1].isFavorite, false)
    }
    
    func testConvertListToDictionary() {
        let users = [
            UserListItem(id: 1, login: "Alice", imageURL: ""),
            UserListItem(id: 1, login: "Bob", imageURL: ""),
            UserListItem(id: 1, login: "Charlie", imageURL: ""),
            UserListItem(id: 1, login: "ash", imageURL: ""),
        ]
        
        let result = usecase.convertListToDictionary(favoriteUsers: users)
        
        XCTAssertEqual(result.keys.count, 3)
        XCTAssertEqual(result["A"]?.count, 2)
        XCTAssertEqual(result["B"]?.count, 1)
        XCTAssertEqual(result["C"]?.count, 1)
    }
    
    override func tearDown() {
        repository = nil
        usecase = nil
        super.tearDown()
    }
}
