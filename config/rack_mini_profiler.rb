# Do not let rack-mini-profiler disable caching.
Rack::MiniProfiler.config.disable_caching = false

# Set MemoryStore.
Rack::MiniProfiler.config.storage = Rack::MiniProfiler::MemoryStore
