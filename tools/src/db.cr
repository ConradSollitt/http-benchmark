require "yaml"
require "admiral"
require "pg"
require "crustache"

class App < Admiral::Command
  class ReadmeWriter < Admiral::Command
    def run
      results = {} of String => Hash(String, String | Float64 | Float32)
      order_by_requests = <<-EOS
SELECT r.id, l.label, f.label, e.label, m.label, avg(c.value) 
  FROM frameworks AS f 
  JOIN writable AS w ON w.framework_id = f.id 
  JOIN languages AS l ON l.id = w.language_id 
  JOIN runnable AS r ON r.writable_id = w.id 
  JOIN engines AS e ON e.id = r.engine_id 
  JOIN computable AS c ON c.runnable_id = r.id 
  JOIN metrics AS m ON c.metric_id = m.id 
    GROUP BY 1,2,3,4,5
      ORDER BY 6 DESC
EOS
      DB.open(ENV["DATABASE_URL"]) do |db|
        db.query order_by_requests do |row|
          row.each do
            key = row.read(Int).to_s
            language = row.read(String)
            framework = row.read(String)
            engine = row.read(String)
            metric = row.read(String)
            value = row.read(Float)
            unless results.has_key?(key)
              results[key] = {} of String => (String | Float64 | Float32)
              results[key]["language"] = language
              config = YAML.parse(File.read("#{language}/config.yaml"))
              results[key]["language_version"] = config["provider"]["default"]["language"].to_s
              results[key]["framework"] = framework
              results[key]["engine"] = engine
              config = YAML.parse(File.read("#{language}/config.yaml"))
              results[key]["language_version"] = config["provider"]["default"]["language"].to_s
              config = YAML.parse(File.read("#{language}/#{framework}/config.yaml"))
              if config["framework"].as_h.has_key?("github")
                website = "https://github.com/#{config["framework"]["github"].to_s}"
              else
                website = "https://#{config["framework"]["website"].to_s}"
              end
              results[key]["framework_website"] = website
              results[key]["framework_version"] = config["framework"]["version"].to_s
              begin
                results[key]["framework_website"] = "https://github.com/#{config["framework"]["github"].to_s}"
              rescue
                results[key]["framework_website"] = "https://#{config["framework"]["website"].to_s}"
              end
            end
            results[key][metric] = value
          end
        end
      end
      lines = [
        "|    | Language | Framework | Engine | Speed (`req/s`) | Horizontal scale (parallelism) | Vertical scale (concurrency) |",
        "|----|----------|-----------|--------|----------------:|-------------|-------------|",
      ]
      c = 1
      results.each do |_, row|
        lines << "| %s | %s (%s)| [%s](%s) (%s) | %s | %s | | |" % [
          c,
          row["language"],
          row["language_version"],
          row["framework"],
          row["framework_website"],
          row["framework_version"],
          row["engine"],
          row["request_per_second"].to_f.trunc.format(delimiter: ' ', decimal_places: 0),
        ]
        c += 1
      end

      path = File.expand_path("../../../README.mustache.md", __FILE__)
      template = Crustache.parse(File.read(path))
      puts Crustache.render template, {"results" => lines}
    end
  end

  register_sub_command to_readme : ReadmeWriter, description "Update readme with results"

  def run
    puts "help"
  end
end

App.run
