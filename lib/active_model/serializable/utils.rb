module ActiveModel
  module Serializable
    module Utils
      extend self

      def _const_get(const)
        begin
          method = :const_get

          # Cliff C-
          # Upgrading from Ruby 2.6.5 to Ruby 2.6.6 seemed to break the
          # ability to const_get an entire constant consistently. Chaining the
          # fetch of each individual constant seems to work. As V1 will be
          # replaced by V2 in the future we will use this patch temporarily.
          # (A future Rails or Ruby update may also resolve this).

          current_object = Object

          const.split('::').each do |module_or_class|
            current_object = current_object.send(method, module_or_class)
          end

          current_object
        rescue NameError
          const.safe_constantize
        end
      end
    end
  end
end
