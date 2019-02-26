module Application	
	require 'makegit/config'
	require 'makegit/fs_builder'
	require 'makegit/repo_builder'

	require 'json'
	require 'optparse'

	class Makegit

		attr_reader :params, :project_name, :git_user, :git_token

		def initialize(argv)
			@params, @project_name = parse_options(argv)
			@git_user, @git_token = Config.new.login
		end

		def run
			FSBuilder.new(project_name, params[:template]).build
			RepoBuilder.new(project_name, git_user, git_token).build
			STDOUT.puts "Project successfully created. Type \"cd #{project_name}\" and get to work!"
		end

		def parse_options(argv)
			argv << '-h' if argv.empty?
			params = {}
			OptionParser.new do |opts|
			 	opts.banner = "Usage: [project_name] [options]"

				opts.on("-h", "--help", "Prints this help") do
					puts opts
        	exit
				end

				opts.on("--rubygem", "Creates RubyGem project template") do
					params[:template] = "rubygem"
				end

			end.parse!
			
			project_name = argv[0]
			raise ArgumentError, "No Project Name Given", caller if project_name == nil || project_name.empty?
			
			[params, project_name]

		end
	end
end