require 'spec_helper_acceptance'

describe 'golang class:' do
  context 'default parameters' do
    it 'runs successfully' do
      pp = <<-EOS
      class { 'etcd':
        version => '3.3.20',
        config  => {
          'data-dir' => '/var/lib/etcd',
        },
      }
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe file('/etc/etcd.yaml') do
      expected_content = {
        'data-dir' => '/var/lib/etcd',
      }
      its(:content_as_yaml) { is_expected.to eq(expected_content) }
    end

    describe service('etcd') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end

  context 'upgrades etcd' do
    it 'runs successfully' do
      pp = <<-EOS
      class { 'etcd':
        config => {
          'data-dir' => '/var/lib/etcd',
        },
      }
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe file('/etc/etcd.yaml') do
      expected_content = {
        'data-dir' => '/var/lib/etcd',
      }
      its(:content_as_yaml) { is_expected.to eq(expected_content) }
    end

    describe service('etcd') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
