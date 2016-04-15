require 'spec_helper'

describe 'elkstack' do
  context "elkstack class without any parameters" do
    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_class('elkstack::params') }
    it { is_expected.to contain_class('elkstack::install').that_comes_before('elkstack::config') }
    it { is_expected.to contain_class('elkstack::config') }
    it { is_expected.to contain_class('elkstack::service').that_subscribes_to('elkstack::config') }
    it { is_expected.to contain_class('elkstack::plugins').that_comes_after('elkstack::service') }

    it { is_expected.to contain_service('elasticsearch') }
    it { is_expected.to contain_package('elasticsearch').with_ensure('present') }
    it { is_expected.to contain_service('kibana') }
    it { is_expected.to contain_package('kibana').with_ensure('present') }
    it { is_expected.to contain_service('logstash') }
    it { is_expected.to contain_package('logstash').with_ensure('present') }
    it { is_expected.to contain_service('nginx') }
    it { is_expected.to contain_package('nginx').with_ensure('present') }
  end
end
