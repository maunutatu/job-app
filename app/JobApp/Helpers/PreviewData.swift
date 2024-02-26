enum PreviewData {
	private static let jobService = SampleJobService()

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
}
