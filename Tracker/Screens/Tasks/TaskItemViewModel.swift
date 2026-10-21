import Combine
import Foundation

final class TaskItemViewModel: ObservableObject, Identifiable {
	private let modelsManager = ModelsManager.shared
	private let timersManager = TimersManager.shared
	
	private var timerToken: UUID?
	
	let model: TaskModel
	
	var title: String = ""
	var details: String?
	var project: ProjectViewModel?
	@Published var time: TimeInterval = 0.0
	@Published var playingDate: Date?
	@Published var playing: Bool {
		didSet {
			if playing {
				timersManager.play(task: model)
			} else {
				timersManager.pause(task: model)
			}
		}
	}
	
	init(model: TaskModel) {
		self.model = model
		self.title = model.title
		self.details = model.details
		self.time = model.time
		self.playing = model.playing
		self.playingDate = model.playingDate
		self.project = ProjectViewModel(model: model.project)
		subscribe()
	}
	
	private func subscribe() {
		self.timerToken = timersManager.subscribe(task: model) { [weak self] task in
			self?.time = task.time
			self?.playing = task.playing
			self?.playingDate = task.playingDate
		}
	}
	
	deinit {
		if let token = self.timerToken {
			timersManager.unsubscribe(from: token)
			self.timerToken = nil
		}
	}
	
	func play() {
		if !playing {
			playing = true
		}
	}
	
	func pause() {
		if playing {
			playing = false
		}
	}
	
	func togglePlayback() {
		playing.toggle()
	}
	
	func checkPlayback() {
		self.time = model.time
		self.playing = model.playing
		self.playingDate = model.playingDate
	}
}
