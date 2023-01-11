require 'colorize'
require 'find'
require 'fileutils'

class FileExplorer
  def initialize
    @default_directory = Dir.pwd
    @path = @default_directory
  end

  #lil code unfinisjhed right here, get back at ya later, github fucked me over

  private

  def copy_file
    puts 'Enter the file/directory path to be copied: '
    file_path = get_input
    file_path = File.join(@default_directory, file_path) if file_path.empty?
    unless File.exist?(file_path)
      puts "#{file_path} does not exist"
      return
    end
    puts 'Enter the destination path: '
    destination = get_input
    destination = File.join(@default_directory, destination) if destination.empty?
    FileUtils.cp_r(file_path, destination)
  end

  def create_file
    puts 'Enter the file/directory name: '
    name = get_input
    puts 'Enter the path to create file/directory: '
    path = get_input
    path = @default_directory if path.empty?
    if File.exist?(File.join(path, name))
      puts "#{name} already exists"
    else
      puts 'Enter the type of the file (f for file, d for directory): '
      type = get_input
      if type == 'f'
        File.new(File.join(path, name), "w")
        puts "#{name} created"
      elsif type == 'd'
        Dir.mkdir(File.join(path, name))
        puts "#{name} created"
      else
        puts 'Invalid type'
      end
    end
  end

  
end
