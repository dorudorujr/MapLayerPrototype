import SwiftUI
import MapKit

struct ContentView: View {
    // Memo: StateObjectじゃなくてもいいかも
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        Map(interactionModes: .all) {
            UserAnnotation(anchor: .center) { userLocation in
                VStack {
                    Image(systemName: "arrow.up")
                        .rotationEffect(.degrees(userLocation.heading?.magneticHeading ?? 0))
                        .foregroundColor(.blue)
                    Circle()
                        .foregroundStyle(.blue)
                        .padding(2)
                        .background(
                            Circle()
                                .fill(.white)
                        )
                }
            }
        }
        .mapControls {
            MapUserLocationButton()
        }
        .onAppear {
            locationManager.requestLocation()
        }
    }
}

#Preview {
    ContentView()
}
