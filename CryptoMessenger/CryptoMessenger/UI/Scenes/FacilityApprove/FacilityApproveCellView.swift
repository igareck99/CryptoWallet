import SwiftUI

struct FacilityApproveCellView: View {
    
    // MARK: - Internal Properties
    
    var item: ApproveFacilityCellTitle
    
    // MARK: - Body
    
    var body: some View {
        
        HStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color(.blue(0.1)))
                    .frame(width: 40, height: 40)
                item.image
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 12))
                    .foregroundColor(.romanSilver)
                Text(item.text)
                    .font(.system(size: 17))
                    .foregroundColor(.chineseBlack)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .padding(.trailing, 16)
            }
        }
    }
}
