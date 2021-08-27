import UIKit

// MARK: - CallListView

final class CallListView: UIView {

    // MARK: - Private Properties

    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    private var callList: [CallStruct] = []

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        background(.white())
        createCallListArray()
        setTableViewDelegates()
        setupTableView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    private func createCallListArray() {
        callList.append(CallStruct(name: "Martin Randolph", dateTime: "19 сен 18:59", image: R.image.callList.user1(),
                                   isIncall: false))
        callList.append(CallStruct(name: "Karen Castillo", dateTime: "07 сен 18:36", image: R.image.callList.user2(),
                                   isIncall: true))
        callList.append(CallStruct(name: "Kieron Dotson", dateTime: "04 сен 18:11", image: R.image.callList.user3(),
                                   isIncall: true))
        callList.append(CallStruct(name: "Jamie Franco", dateTime: "03 июн 06:27", image: R.image.callList.user4(),
                                   isIncall: true))
    }

    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    func removeCall(index: Int) {
        callList.remove(at: index)
        tableView.reloadData()
    }

    func removeAllCalls() {
        callList.removeAll()
        tableView.reloadData()
    }

    // MARK: - Private Methods

    private func setupTableView() {
        tableView.snap(parent: self) {
            $0.register(CallCell.self, forCellReuseIdentifier: CallCell.identifier)
            $0.separatorInset.left = 68
            $0.allowsSelection = true
            $0.isUserInteractionEnabled = true
            $0.translatesAutoresizingMaskIntoConstraints = false
        } layout: {
            $0.leading.trailing.bottom.top.equalTo($1)
        }
    }

}

// MARK: - CallListView (UITableViewDelegate)

extension CallListView: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return callList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CallCell.identifier, for: indexPath) as?
                CallCell else { return CallCell() }
        let currentLastItem = callList[indexPath.row]
        cell.configure(currentLastItem)
        return cell
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let action = UIContextualAction(style: .destructive, title: "Удалить") { _, _, _  in
            self.removeCall(index: indexPath[1])
        }
        action.backgroundColor = .red
        action.image = R.image.callList.deleteimage()
        return UISwipeActionsConfiguration(actions: [action])
    }
}
