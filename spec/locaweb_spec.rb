require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Inploy::Deploy do
  
  def expect_setup_in(path)
    expect_command "git clone . /tmp/#{@application} && tar czf - /tmp/#{@application} | ssh #{@user}@#{@host} 'tar xzfv - -C / && mv /tmp/#{@application} #{path}/ && cd #{path}/#{@application} && rake inploy:local:setup'"
  end

  context "with template locaweb" do
    before :each do
      subject.template = :locaweb
      subject.user = @user = 'batman'
      subject.hosts = [@host = 'gothic']
      subject.application = @application = "robin"
      mute subject
    end

    context "on remote setup" do
      it "should clone the repository with the application name and execute local setup" do
        expect_setup_in "/home/#{@user}/rails_app"
        subject.remote_setup
      end
      
      it "should accept a custom path" do
        subject.path = path = '/home/xpto/apps'
        expect_setup_in path
        subject.remote_setup
      end
    end

    context "on remote update" do
      it "should push to the repository" do
        expect_command "git push ssh://[#{@user}@#{@host}]/home/#{@user}/rails_app/#{@application} master"
        subject.remote_update
      end
    end
  end
end