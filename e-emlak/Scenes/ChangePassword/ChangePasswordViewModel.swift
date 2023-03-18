//
//  ChangePasswordViewModel.swift
//  e-emlak
//
//  Created by Hakan Or on 18.03.2023.
//

protocol ChangePasswordViewModelDelegate: AnyObject {
    func didFetchUser(password: String, email: String, uid: String)
}

final class ChangePasswordViewModel {
    weak var delegate: ChangePasswordViewModelDelegate?
    
    private let userService: UserServicable
    
    init(userService: UserServicable = UserService.shared) {
        self.userService = userService
    }

    func fetchUserCredentials(){
        userService.fetchUser { [weak self] user in
            self?.delegate?.didFetchUser(password: user.password, email: user.email, uid: user.uid)
        }
    }
}
