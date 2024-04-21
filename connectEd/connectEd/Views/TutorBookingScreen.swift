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
    @State private var selectedLocation: CLLocationCoordinate2D?
    @State var searchResults: [MKMapItem] = []
    @State private var visibleRegion: MKCoordinateRegion = .duke
    @State private var selectedOptionIndex = 0
    @State private var isPresentingNavigator: Bool = false
    @State private var selectedMeetingTime: String = ""
    
    let addMeetingLoader = AddMeetingLoader()
    
    var body: some View {
        Form {
            
            Section(header: Text("Select a Course:")) {
                if tutor.courses.isEmpty {
                    Text("No available courses to select")
                }
                else {
                    Picker(selection: $selectedCourse, label: Text("")) {
                        ForEach(tutor.courses) { course in
                            Text("\(course.subject.rawValue.uppercased()) \(course.code)").frame(maxWidth: .infinity, alignment: .center).tag("\(course.subject.rawValue.uppercased()) \(course.code)")
                            
                        }
                    }.labelsHidden()
                }
            }
            
            Section(header: Text("Pick a Time")) {
                Text("\(tutor.name)'s Availability").bold().font(.title3)
                if tutor.availability.isEmpty {
                    Text("No availability provided")
                }
                else {
                    Picker(selection: $selectedMeetingTime, label: Text("")) {
                        ForEach(tutor.availability) { time in
                            Text(printAvailability(availability: [time])).tag(printAvailability(availability: [time]))
                        }
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                }
            }
            
            
            Section(header: Text("Meeting Location")) {
                Button("Edit") {
                    isPresentingNavigator.toggle()
                }
            }
            
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
                let meetingTimeString = convertDateToString(selectedMeetingTime: selectedMeetingTime)
                print(selectedMeetingTime)
                self.submit(email: tutor.email, date: meetingTimeString[0], startTime: meetingTimeString[1], endTime: meetingTimeString[2])
                
            }) {
                Text("Submit").frame(maxWidth: .infinity, alignment: .center)
                
            }
            //            .disabled(selectedCourse.isEmpty) /*|| selectedLocation == nil)*/
        }
        .navigationTitle("Meet with \(tutor.name)!")
        .navigationBarTitleDisplayMode(.inline).frame(alignment: .center)

        .sheet(isPresented: $isPresentingNavigator){
            
            NavigationStack {
                Navigator()
            }
        }
    }
    
    private func convertDateToString(selectedMeetingTime: String) -> [String] {
        
        let meetingString = selectedMeetingTime.split(separator: " ")
        print("meeting string: \(selectedMeetingTime)")
        let date = meetingString[0]
        let startTimeString = meetingString[1].split(separator: ":")
        let endTimeString = meetingString[4].split(separator: ":")
        var startTime = String(meetingString[1])
        var endTime = String(meetingString[4])
        if meetingString[2] == "PM" && startTimeString[0] != "12" {
            let hour = (Int(startTimeString[0]) ?? 0) + 12
            startTime = "\(hour):\(startTimeString[1])"
        }
        else if startTimeString[0] == "12"{
            startTime = "0:\(startTimeString[1])"
        }
        if meetingString[5] == "PM" && endTimeString[0] != "12" {
            let hour = (Int(endTimeString[0]) ?? 0) + 12
            endTime = "\(hour):\(endTimeString[1])"
        }
        else if endTimeString[0] == "12"{
            endTime = "0:\(endTimeString[1])"
        }
        return [String(date), startTime, endTime]
    }
    
    private func submit(email: String, date: String, startTime: String, endTime: String) {
        Task {
            await addMeetingLoader.addUserMeeting(addMeetingInput: AddMeetingInput(user_email: email, meeting_date: String(date), start_time: startTime, end_time: endTime))
        }
    }
    
    func dateDisplay(for event: EKEvent) -> String {
        DateFormatters.mediumDate(event.startDate)
    }
    
    func timeDisplay(for event: EKEvent) -> String {
        DateFormatters.timeRange(event.startDate, event.endDate)
    }
}

#Preview {
    TutorBookingScreen(tutor: Tutor.previewData[4])
}
