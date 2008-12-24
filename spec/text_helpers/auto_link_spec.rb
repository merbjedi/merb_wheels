require File.dirname(__FILE__) + '/../spec_helper'

describe "auto_link" do
  include Merb::GlobalHelpers

  it "should automatically add anchor tags to link urls it finds" do
    urls = %w(http://www.rubyonrails.com
              http://www.rubyonrails.com:80
              http://www.rubyonrails.com/~minam
              https://www.rubyonrails.com/~minam
              http://www.rubyonrails.com/~minam/url%20with%20spaces
              http://www.rubyonrails.com/foo.cgi?something=here
              http://www.rubyonrails.com/foo.cgi?something=here&and=here
              http://www.rubyonrails.com/contact;new
              http://www.rubyonrails.com/contact;new%20with%20spaces
              http://www.rubyonrails.com/contact;new?with=query&string=params
              http://www.rubyonrails.com/~minam/contact;new?with=query&string=params
              http://en.wikipedia.org/wiki/Wikipedia:Today%27s_featured_picture_%28animation%29/January_20%2C_2007
              http://www.mail-archive.com/rails@lists.rubyonrails.org/
              http://www.amazon.com/Testing-Equal-Sign-In-Path/ref=pd_bbs_sr_1?ie=UTF8&s=books&qid=1198861734&sr=8-1
              http://en.wikipedia.org/wiki/Sprite_(computer_graphics)
              http://en.wikipedia.org/wiki/Texas_hold'em
              https://www.google.com/doku.php?id=gps:resource:scs:start
            )

    urls.each do |url|
      auto_link(url).should == %{<a href="#{url}">#{url}</a>}
    end
  end
  
  it "should automatically link various formats" do
    email_raw    = 'david@loudthinking.com'
    email_result = %{<a href="mailto:#{email_raw}">#{email_raw}</a>}
    email2_raw    = '+david@loudthinking.com'
    email2_result = %{<a href="mailto:#{email2_raw}">#{email2_raw}</a>}
    link_raw     = 'http://www.rubyonrails.com'
    link_result  = %{<a href="#{link_raw}">#{link_raw}</a>}
    link_result_with_options  = %{<a href="#{link_raw}" target="_blank">#{link_raw}</a>}
    link2_raw    = 'www.rubyonrails.com'
    link2_result = %{<a href="http://#{link2_raw}">#{link2_raw}</a>}
    link3_raw    = 'http://manuals.ruby-on-rails.com/read/chapter.need_a-period/103#page281'
    link3_result = %{<a href="#{link3_raw}">#{link3_raw}</a>}
    link4_raw    = 'http://foo.example.com/controller/action?parm=value&p2=v2#anchor123'
    link4_result = %{<a href="#{link4_raw}">#{link4_raw}</a>}
    link5_raw    = 'http://foo.example.com:3000/controller/action'
    link5_result = %{<a href="#{link5_raw}">#{link5_raw}</a>}
    link6_raw    = 'http://foo.example.com:3000/controller/action+pack'
    link6_result = %{<a href="#{link6_raw}">#{link6_raw}</a>}
    link7_raw    = 'http://foo.example.com/controller/action?parm=value&p2=v2#anchor-123'
    link7_result = %{<a href="#{link7_raw}">#{link7_raw}</a>}
    link8_raw    = 'http://foo.example.com:3000/controller/action.html'
    link8_result = %{<a href="#{link8_raw}">#{link8_raw}</a>}
    link9_raw    = 'http://business.timesonline.co.uk/article/0,,9065-2473189,00.html'
    link9_result = %{<a href="#{link9_raw}">#{link9_raw}</a>}
    link10_raw    = 'http://www.mail-archive.com/ruby-talk@ruby-lang.org/'
    link10_result = %{<a href="#{link10_raw}">#{link10_raw}</a>}

    auto_link("hello #{email_raw}", :email_addresses).should == "hello #{email_result}"
    auto_link("Go to #{link_raw}", :urls).should == "Go to #{link_result}"
    auto_link("Go to #{link_raw}", :email_addresses).should == "Go to #{link_raw}"
    auto_link("Go to #{link_raw} and say hello to #{email_raw}").should == "Go to #{link_result} and say hello to #{email_result}"
    auto_link("<p>Link #{link_raw}</p>").should == "<p>Link #{link_result}</p>"
    auto_link("<p>#{link_raw} Link</p>").should == "<p>#{link_result} Link</p>"
    auto_link("<p>Link #{link_raw}</p>", :all, {:target => "_blank"}).should == "<p>Link #{link_result_with_options}</p>"
    auto_link(%(Go to #{link_raw}.)).should == "Go to #{link_result}."
    auto_link(%(<p>Go to #{link_raw}, then say hello to #{email_raw}.</p>)).should == "<p>Go to #{link_result}, then say hello to #{email_result}.</p>"
    auto_link("Go to #{link2_raw}", :urls).should == "Go to #{link2_result}"
    auto_link("Go to #{link2_raw}", :email_addresses).should == "Go to #{link2_raw}"
    auto_link("<p>Link #{link2_raw}</p>").should == "<p>Link #{link2_result}</p>"
    auto_link("<p>#{link2_raw} Link</p>").should == "<p>#{link2_result} Link</p>"
    auto_link(%(Go to #{link2_raw}.)).should == "Go to #{link2_result}."
    auto_link(%(<p>Say hello to #{email_raw}, then go to #{link2_raw}.</p>)).should == "<p>Say hello to #{email_result}, then go to #{link2_result}.</p>"
    auto_link("Go to #{link3_raw}", :urls).should == "Go to #{link3_result}"
    auto_link("Go to #{link3_raw}", :email_addresses).should == "Go to #{link3_raw}"
    auto_link("<p>Link #{link3_raw}</p>").should == "<p>Link #{link3_result}</p>"
    auto_link("<p>#{link3_raw} Link</p>").should == "<p>#{link3_result} Link</p>"
    auto_link(%(Go to #{link3_raw}.)).should == "Go to #{link3_result}."
    auto_link(%(<p>Go to #{link3_raw}. seriously, #{link3_raw}? i think I'll say hello to #{email_raw}. instead.</p>)).should == \
               "<p>Go to #{link3_result}. seriously, #{link3_result}? i think I'll say hello to #{email_result}. instead.</p>"

    auto_link("<p>Link #{link4_raw}</p>").should == "<p>Link #{link4_result}</p>"
    auto_link("<p>#{link4_raw} Link</p>").should == "<p>#{link4_result} Link</p>"
    auto_link("<p>#{link5_raw} Link</p>").should == "<p>#{link5_result} Link</p>"
    auto_link("<p>#{link6_raw} Link</p>").should == "<p>#{link6_result} Link</p>"
    auto_link("<p>#{link7_raw} Link</p>").should == "<p>#{link7_result} Link</p>"
    auto_link("Go to #{link8_raw}", :urls).should == "Go to #{link8_result}"
    auto_link("Go to #{link8_raw}", :email_addresses).should == "Go to #{link8_raw}"
    auto_link("<p>Link #{link8_raw}</p>").should == "<p>Link #{link8_result}</p>"
    auto_link("<p>#{link8_raw} Link</p>").should == "<p>#{link8_result} Link</p>"
    auto_link(%(Go to #{link8_raw}.)).should == "Go to #{link8_result}."
    auto_link("<p>Go to #{link8_raw}. seriously, #{link8_raw}? i think I'll say hello to #{email_raw}. instead.</p>").should == \
              "<p>Go to #{link8_result}. seriously, #{link8_result}? i think I'll say hello to #{email_result}. instead.</p>"

    auto_link("Go to #{link9_raw}", :urls).should == "Go to #{link9_result}"
    auto_link("Go to #{link9_raw}", :email_addresses).should == "Go to #{link9_raw}"
    auto_link("<p>Link #{link9_raw}</p>").should == "<p>Link #{link9_result}</p>"
    auto_link("<p>#{link9_raw} Link</p>").should == "<p>#{link9_result} Link</p>"
    auto_link(%(Go to #{link9_raw}.)).should == "Go to #{link9_result}."

    auto_link("<p>Go to #{link9_raw}. seriously, #{link9_raw}? i think I'll say hello to #{email_raw}. instead.</p>").should == \
              "<p>Go to #{link9_result}. seriously, #{link9_result}? i think I'll say hello to #{email_result}. instead.</p>"

    auto_link("<p>#{link10_raw} Link</p>").should == "<p>#{link10_result} Link</p>"

    auto_link(email2_raw).should == email2_result
    auto_link(nil).should == ""
    auto_link('').should == ""
    auto_link("#{link_raw} #{link_raw} #{link_raw}").should == "#{link_result} #{link_result} #{link_result}"
    auto_link('<a href="http://www.rubyonrails.com">Ruby On Rails</a>').should == '<a href="http://www.rubyonrails.com">Ruby On Rails</a>'
    
  end
  
  it "should automatically link at end of line" do
    url1 = "http://api.rubyonrails.com/Foo.html"
    url2 = "http://www.ruby-doc.org/core/Bar.html"
    
    auto_link("<p>#{url1}<br />#{url2}<br /></p>").should == \
              %{<p><a href="#{url1}">#{url1}</a><br /><a href="#{url2}">#{url2}</a><br /></p>}
    
  end
  
  it "should allow a block to replace links" do
    url = "http://api.rubyonrails.com/Foo.html"
    email = "fantabulous@shiznadel.ic"
    
    results = auto_link("<p>#{url}<br />#{email}<br /></p>") { |result| truncate(result, :length => 10) }
    results.should ==  %{<p><a href="#{url}">#{url[0...7]}...</a><br /><a href="mailto:#{email}">#{email[0...7]}...</a><br /></p>}
  end
  
  it "should allow an options hash to set the replaced link attributes" do
    results = auto_link("Welcome to my new blog at http://www.myblog.com/. Please e-mail me at me@email.com.", :link => :all, :html => { :class => "menu", :target => "_blank" })
    results.should ==   'Welcome to my new blog at <a href="http://www.myblog.com/" class="menu" target="_blank">http://www.myblog.com/</a>. Please e-mail me at <a href="mailto:me@email.com">me@email.com</a>.'
  end
  
end