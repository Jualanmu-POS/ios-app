//
//  JualanMuTests.swift
//  JualanMuTests
//
//  Created by Azmi Muhammad on 25/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import XCTest
@testable import JualanMu

class JualanMuTests: XCTestCase {
    
    private var repo: ReportRepo!
    private var validation: Validation!
    
    private let numeric = "123456"
    private let campuran = "asd12314"

    override func setUp() {
        repo = ReportRepo(transactionRepo: TransactionRepo())
        validation = BaseValidation()
    }

    override func tearDown() {
        repo = nil
    }

    func testExample() {
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
