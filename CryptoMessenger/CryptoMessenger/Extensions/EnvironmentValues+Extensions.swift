import SwiftUI

extension EnvironmentValues {
	var selectedSegmentTag: Any? {
		get { self[SelectedSegmentTagKey.self] }
		set { self[SelectedSegmentTagKey.self] = newValue }
	}

	var segmentedControlNamespace: Namespace.ID? {
		get { self[SegmentedControlNamespaceKey.self] }
		set { self[SegmentedControlNamespaceKey.self] = newValue }
	}
}
