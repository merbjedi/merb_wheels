module MerbWheels
  module Monkey
    module ObjectExtensions
      # An object is present if it's not blank.
      def present?
        !blank?
      end
    end
  end
end