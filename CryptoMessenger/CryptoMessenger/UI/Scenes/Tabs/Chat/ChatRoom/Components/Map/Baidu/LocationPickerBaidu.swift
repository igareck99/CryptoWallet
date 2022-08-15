import BaiduMapAPI_Map
import SwiftUI
import UIKit

struct LocationPickerBaidu {

	typealias UIViewControllerType = UIViewController

	private let annotation = BMKPointAnnotation()

	func makeUIViewController(context: Context) -> UIViewController {
		let showMap = BMKShowMapPage()
		showMap.mapView.addAnnotation(annotation)
		showMap.mapView.showAnnotations([annotation], animated: false)
		return showMap
	}

	func update(coordinates: CLLocationCoordinate2D) {
		annotation.coordinate = coordinates
	}
}

// MARK: - UIViewControllerRepresentable

extension LocationPickerBaidu: UIViewControllerRepresentable {
	func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
