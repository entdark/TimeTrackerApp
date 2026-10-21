import SwiftData
import Foundation

@MainActor
public final class ModelsManager {
	public static let shared = ModelsManager()
	
	let container: ModelContainer? = {
		do {
			let schema = Schema([TaskModel.self, ProjectModel.self])
			let config = ModelConfiguration(schema: schema)
			let container = try ModelContainer(
				for: schema, configurations: [config]
			)
			return container
		} catch {
			print(error)
		}
		return nil
	}()
	
	public func insert(_ model: any PersistentModel) {
		container?.mainContext.insert(model)
		save()
	}
	
	public func fetch<T>() -> [T]? where T: PersistentModel {
		let fd = FetchDescriptor<T>()
		do {
			return try container?.mainContext.fetch(fd)
		} catch {
			
		}
		return nil
	}
	
	public func fetch<T>(predicate: Predicate<T>?) -> [T]? where T: PersistentModel {
		let fd = FetchDescriptor<T>(predicate: predicate)
		do {
			return try container?.mainContext.fetch(fd)
		} catch {
			
		}
		return nil
	}
	
	public func save() {
		do {
			try container?.mainContext.save()
		} catch {
			
		}
	}
	
	public func delete(_ model: any PersistentModel) {
		container?.mainContext.delete(model)
	}
	
	public func delete(type: any PersistentModel.Type) {
		do {
			try container?.mainContext.delete(model: type)
		} catch {
			
		}
	}
}
