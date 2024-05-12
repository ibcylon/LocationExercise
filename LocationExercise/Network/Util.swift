//
//  Util.swift
//  LocationExercise
//
//  Created by kangho lee on 5/11/24.
//

import Foundation

extension Encodable {
  func toDictionay() -> [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else {
      return nil
    }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments))
      .flatMap { $0 as? [String: Any] }
  }
}
