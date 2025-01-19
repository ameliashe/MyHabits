//
//  createHabitViewController.swift
//  MyHabits
//
//  Created by Amelia Shekikhacheva on 12/3/24.
//

import UIKit

class HabitEditViewController: UIViewController {

	//MARK: Model
	var habit: Habit!
	let store = HabitsStore.shared

	var selectedColor: UIColor = .systemBlue {
		didSet {
			colorButton.backgroundColor = selectedColor
		}
	}


	//MARK: UI Elements
	let nameLabel: UILabel = {
		let label = UILabel()
		label.text = NSLocalizedString("Название", comment: "Label for habit name")
		label.font = .systemFont(ofSize: 13, weight: .semibold)
		label.textColor = .black
		return label
	}()

	let nameField: UITextField = {
		let field = UITextField()
		field.placeholder = NSLocalizedString("Бегать по утрам, спать 8 часов и т.п.", comment: "Placeholder for habit name input")
		field.borderStyle = .none
		field.font = .systemFont(ofSize: 13, weight: .regular)
		field.textColor = .black
		return field
	}()

	let colorLabel: UILabel = {
		let label = UILabel()
		label.text = NSLocalizedString("Цвет", comment: "Label for selecting the color of the habit")
		label.font = .systemFont(ofSize: 13, weight: .semibold)
		label.textColor = .black
		return label
	}()

	let colorButton: UIButton = {
		let button = UIButton()
		button.backgroundColor = UIColor(named: "HabitOrange")
		button.layer.cornerRadius = 15
		button.layer.masksToBounds = true
		return button
	}()

	let timeLabel: UILabel = {
		let label = UILabel()
		label.text = NSLocalizedString("Время", comment: "Label for selecting the time of the habit")
		label.font = .systemFont(ofSize: 13, weight: .semibold)
		label.textColor = .black
		return label
	}()

	let prefixTimeLabel: UILabel = {
		let label = UILabel()
		label.textColor = .black
		label.text = NSLocalizedString("Каждый день в ", comment: "Prefix for time label")
		label.font = .systemFont(ofSize: 13, weight: .regular)
		label.textAlignment = .center
		return label
	}()

	let selectedTimeLabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor(named: "HabitPurple")
		label.font = .systemFont(ofSize: 13, weight: .regular)
		label.textAlignment = .center
		return label
	}()

	let datePicker: UIDatePicker = {
		let picker = UIDatePicker()
		picker.datePickerMode = .time
		picker.preferredDatePickerStyle = .wheels
		return picker
	}()

	let deleteButton: UIButton = {
		let button = UIButton()
		button.setTitle(
			NSLocalizedString("Удалить привычку", comment: "Button title to delete a habit"),
			for: .normal
		)
		button.setTitleColor(.red, for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 13, weight: .regular)
		return button
	}()


	//MARK: Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white

		addSubviews()
		setupConstraints()

		setupNavigationBar()
		setupInitialTime()
		setupInitialValues()


		addGestureToColorButton()
		addDatePickerTarget()
		addDeleteButtonTarget()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationItem.largeTitleDisplayMode = .never
	}


	//MARK: UI Setup
	func addSubviews() {
		view.addSubview(nameLabel)
		view.addSubview(nameField)
		view.addSubview(colorLabel)
		view.addSubview(colorButton)
		view.addSubview(timeLabel)
		view.addSubview(datePicker)
		view.addSubview(prefixTimeLabel)
		view.addSubview(selectedTimeLabel)
		view.addSubview(deleteButton)

	}

	func setupConstraints() {
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameField.translatesAutoresizingMaskIntoConstraints = false
		colorLabel.translatesAutoresizingMaskIntoConstraints = false
		colorButton.translatesAutoresizingMaskIntoConstraints = false
		timeLabel.translatesAutoresizingMaskIntoConstraints = false
		datePicker.translatesAutoresizingMaskIntoConstraints = false
		prefixTimeLabel.translatesAutoresizingMaskIntoConstraints = false
		selectedTimeLabel.translatesAutoresizingMaskIntoConstraints = false
		deleteButton.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 21),
			nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

			nameField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
			nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			nameField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 7),

			colorLabel.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 16),
			colorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

			colorButton.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 7),
			colorButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			colorButton.widthAnchor.constraint(equalToConstant: 30),
			colorButton.heightAnchor.constraint(equalToConstant: 30),

			timeLabel.topAnchor.constraint(equalTo: colorButton.bottomAnchor, constant: 16),
			timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

			prefixTimeLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 7),
			prefixTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

			selectedTimeLabel.topAnchor.constraint(equalTo: prefixTimeLabel.topAnchor),
			selectedTimeLabel.leadingAnchor.constraint(equalTo: prefixTimeLabel.trailingAnchor),


			datePicker.topAnchor.constraint(equalTo: selectedTimeLabel.bottomAnchor, constant: 16),
			datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

			deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
			deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
	}

	func setupNavigationBar() {
		title = NSLocalizedString("Править", comment: "Title for editing a habit screen")
		view.backgroundColor = .white
		navigationController?.navigationBar.isTranslucent = false
		navigationController?.navigationBar.tintColor = UIColor(named: "HabitPurple")

		navigationItem.leftBarButtonItem = UIBarButtonItem(
			title: NSLocalizedString("Отменить", comment: "Cancel button title"),
			style: .plain,
			target: self,
			action: #selector(cancelButtonTapped)
		)
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: NSLocalizedString("Сохранить", comment: "Save button title"),
			style: .done,
			target: self,
			action: #selector(createButtonTapped)
		)
	}

	func setupInitialValues() {
			nameField.text = habit.name
			selectedColor = habit.color
			datePicker.date = habit.date
			updateTimeLabel()
		}

	func setupInitialTime() {
		updateTimeLabel()
	}

	func updateTimeLabel() {
		let formatter = DateFormatter()
		formatter.timeStyle = .short
		selectedTimeLabel.text = formatter.string(from: datePicker.date)
	}


	//MARK: User Interaction methods
	func addDatePickerTarget() {
		datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
	}

	@objc func datePickerValueChanged() {
		updateTimeLabel()
	}

	func addGestureToColorButton() {
		colorButton.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
	}

	func addDeleteButtonTarget() {
		deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
	}

	@objc func colorButtonTapped() {
		let colorPicker = UIColorPickerViewController()
		colorPicker.delegate = self
		colorPicker.selectedColor = selectedColor
		present(colorPicker, animated: true, completion: nil)
	}

	@objc func cancelButtonTapped() {
		navigationController?.popViewController(animated: true)
	}

	@objc func createButtonTapped() {
		guard let name = nameField.text, !name.isEmpty else {
			return
		}

		habit.name = name
		habit.color = selectedColor
		habit.date = datePicker.date

		NotificationCenter.default.post(name: NSNotification.Name("HabitsUpdated"), object: nil)

		navigationController?.popViewController(animated: true)
	}

	@objc func deleteButtonTapped() {
		let alert = UIAlertController(
			title: NSLocalizedString("Удалить привычку", comment: "Title for delete habit confirmation alert"),
			message: NSLocalizedString("Вы хотите удалить привычку ", comment: "Message for delete habit confirmation alert") + "\"\(habit.name)\"?",
			preferredStyle: .alert
		)
		alert.addAction(
			UIAlertAction(
				title: NSLocalizedString("Отмена", comment: "Cancel button in delete confirmation"),
				style: .cancel,
				handler: nil
			)
		)

		alert.addAction(
			UIAlertAction(
				title: NSLocalizedString("Удалить", comment: "Delete button in delete confirmation"),
				style: .destructive,
				handler: { [weak self] _ in
					guard let self = self else { return }
					if let index = HabitsStore.shared.habits.firstIndex(of: self.habit) {
						HabitsStore.shared.habits.remove(at: index)
					}
					
					NotificationCenter.default.post(name: NSNotification.Name("HabitsUpdated"), object: nil)
					self.navigationController?.popToRootViewController(animated: true)
				})
		)

		present(alert, animated: true, completion: nil)
	}

}

extension HabitEditViewController: UIColorPickerViewControllerDelegate {

	//MARK: ColorPicker Setup
	func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
		selectedColor = viewController.selectedColor
	}

	func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
	}
}
