require 'colorize'
require 'fileutils'
require 'find'

class FileExplorer
  def initialize
    @default_directory = Dir.pwd
    @path = @default_directory
    @changes = []
  end

  def run
    loop do
      print_directory
      input = get_input
      case input
      when 'l'
        list_files
      when 'c'
        change_directory
      when 'r'
        rename_file
      when 'd'
        delete_file
      when 'w'
        save_changes
      when 'f'
        find_files
      when 'cp'
        copy_file
      when 's'
        file_info
      when 't'
        create_file
      when 'u'
        undo
      when 'h'
        help
      when 'q'
        puts 'Exiting file explorer...'
        break
      else
        puts 'Invalid option'
      end
    end
  end

  private

  def print_directory
    puts "#{@path} $ "
  end

  def get_input
    gets.strip
  end

  def list_files
    Find.find(@path) do |f|
      if File.directory?(f)
        puts "#{File.basename(f)}/".colorize(:blue)
      else
        puts "#{File.basename(f)}".colorize(:green)
      end
    end
  end

  def change_directory
    puts 'Enter the path: '
    new_path = get_input
    new_path = File.join(@default_directory, new_path) if new_path.empty?
    if Dir.exist?(new_path)
      @changes << [:cd, @path]
      @path = new_path
      Dir.chdir(@path)
    else
      puts "#{new_path} does not exist"
    end
  end
  
  def rename_file
    puts 'Enter new file name: '
    new_name = get_input
    @changes << [:mv, File.basename(file_path), File.join(File.dirname(file_path), new_name)]
    File.rename(file_path, File.join(File.dirname(file_path), new_name))
    puts "#{File.basename(file_path)} renamed to #{new_name}"
  end

  def delete_file
    puts 'Enter the file/directory path to be deleted: '
    file_path = get_input
    file_path = File.join(@default_directory, file_path) if file_path.empty?
    unless File.exist?(file_path)
      puts "#{file_path} does not exist"
      return
    end
    @changes << [:rm, File.basename(file_path), file_path]
    if File.directory?(file_path)
      FileUtils.remove_dir(file_path)
    else
      File.delete(file_path)
    end
    puts "#{File.basename(file_path)} deleted"
  end

  def save_changes
    puts 'Enter the file name to save changes: '
    file_name = get_input
    File.open(file_name, 'w') do |file|
      @changes.each do |change|
        case change[0]
        when :cd
          file.puts "cd #{change[1]}"
        when :mv
          file.puts "mv #{change[2]} #{change[1]}"
        when :rm
          file.puts "rm -r #{change[2]}"
        when :cp
          file.puts "cp -r #{change[2]} #{change[3]}"
        when :touch
          file.puts "touch #{File.join(change[2], change[1])}"
        when :mkdir
          file.puts "mkdir #{File.join(change[2], change[1])}"
        end
      end
    end
    puts "Changes saved to #{file_name}"
  end

  def find_files
    puts 'Enter the name of the file(s) to find: '
    name = get_input
    found = false
    Find.find(@path) do |f|
      if File.basename(f) == name
        puts f
        found = true
      end
    end
    puts "No files found with name #{name}" unless found
  end

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
    @changes << [:cp, File.basename(file_path), file_path, destination]
    FileUtils.cp_r(file_path, destination)
  end

  def file_info
    puts 'Enter the file path: '
    file_path = get_input
    file_path = File.join(@default_directory, file_path) if file_path.empty?
    unless File.exist?(file_path)
      puts "#{file_path} does not exist"
      return
    end
    puts "Size: #{File.size(file_path)} bytes"
    puts "Permissions: #{File.stat(file_path).mode.to_s(8)[-4, 4]}"
    puts "Last modified: #{File.mtime(file_path)}"
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
        @changes << [:touch, name, path]
        puts "#{name} created"
      elsif type == 'd'
        Dir.mkdir(File.join(path, name))
        @changes << [:mkdir, name, path]
        puts "#{name} created"
      else
        puts 'Invalid type'
      end
    end
  end

  def undo
    last_change = @changes.pop
    case last_change[0]
    when :cd
      @path = last_change[1]
      Dir.chdir(@path)
      puts "Moved to #{@path}"
    when :mv
      File.rename(File.join(File.dirname(last_change[2]), last_change[1]), last_change[2])
      puts "#{last_change[1]} renamed back to #{File.basename(last_change[2])}"
    when :rm
      if File.directory?(last_change[2])
        Dir.mkdir(last_change[2])
      else
        File.new(last_change[2], "w")
      end
      puts "#{last_change[1]} restored"
    when :cp
      FileUtils.rm_r(last_change[3])
      puts "#{last_change[1]} removed from #{last_change[3]}"
    when :touch
      File.delete(File.join(last_change[2], last_change[1]))
      puts "#{last_change[1]} deleted"
    when :mkdir
      FileUtils.remove_dir(File.join(last_change[2], last_change[1]))
      puts "#{last_change[1]} deleted"
    end
  end

  def help
    puts 'l: List files in current directory'
    puts 'c: Change directory'
    puts 'r: Rename file'
    puts 'd: Delete file'
    puts 'w: Save changes'
    puts 'f: Find files'
    puts 'cp: Copy file'
    puts 's: File information'
    puts 't: Create file/directory'
    puts 'u: Undo last change'
    puts 'q: Exit'
  end
end

explorer = FileExplorer.new
explorer.run
