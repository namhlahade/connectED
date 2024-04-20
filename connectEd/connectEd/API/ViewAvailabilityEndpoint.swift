//
//  ViewTutorEndpoint.swift
//  connectEd
//
//  Created by Namh Lahade on 4/19/24.
//

import Foundation

class ViewAvailabilityAPI: APIClient {
    var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func viewAvailability(emailInput: EmailStruct) async throws -> ViewAvailabilityResponse {
        let url = "https://shielded-ocean-89788-33c0d45404d1.herokuapp.com/viewAvailability"
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(emailInput)
        let response: ViewAvailabilityResponse = try await performPostRequest(url: url, data: jsonData)
        return response
    }
}
