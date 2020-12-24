//
//  NetworkManager.swift
//  GinCore
//
//  Created by Kyle Zhao on 12/20/20.
//

import Foundation

class NetworkManager: DataManaging {

    let baseURLComponents: URLComponents

    init() {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "api.currencylayer.com"
        components.queryItems = [URLQueryItem(name: "access_key", value: "6c1c66fc734756122538b518cdb938d7")]
        self.baseURLComponents = components
    }

    // MARK: - DataManaging

    func perform(command: Command) {
        logCore("\(command)")

        var components = self.baseURLComponents

        components.path = command.path

        if command.queryItems != nil {
            components.queryItems?.append(contentsOf:command.queryItems!)
        }

        guard let url = components.url else {
            logCoreError("Failed to convert \(components) into URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (dataOptional, responseOptional, error) in
            DispatchQueue.global(qos: .userInitiated).async {
                NetworkManager.handleResponse(command: command, dataOptional: dataOptional, responseOptional: responseOptional, error: error)
            }
        }

        task.resume()
    }

    class private func handleResponse(command: Command, dataOptional: Data?, responseOptional: URLResponse?, error: Error?) -> Void {

        logCore("\(String(describing: responseOptional))")

        guard let response = responseOptional as? HTTPURLResponse else {
            logCoreError("Received nil Response for \(command) \(String(describing: error?.localizedDescription))")
            return
        }

        guard (200...299).contains(response.statusCode) else {
            logCoreError("Response Failed for \(command) code:\(response.statusCode) \(String(describing: error?.localizedDescription)) \(String(describing: response))")
            return
        }

        guard let data = dataOptional else {
            logCoreError("Received nil data for \(command) code:\(response.statusCode) \(String(describing: error?.localizedDescription)) \(String(describing: response))")
            return
        }

        guard let json = try? JSONSerialization.jsonObject(with: data, options:[]) else {
            logCoreError("Failed to parse JSON data for \(command) data:\(data)")
            return
        }

        if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            logCore("Success:\(command) JSON:\(String(decoding: jsonData, as: UTF8.self))")
        } else {
            logCoreError("Failed to parse JSON data for \(command) data:\(data)")
        }

        guard let jsonDictionary = json as? [String: Any] else {
            logCoreError("Failed to cast JSON data into ictionary for \(command) data:\(data)")
            return
        }

        guard let success = jsonDictionary["success"] as? Bool else {
            logCoreError("Failed to parse success parameter for \(command) \(jsonDictionary)")
            return
        }

        guard success == true else {
            logCoreError("Server request failed with success == false for \(command) \(jsonDictionary)")
            return
        }

        let result = command.result(with: jsonDictionary)

        DispatchQueue.main.async {
            command.handler(result)
        }
    }
}
