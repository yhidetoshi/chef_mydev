require 'spec_helper'

describe 'yum_test::test_repository_one' do
  let(:test_repository_one_run) do
    ChefSpec::SoloRunner.new(
      step_into: 'yum_repository'
    ).converge(described_recipe)
  end

  let(:test_repository_one_template) do
    test_repository_one_run.template('/etc/yum.repos.d/test1.repo')
  end

  let(:test_repository_one_content) do
    '# This file was generated by Chef
# Do NOT modify this file by hand.

[test1]
name=an test
baseurl=http://drop.the.baseurl.biz
enabled=1
gpgcheck=1
'
  end

  context 'creating a yum_repository with minimal parameters' do
    it 'creates yum_repository[test1]' do
      expect(test_repository_one_run).to create_yum_repository('test1')
    end

    it 'steps into yum_repository and creates template[/etc/yum.repos.d/test1.repo]' do
      expect(test_repository_one_run).to create_template('/etc/yum.repos.d/test1.repo')
    end

    it 'steps into yum_repository and renders file[/etc/yum.repos.d/test1.repo]' do
      expect(test_repository_one_run).to render_file('/etc/yum.repos.d/test1.repo').with_content(test_repository_one_content)
    end

    it 'steps into yum_repository and runs execute[yum clean metadata test1]' do
      expect(test_repository_one_run).to_not run_execute('yum clean metadata test1')
    end

    it 'steps into yum_repository and runs execute[yum-makecache-test1]' do
      expect(test_repository_one_run).to_not run_execute('yum-makecache-test1')
    end

    it 'steps into yum_repository and runs ruby_block[yum-cache-reload-test1]' do
      expect(test_repository_one_run).to_not run_ruby_block('yum-cache-reload-test1')
    end

    it 'sends a :run to execute[yum-makecache-test1]' do
      expect(test_repository_one_template).to notify('execute[yum-makecache-test1]')
    end

    it 'sends a :create to ruby_block[yum-cache-reload-test1]' do
      expect(test_repository_one_template).to notify('ruby_block[yum-cache-reload-test1]')
    end
  end
end
