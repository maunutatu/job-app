enum PreviewData {
	private static let jobService = SampleJobService()
	private static let userService = SampleUserService()

	static let sampleJobs = {
		do {
			return try jobService.jobs()
		} catch {
			fatalError("Failed to load sample jobs: \(error)")
		}
	}()

	static let sampleJob = {
		guard let job = sampleJobs.first else {
			fatalError("No jobs in sample list")
		}
		return job
	}()

	static let sampleUser = {
		guard let user = try? userService.getUser(withId: 1) else {
			fatalError("No user in sample list")
		}
		return user
	}()
}
