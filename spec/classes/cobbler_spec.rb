require 'spec_helper'

describe 'cobbler' do
  context 'supported operating systems' do
    describe "ejabberd class without any parameters on Redhat" do
      let(:facts) {{
        :osfamily         => 'Redhat',
      }}

      it { should compile.with_all_deps }
      it { should contain_class('cobbler') }
      it { should contain_class('cobbler::params') }
      it { should contain_class('cobbler::prerequisites').that_comes_before('cobbler::install') }
      it { should contain_class('cobbler::install').that_comes_before('cobbler::config') }
      it { should contain_class('cobbler::config').that_comes_before('cobbler::service') }
      it { should contain_class('cobbler::service') }
    end
  end

  context 'unsupported operating system' do
    ['Debian','Solaris'].each do |osfamily|
      describe 'ejabberd class without any parameters on Solaris/Nexenta' do
        let(:facts) {{
          :osfamily        => osfamily,
          }}

          it { expect { should contain_package('ejabberd') }.to raise_error(Puppet::Error, /currently only supports osfamily RedHat/) }
        end
      end
  end
end