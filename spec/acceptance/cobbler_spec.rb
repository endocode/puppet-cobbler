require 'spec_helper_acceptance'

describe 'cobbler class' do

  describe 'without parameters' do
    it 'should idempotently run' do
      pp = <<-EOS
        class { cobbler: }
      EOS

      apply_on_all_hosts(pp)
    end

    describe package('cobbler') do
      it { should be_installed }
    end

    describe service('cobblerd') do
      it { should be_enabled }
      it { should be_running }
    end

    describe port(80) do
      it { is_expected.to be_listening }
    end

  end
end
