require 'json'
require 'open-uri'
require 'term/ansicolor'

class String
  include Term::ANSIColor
end


module Gemfile19
  extend self

  ISIT19_URL     = "http://isitruby19.com"
  ISIT19_FILE    = "comments.json"
  VERSION_REGEXP = /^[>=~]*\s*(\d.+)$/
  GEMNAME_REGEXP = /^gem\s*["|'](.*.?)["|']s*/

  def run
    begin
      open_and_parse_gemfile
      parse_gem_comments
      create_and_print_report
    rescue Errno::ENOENT
      puts 'Missing Gemfile. Please run gemfil19 in your Ruby/Rails project root dir'
    end
  end

  def open_and_parse_gemfile
    @gems_to_check = []
    gemfile ||= File.read('Gemfile').split(/\n/)
    gemfile.each do |line|
      line = line.split(",")
      name, version = line[0], line[1]
      @gems_to_check << $1 if (name && name.strip.match(GEMNAME_REGEXP))
    end
  end

  def parse_gem_comments
    @tested_gems   = []
    @untested_gems = []
    @missing_gems  = []
    @will_work = []
    @may_work  = []
    @will_fail = []

    @gems_to_check.each do |gem_name|
      url = "#{ISIT19_URL}/#{gem_name}/#{ISIT19_FILE}"
      begin
        json_data = open(url).read
      rescue
        @missing_gems << gem_name
        next
      end

      gem_comments = JSON.parse(json_data)
      if gem_comments.size == 0
        @untested_gems << gem_name
      else
        sum = 0
        gem_comments.each do |c|
          sum += 1 if c["comment"]["works_for_me"]
        end
        calculate_compatability_ratio(sum, gem_comments.size, gem_name)
      end
    end
  end

  def create_and_print_report
    puts ""
    puts "Gemfile19 v0.1.0".negative
    puts "================"
    puts ""
    puts "Gems that will work - #{@will_work.size}".green
    puts "------------------------".green
    puts ""
    puts @will_work
    puts ""
    puts "Gems that may work - #{@may_work.size}".yellow
    puts "-----------------------".yellow
    puts ""
    puts @may_work
    puts ""
    puts "Gems that will fail - #{@will_fail.size}".red
    puts "-----------------------".red
    puts ""
    puts @will_fail
    puts ""
    puts "Untested gems - #{@will_fail.size}"
    puts "-----------------"
    puts ""
    puts @untested_gems
    puts ""
    puts "Missing gems - #{@missing_gems.size}"
    puts "-----------------"
    puts ""
    puts @missing_gems
    puts ""
  end

  def calculate_compatability_ratio(works_for_me, count, name)
    rate = works_for_me/count.to_f
    if rate > 0.80
      @will_work << name #{:name => name, :rate => rate }
    elsif rate >= 0.40
      @may_work  << name #{ :name => name, :rate => rate }
    else
      @will_fail << name #{ :name => name, :rate => rate }
    end
  end

end
