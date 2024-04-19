//
//  AddTutorEndpoint.swift
//  connectEd
//
//  Created by Namh Lahade on 4/17/24.
//

import Foundation

class AddTutorAPI: APIClient {
    var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func addTutor(tutor: AddTutorStruct) async throws -> AddAPIResponse {
        let url = "https://shielded-ocean-89788-33c0d45404d1.herokuapp.com/addTutor"
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(tutor)
        
        let response: AddAPIResponse = try await performPostRequest(url: url, data: jsonData)
        return response
        

    }
}
