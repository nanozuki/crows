local log = {}

log.levels = {
	error = "ERROR",
	warn = "WARN",
	info = "INFO",
	debug = "DEBUG",
}
log.level = log.levels.warn

local level_pri = {
	[log.levels.debug] = 0,
	[log.levels.info] = 1,
	[log.levels.warn] = 2,
	[log.levels.error] = 3,
}

local function level_valid(level)
	if level_pri[level] == nil then
		error(string.format("level '%s' is not valid", level))
	end
end

local function should_log(level)
	level_valid(log.level)
	level_valid(level)
	return level_pri[level] >= level_pri[log.level]
end

function log.raw_log(level, ...)
	if should_log(level) then
		print(string.format("[%s]", level), ...)
	end
end

function log.debug(...)
	log.raw_log(log.levels.debug, ...)
end
function log.info(...)
	log.raw_log(log.levels.info, ...)
end

function log.warn(...)
	log.raw_log(log.levels.warn, ...)
end

function log.error(...)
	log.raw_log(log.levels.error, ...)
end

function log.fatal(message, level)
	error("[FATAL] " .. message, level)
end

return log
