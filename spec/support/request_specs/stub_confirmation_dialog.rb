module RequestSpecs
  module StubConfirmationDialog
    def answer_yes_to_confirmations
      page.evaluate_script('window.confirm = function(msg) { return true; }')
    end
    def answer_no_to_confirmations
      page.evaluate_script('window.confirm = function(msg) { return false; }')
    end
  end
end