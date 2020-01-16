require "admiral"
require "pg"

PIPELINES = {
  "GET": File.expand_path("../../" + "pipeline.lua", __FILE__),
}

def insert(framework_id, language_id, engine_id, metric_id, value)
  DB.open(ENV["DATABASE_URL"]) do |db|
    row = db.query("insert into writable (language_id, framework_id) values ($1, $2) on conflict (language_id, framework_id) do update set language_id = $1, framework_id = $2 returning id", language_id, framework_id)
    row.move_next
    writable_id = row.read(Int)

    row = db.query("insert into runnable (engine_id, writable_id) values ($1, $2) on conflict (engine_id, writable_id) do update set engine_id = $1, writable_id = $2 returning id", engine_id, writable_id)
    row.move_next
    runnable_id = row.read(Int)

    db.exec("insert into computable (runnable_id, metric_id, value) values ($1, $2, $3)", runnable_id, metric_id, value)
  end
end

class Client < Admiral::Command
  define_flag threads : Int32, description: "# of threads", default: 8, long: "threads", short: "t"
  define_flag connections : Int32, description: "# of opened connections", default: 500, long: "connections", short: "c"
  define_flag duration : Int32, description: "Time to test, in seconds", default: 5, long: "duration", short: "d"
  define_flag language : String, description: "Language used", required: true, long: "language", short: "l"
  define_flag framework : String, description: "Framework used", required: true, long: "framework", short: "f"
  define_flag engine : String, description: "Engine", required: true, long: "engine", short: "e"
  define_flag routes : Array(String), long: "routes", short: "r", default: ["GET:/"]

  def run
    DB.open(ENV["DATABASE_URL"]) do |db|
      row = db.query("INSERT INTO languages (label) VALUES ($1) ON CONFLICT (label) DO UPDATE SET label = $1 RETURNING id", flags.language)
      row.move_next
      language_id = row.read(Int)

      row = db.query("INSERT INTO frameworks (label) VALUES ($1) ON CONFLICT (label) DO UPDATE SET label = $1 RETURNING id", flags.framework)
      row.move_next
      framework_id = row.read(Int)

      row = db.query("INSERT INTO engines (label) VALUES ($1) ON CONFLICT (label) DO UPDATE SET label = $1 RETURNING id", flags.engine)
      row.move_next
      engine_id = row.read(Int)

      sleep 20 # due to external program usage

      address = File.read("ip.#{flags.engine}.txt").strip

      # Warm-up
      Process.new("wrk", ["-H", "Connection: keep-alive", "-d", "5s", "-c", "8", "--timeout", "8", "-t", flags.threads.to_s, "http://#{address}:3000"])

      flags.routes.each do |route|
        method, uri = route.split(":")
        url = "http://#{address}:3000#{uri}"

        options = {} of String => String | Int32
        options["duration"] = "#{flags.duration}s"
        options["connections"] = flags.connections
        options["timeout"] = 8
        options["threads"] = flags.threads
        if method == "POST"
          options["script"] = File.expand_path("../../" + "pipeline_post.lua", __FILE__)
        end
        params = [] of String
        params << "--latency"
        options.each do |key, value|
          params << "--#{key}"
          params << value.to_s
        end
        params << url

        stdout = IO::Memory.new
        process = Process.new("wrk", params, output: stdout)
        status = process.wait
        output = stdout.to_s
        lines = output.split("\n")
        requests_per_seconds = lines.grep(/Requests/).first.split(":").pop.strip.to_f
        row = db.query("INSERT INTO metrics (label) VALUES ($1) ON CONFLICT (label) DO UPDATE SET label = $1 RETURNING id", "request_per_second")
        row.move_next
        metric_id = row.read(Int)

        insert(framework_id, language_id, engine_id, metric_id, requests_per_seconds)
      end
    end
  end
end

Client.run
