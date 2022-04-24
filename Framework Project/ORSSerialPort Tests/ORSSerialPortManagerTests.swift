//
//  ORSSerialPortManagerTests.swift
//  ORSSerialPort Tests
//
//  Created by John Aguilar on 4/24/22.
//  Copyright © 2022 Open Reel Software. All rights reserved.
//

import XCTest
@testable import ORSSerial

class ORSSerialPortManagerTests: XCTestCase {

    var portConnectedExpectation: XCTestExpectation?
    var portDisconnectedExpectation: XCTestExpectation?
    
    override func setUpWithError() throws {
        registerNotificationObservers()
    }

    override func tearDownWithError() throws {
    }

    func testConnect() throws {
        let ports = ORSSerialPortManager.shared().availablePorts
        print("Connected ports \(ports)")
        
        // Wait for a port to be connected
        portConnectedExpectation = expectation(description: "Wait for port to be connected")
        waitForExpectations(timeout: 20)
    }

    func testDisconnect() throws {
        let ports = ORSSerialPortManager.shared().availablePorts
        print("Connected ports \(ports)")
        
        // Wait for a port to be connected
        portDisconnectedExpectation = expectation(description: "Wait for port to be disconnected")
        waitForExpectations(timeout: 20)
    }
}

extension ORSSerialPortManagerTests {
    
    private func registerNotificationObservers() {
        NotificationCenter.default.addObserver(forName: .ORSSerialPortsWereConnected, object: nil, queue: nil) { [weak self] notification in
            guard let ports = notification.userInfo?[ORSConnectedSerialPortsKey] as? [ORSSerialPort] else { return }
            
            print("Connected Ports \(ports)")
            self?.portConnectedExpectation?.fulfill()
        }
        
        NotificationCenter.default.addObserver(forName: .ORSSerialPortsWereDisconnected, object: nil, queue: nil) { [weak self] notification in
            guard let ports = notification.userInfo?[ORSDisconnectedSerialPortsKey] as? [ORSSerialPort] else { return }
            
            print("Disconnected Ports \(ports)")
            self?.portDisconnectedExpectation?.fulfill()
        }
    }
    
}
