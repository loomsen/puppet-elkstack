require 'spec_helper'
describe 'elkstack' do

  context 'with default values for all parameters' do
    it { should contain_class('elkstack') }
  end
end
