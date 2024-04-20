import SwiftUI

struct ContentView: View {
    @State private var selectedHours: [[Int]] = []
    @State private var areAM: [[Bool]] = []
    
    var body: some View {
        HStack {
            
            /*Picker(selection: $selectedHour, label: Text("Select Hour")) {
             ForEach(1...12, id: \.self) { hour in
             Text("\(hour)").tag(hour)
             }
             }
             .labelsHidden()
             .pickerStyle(.wheel)
             .frame(width: 50, height: 100)
             .onChange(of: selectedHour) {
             print("Selected time: \(selectedHour) \(isAM ? "AM" : "PM")")
             }*/
            ForEach(Array($selectedHours.enumerated()), id: \.offset) { index, element in
                Picker(selection: $selectedHours[index][0], label: Text("Select Hour")) {
                    ForEach(1...12, id: \.self) { hour in
                        Text("\(hour)").tag(hour)
                    }
                }
                .labelsHidden()
                .pickerStyle(.wheel)
                .frame(width: 50, height: 100)
                /*.onChange(of: selectedHours[index][0]) {
                 print("Selected time: \(selectedHour) \(isAM ? "AM" : "PM")")
                 }*/
                
                Picker(selection: $areAM[index][0], label: Text("")) {
                    Text("AM").tag(true)
                    Text("PM").tag(false)
                }
                .labelsHidden()
                .pickerStyle(.wheel)
                .frame(width: 60, height: 100)
                /*.onChange(of: isAM) {
                 print("Selected time: \(selectedHour) \(isAM ? "AM" : "PM")")
                 }*/
            }
            
        }
        
        Button("Add availability", systemImage: "plus.circle") {
            //data.availability.append(Availability(day: .sunday, times: [dateGetter("00:00"), dateGetter("00:00")]))
            selectedHours.append([6, 6])
            areAM.append([true, true])
            
            //print(data.availability)
            print(selectedHours)
            print(areAM)
            
        }
    }
}

#Preview {
    ContentView()
}
