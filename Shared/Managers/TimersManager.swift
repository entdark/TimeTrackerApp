import Foundation

public final class TimersManager {
	public static let shared = TimersManager()
	
	@MainActor
	private let modelsManager = ModelsManager.shared
	private let liveActivityManager = LiveActivityManager.shared
	private let lock = NSLock()
	
	private var tasks: Set<TaskModel> = []
	private var observers: [UUID:(TaskModel) -> ()] = [:]
	
	public func subscribe(task: TaskModel, block: @escaping (TaskModel) ->()) -> UUID {
		let token = UUID()
		lock.lock()
		observers[token] = { timedTask in
			if timedTask == task {
				block(task)
			}
		}
		lock.unlock()
		return token
	}
	
	public func unsubscribe(from token: UUID) {
		lock.lock()
		observers[token] = nil
		lock.unlock()
	}
	
	@MainActor
	public func play(task: TaskModel) {
		if task.playing {
			return
		}
		
		task.play()
		modelsManager.save()
		
		Task {
			await liveActivityManager.startOrUpdate(task: task)
		}
		lock.lock()
		let blocks = observers.values
		lock.unlock()
		
		blocks.forEach { block in
			block(task)
		}
	}
	
	@MainActor
	public func pause(task: TaskModel) {
		if !task.playing {
			return
		}
		
		task.pause()
		modelsManager.save()
		
		Task {
			await liveActivityManager.stop(task: task)
		}
		lock.lock()
		let blocks = observers.values
		lock.unlock()
		
		blocks.forEach { block in
			block(task)
		}
	}
	
	@MainActor
	public func update(task: TaskModel) {
		if task.playing {
			Task {
				await liveActivityManager.startOrUpdate(task: task)
			}
		}
	}
}
