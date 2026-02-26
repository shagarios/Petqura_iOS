//
//  SaveAddressViewModelTests.swift
//  PawWalkerTests
//
//  Created by shagar on 06/03/25.
//

import XCTest
@testable import PawWalker

final class SaveAddressViewModelTests: XCTestCase {
    private var sut :  NewAddressViewModel!
    
    override func setUp() {
        super.setUp()
        sut = NewAddressViewModel(isEdit: false, address: nil)
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    //MARK: MOBILE NUMBER TEST CASES
    
    func testMobileNumberValid() {
        sut.mobileNumber = "1234567890"
        XCTAssertTrue(sut.isMobileValid(), "Valid 10-digit mobile number should return true")
    }
    func testMobileNumberInvalid() {
        sut.mobileNumber = "123454"
        XCTAssertFalse(sut.isMobileValid(), "Invalid mobile number should return false")
    }
    func testMobileNumberEmpty() {
        sut.mobileNumber = ""
        XCTAssertFalse(sut.isMobileValid())
    }
    
    //MARK: ZIPCODE TEST CASES
    
    func testZipCodeValid() {
        sut.zipcode = "123456"
        XCTAssertTrue(sut.isZipCodeValid(), "Valid 6-digit zip should return true")
    }
    
    func testZipCodeISInvalid() {
        sut.zipcode = "1234567890"
        XCTAssertFalse(sut.isZipCodeValid(), "Invalid zip code should return false")
    }
    
    func testZipCOdeEmpty() {
        sut.zipcode = ""
        XCTAssertFalse(sut.isZipCodeValid(), "Invalid zip code should return false")
    }
    func testAllfieldsAreValid() {
        sut.fullName = "John Doe"
        sut.mobileNumber = "1234567890"
        sut.email = "test@example.com"
        sut.addressLine = "123 Street"
        sut.city = "banglure"
        sut.state = "kerala"
        sut.zipcode = "123456"
        XCTAssertTrue(sut.isAllFieildISValid(), "All fields correctly filled should return true")
    }
    
    func testAllfieldsAreInvalid() {
        sut.fullName = ""
        sut.mobileNumber = "12345"
        sut.email = ""
        sut.addressLine = ""
        sut.city = ""
        sut.state = ""
        sut.zipcode = "12"
        XCTAssertFalse(sut.isAllFieildISValid(), "Missing required fields should return false")
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
    
}
