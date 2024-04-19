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
    
    func addTutor(tutor: TutorStruct) async throws -> AddAPIResponse {
        let url = "https://shielded-ocean-89788-33c0d45404d1.herokuapp.com/getTutors"
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(tutor)
        
        let response: AddAPIResponse = try await performPostRequest(url: url, data: jsonData)
        return response
        

    }
}
