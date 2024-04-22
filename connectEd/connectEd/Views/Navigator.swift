import SwiftUI
import MapKit
import CoreLocation

extension CLLocationCoordinate2D {
    static let lily = CLLocationCoordinate2D(latitude: 36.00764022529388, longitude: -78.91534436772467)
    static let perkins = CLLocationCoordinate2D(latitude: 36.00218581433478, longitude: -78.93853196719694)
    static let twinnies = CLLocationCoordinate2D(latitude: 36.003598463809276, longitude: -78.93945945727503)
    static let wu = CLLocationCoordinate2D(latitude: 36.00109648676538, longitude: -78.93925997447101)
}

enum LocationCoordinate {
    case lily
    case perkins
    case twinnies
    case wu

    var coordinate: CLLocationCoordinate2D {
        switch self {
        case .lily:
            return CLLocationCoordinate2D.lily
        case .perkins:
            return CLLocationCoordinate2D.perkins
        case .twinnies:
            return CLLocationCoordinate2D.twinnies
        case .wu:
            return CLLocationCoordinate2D.wu
        }
    }

    var name: String {
        switch self {
        case .lily:
            return "Lily"
        case .perkins:
            return "Perkins"
        case .twinnies:
            return "Twinnies"
        case .wu:
            return "WU"
        }
    }
}


extension MKCoordinateRegion {
    static let duke = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 36.002250, longitude: -78.938638), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
}

struct Location: Identifiable {
    let id: UUID = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
    
    static let dukeCampus = [Location(name: "Perkins", coordinate: .perkins), Location(name: "WU", coordinate: .wu), Location(name: "Twinnies", coordinate: .twinnies), Location(name: "Lily", coordinate: .lily)]
}

struct Navigator: View {
    @Binding var currentLocation: String
    let locationManager = CLLocationManager()
    @State var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State var searchResults: [MKMapItem] = []
    @State private var visibleRegion: MKCoordinateRegion = .duke
    @State private var selectedMapItem: MKMapItem?
    @State private var route: MKRoute?
    @State private var scale: Double = 0.02
    
    var body: some View {
        NavigationStack{
            Map(position: $position, selection: $selectedMapItem) {
                ForEach(searchResults, id: \.self) { mapItem in
                    Marker(item: mapItem)
                }
                UserAnnotation()
                if let route {
                    MapPolyline(route)
                        .stroke(.blue, lineWidth: 5)
                }
                Marker("", systemImage: "book", coordinate: .perkins)
                    .tint(.orange)
                Annotation(coordinate: .perkins) {
                    Image(systemName: "book.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .background (Color.blue)
                        .cornerRadius(4)
                } label: { Text("Perkins") }
            }
            .mapStyle(.hybrid)
            .onMapCameraChange { context in
                visibleRegion = context.region
            }
            .overlay(alignment: .bottomTrailing) {
                Button(action: {
                    scale = scale / 1.5
                    visibleRegion.span = MKCoordinateSpan(latitudeDelta: scale, longitudeDelta: scale)
                    position = .region(visibleRegion)
                    
                }) {
                    Image(systemName: "plus.square.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit).foregroundColor(.green)
                        
                }.padding([.top], -100).frame(maxWidth: 50, maxHeight: 50).padding([.trailing], 10)
                
                Button(action: {
                    scale = scale * 1.5
                    visibleRegion.span = MKCoordinateSpan(latitudeDelta: scale, longitudeDelta: scale)
                    position = .region(visibleRegion)
                    
                }) {
                    Image(systemName: "minus.square.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.red)
                }.padding([.top], 0).frame(maxWidth: 50, maxHeight: 50).padding([.trailing, .bottom], 10)
            }
            .mapControls {
                MapUserLocationButton()
            }.cornerRadius(20)
                .safeAreaInset(edge: .top) {
                    HStack {
                        Spacer()
                        SearchQuery(searchResults: $searchResults, region: $visibleRegion)
                        Spacer()
                    }
                    .background(.white)
                }.padding()
                .safeAreaInset(edge: .bottom) {
                    VStack {
                        if let selectedMapItem {
                            Text(selectedMapItem.name ?? "No name")
                            Button("Directions") { getDirections() }
                        }
                        HStack {
                            Spacer()
                            RegionButtons(position: $position, currentLocation: $currentLocation)
                                .padding(.top)
                            Spacer()
                        }
                    }
                    .background(.white)
                }
                .onAppear {
                    locationManager.requestWhenInUseAuthorization()
                }
        }
        
    }
    
    func getDirections() {
        route = nil
        guard let selectedMapItem else { return }
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: .perkins))
        request.destination = selectedMapItem
        
        Task {
            let directions = MKDirections(request: request)
            let response = try? await directions.calculate()
            route = response?.routes.first
        }
    }
    
}

struct SearchQuery: View {
    @Binding var searchResults: [MKMapItem]
    @Binding var region: MKCoordinateRegion
    @State var query: String = ""
    
    func search() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        request.region = region
        
        Task {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            searchResults = response?.mapItems ?? []
        }
    }
    
    var body: some View {
        TextField("Search", text: $query)
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.gray, style: StrokeStyle(lineWidth: 1.0)))
            .padding()
            .onSubmit {
                search()
            }
    }
}

struct RegionButtons: View {
    @Binding var position: MapCameraPosition
    @Binding var currentLocation: String
    @State private var selectedLocationIndex = 0
    let locations = [LocationCoordinate.lily, LocationCoordinate.perkins, LocationCoordinate.twinnies, LocationCoordinate.wu]

    var body: some View {
        
        VStack {
            Picker(selection: $selectedLocationIndex, label: Text("Locations")) {
                ForEach(locations.indices, id: \.self) { index in
                    Text(locations[index].name)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: selectedLocationIndex) {
                position = .region(MKCoordinateRegion(center: locations[selectedLocationIndex].coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)))
                currentLocation = locations[selectedLocationIndex].name
            }
        }
        .padding()
    }
}
