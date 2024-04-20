import Foundation

@Observable
class AddMeetingLoader {
    let apiClient = AddMeetingAPI()
    private(set) var state: LoadingState = .idle
    
    enum LoadingState {
        case idle
        case loading
        case success(data: AddAPIResponse)
        case failed(error: Error)
    }
    
    @MainActor
    func addUserMeeting(addMeetingInput: AddMeetingInput) async {
        self.state = .loading
        do {
            let response = try await apiClient.addMeeting(addMeetingInput: addMeetingInput)
            self.state = .success(data: response)
        } catch {
            self.state = .failed(error: error)
        }
    }
}
