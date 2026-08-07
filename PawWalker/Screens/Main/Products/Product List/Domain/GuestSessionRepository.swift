//
//  GuestSessionRepository.swift
//  PawWalker
//
//  Created by shagar on 07/08/26.
//

import Foundation

protocol GuestSessionRepository {
    func fetchGuestId()  -> String
    func updateGuestId(guestId: String)
    func deleteGuestId()
}
