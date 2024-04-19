//
//  GetTutorEndpoint.swift
//  connectEd
//
//  Created by Namh Lahade on 4/19/24.
//

import Foundation

class GetTutorAPI: APIClient {
    var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getTutor() async throws -> TutorsResponse {
        let url = "https://shielded-ocean-89788-33c0d45404d1.herokuapp.com/getTutors"
        let response: TutorsResponse = try await performRequest(url: url)
        print(response)
        return response
    }
}

