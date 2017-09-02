import ceylon.logging {
	logger,
	Logger,
	writeSimpleLog,
	addLogWriter
}
shared Logger log =
	let (log = logger(`module it.feelburst.yoshino`))
		let (logWriter = addLogWriter(writeSimpleLog))
			log;