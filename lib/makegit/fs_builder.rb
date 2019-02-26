module Application
	class FSBuilder
		attr_reader :project_name, :template

		def initialize(project_name, template)
			@project_name = project_name
			@template = template || "bare"
		end

		def build
			if template == "bare"
				bare
			elsif template == "rubygem"
				rubygem
			else
				raise ArgumentError, "Could not find a template to build"
			end
		end

		def bare
			STDOUT.puts "Building a bare project template"
			Dir.mkdir(project_name)
			Dir.chdir(project_name) do
				File.open("README.md", "w"){ |f| f.puts "\# #{project_name}"}
			end
		end

		def rubygem
			STDOUT.puts "Building a RubyGem project template"
			Dir.mkdir(project_name)
			Dir.chdir(project_name) do
				File.open("#{project_name}.gemspec", "w"){ |f| 
					f << "Gem::Specification.new do |s|\n"
					f << "\ts.name        = \'\'\n"
					f << "\ts.version     = \'\'\n"
					f << "\ts.date        = \'\'\n"
					f << "\ts.summary     = \'\'\n"
					f << "\ts.description = \'\'\n"
					f << "\ts.authors     = \'[]\'\n"
					f << "\ts.email       = \'\'\n"
					f << "\ts.files       = \'[]\'\n"
					f << "\ts.executables << \'#{project_name}\'\n"
					f << "\ts.homepage    = \'\'\n"
					f << "\ts.license     = \'\'\n"
					f << "end"
				}
				File.open("Rakefile", "w")
				File.open("README.md", "w"){ |f| f.puts "\# #{project_name}: A RubyGem"}

				Dir.mkdir("bin")
				Dir.chdir("bin") do
					File.open(project_name, "w"){ |f| f.puts "\#!/usr/bin/env ruby"}
				end

				Dir.mkdir("lib")
				Dir.chdir("lib") do
					File.open("#{project_name}.rb", "w")
				end

				Dir.mkdir("test")
				Dir.chdir("test") do
					File.open("test_#{project_name}.rb", "w")
				end
			end
		end
	end
end