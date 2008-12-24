# methods copied directly from ActiveSupport
# see included /LICENSE

module MerbWheels #:nodoc:
  module CoreExt #:nodoc:
    module StringExt #:nodoc:
      
      # Returns the character at the +position+ treating the string as an array (where 0 is the first character).
      #
      # Examples: 
      #   "hello".at(0)  # => "h"
      #   "hello".at(4)  # => "o"
      #   "hello".at(10) # => nil
      def at(position)
        self[position, 1]
      end
      
      # Returns the remaining of the string from the +position+ treating the string as an array (where 0 is the first character).
      #
      # Examples: 
      #   "hello".from(0)  # => "hello"
      #   "hello".from(2)  # => "llo"
      #   "hello".from(10) # => nil
      def from(position)
        self[position..-1]
      end
      
      # Returns the beginning of the string up to the +position+ treating the string as an array (where 0 is the first character).
      #
      # Examples: 
      #   "hello".to(0)  # => "h"
      #   "hello".to(2)  # => "hel"
      #   "hello".to(10) # => "hello"
      def to(position)
        self[0..position]
      end
      
      # Returns the first character of the string or the first +limit+ characters.
      #
      # Examples: 
      #   "hello".first     # => "h"
      #   "hello".first(2)  # => "he"
      #   "hello".first(10) # => "hello"
      def first(limit = 1)
        self[0..(limit - 1)]
      end
      
      # Returns the last character of the string or the last +limit+ characters.
      #
      # Examples: 
      #   "hello".last     # => "o"
      #   "hello".last(2)  # => "lo"
      #   "hello".last(10) # => "hello"
      def last(limit = 1)
        from(-limit) || self
      end
      
      # 'a'.ord == 'a'[0] for Ruby 1.9 forward compatibility.
      def ord
        self[0]
      end if RUBY_VERSION < '1.9'
      
      # Returns the string, first removing all whitespace on both ends of
      # the string, and then changing remaining consecutive whitespace
      # groups into one space each.
      #
      # Examples:
      #   %{ Multi-line
      #      string }.squish                   # => "Multi-line string"
      #   " foo   bar    \n   \t   boo".squish # => "foo bar boo"
      def squish
        dup.squish!
      end

      # Performs a destructive squish. See String#squish.
      def squish!
        strip!
        gsub!(/\s+/, ' ')
        self
      end
      
      # By default, +camelize+ converts strings to UpperCamelCase. If the argument to camelize
      # is set to <tt>:lower</tt> then camelize produces lowerCamelCase.
      #
      # +camelize+ will also convert '/' to '::' which is useful for converting paths to namespaces.
      #
      #   "active_record".camelize                # => "ActiveRecord"
      #   "active_record".camelize(:lower)        # => "activeRecord"
      #   "active_record/errors".camelize         # => "ActiveRecord::Errors"
      #   "active_record/errors".camelize(:lower) # => "activeRecord::Errors"
      def camelize(first_letter = :upper)
        case first_letter
          when :upper then self.camel_case
          when :lower then self.camel_case.to(0).downcase+self.from(1)
        end
      end
      
      # Capitalizes all the words and replaces some characters in the string to create
      # a nicer looking title. +titleize+ is meant for creating pretty output. It is not
      # used in the Rails internals.
      #
      # +titleize+ is also aliased as +titlecase+.
      #
      #   "man from the boondocks".titleize # => "Man From The Boondocks"
      #   "x-men: the last stand".titleize  # => "X Men: The Last Stand"
      def titleize
        # TODO
        # Inflector.titleize(self)
      end
      
      # Replaces underscores with dashes in the string.
      #
      #   "puni_puni" # => "puni-puni"
      def dasherize
        # TODO
        # Inflector.dasherize(self)
      end
      
      # Removes the module part from the constant expression in the string.
      #
      #   "ActiveRecord::CoreExtensions::String::Inflections".demodulize # => "Inflections"
      #   "Inflections".demodulize                                       # => "Inflections"
      def demodulize
        # TODO
        # Inflector.demodulize(self)
      end
      
      
      # Replaces special characters in a string so that it may be used as part of a 'pretty' URL.
      # 
      # ==== Examples
      #
      #   class Person
      #     def to_param
      #       "#{id}-#{name.parameterize}"
      #     end
      #   end
      # 
      #   @person = Person.find(1)
      #   # => #<Person id: 1, name: "Donald E. Knuth">
      # 
      #   <%= link_to(@person.name, person_path %>
      #   # => <a href="/person/1-donald-e-knuth">Donald E. Knuth</a>
      def parameterize
        # TODO
        # Inflector.demodulize(self)
      end
      
      
      # Creates the name of a table like Rails does for models to table names. This method
      # uses the +pluralize+ method on the last word in the string.
      #
      #   "RawScaledScorer".tableize # => "raw_scaled_scorers"
      #   "egg_and_ham".tableize     # => "egg_and_hams"
      #   "fancyCategory".tableize   # => "fancy_categories"
      def tableize
        # TODO
        # Inflector.demodulize(self)
      end
      
      # Create a class name from a plural table name like Rails does for table names to models.
      # Note that this returns a string and not a class. (To convert to an actual class
      # follow +classify+ with +constantize+.)
      #
      #   "egg_and_hams".classify # => "EggAndHam"
      #   "posts".classify        # => "Post"
      #
      # Singular names are not handled correctly.
      #
      #   "business".classify # => "Busines"
      def classify
        # TODO
        # Inflector.classify(self)
      end
      
      # Capitalizes the first word, turns underscores into spaces, and strips '_id'.
      # Like +titleize+, this is meant for creating pretty output.
      #
      #   "employee_salary" # => "Employee salary" 
      #   "author_id"       # => "Author"
      def humanize
        # TODO
        # Inflector.humanize(self)
      end
      
      # Creates a foreign key name from a class name.
      # +separate_class_name_and_id_with_underscore+ sets whether
      # the method should put '_' between the name and 'id'.
      #
      # Examples
      #   "Message".foreign_key        # => "message_id"
      #   "Message".foreign_key(false) # => "messageid"
      #   "Admin::Post".foreign_key    # => "post_id"
      def foreign_key(separate_class_name_and_id_with_underscore = true)
        # TODO
        # Inflector.foreign_key(self, separate_class_name_and_id_with_underscore)
      end
      
      # +constantize+ tries to find a declared constant with the name specified
      # in the string. It raises a NameError when the name is not in CamelCase
      # or is not initialized.
      #
      # Examples
      #   "Module".constantize # => Module
      #   "Class".constantize  # => Class
      def constantize
        # TODO
        # Inflector.constantize(self)
      end
      
      # Does the string start with the specified +prefix+?
      def starts_with?(prefix)
        prefix = prefix.to_s
        self[0, prefix.length] == prefix
      end
      alias_method :start_with?, :starts_with?

      # Does the string end with the specified +suffix+?
      def ends_with?(suffix)
        suffix = suffix.to_s
        self[-suffix.length, suffix.length] == suffix      
      end
      alias_method :end_with?, :ends_with?
    end
  end
end

String.send :include, MerbWheels::CoreExt::StringExt