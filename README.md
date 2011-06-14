# err_supply

Err Supply is a Rails 3 view helper that helps produce simple, beautiful error messages.

The helper unpacks and rekeys the standard Rails error hash to make applying error messages to your views dead simple. Even better, because the extension cures Rails' brain-damaged way of recording errors from nested resources/attributes,  it works with both simple and complex forms.



## What Is This?

Err Supply is designed to make the default Rails error reporting structure more useful for complex
interfaces.  

### HTML vs AJAX form submissions

We started thinking about Err Supply when we worked on a project that required an AJAX form submission.

For normal HTML submissions, we coded up a custom error handler in Rails to display the messages below the 
form input. To replicate this for the AJAX submission, we realized we would have to convert the error hash 
to JSON and then wire up a jQuery event handler to perform the same DOM manipulations Rails was performing 
internally.  Obviously, we weren't super excited about having code in two places and in two languages to 
provide the same business value.

    
### Ambiguous error messages for nested attributes

The problem was compounded a few months later when we worked on a different project that required an AJAX 
form submission for a nested form.

Here, even the workaround is problematic. Because Rails reports errors on nested attributes ambiguously, 
there really wasn't any way to use a javascript workaround without first reconstituting the error hash
itself.

If you don't know what I mean by saying the error messages are ambiguous, here's an example. Say you have 
these models defined:

    class Father < ActiveRecord::Base
      attr_accessible :name
      attr_accessible :age
    
      has_many :sons
    
      accepts_nested_attributes_for :sons, :allow_destroy => true
    
      validates_presence_of :name, :age
    end
  
    class Son < ActiveRecord::Base
      attr_accessible :name
      attr_accessible :age
    
      belongs_to :father
    
      validates_presence_of :name, :age
    end
    
If you pull up the nested edit form for a father with two sons and delete one son's name and the other 
son's age, Rails will return the following error hash:

    {
      "sons.name": ["can't be blank"],
      "sons.age": ["can't be blank"]
    }

Umm, thanks, but which son is missing a name and which one is missing an age? Or is it the same son missing 
both values? Or, do they both have problems?



## Our Solution

Err Supply converts the Rails error hash from a slightly ambiguous object graph to a flat, unambiguous
hash of DOM element ids. It does this by traversing the object graph for you and determining exactly which
child resources have errors. It then adds those errors to a new hash object where the key is the DOM id
of the corresponding form input.

Err Supply publishes this newly constituted error hash via a custom jQuery event, allowing the view
to handle errors through a single javascript interface.  This strategy allows errors from HTML and AJAX
form submissions to be run through a single piece of code.



## Installation

Install me from RubyGems.org by adding a gem dependency to your Gemfile.  Bundler does 
the rest.

	gem "err_supply"

If you want the default javascript handlers, run the install generator from the command line.

	$ rails g err_supply:install

This will copy two javascripts files to your project: the latest stable version of the
jQuery plugin qtip and a simple $.live() function to modify the view using the information
in the err_supply error hash.



## Basic Usage

The main `err_supply` helper returns an escaped javascript invocation that triggers a custom
event named `err_supply:loaded` and supplies the edited error hash as data.

    <script type="text/javascript">
      <%= err_supply @father %>
    </script>

This will evaluate @father.errors and apply an errors to the form. It assumes all form inputs
are named in the standard rails way and that all error attribute keys match the form input
keys exactly.
    

### 1. Whitelists/Blacklists

Attributes can be whitelisted or blacklisted using the standard `:only` and `:except` notation.

Because `err_supply` will ignore any unmatched attributes, such declarations are not strictly
required.  They typically only make sense for minor actions against models with many, 
many attributes.


### 2. Changing Labels

Say a User class has an attribute `:born_on` to store the user's date of birth.  In your form
builder you declare the textbox normally like so:

    <%= f.text_field :born_on %>
    
A presence\_of error will be formatted as:

    Born on can't be blank.
    
To make this nicer, we can change the label for the attribute like this:

    <script type="text/javascript">
      <%= err_supply @user, :born_on => { :label => "Date of birth" } %>
    </script>

This will attach the following presence of error to the :born_on field:

    Date of birth can't be blank.


### 3. Changing Keys

Say a User class belongs to an Organization class.  In your form, you declare a selector 
for assigning the organization.  The selector is named `:ogranization_id`.

Depending on how your validations are written, you might very well get an error message for
this form keyed to `:organization`.  Because your selector is keyed to `:organization_id`, 
the default javascript handler will consider this an unmatched attribute.

You can solve this problem by changing the key for the attribute like so:

    <script type="text/javascript">
      <%= err_supply @user, :organization => { :key => :organization_id } %>
    </script>
    

### 4. Nested Attributes

You can apply the same principles to nested attributes by nesting the instructions. To return
to our father/son example, you can change the name labels for both entities using the following
notation:

    <script type="text/javascript">
      <%= err_supply  @father, 
                      :name => { :label => "Father's name" },
                      :sons => {
                        :name => { :label => "Son's name" }
                      }
      %>
    </script>


### 5. Combining Instructions (aka Go Crazy)

Attribute instructions are provided as hashes so that both `key` and `label` changes can be 
declared on the same attribute.

Honestly, such instructions are rare in the real world, but error handling can get weird fast,
so the library supports it.  
        
        
        
        
## Advanced Usage

There are a handful of scenarios that fall outside the area of basic usage worth discussing.

### 1. AJAX Submissions and Nested Forms

When Rails submits a nested form via a full page refresh, Rails automatically re-indexes any
DOM elements in a nested collection starting at 0.

If you're submitting a form remotely, it's on you to do this by re-rendering the nested fields
with the current collection.

As long as you do this before the `err_supply` call is made, everything will work normally.


### 2. Other Javascript Libraries

If you don't use jQuery, you may want to override the `err_supply` helper to format the 
javascript invocation differently.

The library is constructed so the main public method named `err_supply` is pretty dumb. Most
of the real hash-altering magic occurs in a protected method called `err_supply_hash`. You can
override the much simpler method without worrying about damaging the core hash interpretation 
functionality.

See the `lib` directory for details.


### 3. Handling Unmatched Errors

The default javascript handler bundles up unmatched error keys into a new hash and publishes them
using the custom jQuery event `err_supply:unmatched`.




## Prerequisites

* <b>Ruby on Rails:</b> <http://rubyonrails.org>
* <b>jQuery:</b>        <http://jquery.com>




## Helpful Links

* <b>Repository:</b>  <http://github.com/coroutine/err_supply>
* <b>Gem:</b>         <http://rubygems.org/gems/err_supply>
* <b>Authors:</b>     <http://coroutine.com>




## Gemroll

Other gems by Coroutine include:

* [acts\_as\_current](http://github.com/coroutine/acts_as_current)
* [acts\_as\_label](http://github.com/coroutine/acts_as_label)
* [acts\_as\_list\_with\_sti\_support](http://github.com/coroutine/acts_as_list_with_sti_support)
* [delayed\_form\_observer](http://github.com/coroutine/delayed_form_observer)
* [kenny\_dialoggins](http://github.com/coroutine/kenny_dialoggins)
* [michael\_hintbuble](http://github.com/coroutine/michael_hintbuble)
* [tiny\_navigation](http://github.com/coroutine/tiny_navigation)




## License

Copyright (c) 2011 [Coroutine LLC](http://coroutine.com).

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.