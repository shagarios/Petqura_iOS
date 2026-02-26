//
//  MobileNumberRegistrationViewModelTests.swift
//  PawWalkerTests
//
//  Created by shagar on 12/12/24.
//

import XCTest
@testable import PawWalker
final class MobileNumberRegistrationViewModelTests: XCTestCase {

    private var sut : MobileNumberRegistrationViewModel!
    
    
    override func setUp() {
        super.setUp()
        sut = MobileNumberRegistrationViewModel(coordinator: AccountCoordinator())
    }
    func testInvalidName() {
        XCTAssertFalse(sut.isValidName(name: "1234nadd"))
        XCTAssertFalse(sut.isValidName(name: "4567i8"))
        XCTAssertFalse(sut.isValidName(name: "!@shagar"))
        XCTAssertFalse(sut.isValidName(name: "shagar."))
    }
   
    func testValidName() {
        XCTAssertTrue(sut.isValidName(name: "shagar"))
        XCTAssertTrue(sut.isValidName(name: "sha gar"))
        XCTAssertTrue(sut.isValidName(name: "shagar pk"))
        XCTAssertTrue(sut.isValidName(name: "shagar c"))
        XCTAssertTrue(sut.isValidName(name: " shagar"))
        XCTAssertTrue(sut.isValidName(name: "shagar "))
        XCTAssertTrue(sut.isValidName(name: "ab"))
    }
    
    func testInValidMobileNumber()  {
      //  XCTAssertTrue(sut.isValidMobileNumber(number: number))
        XCTAssertFalse(sut.isValidMobileNumber(number: "1234"))
        XCTAssertFalse(sut.isValidMobileNumber(number: "12345678901123445"))
        XCTAssertFalse(sut.isValidMobileNumber(number: "abcdefghqw"))
        XCTAssertFalse(sut.isValidMobileNumber(number: "9746 349098"))
        XCTAssertFalse(sut.isValidMobileNumber(number: "1234567890"))
    }
    func testValidMobileNumber() {
        XCTAssertTrue(sut.isValidMobileNumber(number: "9746349098"))
    }
    //MARK: email validation
    
    func testValidEmail() {
        sut.email = "shaagar@gmail.com"
        XCTAssertTrue(sut.isEmailValid(),  "Valid email should return true")
    }
    func testInvalidEmail() {
        sut.email = "shagar"
        XCTAssertFalse(sut.isEmailValid(), "Invalid email should return false")
    }
    func testInValidSpaceEMail() {
        sut.email = "shagar @gmail.com"
        XCTAssertFalse(sut.isEmailValid(), "Invalid email should return false")
    }
    func testInValidSpaceEmty() {
        sut.email = "shag@gmailcom"
        XCTAssertFalse(sut.isEmailValid(), "Invalid email should return false")
    }
    func testInValidSpaceWithoutCom() {
        sut.email = "shag@gmail.in"
        XCTAssertTrue(sut.isEmailValid(), "Invalid email should return false")
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

}
