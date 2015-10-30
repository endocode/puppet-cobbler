require 'spec_helper'

describe 'cobbler' do
  context 'supported operating systems' do
    ['Debian','Redhat'].each do |osfamily|
      describe "cobbler class without any parameters on #{osfamily}" do
        let(:facts) {{
          :osfamily         => osfamily,
          :lsbdistid        => osfamily,
        }}

        it { should compile.with_all_deps }
        it { should contain_class('cobbler') }
        it { should contain_class('cobbler::params') }
        it { should contain_class('cobbler::prerequisites').that_comes_before('cobbler::install') }
        it { should contain_class('cobbler::install').that_comes_before('cobbler::config') }
        it { should contain_class('cobbler::config').that_comes_before('cobbler::service') }
        it { should contain_class('cobbler::service') }

        it { should contain_exec('cobblersync') }
        it { should contain_file('/distro/kickstarts').with_owner('root') }
        it { should contain_file('/distro').with_owner('root') }

        it { should contain_file('/etc/cobbler/modules.conf').with_owner('root') }
        it { should contain_file('/etc/cobbler/settings').with_owner('root') }

        it { should contain_package('cobbler') }
        it { should contain_file('/etc/init.d/cobblerd').with_owner('root') }
        it { should contain_service('cobblerd') }

        if osfamily == 'Debian'
          it { should contain_apt__key('cobbler') }
          it { should contain_apt__source('cobbler') }
          it { should contain_file('/etc/apache2/conf.d/cobbler.conf') }
          it { should contain_file('/etc/apache2/conf.d/distros.conf') }
          it { should contain_file('/etc/apache2/conf.d/proxy_cobbler.conf') }
        end

        if osfamily == 'Redhat'
          it { should_not contain_apt__key('cobbler') }
          it { should_not contain_apt__source('cobbler') }
          it { should contain_package('epel-release') }
          it { should contain_package('syslinux') }
          it { should contain_package('tftp-server') }
          it { should contain_file('/etc/httpd/conf.d/cobbler.conf') }
          it { should contain_file('/etc/httpd/conf.d/distros.conf') }
          it { should contain_file('/etc/httpd/conf.d/proxy_cobbler.conf') }
        end

      end
    end
  end

  context 'unsupported operating system' do
    ['Solaris', 'Suse'].each do |osfamily|
      describe 'cobbler class without any parameters on Solaris/Nexenta' do
        let(:facts) {{
          :osfamily        => osfamily,
          }}

          it { expect { should contain_package('cobbler') }.to raise_error(Puppet::Error, /currently only supports osfamily RedHat & Debian/) }
        end
      end
  end
end