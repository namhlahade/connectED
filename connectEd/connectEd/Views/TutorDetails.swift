import SwiftUI
import MapKit
import MessageUI
import EventKit
import CoreLocation

struct TutorDetails: View {
    @Bindable var tutor: Tutor
    let eventService = EventService()
    
    @State private var selectedCourse = ""
    @State private var sessionDuration = 1
    @State private var price = 0.0
    @State private var selectedLocation: CLLocationCoordinate2D?
    @State var searchResults: [MKMapItem] = []
    @State private var visibleRegion: MKCoordinateRegion = .duke
    
    var body: some View {
        Form {
            Section(header: Text("Tutor")) {
                Text(tutor.name)
            }
//            Section(header: Text("Course to Cover")) {
//                Picker("Course", selection: $selectedCourse) {
//                    ForEach(tutor.courses ?? ["None"], id: \.self){ course in
//                        Text(course).tag(course)
//                    }
//                }
//            }
            
            Section(header: Text("Session Duration")) {
                Calendar()
            }
            
            Section(header: Text("Price")) {
                Slider(value: $price, in: 0...100, step: 1) {
                    Text("Price: $\(price, specifier: "%.2f")")
                }
            }
            
            Section(header: Text("Meeting Location")) {
                Navigator()
            }
            
            Button(action: {
                self.submit()
            }) {
                Text("Submit")
            }
            .disabled(selectedCourse.isEmpty) /*|| selectedLocation == nil)*/
        }
        .navigationBarTitle("Tutor Details")
        
    }
    
    private func submit() {
        
    }
    
    func dateDisplay(for event: EKEvent) -> String {
        DateFormatters.mediumDate(event.startDate)
    }
    
    func timeDisplay(for event: EKEvent) -> String {
        DateFormatters.timeRange(event.startDate, event.endDate)
    }
}

#Preview {
    TutorDetails(tutor: Tutor(id: UUID(), name: "Neel Runton", email: "ndr19@duke.edu", courses: ["ECE 500", "EGR 300"], status: .online))
}
