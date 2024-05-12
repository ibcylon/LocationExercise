//
//  LocationExerciseTests.swift
//  LocationExerciseTests
//
//  Created by kangho lee on 4/28/24.
//

import XCTest
@testable import LocationExercise
final class LocationExerciseTests: XCTestCase {
  var sut: KakaoClient?
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    sut = KakaoClientImpl()
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  // Test Case 1
  // implement test code of LocationService.convertAddressToLocation
  // Given string location
  // When convertAddressToLocation
  // Then return CLLocation
  
//  func testExample() throws {
//    // This is an example of a functional test case.
//    // Use XCTAssert and related functions to verify your tests produce the correct results.
//    // Any test you write for XCTest can be annotated as throws and async.
//    // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//    // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//    let exp = expectation(description: "asd")
//    let service = LocationService()
//    
//    Task {
//      let location = try await service.convertAddressToLocation(address: "서울시 성북구 성북동")
//      print("location" ,location)
//      exp.fulfill()
//    }
//    
//    wait(for: [exp], timeout: 4)
//  }
  
  func testsearchFromAddress() throws {
    let searchExp = expectation(description: "search")
    
    Task.init {
      do {
        let response = try await self.sut?.searchFromAddress(address: "서울시 성북구 성북동").toDomain()
        print(response?.description)
        searchExp.fulfill()
      } catch {
        if case let NetworkError.errorResponse(message: message) = error {
          print(message)
          searchExp.fulfill()
        } else {
          if let error = error as? NetworkError {
            print(error.message)
          } else {
            print(error.localizedDescription)
          }
          searchExp.fulfill()
          XCTFail()
        }
      }
    }
    wait(for: [searchExp], timeout: 10)
  }
  
  func testCoordinate() throws {
    let coordinatExp = expectation(description: "coordinate")
    
    Task.init {
      do {
        let response = try await self.sut?.searchFromPoint(longitude: 127.003274531869, latitude: 37.591046609396).toDomain()
        print(response?.description)
        coordinatExp.fulfill()
      } catch let error as NetworkError {
        print(error.message)
        coordinatExp.fulfill()
      } catch {
        print(error.localizedDescription)
        coordinatExp.fulfill()
        XCTFail()
      }
    }
    
    wait(for: [coordinatExp], timeout: 10)
  }
  
  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
