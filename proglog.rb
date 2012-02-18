require 'crayon'
require './settings.rb'


def recent
  if ARGV[1]
    then num = ARGV[1].to_i
  else num = 5
  end
  
  file = File.new(@file,'r')
  count = file.lines.count.to_i
  file.close
  
  if count < num
    then num = count
  end
  puts Crayon.red("Here are #{num} recent commits")

  start_line = (count - num)+1
  end_line = count

  range = (start_line..end_line)

  file = File.new(@file,'r')
  file.each_line do |line|
    if range.include? file.lineno
      then
        summary = split_input_text(line)
        colour_and_print summary
      else
      end
  end 
  file.close
  
end

def all
  puts Crayon.red("All commits")
  File.open(@file,'r').each_line do |line|
    summary = split_input_text(line)
    # puts summary
    colour_and_print summary
  end
end

def add_commit
  puts Crayon.red("Add commit")
  date = Time.now.strftime("%d %b %Y %H:%M")
  user = @user 
  all = ARGV.join(" ")
  commit = all.split("@")[0].chop
  section = all.split("@")[1]
  summary = [date, user, commit, section]
  colour_and_print summary
  # exit
  File.open(@file, "a+") do |file|
    file.write("#{flatten_for_file(summary)}\n")
  end
end             

def interpret_arguments
  case ARGV[0]
  when "recent"
    recent
  when "r"
    recent
  when "all"
    all
  when "a"
    all
  else
    add_commit
  end
end

def split_input_text(text)
  begin
    date = text.split("[")[0].chop
    user = text.scan(/\[(..)\]/)[0][0]
    rest = text.scan(/\]\s(.*)/)[0][0]
    if rest.split("@").count > 1
      then 
        commit = rest.split("@")[0].chop
        section = rest.split("@")[1]
      else
        commit = rest
        section = ""
      end
      [date, user, commit, section]
  rescue
    text
  end
end

def colour_and_print(summary)
  begin
    date = Crayon.green(summary[0])
    user = Crayon.yellow(summary[1])
    commit = summary[2]
    section = Crayon.blue("@"+summary[3])
    summary = "#{date} [#{user}] #{commit} #{section}\n"
    puts summary
  rescue 
    puts summary
  end
end  

def flatten_for_file(summary)
  "#{summary[0]} [#{summary[1]}] #{summary[2]} @#{summary[3]}"
end

interpret_arguments
