import UIKit

// MARK: - CallListView

final class CallListView: UIView {

    // MARK: - Internal Properties

    var didTap: (() -> Void)?

    // MARK: - Private Properties

    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    private lazy var testLabel = UILabel()
    var callList: [CallStruct] = []
    let cellId = "cellId"

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        background(.white())
        createCallListArray()
        setTableViewDelegates()
        setupTabelView()

    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func createCallListArray() {
        callList.append(CallStruct(name: "Martin Randolph"))
        callList.append(CallStruct(name: "Karen Castillo"))
        callList.append(CallStruct(name: "Kieron Dotson"))

    }

    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - Private Methods

    private func setupTabelView() {
        tableView.snap(parent: self) {
            $0.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
            $0.allowsSelection = true
            $0.isUserInteractionEnabled = true
            $0.translatesAutoresizingMaskIntoConstraints = false
        } layout: {
            $0.top.equalTo($1).offset(103)
            $0.leading.trailing.bottom.equalTo($1)
        }
    }

}

extension CallListView: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return callList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let currentLastItem = callList[indexPath.row]
        cell.textLabel?.text = currentLastItem.name
        return cell
    }

}
