//swiftlint: disable all

import Foundation
import SwiftUI
import BaiduMapAPI_Map
import BaiduMapAPI_Utils
import BaiduMapAPI_Base
import BaiduMapAPI_Search
import BaiduMapAPI_Cloud

final class BMKShowMapPage: UIViewController {
    let kHeight_SegmentBackground: CGFloat = 60
    let kHeight_BottomControlView: CGFloat = 60
	let BMKMapVersion = "百度地图iOS SDK " + BMKGetMapApiVersion()
    
    // MARK: - Lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mapView.viewWillDisappear()
    }
    
    //MARK:Config UI
    func configUI() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .white
        view.backgroundColor = .white
        title = "显示地图"
        view.addSubview(mapSegmentControl)
        view.addSubview(mapView)
    }
    
    //MARK:Responding events
    @objc func segmentControlDidChangeValue(_ segmented: UISegmentedControl) {
        switch segmented.selectedSegmentIndex {
        case 1:
            mapView.mapType = BMKMapType.satellite
        case 2:
            mapView.mapType = BMKMapType.none
        default:
            mapView.mapType = BMKMapType.standard
            break
        }
    }
    
    @objc func switchDidChangeValue(_ switched: UISwitch) {
        if switched.isOn {
            let path: String = Bundle.main.path(forResource: "c67be9c4904e2e2b423215733163a601", ofType:"sty")!
            mapView.setCustomMapStylePath(path)
            mapView.setCustomMapStyleEnable(true)
        } else {
            mapView.setCustomMapStyleEnable(false)
        }
    }
    
    //MARK:Lazy loading
    lazy var mapView: BMKMapView = {
        let mapView = BMKMapView(frame: CGRect(x: 0, y: kHeight_SegmentBackground, width: KScreenWidth, height: KScreenHeight - kViewTopHeight - kHeight_SegmentBackground - kHeight_BottomControlView - KiPhoneXSafeAreaDValue - 300))
        mapView.delegate = self
        return mapView
    }()
    
    lazy var mapSegmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl.init(items: ["标准地图", "卫星地图", "空白地图"])
        segmentControl.frame = CGRect(x: 10 * widthScale, y: 12.5, width: 355 * widthScale, height: 35)
        segmentControl.setTitle("标准地图", forSegmentAt: 0)
        segmentControl.setTitle("卫星地图", forSegmentAt: 1)
        segmentControl.setTitle("空白地图", forSegmentAt: 2)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self , action: #selector(segmentControlDidChangeValue), for: UIControl.Event.valueChanged)
        return segmentControl
    }()
    
    lazy var bottomControlView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: KScreenHeight - kViewTopHeight - kHeight_BottomControlView - KiPhoneXSafeAreaDValue, width: KScreenWidth, height: kHeight_BottomControlView))
        return view
    }()
    
    lazy var customizationMapSwitch: UISwitch = {
        let mapSwitch = UISwitch(frame: CGRect(x: 125 * widthScale, y: 17, width: 48 * widthScale, height: 26))
        mapSwitch.addTarget(self, action: #selector(switchDidChangeValue), for: UIControl.Event.valueChanged)
        return mapSwitch
    }()
    
    lazy var customizationgMapLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 181 * widthScale, y: 20, width: 100 * widthScale, height: 20))
        label.textColor = COLOR(0x3385FF)
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "个性化地图"
        return label
    }()
}

// MARK: - BMKMapViewDelegate

extension BMKShowMapPage: BMKMapViewDelegate {}
