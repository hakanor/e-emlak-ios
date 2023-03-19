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
        let user = UserTestData.validUser
        userService.userToBeReturned = user
        
        // When
        sut.fetchUserCredentials()
        
        // Then
        XCTAssertTrue(delegate.fetchUserCalled)
        XCTAssertEqual(user.email, delegate.passedEmail)
        XCTAssertEqual(user.password, delegate.passedPassword)
        XCTAssertEqual(user.uid, delegate.passedUID)
    }
    
}

final class MockChangePasswordViewModelDelegate: ChangePasswordViewModelDelegate{
    
    var fetchUserCalled = false
    var passedPassword: String?
    var passedEmail: String?
    var passedUID: String?
    
    func didFetchUser(password: String, email: String, uid: String) {
        fetchUserCalled = true
        passedPassword = password
        passedEmail = email
        passedUID = uid
    }
}

final class MockUserService: UserServicable {
    var userToBeReturned: User = UserTestData.validUser
    
    func fetchUser(completion: @escaping(User) -> Void) {
        completion(userToBeReturned)
    }
}

enum UserTestData {
    static let validUser = User(uid: "il8EDi5fBWOrVpYQAAobna5NJAW2", dictionary: [
        "name": "Hakan",
        "surname": "Or",
        "email": "hakanor99@gmail.com",
        "phoneNumber": "0534-612-6042",
        "imageUrl": "https://example.com/avatar.png",
        "password": "password",
        "aboutMe": "aboutMe",
        "city": "Konya"
    ] as [String : AnyObject])
}
