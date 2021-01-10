//
//  Bundle-Decodable.swift
//  WeldLearn
//
//  Created by JWSScott777 on 1/10/21.
//

import Foundation

extension Bundle {
    func decode<T: Decodable>(
        _ type: T.Type,
        from file: String,
        dataDecodingStrategy: JSONDecoder.DateDecodingStrategy =
        .deferredToDate,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy =
        .useDefaultKeys) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Can't find \(file) in bundle")
        }
// attempt to load the URL into a Data instance
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Can't load \(file) from bundle.")
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dataDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy

        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {

            fatalError(

                "Could not decode \(file) from bundle missing key '\(key.stringValue)'- \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode \(file) from bundle because of a mismatch- \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode \(file) because of missing \(type) value- \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode \(file) because it is not valid json")
        } catch {
            fatalError("Error decoding \(file) from bundle: \(error.localizedDescription)")
        }
    }
}

