module Grid5000
  class Graph
    VERSION = "0.1.0"
    
    class Error < StandardError; end
    
    attr_reader :options, :nodes
    
    def initialize(nodes, options = {})
      @nodes = nodes
      @options = options
    end
    
    class << self
      def check_environment!
        `which rrdtool`
        raise(Error, "It looks like you do not have the `rrdtool` binary in your path. Please try to install it first.") if $?.exitstatus != 0
        `which unzip`
        raise(Error, "It looks like you do not have the `unzip` binary in your path. Please try to install it first.") if $?.exitstatus != 0
        true
      end
    end
    
    def graph!      
      raise(Error, "No nodes given") if nodes.empty?

      if nodes.all?{|n| n =~ /\.\w+\.grid5000\.fr$/}
        fetch_timeseries
        graph_timeseries
      else
        raise(Error, "One of the given nodes is not correct: #{nodes.inspect}")
      end

    end
    
    def fetch_timeseries
      nodes_by_site = nodes.group_by{|n|
        n.split(".")[1]
      }
      nodes_by_site.keys.each do |site|
        cmd = "curl -kn \"https://api.grid5000.fr/2.0/grid5000"+
        "/sites/#{site}/metrics/{#{options[:metrics].join(",")}}/timeseries.zip"+
        "?only=#{nodes_by_site[site].join(",")}"+
        "&from=#{options[:from]}"+
        "&to=#{options[:to]}"+
        "&resolution=#{options[:resolution]}\""+
        " -o \"#{File.join(options[:output], "#{site}-#1-timeseries.zip")}\""
        puts cmd
        system cmd
      end
    end
    
    def graph_timeseries
      Dir.chdir(options[:output]) do |dir|
        Dir["*.zip"].each do |zip|
         system "unzip #{zip}"
        end
        commands = {}
        Dir["*.grid5000.fr/*.xml"].each do |xml|
         dirname = File.dirname(xml)
         metric = File.basename(xml, ".xml")
         node = File.basename(dirname).split(".").first
         commands[metric] ||= "rrdtool graph #{metric}.png --title #{metric} -s #{options[:from]}"
         puts "Restoring #{metric}..."
         rrd = "#{File.join(dirname, metric)}.rrd"
         File.unlink rrd if File.exist?(rrd)
         system "rrdtool restore #{xml} #{rrd}"
         # generate random color
         color = "%06x" % (rand * 0xffffff)
         commands[metric] += " DEF:#{node}=#{rrd}:sum:AVERAGE LINE2:#{node}##{color}:#{node}"
        end
        commands.each do |metric, cmd| 
         puts "Executing #{cmd}"
         system cmd
        end
        puts "The following graphs have been generated in #{dir.inspect}:"
        puts Dir["*.png"].join("\n")
      end
    end
    
  end
end