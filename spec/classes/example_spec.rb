require 'spec_helper'

describe 'elkstack' do
  context "elkstack class without any parameters" do
    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_class('elkstack::params') }
    it { is_expected.to contain_class('elkstack::install').that_comes_before('elkstack::config') }
    it { is_expected.to contain_class('elkstack::config') }
    it { is_expected.to contain_class('elkstack::service').that_subscribes_to('elkstack::config') }
    it { is_expected.to contain_class('elkstack::plugins') }

    it { is_expected.to contain_service('elasticsearch') }
    it { is_expected.to contain_package('elasticsearch').with_ensure('present') }
    it { is_expected.to contain_service('kibana') }
    it { is_expected.to contain_package('kibana').with_ensure('present') }
    it { is_expected.to contain_service('logstash') }
    it { is_expected.to contain_package('logstash').with_ensure('present') }
    it { is_expected.to contain_service('nginx') }
    it { is_expected.to contain_package('nginx').with_ensure('present') }
    it { is_expected.to contain_package('java').with_ensure('present') }
    it { is_expected.to contain_file('logstash repo').with_ensure('file') }
    it { is_expected.to contain_file('kibana repo').with_ensure('file') }
    it { is_expected.to contain_file('elasticsearch repo').with_ensure('file') }
    it { is_expected.to contain_file('kibana nginx config').with_ensure('file') }

    it do
      is_expected.to contain_file('/opt/kibana/optimize/.babelcache.json').with({
        'owner'  => 'kibana', 
      })
    end

    it { is_expected.to contain_file('/etc/logstash/conf.d/99-elasticsearch-output.conf').with_ensure('present') }

    it { is_expected.to contain_exec('install elastic/sense into kibana') }
    it { is_expected.to contain_exec('install elasticsearch/marvel/latest into kibana') }
    it { is_expected.to contain_exec('install license') }
    it { is_expected.to contain_exec('install logstash-input-jdbc') }
    it { is_expected.to contain_exec('install marvel-agent') }
    it { is_expected.to contain_exec('import elasticsearch key') }

    it { is_expected.to contain_file_line('elasticsearch url for kibana') }


  end
end
