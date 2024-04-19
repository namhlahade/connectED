import SwiftUI
import MapKit
import MessageUI
import EventKit
import CoreLocation

struct TutorBookingScreen: View {
    @Bindable var tutor: Tutor
    @State private var selectedCourse = ""
    @State private var sessionDuration = 1
    @State private var price = 0.0
    @State private var selectedLocation: CLLocationCoordinate2D?
    @State var searchResults: [MKMapItem] = []
    @State private var visibleRegion: MKCoordinateRegion = .duke
    
    var body: some View {
        Form {
            
            ProfileSection(title: "Tutoring Information", sectionLabels: ["Courses"], sectionData: [getCourselist(courses: tutor.courses)])
            
//            Section(header: Text("Course to Cover")) {
//                Picker("Course", selection: $selectedCourse) {
//                    ForEach(tutor.courses, id: \.self){ course in
//                        Text(course).tag(course)
//                    }
//                }
//            }
            
            ProfileSection(title: "Meeting Time", sectionLabels: ["\(tutor.name)'s Availability"], sectionData: [printAvailability(days: tutor.availability_days, times: tutor.availability_times)])
            
            
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
        .navigationBarTitle("Meet with \(tutor.name)!").navigationBarTitleDisplayMode(.inline)
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
    TutorBookingScreen(tutor: Tutor(id: UUID(), name: "Neel Runton", email: "ndr19@duke.edu", courses: [], status: .online, isFavorite: false, availability_days: [], availability_times: []))
}
