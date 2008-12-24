module MerbWheels #:nodoc:
  module Helpers #:nodoc:
    module SanitizeHelpers
      # This +sanitize+ helper will html encode all tags and strip all attributes that aren't specifically allowed.
      # It also strips href/src tags with invalid protocols, like javascript: especially.  It does its best to counter any
      # tricks that hackers may use, like throwing in unicode/ascii/hex values to get past the javascript: filters.  Check out
      # the extensive test suite.
      #
      #   <%= sanitize @article.body %>
      #
      # You can add or remove tags/attributes if you want to customize it a bit.  See ActionView::Base for full docs on the
      # available options.  You can add tags/attributes for single uses of +sanitize+ by passing either the <tt>:attributes</tt> or <tt>:tags</tt> options:
      #
      # Normal Use
      #
      #   <%= sanitize @article.body %>
      #
      # Custom Use (only the mentioned tags and attributes are allowed, nothing else)
      #
      #   <%= sanitize @article.body, :tags => %w(table tr td), :attributes => %w(id class style)
      #
      # Add table tags to the default allowed tags
      #
      #   Rails::Initializer.run do |config|
      #     config.action_view.sanitized_allowed_tags = 'table', 'tr', 'td'
      #   end
      #
      # Remove tags to the default allowed tags
      #
      #   Rails::Initializer.run do |config|
      #     config.after_initialize do
      #       ActionView::Base.sanitized_allowed_tags.delete 'div'
      #     end
      #   end
      #
      # Change allowed default attributes
      #
      #   Rails::Initializer.run do |config|
      #     config.action_view.sanitized_allowed_attributes = 'id', 'class', 'style'
      #   end
      #
      # Please note that sanitizing user-provided text does not guarantee that the
      # resulting markup is valid (conforming to a document type) or even well-formed.
      # The output may still contain e.g. unescaped '<', '>', '&' characters and
      # confuse browsers.
      #
      def sanitize(html, options = {})
        Inner.white_list_sanitizer.sanitize(html, options)
      end

      # Sanitizes a block of CSS code. Used by +sanitize+ when it comes across a style attribute.
      def sanitize_css(style)
        Inner.white_list_sanitizer.sanitize_css(style)
      end

      # Strips all HTML tags from the +html+, including comments.  This uses the
      # html-scanner tokenizer and so its HTML parsing ability is limited by
      # that of html-scanner.
      #
      # ==== Examples
      #
      #   strip_tags("Strip <i>these</i> tags!")
      #   # => Strip these tags!
      #
      #   strip_tags("<b>Bold</b> no more!  <a href='more.html'>See more here</a>...")
      #   # => Bold no more!  See more here...
      #
      #   strip_tags("<div id='top-bar'>Welcome to my website!</div>")
      #   # => Welcome to my website!
      def strip_tags(html)
        Inner.full_sanitizer.sanitize(html)
      end

      # Strips all link tags from +text+ leaving just the link text.
      #
      # ==== Examples
      #   strip_links('<a href="http://www.rubyonrails.org">Ruby on Rails</a>')
      #   # => Ruby on Rails
      #
      #   strip_links('Please e-mail me at <a href="mailto:me@email.com">me@email.com</a>.')
      #   # => Please e-mail me at me@email.com.
      #
      #   strip_links('Blog: <a href="http://www.myblog.com/" class="nav" target=\"_blank\">Visit</a>.')
      #   # => Blog: Visit
      def strip_links(html)
        Inner.link_sanitizer.sanitize(html)
      end

      module Inner #:nodoc:
        mattr_writer :full_sanitizer, :link_sanitizer, :white_list_sanitizer

        def sanitized_protocol_separator
          Inner.white_list_sanitizer.protocol_separator
        end

        def sanitized_uri_attributes
          Inner.white_list_sanitizer.uri_attributes
        end

        def sanitized_bad_tags
          Inner.white_list_sanitizer.bad_tags
        end

        def sanitized_allowed_tags
          Inner.white_list_sanitizer.allowed_tags
        end

        def sanitized_allowed_attributes
          Inner.white_list_sanitizer.allowed_attributes
        end

        def sanitized_allowed_css_properties
          Inner.white_list_sanitizer.allowed_css_properties
        end

        def sanitized_allowed_css_keywords
          Inner.white_list_sanitizer.allowed_css_keywords
        end

        def sanitized_shorthand_css_properties
          Inner.white_list_sanitizer.shorthand_css_properties
        end

        def sanitized_allowed_protocols
          Inner.white_list_sanitizer.allowed_protocols
        end

        def sanitized_protocol_separator=(value)
          Inner.white_list_sanitizer.protocol_separator = value
        end

        # Gets the HTML::FullSanitizer instance used by +strip_tags+.  Replace with
        # any object that responds to +sanitize+.
        def self.full_sanitizer
          @full_sanitizer ||= MerbWheels::FullSanitizer.new
        end

        # Gets the HTML::LinkSanitizer instance used by +strip_links+.  Replace with
        # any object that responds to +sanitize+.
        def self.link_sanitizer
          @link_sanitizer ||= MerbWheels::LinkSanitizer.new
        end

        # Gets the HTML::WhiteListSanitizer instance used by sanitize and +sanitize_css+.
        # Replace with any object that responds to +sanitize+.
        def self.white_list_sanitizer
          @white_list_sanitizer ||= MerbWheels::WhiteListSanitizer.new
        end

        # Adds valid HTML attributes that the +sanitize+ helper checks for URIs.
        #
        #   Rails::Initializer.run do |config|
        #     config.action_view.sanitized_uri_attributes = 'lowsrc', 'target'
        #   end
        #
        def sanitized_uri_attributes=(attributes)
          MerbWheels::WhiteListSanitizer.uri_attributes.merge(attributes)
        end

        # Adds to the Set of 'bad' tags for the +sanitize+ helper.
        #
        #   Rails::Initializer.run do |config|
        #     config.action_view.sanitized_bad_tags = 'embed', 'object'
        #   end
        #
        def sanitized_bad_tags=(attributes)
          MerbWheels::WhiteListSanitizer.bad_tags.merge(attributes)
        end

        # Adds to the Set of allowed tags for the +sanitize+ helper.
        #
        #   Rails::Initializer.run do |config|
        #     config.action_view.sanitized_allowed_tags = 'table', 'tr', 'td'
        #   end
        #
        def sanitized_allowed_tags=(attributes)
          MerbWheels::WhiteListSanitizer.allowed_tags.merge(attributes)
        end

        # Adds to the Set of allowed HTML attributes for the +sanitize+ helper.
        #
        #   Rails::Initializer.run do |config|
        #     config.action_view.sanitized_allowed_attributes = 'onclick', 'longdesc'
        #   end
        #
        def sanitized_allowed_attributes=(attributes)
          MerbWheels::WhiteListSanitizer.allowed_attributes.merge(attributes)
        end

        # Adds to the Set of allowed CSS properties for the #sanitize and +sanitize_css+ helpers.
        #
        #   Rails::Initializer.run do |config|
        #     config.action_view.sanitized_allowed_css_properties = 'expression'
        #   end
        #
        def sanitized_allowed_css_properties=(attributes)
          MerbWheels::WhiteListSanitizer.allowed_css_properties.merge(attributes)
        end

        # Adds to the Set of allowed CSS keywords for the +sanitize+ and +sanitize_css+ helpers.
        #
        #   Rails::Initializer.run do |config|
        #     config.action_view.sanitized_allowed_css_keywords = 'expression'
        #   end
        #
        def sanitized_allowed_css_keywords=(attributes)
          MerbWheels::WhiteListSanitizer.allowed_css_keywords.merge(attributes)
        end

        # Adds to the Set of allowed shorthand CSS properties for the +sanitize+ and +sanitize_css+ helpers.
        #
        #   Rails::Initializer.run do |config|
        #     config.action_view.sanitized_shorthand_css_properties = 'expression'
        #   end
        #
        def sanitized_shorthand_css_properties=(attributes)
          MerbWheels::WhiteListSanitizer.shorthand_css_properties.merge(attributes)
        end

        # Adds to the Set of allowed protocols for the +sanitize+ helper.
        #
        #   Rails::Initializer.run do |config|
        #     config.action_view.sanitized_allowed_protocols = 'ssh', 'feed'
        #   end
        #
        def sanitized_allowed_protocols=(attributes)
          MerbWheels::WhiteListSanitizer.allowed_protocols.merge(attributes)
        end
      end
    end
  end
end
