module MerbWheels #:nodoc:
  module Helpers #:nodoc:
    module JavascriptHelpers
      
      JS_ESCAPE_MAP = {
        '\\'    => '\\\\',
        '</'    => '<\/',
        "\r\n"  => '\n',
        "\n"    => '\n',
        "\r"    => '\n',
        '"'     => '\\"',
        "'"     => "\\'" } unless defined?(JS_ESCAPE_MAP)

      # Escape carrier returns and single and double quotes for JavaScript segments.
      def escape_javascript(javascript)
        if javascript
          javascript.gsub(/(\\|<\/|\r\n|[\n\r"'])/) { JS_ESCAPE_MAP[$1] }
        else
          ''
        end
      end

      # Returns a JavaScript tag with the +content+ inside. Example:
      #   javascript_tag "alert('All is good')"
      #
      # Returns:
      #   <script type="text/javascript">
      #   //<![CDATA[
      #   alert('All is good')
      #   //]]>
      #   </script>
      #
      # +html_options+ may be a hash of attributes for the <script> tag. Example:
      #   javascript_tag "alert('All is good')", :defer => 'defer'
      #   # => <script defer="defer" type="text/javascript">alert('All is good')</script>
      #
      # Instead of passing the content as an argument, you can also use a block
      # in which case, you pass your +html_options+ as the first parameter.
      #   <% javascript_tag :defer => 'defer' do -%>
      #     alert('All is good')
      #   <% end -%>
      def javascript_tag(content_or_options_with_block = nil, html_options = {}, &block)
        content =
          if block_given?
            html_options = content_or_options_with_block if content_or_options_with_block.is_a?(Hash)
            capture(&block)
          else
            content_or_options_with_block
          end

        tag(:script, javascript_cdata_section(content), html_options.merge(:type => "text/javascript"))
      end

      def javascript_cdata_section(content) #:nodoc:
        "\n//#{cdata_section("\n#{content}\n//")}\n"
      end
    end
  end
end