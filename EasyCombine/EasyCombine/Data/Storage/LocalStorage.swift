//
//  LocalStorage.swift
//  EasyCombine
//
//  Created by hb9879055 on 2/10/25.
//
/*!<
 # 외부 데이터 관리 (API, DB, 로컬. 저장소 등)
   - UserDefaults 또는 CoreData 관리
 */

import Foundation

final class LocalStorage {
    static let shared = LocalStorage() // 싱글톤 인스턴스
    private let userDefaults = UserDefaults.standard

    private init() {} // 외부에서 인스턴스 생성 방지

    // MARK: - 저장 함수
    func save<T: Codable>(_ object: T, forKey key: String) {
        do {
            let data = try JSONEncoder().encode(object)
            userDefaults.set(data, forKey: key)
        } catch {
            print("Failed to save object for key \(key): \(error.localizedDescription)")
        }
    }

    // MARK: - 불러오기 함수
    func load<T: Codable>(forKey key: String, as type: T.Type) -> T? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        do {
            let object = try JSONDecoder().decode(type, from: data)
            return object
        } catch {
            print("Failed to load object for key \(key): \(error.localizedDescription)")
            return nil
        }
    }

    // MARK: - 삭제 함수
    func delete(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
