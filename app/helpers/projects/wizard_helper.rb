module Projects::WizardHelper
  def active?(st)
    if step == st
      {:class => 'active'}
    else
      {}
    end
  end
end
