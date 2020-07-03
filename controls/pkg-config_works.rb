title 'Tests to confirm pkg-config works as expected'

plan_origin = ENV['HAB_ORIGIN']
plan_name = input('plan_name', value: 'pkg-config')

control 'core-plans-pkg-config-works' do
  impact 1.0
  title 'Ensure pkg-config works as expected'
  desc '
  Verify pkg-config by ensuring that
  (1) its installation directory exists 
  (2) it returns the expected version
  '
  
  plan_installation_directory = command("hab pkg path #{plan_origin}/#{plan_name}")
  describe plan_installation_directory do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stderr') { should be_empty }
  end
  
  plan_pkg_version = plan_installation_directory.stdout.split("/")[5]
  command_full_path = File.join(plan_installation_directory.stdout.strip, "bin", "pkg-config")
  describe command("#{command_full_path} --version") do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stdout') { should match /#{plan_pkg_version}/ }
    its('stderr') { should be_empty }
  end
end