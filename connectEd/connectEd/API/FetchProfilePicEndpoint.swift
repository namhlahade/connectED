//
//  FetchProfilePicEndpoint.swift
//  connectEd
//
//  Created by Neel Runton on 4/21/24.
//

import Foundation
import SwiftUI

class FetchProfilePicEndpoint {
    var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getThePhoto(path: String) async throws -> UIImage? {
        print("Got to getThePhoto")
        /*let image: UIImage? = try await getPhoto(path: path)
        print("Got the image optional")
        return image*/
        return nil
    }
}
