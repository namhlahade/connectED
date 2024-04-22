import SwiftUI
import MapKit
import MessageUI
import EventKit
import CoreLocation

struct TutorBookingScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @Bindable var tutor: Tutor
    @State private var sessionDuration = 1
    @State var selectedCourse: String = ""
    @State private var price = 0.0
//    @State private var selectedLocation: CLLocationCoordinate2D?
    @State var searchResults: [MKMapItem] = []
    @State private var visibleRegion: MKCoordinateRegion = .duke
    @State private var selectedOptionIndex = 0
    @State private var isPresentingNavigator: Bool = false
    @State private var selectedMeetingTime: String = ""
    @State var currentLocation: String = "Lily"
    @State var eventService = EventService()

    
    var body: some View {
        Form {
            Section(header: Text("Select a Course:")) {
                if tutor.courses.isEmpty {
                    Text("No available courses to select").frame(maxWidth: .infinity, alignment: .center)
                }
                else {
                    Picker(selection: $selectedCourse, label: Text("").frame(maxWidth: .infinity, alignment: .center)) {
                        Text("Select a Course").tag("")
                        ForEach(tutor.courses) { course in
                            Text("\(course.subject.rawValue.uppercased()) \(course.code)").frame(maxWidth: .infinity, alignment: .center).tag("\(course.subject.rawValue.uppercased()) \(course.code)").foregroundColor(Color.blue)
                            
                            
                        }
                    }.labelsHidden().frame(maxWidth: .infinity, alignment: .center).labelsHidden()
                }
            }
            
            Section(header: Text("Pick a Time")) {
                if tutor.availability.isEmpty {
                    Text("No tutor availability provided").frame(maxWidth: .infinity, alignment: .center)
                    
                }
                else {
                    Picker(selection: $selectedMeetingTime, label: Text("")) {
                        Text("Select a Meeting Time").tag("")
                        ForEach(tutor.availability) { time in
                            Text(printAvailability(availability: [time])).tag(printAvailability(availability: [time]))
                        }
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .multilineTextAlignment(.center)
                }
            }
            
//            Map(position: .lily, selection: $selectedMapItem){
//
//            }
            Section(header: Text("Meeting Location")) {
                Button("Current Location: \(currentLocation)") {
                    isPresentingNavigator.toggle()
                }.frame(maxWidth: .infinity, alignment: .center)
            }
            
            NavigationLink(destination: EventEditView(eventService: eventService, event: fillInEvent(tutor: tutor, meetingString: selectedMeetingTime.split(separator: " ")))) {
                Text("Add Meeting To Your Calendar!").frame(maxWidth: .infinity, alignment: .center)
            }
            .disabled(selectedCourse == "" || selectedMeetingTime == "")
        }
        .navigationTitle("Meet with \(tutor.name)!")
        .navigationBarTitleDisplayMode(.inline).frame(alignment: .center)

        .sheet(isPresented: $isPresentingNavigator){
            
            NavigationStack {
                Navigator(currentLocation: $currentLocation)
                Text("Current Location: \(currentLocation)")
            }
        }.frame(maxWidth: .infinity, alignment: .center)
    }
                           
    func fillInEvent(tutor: Tutor, meetingString: [Substring]) -> EKEvent? {
        if meetingString.isEmpty {
            return nil
        }
        else {
            let eventStore = EKEventStore()
            let now = Date.now
            let calendar = Calendar.current
            var meetingWeekday = Availability.Day.allCases.firstIndex(where: {$0 == Availability.Day(rawValue: String(meetingString[0]).lowercased())})
            if meetingWeekday == 6 {
                meetingWeekday = 1
            }
            else {
                meetingWeekday! += 2
            }
            
            var initialStartHour = Int(meetingString[1].split(separator: ":")[0])!
            var startHour: Int
            if initialStartHour != 12 {
                startHour = initialStartHour + (meetingString[2] == "AM" ? 0 : 12)
            }
            else {
                startHour = meetingString[2] == "AM" ? 0 : 12
            }
            let startDate = calendar.nextDate(after: now, matching: DateComponents(hour: startHour, minute: Int(meetingString[1].split(separator: ":")[1]), weekday: meetingWeekday), matchingPolicy: .nextTime)
            
            
            var initialEndHour = Int(meetingString[4].split(separator: ":")[0])!
            var endHour: Int
            if initialEndHour != 12 {
                endHour = initialEndHour + (meetingString[5] == "AM" ? 0 : 12)
            }
            else {
                endHour = meetingString[5] == "AM" ? 0 : 12
            }
            let endDate = calendar.nextDate(after: now, matching: DateComponents(hour: endHour, minute: Int(meetingString[4].split(separator: ":")[1]), weekday: meetingWeekday), matchingPolicy: .nextTime)
            
            var event = EKEvent(eventStore: eventStore)
            event.title = "Meeting with \(tutor.name)"
            event.startDate = startDate
            event.endDate = endDate
            event.location = currentLocation
            return event
        }
    }
                           
    func dateDisplay(for event: EKEvent) -> String {
        DateFormatters.mediumDate(event.startDate)
    }
    
    func timeDisplay(for event: EKEvent) -> String {
        DateFormatters.timeRange(event.startDate, event.endDate)
    }
}

struct TutorBookingScreen_Previews: PreviewProvider {
    @State var currentLocation: String = "Lily"
    static var previews: some View {
        TutorBookingScreen(tutor: Tutor.previewData[4])
    }
}
