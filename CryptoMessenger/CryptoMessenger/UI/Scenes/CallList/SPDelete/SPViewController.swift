import UIKit

class SPViewController: BaseViewController {

    private lazy var customview = SPView(frame: UIScreen.main.bounds)

    override func loadView() {
        view = customview
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
