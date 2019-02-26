module Application
	class Config
		attr_reader :user, :token
		
		def initialize()
			@user = git_user
			@token = git_token
		end

		def login
			[user, token]
		end
			
	private
		def git_user
			user = `git config github.user`.strip
			if user.empty? || user.nil?
				STDOUT.puts "Warning: git config --global github.user not set"
				STDOUT.puts "Let's set it now..."
				STDOUT.puts "Please enter your GitHub username:"
				user = STDIN.gets.strip
				set_git_config_user(user)
			end
			user
		end

		def git_token
			token = `git config github.token`.strip
			if token.empty? || token.nil?
				STDOUT.puts "Warning: git config --global github.token not set"
				STDOUT.puts "Let's set it now..."
				STDOUT.puts "Visit https://help.github.com/articles/creating-an-access-token-for-command-line-use/"
				STDOUT.puts "Then create a personal access token with the \"repo\" role set"
				STDOUT.puts "Please enter your GitHub token:"
				token = STDIN.gets.strip
				set_git_config_token(token)
			end
			token
		end

		def set_git_config_user(user)
			system("git config --global github.user #{user}")
		end

		def set_git_config_token(token)
			system("git config --global github.token #{token}")
		end
	end
end