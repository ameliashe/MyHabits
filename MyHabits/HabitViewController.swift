//
//  createHabitViewController.swift
//  MyHabits
//
//  Created by Amelia Shekikhacheva on 12/3/24.
//

import UIKit

class HabitViewController: UIViewController {

	//MARK: Model
	let store = HabitsStore.shared

	var selectedColor: UIColor = .systemBlue {
		didSet {
			colorButton.backgroundColor = selectedColor
		}
	}


	//MARK: UI Elements
	let nameLabel: UILabel = {
		let label = UILabel()
		label.text = "Название"
		label.font = .systemFont(ofSize: 13, weight: .semibold)
		label.textColor = .black
		return label
	}()

	let nameField: UITextField = {
		let field = UITextField()
		field.placeholder = "Бегать по утрам, спать 8 часов и т.п."
		field.borderStyle = .none
		field.font = .systemFont(ofSize: 13, weight: .regular)
		field.textColor = .black
		return field
	}()

	let colorLabel: UILabel = {
		let label = UILabel()
		label.text = "Цвет"
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
		label.text = "Время"
		label.font = .systemFont(ofSize: 13, weight: .semibold)
		label.textColor = .black
		return label
	}()

	let prefixTimeLabel: UILabel = {
		let label = UILabel()
		label.textColor = .black
		label.text = "Каждый день в "
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


	//MARK: Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white

		addSubviews()
		setupConstraints()

		setupNavigationBar()
		setupInitialTime()
		

		addGestureToColorButton()
		addDatePickerTarget()
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
			datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
		])
	}

	func setupNavigationBar() {
		title = "Создать"
		view.backgroundColor = .white
		navigationController?.navigationBar.isTranslucent = false
		navigationController?.navigationBar.tintColor = UIColor(named: "HabitPurple")

		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(cancelButtonTapped))
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(createButtonTapped))
	}

	func setupInitialTime() {
		updateTimeLabel()
	}

	func updateTimeLabel() {
		let formatter = DateFormatter()
		formatter.timeStyle = .short
		selectedTimeLabel.text = formatter.string(from: datePicker.date)
	}

	
	//MARK: User Interaction Methods & Setup
	func addDatePickerTarget() {
		datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
	}

	@objc func datePickerValueChanged() {
		updateTimeLabel()
	}

	func addGestureToColorButton() {
		colorButton.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
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

			let alertController = UIAlertController(title: "Имя не может быть пустым!", message: "Введите название привычки.", preferredStyle: .alert)
			let okayAction = UIAlertAction(title: "OK", style: .default)
			alertController.addAction(okayAction)
			present(alertController, animated: true)
			return
		}

		let chosenColor = selectedColor
		let chosenDate = datePicker.date

		let newHabit = Habit(name: name, date: chosenDate, color: chosenColor)
		store.habits.append(newHabit)
		NotificationCenter.default.post(name: NSNotification.Name("HabitsUpdated"), object: nil)

		navigationController?.popViewController(animated: true)
	}

}

extension HabitViewController: UIColorPickerViewControllerDelegate {
	func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
		selectedColor = viewController.selectedColor
	}

	func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
	}
}
