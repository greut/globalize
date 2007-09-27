module ActiveSupport #:nodoc:
  module CoreExtensions #:nodoc:
    module String #:nodoc:
      # Define methods for handeling translation of strings.
      module Translation
        def t(*args)
          ActiveSupport::Translation::TranslatableString.translate(self, args)
        end
      end
    end    
  end
end