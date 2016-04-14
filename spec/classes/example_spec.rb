require 'spec_helper'

describe 'elkstack' do
        context "elkstack class without any parameters" do
#          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('elkstack::params') }
          it { is_expected.to contain_class('elkstack::install').that_comes_before('elkstack::config') }
          it { is_expected.to contain_class('elkstack::config') }
          it { is_expected.to contain_class('elkstack::service').that_subscribes_to('elkstack::config') }

          it { is_expected.to contain_service('elasticsearch') }
          it { is_expected.to contain_package('elasticsearch').with_ensure('present') }
        end
end
