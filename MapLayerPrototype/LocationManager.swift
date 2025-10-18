import MapKit
import CoreLocation
import Combine

// LocationManagerクラスはCLLocationManagerDelegateに準拠し、位置情報の取得と管理を行います。
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    // CLLocationManagerのインスタンスを持っています。
    private let manager = CLLocationManager()

    // 位置情報のアノテーションを保持する配列です。
    @Published private(set) var annotations: [LocationAnnotation] = []

    // 地図の表示領域を表すMKCoordinateRegionのPublishedプロパティです。
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.6895, longitude: 139.6917), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))

    override init() {
        super.init()
        // CLLocationManagerのdelegateをselfに設定します。
        manager.delegate = self
        // 高精度の位置情報を要求します。
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    // 位置情報の取得を開始します。
    func requestLocation() {
        // ユーザーに位置情報の使用許可を求めます。
        manager.requestWhenInUseAuthorization()
    }

    // 位置情報が更新されたときに呼ばれるdelegateメソッドです。
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 最新の位置情報を取得します。
        guard let location = locations.last else { return }

        // 位置情報からLocationAnnotationのインスタンスを作成します。
        let annotation = LocationAnnotation(coordinate: location.coordinate)
        // annotationsプロパティに新しいアノテーションを設定します。
        annotations = [annotation]

        // 新しい位置情報から地図の中心座標を計算します。
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) // 適切なスパン(ズームレベル)を設定します。
        region = MKCoordinateRegion(center: center, span: span) // 新しいregionを設定します。

        // メインスレッドでobjectWillChange.send()を呼び出します。
        // これにより、PublishedプロパティのObserverに変更が通知されます。
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
}

// LocationAnnotationはIdnetifiableプロトコルに準拠する構造体で、地図上のアノテーションを表します。
struct LocationAnnotation: Identifiable {
    let id = UUID() // アノテーションのユニークなIDです。
    let coordinate: CLLocationCoordinate2D // アノテーションの座標です。
}
