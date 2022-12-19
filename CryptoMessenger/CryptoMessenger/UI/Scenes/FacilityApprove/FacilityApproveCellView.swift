import SwiftUI

struct FacilityApproveCellView: View {

	// MARK: - Internal Properties

	var item: ApproveFacilityCellTitle

	// MARK: - Body

	var body: some View {
		VStack(spacing: 12) {
			HStack {
				HStack(spacing: 16) {
					ZStack {
						Circle()
							.fill(Color(.blue(0.1)))
							.frame(width: 40, height: 40)
						item.image
					}
					VStack(alignment: .leading, spacing: 4) {
						Text(item.title)
							.font(.system(size: 12))
							.foregroundColor(.regentGrayApprox)
						Text(item.text)
							.font(.system(size: 17))
							.foregroundColor(.woodSmokeApprox)
							.lineLimit(1)
							.truncationMode(.middle)
							.padding(.trailing, 16)
					}
				}
			}
		}
	}
}
