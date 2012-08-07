RSpec::Matchers.define :have_attribute do |attribute|
  chain :with_value do |val|
    @val = val
  end
  match do |target|
    target.send(attribute) == @val
  end
end