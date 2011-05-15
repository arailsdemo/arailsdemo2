require 'cucumber/formatter/usage'

class StepListFormatter < Cucumber::Formatter::Usage
  attr_reader :io

  def file_output
    @file_output ||= "File generated on #{Time.now}\n"
  end

  def add_to_output(io_string, file_string=nil)
    file_string = io_string if file_string.nil?
    io.print io_string
    file_output << file_string
  end

  def print_summary(features)  # [1]
    add_unused_stepdefs
    aggregate_info
    print_body
    print_footer(features)
    print_to_file if @options[:dry_run]
  end

  def print_body  # [1]
    keys = @stepdef_to_match.keys.sort {|a,b| a.regexp_source <=> b.regexp_source}

    keys.each_with_index do |stepdef_key, i|
      print_border if i%5 == 0
      print_step_definition(stepdef_key, i)
    end
  end

  def print_border  # [1] [2]
    border = "#{'_' * max_length}\n"
    add_to_output(border)
  end

  def max_length  # [2] [3]
    @max_length ||= max_stepdef_length + max_file_colon_line! + 4
  end

  def max_file_colon_line!  # [3] [4]
    @stepdef_to_match.keys.map do |key|
      trim_file_path!(key) if @options[:dry_run]
      key.file_colon_line.unpack('U*').length
    end.max
  end

  def trim_file_path!(path)  # [4]
    path.instance_eval { @file_colon_line = path.file_colon_line.split('features/step_definitions/')[1] }
  end

  def print_step_definition(stepdef_key, i)  # [1] [5]
    num = "#{i+1}) "
    add_to_output(num)

    clean_up_and_print_regex(stepdef_key)
    print_line_comment(stepdef_key) if @options[:source]
  end

  def clean_up_and_print_regex(stepdef_key)  # [5] [6]
    regex = stepdef_key.regexp_source[1..-2]
    regex_ok?(regex) ? regex.chop!.slice!(0) : regex << "[!]"
    add_to_output(format_string(regex, stepdef_key.status), regex)
  end

  def regex_ok?(regex) # [6]  check to see if regex starts with "^" and ends with "$"
    if Fixnum === regex[0]
      regex[0] == 94 && regex[-1] == 36  # ruby 1.8.7
    else
      regex[0] == "^" && regex[-1] == "$"  # ruby 1.9.2
    end
  end

  def print_line_comment(stepdef_key)  # [5]
    indent = max_stepdef_length - stepdef_key.regexp_source.unpack('U*').length
    line_comment = "# #{stepdef_key.file_colon_line}\n".indent(indent + 3)
    add_to_output(format_string(line_comment, :comment), line_comment)
  end

  def print_footer(features)  # [1]
    io.puts
    print_steps(:pending)
    print_steps(:failed)
    print_stats(features, @options.custom_profiles)
    unless @options[:dry_run]
      print_snippets(@options)
      print_passing_wip(@options)
    end
  end

  def print_to_file  # [1]
    begin
      File.open("features/step_definitions/step_list.txt", "w") { |f| f.write(file_output) }
    rescue Exception => e
      io.puts "Could not write list to file: #{e.message}"
    end
  end
end