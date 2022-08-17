import BaiduMapAPI_Map
import SwiftUI
import UIKit

// MARK: - LocationPickerBaidu

struct LocationPickerBaidu {
    
    // MARK: - Internal Properties

	typealias UIViewControllerType = UIViewController
    
    // MARK: - Private Properties

	private let annotation = BMKPointAnnotation()
    
    // MARK: - Internal Methods

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
