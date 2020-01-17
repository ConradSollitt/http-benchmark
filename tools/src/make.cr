require "admiral"
require "yaml"
require "crustache"

alias DockerParam = String | Array(String)

class Merger
  alias ConfigHash = Hash(YAML::Any, YAML::Any)

  def initialize(params : ConfigHash)
    @params = params
  end

  def merge(other = {} of String => String)
    @params.try do |params|
      other = params.merge(other)
    end
    return other
  end
end

struct FrameworkConfig
  property name : String
  property website : String
  property version : Float32
  property langver : Float32 | String

  def initialize(@name, @website, @version, @langver)
  end
end

def create_dockerfile(source, target, config, engine)
  params = {} of String => DockerParam
  if config.has_key?("environment")
    environment = ""
    config["environment"].as_h.each do |k, v|
      environment += "#{k} #{v}"
    end
    params["environment"] = environment
  end

  # Files
  files = [] of String
  config["files"]["default"].as_a.each do |name|
    files << "#{name.to_s} #{name.to_s}"
  end
  if config["files"][engine]
    config["files"][engine].as_h.each do |source, target|
      files << "#{target.to_s} #{source.to_s}"
    end
  end
  params["files"] = files

  # Command
  params["command"] = config["engines"][engine].to_s

  template = Crustache.parse(File.read(source))
  File.write(target, Crustache.render(template, params))
end

class App < Admiral::Command
  class Config < Admiral::Command
    define_flag without_sieger : Bool, description: "run sieger", default: false, long: "without-sieger"
    define_flag sieger_options : String, description: "sieger options", default: "", long: "sieger-options"
    define_flag docker_options : String, description: "extra argument to docker cli", default: "", long: "docker-options"

    def run
      frameworks = {} of String => Array(String)
      Dir.glob("*/*/config.yaml").each do |file|
        directory = File.dirname(file)
        infos = directory.split("/")
        framework = infos.pop
        language = infos.pop

        framework_config = YAML.parse(File.read(File.join(directory, "config.yaml")))
        language_config = YAML.parse(File.read(File.join(directory, "..", "config.yaml")))
        merger = Merger.new(language_config.as_h)
        config = merger.merge(framework_config.as_h)
        if config.has_key?("engines") && ["syro", "rails"].includes?(framework)
          config["engines"].as_h.each do |engine, _|
            create_dockerfile(File.join(directory, "..", "Dockerfile"), File.join(directory, "Dockerfile.#{engine}"), config, engine)
          end
        end
      end
    end
  end

  class TravisConfig < Admiral::Command
    def run
      frameworks = [] of String
      Dir.glob("*/*/config.yaml").each do |file|
        info = file.split("/")
        frameworks << info[info.size - 2]
      end
      config = Crustache.parse(File.read(".ci/template.mustache"))
      File.write(".travis.yml", Crustache.render(config, {"frameworks" => frameworks}))
    end
  end

  class DependabotConfig < Admiral::Command
    def run
      mapping = YAML.parse(File.read(".dependabot/mapping.yaml"))
      frameworks = {} of String => Array(String)
      Dir.glob("*/*/config.yaml").each do |file|
        directory = File.dirname(file)
        infos = directory.split("/")
        framework = infos.pop
        language = infos.pop

        unless frameworks.has_key?(language)
          frameworks[language] = [] of String
        end

        frameworks[language] << framework
      end
      selection = YAML.build do |yaml|
        yaml.mapping do
          yaml.scalar "version"
          yaml.scalar 1
          yaml.scalar "update_configs"

          yaml.sequence do
            frameworks.each do |language, tools|
              tools.each do |tool|
                # Exist if not exist for @dependabot
                next unless mapping["languages"].as_h[language]?

                # Exist if no manifest file
                manifest = String.new
                mapping["languages"][language].as_h.keys.each do |key|
                  file = key.to_s
                  if File.exists?("#{language}/#{tool}/#{file}")
                    manifest = file
                  end
                end
                next if manifest.chars.size == 0

                yaml.mapping do
                  yaml.scalar "package_manager"
                  yaml.scalar mapping["languages"][language][manifest]["label"]
                  yaml.scalar "update_schedule"
                  yaml.scalar mapping["languages"][language][manifest]["update_schedule"]
                  yaml.scalar "directory"
                  yaml.scalar "#{language}/#{tool}"
                  yaml.scalar "default_labels"
                  yaml.sequence do
                    yaml.scalar "language:#{language}"
                  end
                end

                if ["nim", "rust", "julia", "csharp", "fsharp", "kotlin", "perl", "swift"].includes?(language)
                  yaml.mapping do
                    yaml.scalar "package_manager"
                    yaml.scalar "docker"
                    yaml.scalar "update_schedule"
                    yaml.scalar "daily"
                    yaml.scalar "directory"
                    yaml.scalar "#{language}"
                    yaml.scalar "default_labels"
                    yaml.sequence do
                      yaml.scalar "language:#{language}"
                    end
                  end
                end
              end
            end
          end
        end
      end
      File.write(".dependabot/config.yml", selection)
    end
  end

  register_sub_command config : Config, description "Create framework list"
  register_sub_command ci_config : TravisConfig, description "Create configuration file for CI"
  register_sub_command deps_config : DependabotConfig, description "Create configuration file for deps update bot"

  def run
    puts "help"
  end
end

App.run
