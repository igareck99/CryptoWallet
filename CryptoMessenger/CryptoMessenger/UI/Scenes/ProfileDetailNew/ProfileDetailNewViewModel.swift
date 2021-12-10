import SwiftUI

// MARK: - ProfileDetailViewModel

class ProfileDetailNewViewModel: ObservableObject {

    // MARK: - Internal Properties
    
    @State var image = ProfileDetailItem.getProfile().image
    @State var description = ProfileDetailItem.getProfile().description
    @State var status = ProfileDetailItem.getProfile().status
    @State var name = ProfileDetailItem.getProfile().name
    @State var code = ProfileDetailItem.getProfile().countryCode
    @State var phone = ProfileDetailItem.getProfile().phone
}
