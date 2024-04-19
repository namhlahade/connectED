import SwiftUI

struct ContentView: View {
    @State private var selectedHour = 1 // Start from 1
    @State private var isAM = true
    
    var body: some View {
        HStack {
            Picker(selection: $selectedHour, label: Text("Select Hour")) {
                ForEach(1...12, id: \.self) { hour in
                    Text("\(hour)").tag(hour)
                }
            }
            .padding()
            .labelsHidden()
            .pickerStyle(WheelPickerStyle())
            .frame(width: 200) // Adjust the width as needed
            
            Picker(selection: $isAM, label: Text("")) {
                Text("AM").tag(true)
                Text("PM").tag(false)
            }
            .labelsHidden()
            .pickerStyle(SegmentedPickerStyle())
            .padding()
        }
        .onReceive([self.selectedHour].publisher.first()) { _ in
            if self.selectedHour > 12 {
                self.selectedHour = 1
            } else if self.selectedHour < 1 {
                self.selectedHour = 12
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
