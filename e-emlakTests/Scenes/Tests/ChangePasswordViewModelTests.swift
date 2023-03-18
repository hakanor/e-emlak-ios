//
//  ChangePasswordViewModelTests.swift
//  e-emlakTests
//
//  Created by Hakan Or on 18.03.2023.
//

import XCTest
@testable import e_emlak

final class ChangePasswordViewModelTests: XCTestCase {
    private var sut: ChangePasswordViewModel!
    private var userService: MockUserService!
    private var delegate: MockChangePasswordViewModelDelegate!

    override func setUpWithError() throws {
        try super.setUpWithError()
        userService = MockUserService()
        sut = ChangePasswordViewModel(userService: userService)
        delegate = MockChangePasswordViewModelDelegate()
        sut.delegate = delegate
    }
    
    override func tearDownWithError() throws {
        sut = nil
        delegate = nil
        userService = nil
        try super.tearDownWithError()
    }
    
    func test_did_fetch_user_should_be_called_when_fetchUserCredentials_called() {
        // Given
        
        // When
        sut.fetchUserCredentials()
        
        // Then
        XCTAssertTrue(delegate.fetchUserCalled)
    }
    
}

final class MockChangePasswordViewModelDelegate: ChangePasswordViewModelDelegate{
    
    var fetchUserCalled = false
    
    func didFetchUser(password: String, email: String, uid: String) {
        fetchUserCalled = true
    }
}

final class MockUserService: UserServicable {
    
    let mockUser = User(uid: "il8EDi5fBWOrVpYQAAobna5NJAW2", dictionary: [
        "name": "Hakan",
        "surname": "Or",
        "email": "hakanor99@gmail.com",
        "phoneNumber": "0534-612-6042",
        "imageUrl": "https://example.com/avatar.png",
        "password": "password",
        "aboutMe": "aboutMe",
        "city": "Konya"
    ] as [String : AnyObject])
    
    func fetchUser(completion: @escaping(User) -> Void) {
        completion(mockUser)
    }
}
