require 'ostruct'
module Talkable
  class JSONStruct < OpenStruct
    def initialize(hash = nil)
      @table = {}

      class << @table
        def []=(key, value)
          super(key, _deep_struct(value))
        end

        def duplicate
          hash = {}
          each do |key, value|
            hash[key] = _deep_hash(value)
          end
          hash
        end

        private

        def _deep_struct(value)
          if value.is_a?(Array)
            value.map{ |x| _deep_struct(x) }
          elsif value.is_a?(Hash)
            JSONStruct.new(value)
          else
            value
          end
        end

        def _deep_hash(value)
          if value.is_a?(Array)
            value.map{ |x| _deep_hash(x) }
          elsif value.is_a?(JSONStruct)
            value.to_h
          else
            value
          end
        end
      end

      if hash
        hash.each do |key, value|
          @table[key.to_sym] = value
          new_ostruct_member(key)
        end
      end
    end

    def to_h
      @table.duplicate
    end

    def [](key)
      public_send("#{key}")
    end

    def []=(key, value)
      public_send("#{key}=", value)
    end
  end
end
