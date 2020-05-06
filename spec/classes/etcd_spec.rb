require 'spec_helper'

describe 'etcd' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          config: { 'data-dir' => '/var/lib/etcd' },
        }
      end

      it { is_expected.to compile.with_all_deps }
    end
  end
end
