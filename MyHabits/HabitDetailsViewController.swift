//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by Amelia Romanova on 12/7/24.
//

import UIKit

class HabitDetailsViewController: UIViewController {

	var habit: Habit!
	let store = HabitsStore.shared

	var recentDates: [Date] = []

	let tableView: UITableView = {
		let table = UITableView(frame: .zero, style: .grouped)
		table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		table.sectionHeaderHeight = 40
		return table
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground

		addSubviews()

		setupNavigationBar()
		setupTableView()

		setupRecentDates()
	}

	func setupNavigationBar() {
		title = habit.name
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.largeTitleDisplayMode = .never

		navigationController?.navigationBar.isTranslucent = false
		navigationController?.navigationBar.tintColor = UIColor(named: "HabitPurple")

		navigationItem.backBarButtonItem = UIBarButtonItem(title: "Сегодня", style: .plain, target: nil, action: nil)
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Править", style: .plain, target: self, action: #selector(editButtonTapped))
	}

	func addSubviews() {
		view.addSubview(tableView)
	}

	func setupTableView() {
		tableView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])

		tableView.delegate = self
		tableView.dataSource = self
	}

	func setupRecentDates() {
		let calendar = Calendar.current
		let today = Date()
		for i in 1...4 {
			if let date = calendar.date(byAdding: .day, value: -i, to: today) {
				recentDates.append(date)
			}
		}
	}

	@objc func backButtonTapped() {
		navigationController?.popViewController(animated: true)
	}

	@objc func editButtonTapped() {
		let editVC = HabitEditViewController()
		editVC.habit = habit

		navigationController?.pushViewController(editVC, animated: true)
	}

	func isHabitDone(on date: Date) -> Bool {
		let calendar = Calendar.current
		return habit.trackDates.contains(where: { trackDate in
			calendar.isDate(trackDate, inSameDayAs: date)
		})
	}

	func trackHabit(on date: Date) {
		let calendar = Calendar.current
		if calendar.isDateInToday(date) {
			HabitsStore.shared.track(habit)
		} else {
			let alreadyTracked = habit.trackDates.contains { trackedDate in
				calendar.isDate(trackedDate, inSameDayAs: date)
			}
			if !alreadyTracked {
				habit.trackDates.append(date)
			}
		}
	}

	func untrackHabit(on date: Date) {
		let calendar = Calendar.current
		if let index = habit.trackDates.firstIndex(where: {
			calendar.isDate($0, inSameDayAs: date)
		}) {
			habit.trackDates.remove(at: index)
		}
	}
}

extension HabitDetailsViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "АКТИВНОСТЬ"
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return recentDates.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let date = recentDates[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .none

		let calendar = Calendar.current
		if calendar.isDateInYesterday(date) {
			cell.textLabel?.text = "Вчера"
		} else {
			if let dayBeforeYesterday = calendar.date(byAdding: .day, value: -2, to: Date()),
			   calendar.isDate(date, inSameDayAs: dayBeforeYesterday) {
				cell.textLabel?.text = "Позавчера"
			} else {
				cell.textLabel?.text = formatter.string(from: date)
			}
		}

		cell.textLabel?.font = .systemFont(ofSize: 17, weight: .regular)
		cell.textLabel?.textColor = .black

		if isHabitDone(on: date) {
			let config = UIImage.SymbolConfiguration(weight: .bold)
			let checkmarkImage = UIImage(systemName: "checkmark", withConfiguration: config)
			let imageView = UIImageView(image: checkmarkImage)
			imageView.tintColor = UIColor(named: "HabitPurple")
			cell.accessoryView = imageView
		} else {
			cell.accessoryView = nil
		}
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let date = recentDates[indexPath.row]

		if isHabitDone(on: date) {
			untrackHabit(on: date)
		} else {
			trackHabit(on: date)
		}

		tableView.reloadRows(at: [indexPath], with: .automatic)
		NotificationCenter.default.post(name: NSNotification.Name("HabitsUpdated"), object: nil)
	}
}
