import Combine
import Foundation

protocol P2PCallUseCaseProtocol: AnyObject {
    
    var router: P2PCallsRouterable { get }
    
    var isActiveCallExist: Bool { get }
    
    var delegate: P2PCallUseCaseDelegate? { get set }
    
    func placeVoiceCall(roomId: String, contacts: [Contact])
    
    func placeVideoCall(roomId: String, contacts: [Contact])
    
    func answerCall()
    
    func endCall()
    
    func holdCall()
    
    func changeHoldCall()
    
    var isVideoEnabled: Bool { get }
    
    func toggleVideoState()
    
    var isMicEnabled: Bool { get }
    
    func toggleMuteState()
    
    var isSpeakerEnabled: Bool { get }
    
    var isHoldEnabled: Bool { get }
    
    func changeVoiceSpeaker()
    
    var duration: UInt { get }
    
    var callType: P2PCallType { get }
    
    var activeCallStateSubject: CurrentValueSubject<P2PCallState, Never> { get }
    
    var callModelSubject: PassthroughSubject<P2PCall, Never> { get }
    
    var holdCallEnabledSubject: CurrentValueSubject<Bool, Never> { get }
    
    var changeHoldedCallEnabledSubject: CurrentValueSubject<Bool, Never> { get }
    
    var changeHoldedCallEnabledPublisher: AnyPublisher<Bool, Never> { get }
}
