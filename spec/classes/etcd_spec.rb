require 'spec_helper'

describe 'etcd' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      it do
        is_expected.to contain_file('/opt/etcd-3.4.7').with(
          ensure: 'directory',
          owner: 'root',
          group: 'root',
          mode: '0755',
        )
      end

      it do
        is_expected.to contain_archive('/tmp/etcd.tar.gz').with(
          source: 'https://github.com/etcd-io/etcd/releases/download/v3.4.7/etcd-v3.4.7-linux-amd64.tar.gz',
          extract: true,
          extract_path: '/opt/etcd-3.4.7',
          extract_command: 'tar xfz %s --strip-components=1',
          creates: '/opt/etcd-3.4.7/etcd',
          cleanup: 'true',
          user: 'root',
          group: 'root',
          require: 'File[/opt/etcd-3.4.7]',
          before: [
            'File[etcd]',
            'File[etcdctl]',
          ],
        )
      end

      it do
        is_expected.to contain_file('etcd').with(
          ensure: 'link',
          path: '/usr/bin/etcd',
          target: '/opt/etcd-3.4.7/etcd',
          notify: 'Service[etcd]',
        )
      end
      it do
        is_expected.to contain_file('etcdctl').with(
          ensure: 'link',
          path: '/usr/bin/etcdctl',
          target: '/opt/etcd-3.4.7/etcdctl',
          notify: nil,
        )
      end

      it do
        is_expected.to contain_user('etcd').with(
          ensure: 'present',
          name: 'etcd',
          forcelocal: true,
          shell: '/bin/false',
          gid: 'etcd',
          uid: nil,
          home: '/var/lib/etcd',
          managehome: 'false',
          system: 'true',
          before: 'Service[etcd]',
        )
      end
      it do
        is_expected.to contain_group('etcd').with(
          ensure: 'present',
          name: 'etcd',
          forcelocal: 'true',
          gid: nil,
          system: 'true',
          before: 'Service[etcd]',
        )
      end

      it do
        is_expected.to contain_file('etcd.yaml').with(
          ensure: 'file',
          path: '/etc/etcd.yaml',
          owner: 'etcd',
          group: 'etcd',
          mode: '0600',
          notify: 'Service[etcd]',
        )
      end
      it 'has correct config contents' do
        content = catalogue.resource('file', 'etcd.yaml').send(:parameters)[:content]
        config = YAML.safe_load(content)
        expected_config = {
          'data-dir' => '/var/lib/etcd',
        }
        expect(config).to eq(expected_config)
      end
      it do
        is_expected.to contain_file('etcd-data-dir').with(
          ensure: 'directory',
          path: '/var/lib/etcd',
          owner: 'etcd',
          group: 'etcd',
          mode: '0700',
          notify: 'Service[etcd]',
        )
      end
      it { is_expected.not_to contain_file('etcd-wal-dir') }

      it do
        is_expected.to contain_systemd__unit_file('etcd.service').with_notify('Service[etcd]')
      end

      it 'has expected systemd unit file' do
        # Logic for this test borrowed from puppetlabs_spec_helper verify_contents function
        content = catalogue.resource('systemd::unit_file', 'etcd.service').send(:parameters)[:content]
        expected_lines = [
          '[Unit]',
          'Description=etcd key-value store',
          'Documentation=https://github.com/etcd-io/etcd',
          'After=network.target',
          '',
          '[Service]',
          'User=etcd',
          'Group=etcd',
          'Type=notify',
          'ExecStart=/usr/bin/etcd --config-file /etc/etcd.yaml',
          'Restart=always',
          'RestartSec=10s',
          'LimitNOFILE=40000',
          '',
          '[Install]',
          'WantedBy=multi-user.target',
        ]
        expect(content.split("\n") & expected_lines).to match_array expected_lines.uniq
      end

      if Gem::Version.new(os_facts[:puppetversion]) < Gem::Version.new('6.1.0')
        it { is_expected.to contain_class('systemd::systemctl::daemon_reload').that_comes_before('Service[etcd]') }
      end

      it do
        is_expected.to contain_service('etcd').with(
          ensure: 'running',
          enable: 'true',
        )
      end

      context 'when wal-dir is defined' do
        let(:params) do
          {
            config: {
              'data-dir' => '/var/lib/etcd',
              'wal-dir' => '/var/lib/var/lib/etcd/wal',
            },
          }
        end

        it 'has correct config contents' do
          content = catalogue.resource('file', 'etcd.yaml').send(:parameters)[:content]
          config = YAML.safe_load(content)
          expected_config = {
            'data-dir' => '/var/lib/etcd',
            'wal-dir' => '/var/lib/var/lib/etcd/wal',
          }
          expect(config).to eq(expected_config)
        end
        it do
          is_expected.to contain_file('etcd-wal-dir').with(
            ensure: 'directory',
            path: '/var/lib/var/lib/etcd/wal',
            owner: 'etcd',
            group: 'etcd',
            mode: '0700',
            notify: 'Service[etcd]',
          )
        end
      end

      context 'when not managing user or group' do
        let(:params) do
          {
            manage_user: false,
            manage_group: false,
          }
        end

        it { is_expected.not_to contain_user('etcd') }
        it { is_expected.not_to contain_group('etcd') }
      end

      context 'with all params specified' do
        let(:params) do
          {
            version: '4.0.0',
            download_url: 'https://example.com/downloads/etcd.tar.gz',
            download_dir: '/var/tmp',
            extract_dir: '/downloads',
            bin_dir: '/bin',
            user: 'etcd-user',
            user_uid: 1000,
            group: 'etcd-group',
            group_gid: 1001,
            config_path: '/etc/etcd-config.yaml',
            config: {
              'data-dir' => '/etcd-data',
              'wal-dir' => '/var/lib/etcd/wal',
            },
            max_open_files: 4096,
          }
        end

        it do
          is_expected.to contain_file('/downloads/etcd-4.0.0').with(
            ensure: 'directory',
            owner: 'root',
            group: 'root',
            mode: '0755',
          )
        end

        it do
          is_expected.to contain_archive('/var/tmp/etcd.tar.gz').with(
            source: 'https://example.com/downloads/etcd.tar.gz',
            extract: true,
            extract_path: '/downloads/etcd-4.0.0',
            extract_command: 'tar xfz %s --strip-components=1',
            creates: '/downloads/etcd-4.0.0/etcd',
            cleanup: 'true',
            user: 'root',
            group: 'root',
            require: 'File[/downloads/etcd-4.0.0]',
            before: [
              'File[etcd]',
              'File[etcdctl]',
            ],
          )
        end

        it do
          is_expected.to contain_file('etcd').with(
            ensure: 'link',
            path: '/bin/etcd',
            target: '/downloads/etcd-4.0.0/etcd',
            notify: 'Service[etcd]',
          )
        end
        it do
          is_expected.to contain_file('etcdctl').with(
            ensure: 'link',
            path: '/bin/etcdctl',
            target: '/downloads/etcd-4.0.0/etcdctl',
            notify: nil,
          )
        end

        it do
          is_expected.to contain_user('etcd').with(
            ensure: 'present',
            name: 'etcd-user',
            forcelocal: true,
            shell: '/bin/false',
            gid: 'etcd-group',
            uid: '1000',
            home: '/etcd-data',
            managehome: 'false',
            system: 'true',
            before: 'Service[etcd]',
          )
        end
        it do
          is_expected.to contain_group('etcd').with(
            ensure: 'present',
            name: 'etcd-group',
            forcelocal: 'true',
            gid: '1001',
            system: 'true',
            before: 'Service[etcd]',
          )
        end

        it do
          is_expected.to contain_file('etcd.yaml').with(
            ensure: 'file',
            path: '/etc/etcd-config.yaml',
            owner: 'etcd-user',
            group: 'etcd-group',
            mode: '0600',
            notify: 'Service[etcd]',
          )
        end
        it 'has correct config contents' do
          content = catalogue.resource('file', 'etcd.yaml').send(:parameters)[:content]
          config = YAML.safe_load(content)
          expected_config = {
            'data-dir' => '/etcd-data',
            'wal-dir'  => '/var/lib/etcd/wal',
          }
          expect(config).to eq(expected_config)
        end
        it do
          is_expected.to contain_file('etcd-data-dir').with(
            ensure: 'directory',
            path: '/etcd-data',
            owner: 'etcd-user',
            group: 'etcd-group',
            mode: '0700',
            notify: 'Service[etcd]',
          )
        end
        it do
          is_expected.to contain_file('etcd-wal-dir').with(
            ensure: 'directory',
            path: '/var/lib/etcd/wal',
            owner: 'etcd-user',
            group: 'etcd-group',
            mode: '0700',
            notify: 'Service[etcd]',
          )
        end

        it 'has expected systemd unit file' do
          # Logic for this test borrowed from puppetlabs_spec_helper verify_contents function
          content = catalogue.resource('systemd::unit_file', 'etcd.service').send(:parameters)[:content]
          expected_lines = [
            '[Unit]',
            'Description=etcd key-value store',
            'Documentation=https://github.com/etcd-io/etcd',
            'After=network.target',
            '',
            '[Service]',
            'User=etcd-user',
            'Group=etcd-group',
            'Type=notify',
            'ExecStart=/bin/etcd --config-file /etc/etcd-config.yaml',
            'Restart=always',
            'RestartSec=10s',
            'LimitNOFILE=4096',
            '',
            '[Install]',
            'WantedBy=multi-user.target',
          ]
          expect(content.split("\n") & expected_lines).to match_array expected_lines.uniq
        end
      end
    end
  end
end
