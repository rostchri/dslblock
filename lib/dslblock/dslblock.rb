require 'active_support/core_ext' # needed for reverse_merge


module DSLBlock
  
  # To be able to use DSL-Syntax when defining objects the class UniversalItem is used as base-class for all kind of classes
  class UniversalItem
    @@depth = 0
    attr_accessor :options, :id, :depth

    def initialize(options={},&block)
      # set some default options
      options = options.reverse_merge :id => rand.to_s.split('.').last # generate random-id if no id is given
      
      # set some instance-variables according to option-values
      set :id           => options.delete(:id),
          :options      => options,
          :depth        => block_depth
          
      track_block_depth do # update depth-variable
        # be able to use initializer with yield or with instance_eval block 
        # based on the number of arguments for the block passed in
        # if no arguments to the block are given instance_eval &block is used
        block.arity == 1 ? yield(self) : instance_eval(&block)
      end if block_given? && !options[:custom_block]
    end
    
    # Thread and exception-safe tracking of block-depth (http://www.alfajango.com/blog/counting-block-nesting-depth-in-ruby/)
    def block_depth=(value)
      #Thread.current[:block_depth] = value
      @@depth = value
    end
  
    def block_depth
      #Thread.current[:block_depth] || 0
      @@depth || 0
    end
  
    def track_block_depth(&block)
      self.block_depth += 1
      yield
      ensure
        self.block_depth -= 1
    end
        
    def set(options, &block)
      unless options.empty?
        options.each { |k,v| self.send("#{k}=",v) } if options.is_a? Hash # set (multiple) instance-variables if options is a hash
        self.send("#{options}=", yield) if block_given? && options.is_a?(Symbol) # set instance-variable to evaluated block if block is given and option is a symbol
      end
      nil
    end
    
    # allows to access all options via method-function
    def method_missing(sym, *args)
      if sym.to_s =~ /\A(.*)\?\z/ && options.include?($1.to_sym) && (options[$1.to_sym].is_a?(TrueClass) || options[$1.to_sym].is_a?(FalseClass))
        options[$1.to_sym]
      elsif sym.to_s =~ /\A(.*)\z/ && options.include?($1.to_sym) 
        options[$1.to_sym]
      else
        false
      end
    end

    def to_s(opts={})
      res = "#{self.class.name}: ##{id} depth: #{depth} options: #{options}"
      res
    end
  end

end
