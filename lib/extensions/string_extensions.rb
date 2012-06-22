module Extensions
  module StringExtensions
    def shorten(len)
      if length > len
        self[0..(len-4)] + '...'
      else
        self
      end
    end
  end
end

