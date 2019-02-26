module Application
	class RepoBuilder
		attr_reader :project_name, :git_user, :git_token

		def initialize(project_name, git_user, git_token)
			@project_name = project_name
			@git_user = git_user
			@git_token = git_token
		end

		def build
			Dir.chdir(project_name) do
				new_local_repo
				new_remote_repo
			end
		end

		def new_local_repo
			STDOUT.puts "Creating local git repository"
			system("git init")
		end

		def new_remote_repo
			current_dir = File.basename(Dir.getwd)
			STDOUT.puts "Creating remote git repository"
			repo_req = `curl -u #{git_user}:#{git_token} https://api.github.com/user/repos -d '{\"name\":\"#{current_dir}\"}'`
			response = JSON.parse(repo_req)
	    if response['message'] || response['errors']
	      puts response['message']
	      response['errors'] && response['errors'].each do |err|
	        puts "#{err['message']}"
	      end
	      raise "Error creating GitHub repository"
	    else
				system("git add --all")
				system("git commit -m \'Initial commit\'")
				system("git remote add origin git@github.com:#{git_user}/#{current_dir}.git")
				system("git push -u origin master")
			end
		end

	end
end