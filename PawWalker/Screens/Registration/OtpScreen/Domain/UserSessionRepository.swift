//
//  UserSessionRepository.swift
//  PawWalker
//
//  Created by shagar on 07/08/26.
//

import Foundation

protocol UserSessionRepository {
    func fetchUser() -> User? 
}
