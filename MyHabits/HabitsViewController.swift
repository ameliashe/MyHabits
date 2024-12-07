//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Amelia Romanova on 11/24/24.
//

import UIKit

class HabitsViewController: UIViewController {

	enum Identifiers: String {
		case progressCell = "ProgressCell_ID"
		case habitCell = "HabitCell_ID"
	}

	let store = HabitsStore.shared

	let habitsTableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .grouped)
		tableView.separatorStyle = .none
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 130
		tableView.sectionHeaderHeight = 0
		tableView.sectionFooterHeight = 12
		return tableView
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		setupHabitsTableView()

		addSubviews()
		addConstraints()

		setupNavigationBar()

		NotificationCenter.default.addObserver(self, selector: #selector(updateHabitsList), name: NSNotification.Name("HabitsUpdated"), object: nil)
    }

	func addSubviews() {
		view.addSubview(habitsTableView)
	}

	func addConstraints() {
		habitsTableView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			habitsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			habitsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			habitsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			habitsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])
	}

	func setupHabitsTableView() {
		habitsTableView.register(ProgressCollectionViewCell.self, forCellReuseIdentifier: Identifiers.progressCell.rawValue)
		habitsTableView.register(HabitCollectionViewCell.self, forCellReuseIdentifier: Identifiers.habitCell.rawValue)


		habitsTableView.delegate = self
		habitsTableView.dataSource = self
	}

	func setupNavigationBar() {
		title = "Сегодня"
		view.backgroundColor = .white
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationBar.isTranslucent = false
		navigationController?.hidesBarsOnSwipe = false
		navigationController?.navigationBar.tintColor = UIColor(named: "HabitPurple")

		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
	}
	
	@objc func addButtonTapped() {
		let CreateVC: HabitViewController = {
			let habitVC = HabitViewController()
			habitVC.view.backgroundColor = .systemBackground
			habitVC.modalPresentationStyle = .pageSheet
			habitVC.modalTransitionStyle = .coverVertical
			return habitVC
		}()

		navigationController?.pushViewController(CreateVC, animated: true)
	}

	@objc func updateHabitsList() {
		habitsTableView.reloadData()
	}
}

extension HabitsViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return section == 0 ? 1 : HabitsStore.shared.habits.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			guard let cell = habitsTableView.dequeueReusableCell(withIdentifier: Identifiers.progressCell.rawValue, for: indexPath) as? ProgressCollectionViewCell else {
				fatalError("Could not dequeue PhotosTableViewCell")
			}
			return cell
		}
		guard let cell = habitsTableView.dequeueReusableCell(withIdentifier: Identifiers.habitCell.rawValue, for: indexPath) as? HabitCollectionViewCell else {
			fatalError("Could not dequeue CustomPostCell")
		}
		cell.update(store.habits[indexPath.row])
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		   guard indexPath.section == 1 else { return }

		   let habit = store.habits[indexPath.row]
		   let detailsVC = HabitDetailsViewController()
		   detailsVC.habit = habit
		   navigationController?.pushViewController(detailsVC, animated: true)
	   }

}

