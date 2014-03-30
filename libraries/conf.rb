
module ProFTPD
  module Conf

    def self.camel2underscore(str)
      str.gsub(/([^A-Z])([A-Z])/,'\1_\2').downcase
    end

    def self.value(v)
      case v
      when Array
        v.map { |x| value(x) }.join(' ')
      when TrueClass
        'on'
      when FalseClass
        'off'
      when nil
        nil
      else
        v.to_s
      end
    end

    def self.set_env(hs)
      unless hs.kind_of?(Hash)
        raise Exceptions::ValidationFailed, "SetEnv attribute must be a kind of Hash! You passed #{hs.inspect}."
      end
      hs.map do |k, v|
        "SetEnv #{k} #{v}"
      end.join("\n")
    end

    def self.global(conf)
    end

    def self.directory(conf)
      path = conf.delete('path')
      unless path.kind_of?(String)
        raise Exceptions::ValidationFailed, '<Directory> directive must have a "path"'
      end
    end

    def self.virtual_host(conf)
      name = conf.delete('name')
      name = name.join(' ') if name.kind_of?(Array)
      unless name.kind_of?(String)
        raise Exceptions::ValidationFailed, '<VirtualHost> directive must have a "name"'
      end

    end

    def self.anonymous(conf)
      path = conf.delete('path')
      unless path.kind_of?(String)
        raise Exceptions::ValidationFailed, '<Anonymous> directive must have a "path"'
      end

    end

    def self.attribute(conf, name)
      key = camel2underscore(name)
      if conf.has_key?(key)
        case name
        when 'SetEnv'
          set_env(conf[key])
        else
          "%-30s %s" % [ name, value(conf[key]) ]
        end
      end
    end

  end
end
