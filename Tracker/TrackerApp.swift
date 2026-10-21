//import SwiftData
import SwiftUI

@main
struct TrackerApp: App {
	var mainViewModel = MainViewModel()
	
/*	public static let container: ModelContainer? = {
		do {
			let container = try ModelContainer(
				for: TaskModel.self, ProjectModel.self
			)
			return container
		} catch {
			
		}
		return nil
	}()*/
	
    var body: some Scene {
        WindowGroup {
			MainView(viewModel: mainViewModel)
/*				.modelContainer(for: [
					TaskModel.self,
					ProjectModel.self
				])*/
        }
    }
}
