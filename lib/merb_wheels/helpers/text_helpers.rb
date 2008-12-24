module MerbWheels #:nodoc:
  module Helpers #:nodoc:
    module TextHelpers
      
      # Truncates a given +text+ after a given <tt>:length</tt> if +text+ is longer than <tt>:length</tt>
      # (defaults to 30). The last characters will be replaced with the <tt>:omission</tt> (defaults to "...").
      #
      # ==== Examples
      #
      #   truncate("Once upon a time in a world far far away")
      #   # => Once upon a time in a world f...
      #
      #   truncate("Once upon a time in a world far far away", :length => 14)
      #   # => Once upon a...
      #
      #   truncate("And they found that many people were sleeping better.", :length => 25, "(clipped)")
      #   # => And they found that many (clipped)
      #
      #   truncate("And they found that many people were sleeping better.", :omission => "... (continued)", :length => 15)
      #   # => And they found... (continued)
      #
      # You can still use <tt>truncate</tt> with the old API that accepts the
      # +length+ as its optional second and the +ellipsis+ as its
      # optional third parameter:
      #   truncate("Once upon a time in a world far far away", 14)
      #   # => Once upon a time in a world f...
      #
      #   truncate("And they found that many people were sleeping better.", 15, "... (continued)")
      #   # => And they found... (continued)
      def truncate(text, *args)
        options = extract_options_from_args!(args) || {}
        unless args.empty?
          options[:length] = args[0]
          options[:omission] = args[1]
        end
        
        # set defaults
        options[:length] ||= 30
        options[:omission] ||= "..."
        
        if text
          return text.to_s.truncate(options[:length], options[:omission])
        else
          return ""
        end
      end
      
      # Highlights one or more +phrases+ everywhere in +text+ by inserting it into
      # a <tt>:highlighter</tt> string. The highlighter can be specialized by passing <tt>:highlighter</tt>
      # as a single-quoted string with \1 where the phrase is to be inserted (defaults to
      # '<strong class="highlight">\1</strong>')
      #
      # ==== Examples
      #   highlight('You searched for: rails', 'rails')
      #   # => You searched for: <strong class="highlight">rails</strong>
      #
      #   highlight('You searched for: ruby, rails, dhh', 'actionpack')
      #   # => You searched for: ruby, rails, dhh
      #
      #   highlight('You searched for: rails', ['for', 'rails'], :highlighter => '<em>\1</em>')
      #   # => You searched <em>for</em>: <em>rails</em>
      #
      #   highlight('You searched for: rails', 'rails', :highlighter => '<a href="search?q=\1">\1</a>')
      #   # => You searched for: <a href="search?q=rails">rails</a>
      #
      # You can still use <tt>highlight</tt> with the old API that accepts the
      # +highlighter+ as its optional third parameter:
      #   highlight('You searched for: rails', 'rails', '<a href="search?q=\1">\1</a>')     # => You searched for: <a href="search?q=rails">rails</a>
      def highlight(text, phrases, *args)
        options = extract_options_from_args!(args) || {}
        unless args.empty?
          options[:highlighter] = args[0] || '<strong class="highlight">\1</strong>'
        end
        options.reverse_merge!(:highlighter => '<strong class="highlight">\1</strong>')

        if text.blank? || phrases.blank?
          text
        else
          match = Array(phrases).map { |p| Regexp.escape(p) }.join('|')
          text.gsub(/(#{match})/i, options[:highlighter])
        end
      end
      
      # Extracts an excerpt from +text+ that matches the first instance of +phrase+.
      # The <tt>:radius</tt> option expands the excerpt on each side of the first occurrence of +phrase+ by the number of characters
      # defined in <tt>:radius</tt> (which defaults to 100). If the excerpt radius overflows the beginning or end of the +text+,
      # then the <tt>:omission</tt> option (which defaults to "...") will be prepended/appended accordingly. The resulting string
      # will be stripped in any case. If the +phrase+ isn't found, nil is returned.
      #
      # ==== Examples
      #   excerpt('This is an example', 'an', :radius => 5)
      #   # => ...s is an exam...
      #
      #   excerpt('This is an example', 'is', :radius => 5)
      #   # => This is a...
      #
      #   excerpt('This is an example', 'is')
      #   # => This is an example
      #
      #   excerpt('This next thing is an example', 'ex', :radius => 2)
      #   # => ...next...
      #
      #   excerpt('This is also an example', 'an', :radius => 8, :omission => '<chop> ')
      #   # => <chop> is also an example
      #
      # You can still use <tt>excerpt</tt> with the old API that accepts the
      # +radius+ as its optional third and the +ellipsis+ as its
      # optional forth parameter:
      #   excerpt('This is an example', 'an', 5)                   # => ...s is an exam...
      #   excerpt('This is also an example', 'an', 8, '<chop> ')   # => <chop> is also an example
      def excerpt(text, phrase, *args)
        options = extract_options_from_args!(args) || {}
        unless args.empty?
          options[:radius] = args[0] || 100
          options[:omission] = args[1] || "..."
        end
        options.reverse_merge!(:radius => 100, :omission => "...")

        if text && phrase
          phrase = Regexp.escape(phrase)

          if found_pos = text =~ /(#{phrase})/i
            start_pos = [ found_pos - options[:radius], 0 ].max
            end_pos   = [ [ found_pos + phrase.length + options[:radius] - 1, 0].max, text.length ].min

            prefix  = start_pos > 0 ? options[:omission] : ""
            postfix = end_pos < text.length - 1 ? options[:omission] : ""

            prefix + text[start_pos..end_pos].strip + postfix
          else
            nil
          end
        end
      end
      
      # Attempts to pluralize the +singular+ word unless +count+ is 1. If
      # +plural+ is supplied, it will use that when count is > 1, otherwise
      # it will use the Inflector to determine the plural form
      #
      # ==== Examples
      #   pluralize(1, 'person')
      #   # => 1 person
      #
      #   pluralize(2, 'person')
      #   # => 2 people
      #
      #   pluralize(3, 'person', 'users')
      #   # => 3 users
      #
      #   pluralize(0, 'person')
      #   # => 0 people
      def pluralize(count, singular, plural = nil)
        "#{count || 0} " + ((count == 1 || count == '1') ? singular : (plural || singular.pluralize))
      end
      
      # Wraps the +text+ into lines no longer than +line_width+ width. This method
      # breaks on the first whitespace character that does not exceed +line_width+
      # (which is 80 by default).
      #
      # ==== Examples
      #
      #   word_wrap('Once upon a time')
      #   # => Once upon a time
      #
      #   word_wrap('Once upon a time, in a kingdom called Far Far Away, a king fell ill, and finding a successor to the throne turned out to be more trouble than anyone could have imagined...')
      #   # => Once upon a time, in a kingdom called Far Far Away, a king fell ill, and finding\n a successor to the throne turned out to be more trouble than anyone could have\n imagined...
      #
      #   word_wrap('Once upon a time', :line_width => 8)
      #   # => Once upon\na time
      #
      #   word_wrap('Once upon a time', :line_width => 1)
      #   # => Once\nupon\na\ntime
      #
      # You can still use <tt>word_wrap</tt> with the old API that accepts the
      # +line_width+ as its optional second parameter:
      #   word_wrap('Once upon a time', 8)     # => Once upon\na time
      def word_wrap(text, *args)
        options = extract_options_from_args!(args) || {}
        unless args.blank?
          options[:line_width] = args[0] || 80
        end
        options.reverse_merge!(:line_width => 80)

        text.split("\n").collect do |line|
          line.length > options[:line_width] ? line.gsub(/(.{1,#{options[:line_width]}})(\s+|$)/, "\\1\n").strip : line
        end * "\n"
      end
      
      
      # Returns +text+ transformed into HTML using simple formatting rules.
      # Two or more consecutive newlines(<tt>\n\n</tt>) are considered as a
      # paragraph and wrapped in <tt><p></tt> tags. One newline (<tt>\n</tt>) is
      # considered as a linebreak and a <tt><br /></tt> tag is appended. This
      # method does not remove the newlines from the +text+.
      #
      # You can pass any HTML attributes into <tt>html_options</tt>.  These
      # will be added to all created paragraphs.
      # ==== Examples
      #   my_text = "Here is some basic text...\n...with a line break."
      #
      #   simple_format(my_text)
      #   # => "<p>Here is some basic text...\n<br />...with a line break.</p>"
      #
      #   more_text = "We want to put a paragraph...\n\n...right there."
      #
      #   simple_format(more_text)
      #   # => "<p>We want to put a paragraph...</p>\n\n<p>...right there.</p>"
      #
      #   simple_format("Look ma! A class!", :class => 'description')
      #   # => "<p class='description'>Look ma! A class!</p>"
      def simple_format(text, html_options={})
        start_tag = open_tag('p', html_options)
        text = text.to_s.dup
        text.gsub!(/\r\n?/, "\n")                    # \r\n and \r -> \n
        text.gsub!(/\n\n+/, "</p>\n\n#{start_tag}")  # 2+ newline  -> paragraph
        text.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />') # 1 newline   -> br
        text.insert 0, start_tag
        text << "</p>"
      end
      
      
      # Turns all URLs and e-mail addresses into clickable links. The <tt>:link</tt> option
      # will limit what should be linked. You can add HTML attributes to the links using
      # <tt>:href_options</tt>. Possible values for <tt>:link</tt> are <tt>:all</tt> (default),
      # <tt>:email_addresses</tt>, and <tt>:urls</tt>. If a block is given, each URL and
      # e-mail address is yielded and the result is used as the link text.
      #
      # ==== Examples
      #   auto_link("Go to http://www.rubyonrails.org and say hello to david@loudthinking.com")
      #   # => "Go to <a href=\"http://www.rubyonrails.org\">http://www.rubyonrails.org</a> and
      #   #     say hello to <a href=\"mailto:david@loudthinking.com\">david@loudthinking.com</a>"
      #
      #   auto_link("Visit http://www.loudthinking.com/ or e-mail david@loudthinking.com", :link => :urls)
      #   # => "Visit <a href=\"http://www.loudthinking.com/\">http://www.loudthinking.com/</a>
      #   #     or e-mail david@loudthinking.com"
      #
      #   auto_link("Visit http://www.loudthinking.com/ or e-mail david@loudthinking.com", :link => :email_addresses)
      #   # => "Visit http://www.loudthinking.com/ or e-mail <a href=\"mailto:david@loudthinking.com\">david@loudthinking.com</a>"
      #
      #   post_body = "Welcome to my new blog at http://www.myblog.com/.  Please e-mail me at me@email.com."
      #   auto_link(post_body, :href_options => { :target => '_blank' }) do |text|
      #     truncate(text, 15)
      #   end
      #   # => "Welcome to my new blog at <a href=\"http://www.myblog.com/\" target=\"_blank\">http://www.m...</a>.
      #         Please e-mail me at <a href=\"mailto:me@email.com\">me@email.com</a>."
      #
      #
      # You can still use <tt>auto_link</tt> with the old API that accepts the
      # +link+ as its optional second parameter and the +html_options+ hash
      # as its optional third parameter:
      #   post_body = "Welcome to my new blog at http://www.myblog.com/. Please e-mail me at me@email.com."
      #   auto_link(post_body, :urls)     # => Once upon\na time
      #   # => "Welcome to my new blog at <a href=\"http://www.myblog.com/\">http://www.myblog.com</a>.
      #         Please e-mail me at me@email.com."
      #
      #   auto_link(post_body, :all, :target => "_blank")     # => Once upon\na time
      #   # => "Welcome to my new blog at <a href=\"http://www.myblog.com/\" target=\"_blank\">http://www.myblog.com</a>.
      #         Please e-mail me at <a href=\"mailto:me@email.com\">me@email.com</a>."
      def auto_link(text, *args, &block)#link = :all, href_options = {}, &block)
        return '' if text.blank?

        options = extract_options_from_args!(args) if args.size != 2
        options ||= {}
        unless args.empty?
          options[:link] = args[0] || :all
          options[:html] = args[1] || {}
        end
        options.reverse_merge!(:link => :all, :html => {})

        case options[:link].to_sym
          when :all                         then auto_link_email_addresses(auto_link_urls(text, options[:html], &block), &block)
          when :email_addresses             then auto_link_email_addresses(text, &block)
          when :urls                        then auto_link_urls(text, options[:html], &block)
        end
      end
    
      # Turns all urls into clickable links.  If a block is given, each url
      # is yielded and the result is used as the link text.
      def auto_link_urls(text, html_options = {})
        extra_options = Mash.new(html_options).to_html_attributes
        extra_options = " #{extra_options}" unless extra_options.blank?

        text.gsub(AUTO_LINK_RE) do
          all, a, b, c, d = $&, $1, $2, $3, $4
          if a =~ /<a\s/i # don't replace URL's that are already linked
            all
          else
            text = b + c
            text = yield(text) if block_given?
            %(#{a}<a href="#{b=="www."?"http://www.":b}#{c}"#{extra_options}>#{text}</a>#{d})
          end
        end
      end

      # Turns all email addresses into clickable links.  If a block is given,
      # each email is yielded and the result is used as the link text.
      def auto_link_email_addresses(text)
        body = text.dup
        text.gsub(/([\w\.!#\$%\-+.]+@[A-Za-z0-9\-]+(\.[A-Za-z0-9\-]+)+)/) do
          text = $1

          if body.match(/<a\b[^>]*>(.*)(#{Regexp.escape(text)})(.*)<\/a>/)
            text
          else
            display_text = (block_given?) ? yield(text) : text
            %{<a href="mailto:#{text}">#{display_text}</a>}
          end
        end
      end
      
      
      private
      AUTO_LINK_RE = %r{
                      (                          # leading text
                        <\w+.*?>|                # leading HTML tag, or
                        [^=!:'"/]|               # leading punctuation, or
                        ^                        # beginning of line
                      )
                      (
                        (?:https?://)|           # protocol spec, or
                        (?:www\.)                # www.*
                      )
                      (
                        [-\w]+                   # subdomain or domain
                        (?:\.[-\w]+)*            # remaining subdomains or domain
                        (?::\d+)?                # port
                        (?:/(?:[~\w\+@%=\(\)-]|(?:[,.;:'][^\s$]))*)* # path
                        (?:\?[\w\+@%&=.;:-]+)?     # query string
                        (?:\#[\w\-]*)?           # trailing anchor
                      )
                      ([[:punct:]]|<|$|)       # trailing text
                     }x unless const_defined?(:AUTO_LINK_RE)
      
      
    end
  end
end