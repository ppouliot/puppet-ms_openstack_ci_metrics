require 'spec_helper'
describe 'ms_openstack_ci_metrics' do

  context 'with defaults for all parameters' do
    it { should contain_class('ms_openstack_ci_metrics') }
  end
end
